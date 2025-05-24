//------------------------------------------------------------------------------
// AngrealInvBalefire.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 13 $
//
// Description:	When you activate it, the view closes in on your target.  
//				Upon release of the button, it fires a quick, ribbon of white 
//				light--instantaneously, no matter how far away the target is.  
//				The ribbon doesn't stop until it hits part of the BSP (a wall, 
//				a mountain, etc.).  Anything touched by the light will cease to 
//				exist, indeed, they've been wiped from the timeline.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvBalefire expands AngrealInventory;

#exec MESH    IMPORT     MESH=Balefire ANIVFILE=MODELS\Balefire_a.3D DATAFILE=MODELS\Balefire_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=Balefire X=0 Y=0 Z=0

#exec MESH    SEQUENCE   MESH=Balefire SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=Balefire FILE=MODELS\Balefire.PCX GROUP=Skins FLAGS=2 // Balefire

#exec MESHMAP NEW        MESHMAP=Balefire MESH=Balefire
#exec MESHMAP SCALE      MESHMAP=Balefire X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Balefire NUM=1 TEXTURE=Balefire

#exec TEXTURE IMPORT FILE=Icons\I_Balefire.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Balefire.pcx        GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Balefire\LaunchBF.wav		GROUP=Balefire
#exec AUDIO IMPORT FILE=Sounds\Balefire\ActivateBF.wav		GROUP=Balefire
#exec AUDIO IMPORT FILE=Sounds\Balefire\LoopBF.wav			GROUP=Balefire
#exec AUDIO IMPORT FILE=Sounds\Balefire\HitBF.wav			GROUP=Balefire

var() Sound HitSound;

var bool bCheckForCarcasses;

var bool bCasting;

var() float Damage;

var() float PrimeTime;
var float CastTime;

var() float StreakLength;

var() float Kickback;

var() float VisualOffset;

var BalefireCorona GatherEffect;

// Names of classes (including subclasses) that are affected by balefire.
var() name BalefireableTypes[7];

//------------------------------------------------------------------------------
function Cast()
{
	Super.Cast();

	CastTime = Level.TimeSeconds;

	GatherEffect = Spawn( class'BalefireCorona',,, GetStartLoc(), Pawn(Owner).ViewRotation );
	GatherEffect.SetFollowPawn( Pawn(Owner) );

	bCasting = True;
}

//------------------------------------------------------------------------------
singular function UnCast()
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	//local BalefireVisualSegment Streak;
	local BalefireLine Line;
	local vector Start, End;
	local vector VisualStart;
	local float Scalar;

	if( !bCasting ) return;

	// if killed before fully charged... auto-prime.
	if( Pawn(Owner).Health <= 0 && Level.TimeSeconds < CastTime + (PrimeTime / 2) )
	{
		CastTime = Level.TimeSeconds - (PrimeTime / 2);
	}
	
	if( Level.TimeSeconds < CastTime + (PrimeTime / 2) )
	{
		GotoState('FinishCharging');
		return;
	}

	Super.UnCast();

	if( GatherEffect != None )
	{
		GatherEffect.Destroy();
		GatherEffect = None;
	}

	bCasting = False;

	Scalar = FMin( (Level.TimeSeconds - CastTime) / PrimeTime, 1.0 );
	
	Start = GetStartLoc();
	End = GetEndLoc();

	VisualStart = Start + (vect(50,0,-30) >> Pawn(Owner).ViewRotation);

	Line = Spawn( class'BalefireLine' );
	Line.SetEndpoints( VisualStart, End );
//	Line.DrawScale *= Scalar;

	PlaceDecals( VisualStart, Normal(End - VisualStart), StreakLength );
	PlaceDecals( End, Normal(VisualStart - End), StreakLength );

	Pawn(Owner).AddVelocity( Kickback * Normal(vector(Pawn(Owner).ViewRotation)) * -1.0 * Scalar );

	foreach AllActors( class'Actor', HitActor )
	{
		if
		(	HitActor != Owner
		&&	IsBalefireable( HitActor )
		&&	DidIndeedHit( HitActor, HitLocation, HitNormal, End, Start )
		)
		{
			AffectActor( HitActor, HitLocation, HitNormal, Scalar );
		}
	}

	UseCharge();
}

//------------------------------------------------------------------------------
function Reset()
{
	if( GatherEffect != None )
	{
		GatherEffect.Destroy();
		GatherEffect = None;
	}

	CastTime = 0.0;

	bCasting = False;
}

