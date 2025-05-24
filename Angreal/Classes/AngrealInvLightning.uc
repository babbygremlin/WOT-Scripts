//------------------------------------------------------------------------------
// AngrealInvLightning.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 12 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// Note: Will latch on to victims in ice regardless of line of sight (but other
//		 conditions must be met).
//       
//------------------------------------------------------------------------------
class AngrealInvLightning expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealLightningStrikePickup ANIVFILE=MODELS\AngrealLightningStrike_a.3D DATAFILE=MODELS\AngrealLightningStrike_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealLightningStrikePickup X=0 Y=0 Z=0 ROLL=-64

#exec MESH    SEQUENCE   MESH=AngrealLightningStrikePickup SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=AngrealLightningStrikePickupTex FILE=MODELS\AngrealLightningStrike.PCX GROUP="Skins"

#exec MESHMAP NEW        MESHMAP=AngrealLightningStrikePickup MESH=AngrealLightningStrikePickup
#exec MESHMAP SCALE      MESHMAP=AngrealLightningStrikePickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealLightningStrikePickup NUM=1 TEXTURE=AngrealLightningStrikePickupTex

#exec TEXTURE IMPORT FILE=Icons\I_LightningStrike.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_LightningStrike.pcx        GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\LightningStrike\LaunchLS.wav		GROUP=LightningStrike
#exec AUDIO IMPORT FILE=Sounds\LightningStrike\LoopLS.wav		GROUP=LightningStrike
#exec AUDIO IMPORT FILE=Sounds\LightningStrike\EndLS.wav		GROUP=LightningStrike

var() float AttachmentRange;				// How close a victim must be in order to be latched on to.
var() float MaxCollisionRadius;				// Maximum collision radius of Attachable victims.  (Legion in our case).

var() float MaxEffectiveRange;				// How far a victim must be away from the source to free themselves. 
											// (damage is also distance scaled over this range.)

var() float MaxDamageRate;					// Damage given to single victim. (per second)

var() float MaxWaterDamage;					// Damage taken when entering water.
var() float WaterDamageRadius;				// Max effective distance for water "splash damage".

var() float PercentStrain;					// Percentage per-victim damage per added victim. (0.0 to 1.0) - 1.0 means full damage to all.
											// Also works for MaxEffectiveRange.

var() float LatchDelay;						// Must wait this amount before latching on to another victim.

//var() float RoundsPerMinute;				// Number of charges used up per minute while activated.  (constant)
var float ChargeTimer;

var LightningLeech FirstLightningLeech;		// First leech in our linked list of leeches attached to our victims.
var AttachLeechEffect Attacher;				// Our persistant leech attacher.

var LightningDamageNotifyer DamageNotifier;	// Tells us who just hurt us.
var NotifyInWaterReflector WaterNotifier;	// Tells us if our Owner goes into water.

var LightningSkinEffect PlayerEffect;		// Cool, shield-belt type effect.

var int NumVictims;
var bool bCasting;

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
function Cast()
{
	if( !bCasting )
	{
		PlayerEffect = Spawn( class'LightningSkinEffect', Owner,, Owner.Location, Owner.Rotation); 
		PlayerEffect.Mesh = Owner.Mesh;
		PlayerEffect.DrawScale = Owner.Drawscale;

		LatchDelay = 0.0;

		Super.Cast();
		bCasting = true;

		InstallNotifiers();
	}
}

