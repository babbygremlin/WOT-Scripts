//------------------------------------------------------------------------------
// AngrealInvAirBurst.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 10 $
//
// Description:	AirBurst is not a repeater, but you can press the button fairly quickly to
// fire more than one (say, maybe twice as fast as fireball).  The pulse is
// simply a column, firing straight out from your chest, of compressed
// air--probably about three feet out by a foot high and wide.  
// 
// The effect is instantaneous (or as long as it takes to play the animation
// of the pulse being created).  Anyone in the pulse area is affected.  A
// target in the center is shoved back approx. five feet and takes about 20-30
// points of damage.  If possible, the target should be shoved back less and
// take less damage based on how far from the center of the attack the target
// is.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvAirBurst expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealAirBurst ANIVFILE=MODELS\AngrealAirBurst_a.3D DATAFILE=MODELS\AngrealAirBurst_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealAirBurst X=0 Y=0 Z=0 PITCH=-64 YAW=0 ROLL=0

#exec MESH    SEQUENCE   MESH=AngrealAirBurst SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=AngrealAirBurst FILE=MODELS\AngrealAirBurst.PCX GROUP=Skins FLAGS=2 // Balefire

#exec MESHMAP NEW        MESHMAP=AngrealAirBurst MESH=AngrealAirBurst
#exec MESHMAP SCALE      MESHMAP=AngrealAirBurst X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealAirBurst NUM=1 TEXTURE=AngrealAirBurst

#exec TEXTURE IMPORT FILE=Icons\I_AirBurst.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_AirBurst.pcx        GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\AirBurst\ActivateAB.wav				GROUP=AirBurst
//NEW: #exec AUDIO IMPORT FILE=Sounds\AirBurst\ActivateAirBurst.wav	GROUP=AirBurst

//var() float RoundsPerMinute;		// Maximum refire rate.
var float NextCastTime;				// The next time we can cast.

var() float RangeX, RangeY;			// Max effective distance.

var() float MaxDamage;				// Damage given at point-blank range.
var() float MinDamage;				// Damage given at extent of range.

var() float MomentumTransfer;		// Amount objects are thrown.
var() float Kickback;				// Amount of kick transfered to the castor.

var() vector EffectOffset;			// Offset of the effect from the player (relative to Rotation).

var() name AffectedTypes[12];		// Types of classes that are affected.
var() name PushableTypes[4];		// Types of classes that are pushable.

var() float LargestCollisionRadius;	// Size of the largest collision radius of Actors AirBurst affects.

//------------------------------------------------------------------------------
function Cast()
{
	if( Level.TimeSeconds > NextCastTime )
	{
		Super.Cast();

		NextCastTime = Level.TimeSeconds + (60.0 / RoundsPerMinute);
		
		Burst();

		//Pawn(Owner).AddVelocity( -Kickback * Normal(vector(Pawn(Owner).ViewRotation)) );

		UseCharge();
	}
}

//------------------------------------------------------------------------------
function Failed()
{
	NextCastTime = Level.TimeSeconds;	// Allow user to refire on the next tick if we fail.
	Super.Failed();
}