//------------------------------------------------------------------------------
function bool IsBalefireable( Actor A )
{
	local int i;	// Your standard everday iterator.

	for( i = 0; i < ArrayCount(BalefireableTypes); i++ )
	{
		if( A.IsA( BalefireableTypes[i] ) )
		{
			return true;
		}
	}

	return false;
}

//------------------------------------------------------------------------------
function PlaceDecals( vector Start, vector Direction, float Limit )
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local float TraceInterval;
	local vector End;
	local Decal D;

	TraceInterval = 500;

	if( Limit < TraceInterval )
	{
		TraceInterval = Limit;
	}

	End = Start + (TraceInterval * Direction);
	HitActor = Trace( HitLocation, HitNormal, End, Start, false );

	if( HitActor != None )
	{
		// NOTE[aleiby]: Determine how to figure out whether or not HitLocation is inside the level
		// so we don't end up spawning decals out in the void.
		D = Spawn( class'BalefireDecal',,, HitLocation );
		if( D == None )
		{
			// don't worry.
		}
		else if( D.Region.ZoneNumber == 0 )
		{
			D.Destroy();
		}
		else
		{
			D.Align( HitNormal );
		}

		HitLocation += 100 * Direction;		// get off the wall.
		Limit -= VSize(HitLocation - Start);
	}
	else
	{
		HitLocation = End;
		Limit -= TraceInterval;
	}

	if( Limit > 0.0 )
	{
		PlaceDecals( HitLocation, Direction, Limit );
	}
}

//------------------------------------------------------------------------------
// Determins if we really did hit the given actor and calculates the exact
// HitLocation and HitNormal.
//------------------------------------------------------------------------------
function bool DidIndeedHit( Actor HitActor, out vector HitLocation, out vector HitNormal, vector End, vector Start )
{
	local vector RelativePosition;
	local rotator Rot;

	HitNormal = Normal(End - Start);
	Rot = rotator(HitNormal);

	RelativePosition = (HitActor.Location - Start) << Rot;

	HitLocation.X = RelativePosition.X;
	HitLocation.Y = 0.0;
	HitLocation.Z = 0.0;

	if
	(	RelativePosition.X < -VisualOffset
	||	Abs(RelativePosition.Z) > HitActor.CollisionHeight
	||	Abs(RelativePosition.Y) > HitActor.CollisionRadius
	)
	{
		HitLocation = vect(0,0,0);
		HitNormal = vect(0,0,0);
		return false;
	}

	// Transform back to world coords.
	HitLocation = Start + (HitLocation >> Rot);

	return true;
}

//------------------------------------------------------------------------------
state FinishCharging
{
	function Cast()
	{
		GotoState('');
	}

begin:
	Sleep( (CastTime + (PrimeTime / 2)) - Level.TimeSeconds );
	UnCast();
	GotoState('');
}

//-----------------------------------------------------------------------------
// Called when our owner drops us.
//-----------------------------------------------------------------------------
function DropFrom( vector StartLocation )
{
	if( bCasting ) Failed();
	Super.DropFrom( StartLocation );
}

//------------------------------------------------------------------------------
function Failed()
{
	if( GatherEffect != None )
	{
		GatherEffect.FollowPawn = None;
		GatherEffect.Destroy();
		GatherEffect = None;
	}

	Super.Failed();
}

//------------------------------------------------------------------------------
function AffectActor( Actor Victim, vector HitLocation, vector HitNormal, float Scalar )
{
	local name PrevTag;
	local BalefireEffect BE;
	local DamageEffect DE;

	if
	(	(Decoration(Victim) != None && !Decoration(Victim).bStatic)
    ||  (Projectile(Victim) != None && !Projectile(Victim).bStatic)
	||  (WallSlab(Victim)	!= None && !WallSlab(Victim).bStatic)
//	|| 	AngrealInventory(Victim) != None
	)
	{
		BE = Spawn( class'BalefireEffect' );
		BE.RemoveFromTimeline( Victim );
	}
	else if( Pawn(Victim) != None )
	{
		// Set its tag so we can find its carcass if we kill it.
		PrevTag = Victim.Tag;
		Victim.Tag = 'Balefired';

		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.SetSourceAngreal( Self );
		DE.Initialize( Damage * Scalar, Pawn(Owner), HitLocation, HitNormal * Kickback * -1.0 * Scalar, 'Balefire', None );
		DE.SetVictim( Pawn(Victim) );
		//WOTPlayer(Victim).ProcessEffect( DE );
		DE.Invoke();	// balefire breaks all rules.

		if( Pawn(Victim).Health > 0 )
		{
			Victim.Tag = PrevTag;
		}
		else
		{
			bCheckForCarcasses = True;
		}
	}
	else
	{
		Victim.TakeDamage( Damage * Scalar, Pawn(Owner), HitLocation, HitNormal * Kickback * -1.0 * Scalar, 'Balefire' );

		if( PortcullisMover(Victim) == None || PortcullisMover(Victim).WithstandDamage <= 0 )
		{
			BE = Spawn( class'BalefireEffect',,, HitLocation );
			BE.RemoveFromTimeline( None );
		}
	}

	if( HitSound != None )
	{
		Victim.PlaySound( HitSound );
	}
}

