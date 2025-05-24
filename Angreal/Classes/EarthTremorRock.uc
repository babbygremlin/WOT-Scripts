//------------------------------------------------------------------------------
// EarthTremorRock.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Spawn.
// + SetSourceAngreal.
// + Optionally set Lifespan.
// + Call Go();
//------------------------------------------------------------------------------
class EarthTremorRock expands GenericProjectile;

#exec MESH IMPORT MESH=EarthTremorRock ANIVFILE=MODELS\EarthTremor_a.3d DATAFILE=MODELS\EarthTremor_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=EarthTremorRock X=0 Y=0 Z=50

#exec MESH SEQUENCE MESH=EarthTremorRock SEQ=All	STARTFRAME=0 NUMFRAMES=37

#exec TEXTURE IMPORT NAME=JEarthTremorRock1 FILE=MODELS\EarthTremor.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=EarthTremorRock MESH=EarthTremorRock
#exec MESHMAP SCALE MESHMAP=EarthTremorRock X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=EarthTremorRock NUM=0 TEXTURE=JEarthTremorRock1

var() float MinAnimRate;
var() float MaxAnimRate;

// Used to remember where we were spawned so that we can calculate how far
// we actually fell once we hit something.
var vector SpawnLocation;

var vector RelativeUp;

// How high do we spawn these so that we can go up steps, etc.
var() float SpawnHeight;

// How far we can fall without being destroyed.
var() float FallLimit;

// Max variability between animations that are supposed to be synced.
var float StaggerTime;

// How often to play the animation.
var() float Frequency;

// Used to set the collision once we are placed.
var(Collision) float DamageRadius;
var(Collision) float DamageHeight;

// Set this to equal the number of frames in your animation.
var() float NumFrames;

// How often to spew chunks.
var() float MinSpewTime, MaxSpewTime;
var float NextSpewTime;

// Our persistant leech attacher.
var AttachLeechEffect Attacher;

var ETSoundProxy ETS;

// Spew probablilities.
var() float BurningChunkProb, LavaSpewProb;

// Used for controlling damaging of actors other than WOTPlayers and WOTPawns.
var float DamageTimer;

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	NextSpewTime = Level.TimeSeconds + RandRange( MinSpewTime, MaxSpewTime );

	Super.BeginPlay();
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( ETS != None )
	{
		ETS.RemoveRock( Self );
	}
	
	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Go()
{
	GotoState( 'Bobbing' );
}

//------------------------------------------------------------------------------
simulated state Bobbing
{
	simulated function BeginState()
	{
		local vector HitLocation, HitNormal, X, Y, Z;
		local rotator Rot, DeltaRot;
		local Actor HitActor;
		
		GetAxes( Rotation, X, Y, Z );
		HitActor = Trace( HitLocation, HitNormal, Location - Z*FallLimit, Location + Z*SpawnHeight, False );
		if( HitActor == None )
		{
			Destroy();
		}
		else
		{
			Z = HitNormal;
			Y = Z cross X;
			X = Z cross -Y;
			RelativeUp = Z;
			Rot = OrthoRotation( X, Y, Z );
/*			
			// Fail if had to rotate more than 90 degrees.
			DeltaRot = Normalize(Rotation - Rot);
			BroadcastMessage( Self$" "$DeltaRot );
			if( DeltaRot.Pitch > 16383 || DeltaRot.Yaw > 16383 || DeltaRot.Roll > 16383 )
			{
				Destroy();
				return;
			}
*/			
			SetRotation( Rot );
			SetLocation( HitLocation );
		}
	}

	// When we touch a pawn, attach an EarthTremorLeech.
	function Touch( Actor Other )
	{
		local EarthTremorLeech ETL;
		
		local Leech L;
		local LeechIterator IterL;
			
		if( Other != IgnoredPawn && (WOTPlayer(Other) != None || WOTPawn(Other) != None) )
		{
			// If our victim already has an EarthTremorLeech attached, remove it.
			IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(Other) );
			for( IterL.First(); !IterL.IsDone(); IterL.Next() )
			{
				L = IterL.GetCurrent();

				if( EarthTremorLeech(L) != None )
				{
					L.Unattach();
					L.Destroy();
					//log( Self$" unattached "$L$" from "$Other );
				}
			}
			IterL.Reset();
			IterL = None;

			// Attach a new one.
			ETL = Spawn( class'EarthTremorLeech',, Name );
			ETL.InitializeWithProjectile( Self );
			ETL.Lifespan = Lifespan;
			ETL.Momentum = RelativeUp * MomentumTransfer;
			ETL.DamagePerHit = Damage;
			if( Attacher == None )
			{
				//Attacher = Spawn( class'AttachLeechEffect' );
				Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
				Attacher.InitializeWithProjectile( Self );
			}
			Attacher.SetVictim( Pawn(Other) );
			Attacher.SetLeech( ETL );
			if( WOTPlayer(Other) != None )
			{
				WOTPlayer(Other).ProcessEffect( Attacher );
			}
			else if( WOTPawn(Other) != None )
			{
				WOTPawn(Other).ProcessEffect( Attacher );
			}

			//log( Self$" attached "$ETL$" to "$Other );
		}
	}

	// When we untouch a pawn, make sure we remove our leech from him.
	function UnTouch( Actor Other )
	{
		local Leech IterL, L;

		if( WOTPlayer(Other) != None )
		{
			IterL = WOTPlayer(Other).FirstLeech;
		}
		else if( WOTPawn(Other) != None )
		{
			IterL = WOTPawn(Other).FirstLeech;
		}

		while( IterL != None )
		{
			L = IterL;
			IterL = IterL.NextLeech;

			if( L.Tag == Name )
			{
				L.Unattach();
				L.Destroy();
				//log( Self$" unattached "$L$" from "$Other );
			}
		}
	}