//------------------------------------------------------------------------------
function Burst()
{
	local Actor IterA;
	local int i;
//	local vector ActorOffset;
	local float HalfRangeX, HalfRangeY;
	local SprayerBlower Blower;
	//local AirBurstVisual Visual;
	local AirBlastProj Proj;
//	local vector AdjustedLocation;
	local Rotator RotationToUse;

/*NEW
	local AirBurstSprayer Sprayer;
	local rotator SprayerRot;
	local vector X, Y, Z;
*/

	local vector HitLocation, HitNormal;
	local vector Start, End;

	// Precalc.
	HalfRangeX = RangeX / 2.0;
	HalfRangeY = RangeY / 2.0;

	//
	// Old Visuals
	//

	Blower = Spawn( class'SprayerBlower',,, Owner.Location + ((vect(1,0,0) * HalfRangeX) >> Pawn(Owner).ViewRotation), Pawn(Owner).ViewRotation );
	Blower.AddIgnoredType('RespawnFire');
	Blower.Trigger( Self, Instigator );

	//Visual = Spawn( class'AirBurstVisual',,, Owner.Location + (EffectOffset >> Owner.Rotation), Pawn(Owner).ViewRotation );
	//Visual.SetFollowActor( Owner );

	Proj = Spawn( class'AirBlastProj',,, Owner.Location + EffectOffset, rotator(vect(0,1,0) >> Pawn(Owner).ViewRotation) );
	Proj.Velocity = vector(Pawn(Owner).ViewRotation) * 350;
	//Proj.Gravity = Owner.Velocity;
	Proj.RelativeActor = Owner;

	//
	// Pre-calc
	// 

	if( Pawn(Owner) != None )
	{
		RotationToUse = Pawn(Owner).ViewRotation;
		Start = Owner.Location + (vect(0,0,1) * Pawn(Owner).BaseEyeHeight);
	}
	else
	{
		RotationToUse = Owner.Rotation;
		Start = Owner.Location;
	}

	End = Start + ((RangeX * vect(1,0,0)) >> RotationToUse);
/*NEW
	//
	// Visuals.
	//

	//Blower = Spawn( class'SprayerBlower',,, Owner.Location + ((vect(1,0,0) * HalfRangeX) >> Pawn(Owner).ViewRotation), Pawn(Owner).ViewRotation );
	Blower = Spawn( class'SprayerBlower',,, Start + ((End - Start) * 0.5), RotationToUse );
	Blower.AddIgnoredType('RespawnFire');
	Blower.Trigger( Self, Instigator );

	//Visual = Spawn( class'AirBurstVisual',,, Owner.Location + (EffectOffset >> Owner.Rotation), Pawn(Owner).ViewRotation );
	//Visual.SetFollowActor( Owner );

//	Proj = Spawn( class'AirBlastProj',,, Owner.Location + EffectOffset, rotator(vect(0,1,0) >> Pawn(Owner).ViewRotation) );
//	Proj.Velocity = vector(Pawn(Owner).ViewRotation) * 350;
//	//Proj.Gravity = Owner.Velocity;
//	Proj.RelativeActor = Owner;

	//SprayerRot = rotator(Owner.Location - End);
	SprayerRot = rotator((Owner.Location + vect(0,0,21)) - (Start + ((End - Start) * 0.60)));
	GetAxes( SprayerRot, X, Y, Z );
	SprayerRot = OrthoRotation( Z, Y, -X );

	Sprayer = Spawn( class'AirBurstSprayer',,, (Owner.Location + vect(0,0,21)) + ((End - (Owner.Location + vect(0,0,21))) * 0.60), SprayerRot );
	Sprayer.SetRelativeActor( Owner );
*/
	//
	// Effect
	//

	foreach RadiusActors( class'Actor', IterA, RangeX + LargestCollisionRadius, Start )
	{
		if( IsAffectable( IterA ) )
		{
/*
			// Find the closest point on IterA to us.
			AdjustedLocation = class'Util'.static.CalcClosestCollisionPoint( IterA, Start );
			
			// See if the actor is within a bounding box in front of the castor as defined by the range.
			ActorOffset = (AdjustedLocation - Start) << RotationToUse;
			if
			(	ActorOffset.X >=  0.0			&& ActorOffset.X <= RangeX
			&&	ActorOffset.Y >= -HalfRangeY	&& ActorOffset.Y <= HalfRangeY
			&&	ActorOffset.Z >= -HalfRangeY	&& ActorOffset.Z <= HalfRangeY
			)
			{
				PushActor( IterA, ActorOffset, AdjustedLocation );
			}
*/
			if( IterA.LineCheck( HitLocation, HitNormal, Start, End ) )
			{
				PushActor( IterA, (HitLocation - Start) << RotationToUse, HitLocation );
			}
		}
	}
}