//------------------------------------------------------------------------------
function UnCast()
{
	if( bCasting )
	{
		UnInstallNotifiers();

		RemoveAll();

		if( PlayerEffect != None )
		{
			PlayerEffect.Destroy();
			PlayerEffect = None;
		}

		Super.UnCast();
		bCasting = false;
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
function NotifyDamagedBy( Pawn DamageInstigator )
{
	if( !bCasting ) return;

	if( DamageInstigator == Owner )
	{
		UnCast();
	}
	else if( DamageInstigator != None )
	{
		RemoveVictim( DamageInstigator );
	}
}

//------------------------------------------------------------------------------
function NotifyPawnEnteredWater( Pawn WetPawn )
{
	local float InitialHealth;

	//BroadcastMessage( WetPawn$" entered water." );

	if( !bCasting ) return;

	if( WetPawn == Owner )
	{
		InitialHealth = WetPawn.Health;
	}
	else
	{
		RemoveVictim( WetPawn );
	}
	
	DamagePawn( WetPawn, MaxWaterDamage );
	ElectricutePawn( WetPawn );

	// Only UnCast if our owner took damage since it
	// might possibly be blocked with an elemental shield, etc.
	if( WetPawn == Owner && WetPawn.Health < InitialHealth )
	{
		UnCast();
	}
}

//------------------------------------------------------------------------------
// Damages all Pawns within WaterDamageRadius units of the SourcePawn using a 
// linear damage falloff if they are in water (does not take connectivity into
// account).
//
// Ignores the SourcePawn.
//------------------------------------------------------------------------------
function ElectricutePawn( Pawn SourcePawn )
{
	local Pawn IterP;
	local float Damage;
	local float Distance;

	if( !bCasting ) return;

	for(IterP=Level.PawnList; IterP != None; IterP=IterP.NextPawn )
	{
		if( IterP != SourcePawn && IterP.FootRegion.Zone.bWaterZone 
		&&  VSize( SourcePawn.Location-IterP.Location) <= WaterDamageRadius )
		{
			Distance = VSize( SourcePawn.Location - IterP.Location );
			if( Distance < WaterDamageRadius )
			{
				Damage = MaxWaterDamage * (1.0 - (Distance / WaterDamageRadius));
			}
			else
			{
				Damage = 0.0;
			}

			if( Damage > 0.0 )
			{
				DamagePawn( IterP, Damage );
			}
		}
	}
}

//------------------------------------------------------------------------------
// Ripped and modified from GenericProjectile.
//------------------------------------------------------------------------------
simulated function DamagePawn( Actor Victim, int Damage )
{
	local DamageEffect DE;
	local name ProjDamageType;

	// Get appropriate damage type.
	ProjDamageType = class'AngrealInventory'.static.GetDamageType( Self );
	
	// Damage Victim using DamageEffects where appropriate.
	if( WOTPawn(Victim) != None || WOTPlayer(Victim) != None )
	{
		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.SetSourceAngreal( Self );
		DE.Initialize( Damage, Pawn(Owner), Victim.Location, vect(0,0,0), ProjDamageType, None );
		DE.SetVictim( Pawn(Victim) );
		
		if( WOTPawn(Victim) != None )
		{
			WOTPawn(Victim).ProcessEffect( DE );
		}
		else
		{
			WOTPlayer(Victim).ProcessEffect( DE );
		}
	}
	else
	{
		Victim.TakeDamage( Damage, Pawn(Owner), Victim.Location, vect(0,0,0), ProjDamageType );	
	}
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( bCasting )
	{
		// Suck up charges while we are casting.
		ChargeTimer += DeltaTime;
		if( ChargeTimer >= (60.0 / RoundsPerMinute) )
		{
			ChargeTimer -= (60.0 / RoundsPerMinute);
			UseCharge();
		}

		// Check for people to latch on to.
		LatchDelay -= DeltaTime;
		if( LatchDelay < 0.0 )
		{
			LatchDelay += default.LatchDelay;
			AttemptLatch();
		}

		UpdateLeeches();
	}

	Super.Tick( DeltaTime );
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Adjusts our LightningLeeches' ScaleGlow and DamagePerSecond based on 
// the length of the connecting streak.
// Also removes Leeches that have gone out of range.
//------------------------------------------------------------------------------
function UpdateLeeches()
{
	local LightningLeech IterL, NextL;
	local float Dist;
	local float Scalar;	// 1.0(closest) to 0.0(furthest).
	local float Strain;

	Strain = PercentStrain ** NumVictims;

	IterL = FirstLightningLeech;
	while( IterL != None )
	{
		NextL = IterL.NextLightningLeech;

		if( IterL.PathStreak != None && IterL.PathStreak.CurrentLength > 0.0 )
		{
			Dist = IterL.PathStreak.CurrentLength;
		}
		else
		{
			Dist = VSize(IterL.Owner.Location - Owner.Location);
		}
		
		if( Dist < MaxEffectiveRange )
		{
			Scalar = 1.0 - (Dist / MaxEffectiveRange);
			IterL.DamagePerSecond = MaxDamageRate * Strain * Scalar;
			IterL.ScaleGlow = Strain * Scalar;
		}
		else
		{
			RemoveVictim( Pawn(IterL.Owner) );
		}

		IterL = NextL;
	}
}

//------------------------------------------------------------------------------
function AttemptLatch()
{
	local Pawn IterP;
	
	for(IterP=Level.PawnList; IterP != None; IterP=IterP.NextPawn )
	{
		if
		(	IterP != Owner
		&&	VSize( Owner.Location-IterP.Location) <= AttachmentRange + MaxCollisionRadius 
		&&	!IsAlreadyAffected( IterP )
		&&	VSize( class'Util'.static.CalcClosestCollisionPoint( IterP, Owner.Location ) - Owner.Location ) <= AttachmentRange
		&&	IsAttachable( IterP )
		)
		{
			AddVictim( IterP );
			break;	// Only do one at a time.
		}
	}
}

//------------------------------------------------------------------------------
// Is the given pawn already being affected by one of our LightningLeeches?
//------------------------------------------------------------------------------
function bool IsAlreadyAffected( Pawn Other )
{
	local LightningLeech IterL;

	for( IterL = FirstLightningLeech; IterL != None; IterL = IterL.NextLightningLeech )
	{
		if( IterL.Owner == Other )
		{
			return true;
		}
	}

	return false;
}

//------------------------------------------------------------------------------
// Can we latch on to this dude?
//------------------------------------------------------------------------------
function bool IsAttachable( Pawn Other )
{
	local Reflector R;
	local ReflectorIterator IterR;
	local Leech L;
	local LeechIterator IterL;

	local Actor HitActor;
	local vector HitLocation, HitNormal;

	// Error check.
	if( Pawn(Owner) == None )
	{
		warn( "No Owner." );
		return false;
	}

	// Check for Ice (trace below will fail if other is in ice -- just attach 
	// to anyone in ice in our radius regardless of line of sight).
	IterL = class'LeechIterator'.static.GetIteratorFor( Other );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.IsA('IceLeech') )
		{
			IterL.Reset();
			IterL = None;
			return true;
		}
	}
	IterL.Reset();
	IterL = None;

	// Check for AutoTarget.
	IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(LastOwner) );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.IsA('AutoTargetReflector') )
		{
			IterR.Reset();
			IterR = None;
			return true;
		}
	}
	IterR.Reset();
	IterR = None;

	// Check line of sight.
	return
	(	Trace( HitLocation, HitNormal, Other.Location,											Owner.Location + vect(0,0,1) * Pawn(Owner).BaseEyeHeight, true ) == Other
	||	Trace( HitLocation, HitNormal, Other.Location + vect(0,0,1) * Other.CollisionHeight,	Owner.Location + vect(0,0,1) * Pawn(Owner).BaseEyeHeight, true ) == Other
	||	Trace( HitLocation, HitNormal, Other.Location - vect(0,0,1) * Other.CollisionHeight,	Owner.Location + vect(0,0,1) * Pawn(Owner).BaseEyeHeight, true ) == Other
	);
}