//------------------------------------------------------------------------------
simulated function vector GetStartLoc()
{
	local vector Loc;

	Loc = Owner.Location;
	Loc.z += Pawn(Owner).BaseEyeHeight;
	//Loc.z += 10.0;
//	Loc += ((VisualOffset * vect(1,0,0)) >> Pawn(Owner).ViewRotation);

	return Loc;
}

//------------------------------------------------------------------------------
simulated function vector GetEndLoc()
{
	local vector Loc;
	//local vector HitLocation, HitNormal;
	
	Loc = GetStartLoc() + ((vect(1,0,0)*StreakLength) >> Pawn(Owner).ViewRotation);
	//class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, GetStartLoc(), false,, vector(Pawn(Owner).ViewRotation) );

	return Loc;
	//return HitLocation;
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	local Carcass DeadBody;
	local BalefireEffect BE;
	local vector Loc;
	local int i;
	
	if( bCheckForCarcasses )
	{
		// Clean up all the balefired carcasses if any were created.
		foreach AllActors( class'Carcass', DeadBody, 'Balefired' )
		{
			BE = Spawn( class'BalefireEffect',,, DeadBody.Location );
			BE.RemoveFromTimeline( DeadBody );
			bCheckForCarcasses = False;
		}
	}
}

//------------------------------------------------------------------------------
// Traces until it Hits either an actor or the level;
//------------------------------------------------------------------------------
// Recursively calls itself tracing 3000 units at a time until it 
// hits something.
//------------------------------------------------------------------------------
// Depricated: Use functionality in class'Util' instead.
//------------------------------------------------------------------------------
function Actor GetHitActor( out vector HitLocation, out vector HitNormal, vector Start, rotator Rot )
{
	local Actor HitActor;
	local vector End;

	End = Start + ((vect(1,0,0)*3000) >> Rot);

	HitActor = Trace( HitLocation, HitNormal, End, Start, True );
	
	if( HitActor == None )
	{
		HitActor = GetHitActor( HitLocation, HitNormal, End, Rot );
	}
	
	return HitActor;
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetMinRange()
{
	return 80.0;	// Balefire doesn't work well as a close range weapon.
}

defaultproperties
{
     HitSound=Sound'Angreal.Balefire.HitBF'
     Damage=400.000000
     PrimeTime=2.000000
     StreakLength=8000.000000
     Kickback=1000.000000
     VisualOffset=50.000000
     BalefireableTypes(0)=PlayerPawn
     BalefireableTypes(1)=WOTPawn
     BalefireableTypes(2)=Decoration
     BalefireableTypes(3)=LegionProjectile
     BalefireableTypes(4)=WallSlab
     BalefireableTypes(5)=PortcullisMover
     BalefireableTypes(6)=MashadarTrailer
     bElementFire=True
     bElementSpirit=True
     bRare=True
     bOffensive=True
     bCombat=True
     MinInitialCharges=3
     MaxInitialCharges=5
     MaxCharges=10
     Priority=10.000000
     ActivateSoundName="Angreal.ActivateBF"
     DeActivateSoundName="Angreal.LaunchBF"
     MaxChargesInGroup=4
     MinChargeGroupInterval=5.000000
     MissOdds=1.000000
     Title="Balefire"
     Description="Balefire launches a stream of light which travels through everything, even through walls.  Anything the light touches is loosened from the timeline.  Most objects and victims disappear as if they never existed, although cuendillar seals"
     Quote="Something leaped from his hands; he was not sure what it was. A bar of white light, solid as steel. Liquid fire."
     StatusIconFrame=Texture'Angreal.Icons.M_Balefire'
     InventoryGroup=51
     PickupMessage="You got the Balefire ter'angreal"
     PickupViewMesh=Mesh'Angreal.Balefire'
     PickupViewScale=0.700000
     StatusIcon=Texture'Angreal.Icons.I_Balefire'
     Mesh=Mesh'Angreal.Balefire'
     DrawScale=0.700000
}