//------------------------------------------------------------------------------
function PushActor( Actor Victim, vector RelativeOffset, vector HitLocation )
{
	local MomentumEffect ME;
	local DamageEffect DE;
	local vector Momentum, Ignored;
	local float Damage, Scalar;
	local float HalfRangeX, HalfRangeY;

	// Precalc.
	HalfRangeX = RangeX / 2.0;
	HalfRangeY = RangeY / 2.0;

	// Calc scalar.
	Scalar  = 1.0 - (RelativeOffset.X / RangeX);
	Scalar *= 1.0 - (Abs(RelativeOffset.Y) / HalfRangeY);
	Scalar *= 1.0 - (Abs(RelativeOffset.Z) / HalfRangeY);

	// Calc momentum.
	GetAxes( Owner.Rotation, Momentum, Ignored, Ignored );
	Momentum = Normal(Momentum);
	Momentum.Z = 0.5;
	Momentum *= (MomentumTransfer / Victim.Mass) * Scalar;	// Scale appropriately.

	// Calc damage.
	Damage = MinDamage + (MaxDamage - MinDamage) * Scalar;

	// Damage
	if( WOTPlayer(Victim) != None || WOTPawn(Victim) != None )
	{
		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.SetSourceAngreal( Self );
		DE.Initialize( Damage, Instigator, HitLocation, vect(0,0,0), class'AngrealInventory'.static.GetDamageType( Self ), None );
		DE.SetVictim( Pawn(Victim) );

		if( WOTPlayer(Victim) != None )
		{
			WOTPlayer(Victim).ProcessEffect( DE );
		}
		else
		{
			WOTPawn(Victim).ProcessEffect( DE );
		}
	}
	else if( Pawn(Victim) != None )
	{
		Victim.TakeDamage( Damage, Instigator, HitLocation, vect(0,0,0), class'AngrealInventory'.static.GetDamageType( Self ) );	
	}
	else
	{
		Victim.TakeDamage( Damage, Instigator, HitLocation, vect(0,0,0), class'AngrealInventory'.static.GetDamageType( Self ) );	
	}

	// Push
	if( IsPushable( Victim ) )
	{
		if( WOTPlayer(Victim) != None || WOTPawn(Victim) != None )
		{
			//ME = Spawn( class'MomentumEffect' );
			ME = MomentumEffect( class'Invokable'.static.GetInstance( Self, class'MomentumEffect' ) );
			ME.Initialize( Momentum );
			ME.SetSourceAngreal( Self );
			ME.SetVictim( Pawn(Victim) );

			if( WOTPlayer(Victim) != None )
			{
				WOTPlayer(Victim).ProcessEffect( ME );
			}
			else
			{
				WOTPawn(Victim).ProcessEffect( ME );
			}
		}
		else if( Pawn(Victim) != None )
		{
			Pawn(Victim).AddVelocity( Momentum );
		}
		else
		{
			Victim.SetPhysics( PHYS_Falling );
			Victim.Velocity += Momentum;
		}
	}
}

//------------------------------------------------------------------------------
function bool IsAffectable( Actor A )
{
	local int i;

	// You can pick your friends...
	// and you can pick your nose...
	// but don't pick your Owner.
	if( A == Owner ) return false;

	for( i = 0; i < ArrayCount(AffectedTypes); i++ )
	{
		if( AffectedTypes[i] != '' )
		{
			if( A.IsA( AffectedTypes[i] ) )
			{
				return true;
			}
		}
	}

	return false;
}

//------------------------------------------------------------------------------
function bool IsPushable( Actor A )
{
	local int i;

	// You can pick your friends...
	// and you can pick your nose...
	// but don't pick your Owner.
	if( A == Owner ) return false;

	for( i = 0; i < ArrayCount(PushableTypes); i++ )
	{
		if( PushableTypes[i] != '' )
		{
			if( A.IsA( PushableTypes[i] ) )
			{
				return true;
			}
		}
	}

	return false;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetMaxRange()
{
	return RangeX;
}

defaultproperties
{
     RangeX=120.000000
     RangeY=20.000000
     MaxDamage=20.000000
     MinDamage=10.000000
     MomentumTransfer=20000.000000
     Kickback=150.000000
     EffectOffset=(Z=20.000000)
     AffectedTypes(0)=Pawn
     AffectedTypes(1)=Carcass
     AffectedTypes(2)=MashadarTrailer
     AffectedTypes(3)=ExplodingMover
     AffectedTypes(4)=AngrealExpWardProjectile
     AffectedTypes(5)=LegionProjectile
     AffectedTypes(6)=PortcullisMover
     AffectedTypes(7)=WallSlab
     AffectedTypes(8)=BounceableDecoration
     AffectedTypes(9)=BreakableDecoration
     PushableTypes(0)=Carcass
     PushableTypes(1)=BounceableDecoration
     PushableTypes(2)=BreakableDecoration
     LargestCollisionRadius=250.000000
     bElementAir=True
     bCommon=True
     bOffensive=True
     bCombat=True
     RoundsPerMinute=120.000000
     bRestrictsUsage=True
     MinInitialCharges=999
     MaxInitialCharges=999
     ChargeCost=0
     Priority=5.000000
     ActivateSoundName="Angreal.ActivateAB"
     MaxChargeUsedInterval=0.500000
     Title="Air Pulse"
     Description="Air Pulse pushes a small, quick weave of air directly in front of you.  If the blast of air strikes someone, the weave hits like a hammer, inflicting significant damage.  The artifact continually replenishes its power from the One Source"
     Quote="As if a giant hand had smashed him aside, he flew ten paces through the air, crashing to the stones."
     StatusIconFrame=Texture'Angreal.Icons.M_AirBurst'
     InventoryGroup=51
     PickupMessage="You got the Air Pulse ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealAirBurst'
     PickupViewScale=0.300000
     StatusIcon=Texture'Angreal.Icons.I_AirBurst'
     Mesh=Mesh'Angreal.AngrealAirBurst'
     DrawScale=0.300000
}