//------------------------------------------------------------------------------
function AddVictim( Pawn Victim )
{
	local LightningLeech NewL;

/*	
	if( Attacher == None )
	{
		Attacher = Spawn( class'AttachLeechEffect' );
		Attacher.SetSourceAngreal( Self );
	}
*/
	Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
	Attacher.SetSourceAngreal( Self );

	NewL = Spawn( class'LightningLeech',,, Victim.Location );
	NewL.DamagePerSecond = MaxDamageRate;
	NewL.SetSourceAngreal( Self );

	Attacher.SetLeech( NewL );
	Attacher.SetVictim( Victim );
	
	if( WOTPlayer(Victim) != None )
	{
		WOTPlayer(Victim).ProcessEffect( Attacher );	// Note: This will call NotifyAttached if successfully attached.
	}
	else if( WOTPawn(Victim) != None )
	{
		WOTPawn(Victim).ProcessEffect( Attacher );		// Note: This will call NotifyAttached if successfully attached.
	}
}

//------------------------------------------------------------------------------
function NotifyAttached( LightningLeech L )
{
	++NumVictims;
	L.NextLightningLeech = FirstLightningLeech;
	FirstLightningLeech = L;
}

//------------------------------------------------------------------------------
function RemoveVictim( Pawn Victim, optional bool bNoDestroy )
{
	local LightningLeech IterL, PrevL, NextL;

	IterL = FirstLightningLeech;
	while( IterL != None )
	{
		NextL = IterL.NextLightningLeech;

		if( IterL.Owner == Victim )
		{
			if( IterL == FirstLightningLeech )
			{
				FirstLightningLeech = NextL;
			}
			else
			{
				PrevL.NextLightningLeech = NextL;
			}

			if( !bNoDestroy )
			{
				IterL.UnAttach();
				IterL.Destroy();
			}

			--NumVictims;
		}
		else
		{
			PrevL = IterL;
		}

		IterL = NextL;
	}
}