begin:
	// Only play while we have enough time to finish our animation.
	while( Lifespan > NumFrames / (30.0 * MinAnimRate) )
	{
		StaggerTime = FRand() * 0.2;
		Sleep( StaggerTime );
		PlayAnim( 'All', MinAnimRate + (MaxAnimRate - MinAnimRate)*FRand() );
		Sleep( Frequency - StaggerTime );
		Frequency += 0.1;	// Slow down.
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float Prob;

	if( Level.TimeSeconds >= NextSpewTime )
	{
		Prob = FRand();

		if( Prob < BurningChunkProb )
		{
			SpawnChunks( class'LavaRock', Location, RelativeUp );
		}
		else if( Prob < BurningChunkProb + LavaSpewProb )
		{
			Spawn( class'LavaSpew',,, Location + (8.0 * RelativeUp), rotator(RelativeUp) );
		}

		//NextSpewTime = Level.TimeSeconds + RandRange( MinSpewTime, MaxSpewTime );
		NextSpewTime = Level.TimeSeconds + LifeSpan + 100.0;	// Make sure we don't spew again.
	}

	// Occationally damage other touching Actors.
	DamageTimer -= DeltaTime;
	if( DamageTimer < 0.0 )
	{
		DamageTimer = class'EarthTremorLeech'.default.AffectResolution;
		DamageTouching( Damage );
	}
}

//------------------------------------------------------------------------------
simulated function DamageTouching( float Damage )
{
	local Actor IterA;
	local name DamageType;

	if( SourceAngreal != None )
	{
		DamageType = class'AngrealInventory'.static.GetDamageType( SourceAngreal );
	}
	else
	{
		DamageType = 'xEFxx';	// This should only occur on the client, and it really doesn't matter on the client.
	}

	foreach TouchingActors( class'Actor', IterA )
	{
		if( IterA != IgnoredPawn && WOTPlayer(IterA) == None && WOTPawn(IterA) == None )
		{
			IterA.TakeDamage( Damage, Instigator, Location, RelativeUp * MomentumTransfer, DamageType );
		}
	}
}

defaultproperties
{
     MinAnimRate=0.900000
     MaxAnimRate=1.200000
     SpawnHeight=50.000000
     FallLimit=300.000000
     Frequency=1.000000
     NumFrames=37.000000
     MaxSpewTime=10.000000
     BurningChunkProb=0.100000
     LavaSpewProb=0.400000
     Damage=5.000000
     MomentumTransfer=10000
     bCanTeleport=False
     Physics=PHYS_None
     RemoteRole=ROLE_None
     Mesh=Mesh'Angreal.EarthTremorRock'
     DrawScale=4.000000
     CollisionRadius=30.000000
     CollisionHeight=46.000000
     bCollideWorld=False
}