//------------------------------------------------------------------------------
function RemoveAll()
{
	local LightningLeech IterL, NextL;

	IterL = FirstLightningLeech;
	while( IterL != None )
	{
		NextL = IterL.NextLightningLeech;
		IterL.UnAttach();
		IterL.Destroy();
		IterL = NextL;
	}
}

//------------------------------------------------------------------------------
function InstallNotifiers()
{
	// DamageNotifier.
	if( DamageNotifier == None )
	{
		DamageNotifier = Spawn( class'LightningDamageNotifyer' );
		DamageNotifier.SetSourceAngreal( Self );
	}

	if( DamageNotifier.Owner != None )
	{
		warn( "DamageNotifier already installed in ("$DamageNotifier.Owner$")." );
		DamageNotifier.UnInstall();
	}
	DamageNotifier.Install( Pawn(Owner) );

	// WaterNotifier.
	if( WaterNotifier == None )
	{
		WaterNotifier = Spawn( class'NotifyInWaterReflector' );
		WaterNotifier.SetSourceAngreal( Self );
	}

	if( WaterNotifier.Owner != None )
	{
		warn( "WaterNotifier already installed in ("$WaterNotifier.Owner$")." );
		WaterNotifier.UnInstall();
	}
	WaterNotifier.Install( Pawn(Owner) );
}

//------------------------------------------------------------------------------
function UnInstallNotifiers()
{
	// DamageNotifier.
	if( DamageNotifier != None )
	{
		DamageNotifier.UnInstall();
	}
	else
	{
		warn( "Missing DamageNotifier!" );
	}

	// WaterNotifier.
	if( WaterNotifier != None )
	{
		WaterNotifier.UnInstall();
	}
	else
	{
		warn( "Missing WaterNotifier!" );
	}
}

//------------------------------------------------------------------------------
static final function bool IsUsingLightning( Pawn Other )
{
	local Inventory Inv;
	
	for( Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( AngrealInvLightning(Inv) != None )
		{
			return AngrealInvLightning(Inv).bCasting;
		}
	}

	return false;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
// Furthest effective range of artifact.
//------------------------------------------------------------------------------
function float GetMaxRange()
{
	return AttachmentRange;
}

//------------------------------------------------------------------------------
function rotator GetBestTrajectory()
{
	return rotator(Target.Location - Owner.Location);	// Look at our target.
}

defaultproperties
{
    AttachmentRange=180.00
    MaxCollisionRadius=250.00
    MaxEffectiveRange=900.00
    MaxDamageRate=25.00
    MaxWaterDamage=50.00
    WaterDamageRadius=1000.00
    PercentStrain=0.90
    LatchDelay=0.30
    DurationType=0
    bElementFire=True
    bElementWater=True
    bElementAir=True
    bUncommon=True
    bOffensive=True
    MinInitialCharges=10
    MaxInitialCharges=20
    MaxCharges=30
    Priority=8.00
    ActivateSoundName="Angreal.LaunchLS"
    DeActivateSoundName="Angreal.EndLS"
    MaxChargesInGroup=30
    MinChargesInGroup=10
    MaxChargeUsedInterval=1.00
    MinChargeGroupInterval=3.00
    Title="Chain Lightning"
    Description="For as long you continue to activate Chain Lightning, the ter'angreal weaves an aura of electricity around you.  Touching someone else in this state creates a link between you and your target; touching more targets creates more links."
    Quote="More lightning flashed, raising gouts of shattered paving stone ahead of him, ripping open crystal palace walls to rain ruin before him."
    StatusIconFrame=Texture'Icons.M_LightningStrike'
    InventoryGroup=62
    PickupMessage="You got the Chain Lightning ter'angreal"
    PickupViewMesh=Mesh'AngrealLightningStrikePickup'
    StatusIcon=Texture'Icons.I_LightningStrike'
    Texture=None
    Mesh=Mesh'AngrealLightningStrikePickup'
}
