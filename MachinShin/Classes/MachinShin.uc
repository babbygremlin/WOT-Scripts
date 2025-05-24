//------------------------------------------------------------------------------
// MachinShin.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// Note: Make sure you set bNoDelete to true when placing in a MP map.
//------------------------------------------------------------------------------
class MachinShin expands SeekingProjectile;

// Mesh.
#exec MESH IMPORT MESH=MachShin ANIVFILE=MODELS\MachShin_a.3d DATAFILE=MODELS\MachShin_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MachShin X=-270 Y=0 Z=0

#exec MESH SEQUENCE MESH=MachShin SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JMachinShin0 FILE=MODELS\MachinShin.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=MachShin MESH=MachShin
#exec MESHMAP SCALE MESHMAP=MachShin X=0.1 Y=0.1 Z=0.2

// Sounds.
#exec AUDIO IMPORT FILE=Sounds\MachShin01.wav
#exec AUDIO IMPORT FILE=Sounds\MachShin02.wav

struct SoundData
{
	var() Sound AmbSound;
	var() byte AmbSoundRadius;
	var() byte AmbSoundVolume;
};

var() SoundData AmbSounds[3];
var SoundProxy SoundProxies[3];

var() float MinAnimRate;
var() float MaxAnimRate;

// NOTE[aleiby]: This should correspond to the maximum number of players allowed in Multiplayer/Arena mode.
var Pawn AffectedPlayers[16];
var float InitialGlowScale[16];
var float DamageTime[16];
var float DamageTimer[16];

var() float AdditionalGlowScale;

var() float MaxDamageResolution;	// How often damage is given.  In seconds.
var() float MinDamageResolution;	// Must be larger than zero.

var() float AffectResolution;
var float AffectTimer;

var() vector GlowFog;
var() float GlowScale;

var() float RandDamagePct;	// How random you want the damage to be.

var() float SearchRadius;		// How far to search.
var() float SearchResolution;	// How often to check for the closest pawn.
var float SearchTimer;

var RestPoint HomeBase;

var() class<Actor> SearchClasses[4];

replication
{
	reliable if( Role==ROLE_Authority )
		HomeBase;

	reliable if( Role==ROLE_Authority && bNetInitial )
		MaxDamageResolution,
		MinDamageResolution,
		AffectResolution,
		RandDamagePct,
		SearchRadius,
		SearchResolution,
		SearchClasses;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local int i;

	Super.PreBeginPlay();
	
	if( HomeBase == None )
	{
		HomeBase = Spawn( class'RestPoint' );
	}

	Velocity = vect(0,0,0);

	for( i = 0; i < ArrayCount(AmbSounds); i++ )
	{
		if( AmbSounds[i].AmbSound != None )
		{
			SoundProxies[i] = Spawn( class'SoundProxy',,, Location );
			SoundProxies[i].AmbientSound = AmbSounds[i].AmbSound;
			SoundProxies[i].SoundRadius = AmbSounds[i].AmbSoundRadius;
			SoundProxies[i].SoundVolume = AmbSounds[i].AmbSoundVolume;
		}
	}

	Spawn( class'MSInnerRotator', Self,, Location, rotator(vect(0,0,1)) );
	Spawn( class'MSOuterRotator', Self,, Location, rotator(vect(0,0,1)) );
	Spawn( class'MSFillerRotator', Self,, Location, rotator(vect(0,0,1)) );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;
	local float Scalar;		// A value between 1.0 and 0.0 - 1.0 means the player is dead center, 0.0 means the player is on our collision hull.
	local Actor ClosestPawn;
	
	Super.Tick( DeltaTime );

	if( Role==ROLE_Authority )	// Let the server worry about it.
	{
		// Find the closest pawn and hunt him down.
		// If we can't find anyone, go back to our resting position.
		SearchTimer -= DeltaTime;
		if( SearchTimer < 0 )
		{
			SearchTimer += SearchResolution;
			
			ClosestPawn = GetClosestPawn();
			if( ClosestPawn != None )
			{
				SetDestination( ClosestPawn );
			}
			else
			{
				SetDestination( HomeBase );
			}
		}
	
		// Update view fog.
		AffectTimer += DeltaTime;
		if( AffectTimer > AffectResolution )
		{
			AffectTimer = 0;
			
			for( i = 0; i < ArrayCount(AffectedPlayers); i++ )
			{
				if( AffectedPlayers[i] != None )
				{
					Scalar = 1.0 - (VSize( Location - AffectedPlayers[i].Location ) / ProjCollisionRadius);
					// Limit, just in case.
					//Scalar = FMin( 1.0, Scalar );
					Scalar = FMax( 0.0, Scalar );
/*				
					if( PlayerPawn(AffectedPlayers[i]) != None )
					{
						PlayerPawn(AffectedPlayers[i]).ConstantGlowScale = InitialGlowScale[i] - Scalar - AdditionalGlowScale;
					}
*/
					// DamageTime[i] gets bigger as we get further from the center.
					DamageTime[i] = MinDamageResolution + (MaxDamageResolution - MinDamageResolution)*(1.0 - Scalar);
					
					Randomize( DamageTime[i], RandDamagePct );
				}
			}
		}
		
		// Damage players.
		for( i = 0; i < ArrayCount(AffectedPlayers); i++ )
		{
			if( AffectedPlayers[i] != None )
			{
				DamageTimer[i] += DeltaTime;
				if( DamageTimer[i] > DamageTime[i] )
				{
					DamageTimer[i] = 0;
					AffectedPlayers[i].TakeDamage( 1.0, None, AffectedPlayers[i].Location, vect(0,0,0), 'NoFlash' );
				}
			}
		}
	}
	
	// Update SoundProxy locations.
	for( i = 0; i < ArrayCount(SoundProxies); i++ )
	{
		SoundProxies[i].SetLocation( Location );
	}
}

//------------------------------------------------------------------------------
// On exit, value will range from Value - (PercentDifference*Value) to Value + (PercentDifference*Value).
//------------------------------------------------------------------------------
simulated function Randomize( out float Value, float PercentDifference )
{
	local float Diff;
	
	Diff = Value * PercentDifference;
	
	Value = (Value - Diff) + (2 * Diff * FRand());
}

//------------------------------------------------------------------------------
function Actor GetClosestPawn()
{
	local Pawn IterPawn;
	local Projectile IterProj;
	local Actor Closest;
	local float IterDist, ClosestDist;
	local int i;

/* -- too slow.
	for( i = 0; SearchClasses[i] != None; i++ )
	{
		foreach RadiusActors( SearchClasses[i], IterPawn, SearchRadius )
		{
			if( Pawn(IterPawn) != None && Pawn(IterPawn).Health > 0 )	// Only go after live bait.
			{
				IterDist = VSize( IterPawn.Location - Location );
				if( ClosestPawn == None || IterDist < ClosestDist )
				{
					ClosestPawn = IterPawn;
					ClosestDist = IterDist;
				}
			}
		}
	}
*/

	// Search for AngrealIllusionProjectiles first.
	for( IterProj = Level.ProjectileList; IterProj != None; IterProj = IterProj.NextProjectile )
	{
		if( IterProj.IsA('AngrealIllusionProjectile') )
		{
			IterDist = VSize( IterProj.Location - Location );
			if( Closest == None || IterDist < ClosestDist )
			{
				Closest = IterProj;
				ClosestDist = IterDist;
			}
		}
	}
	
	if( Closest == None )
	{
		for( IterPawn = Level.PawnList; IterPawn != None; IterPawn = IterPawn.NextPawn )
		{
			if( IterPawn != None && IterPawn.Health > 0 )	// Only go after live bait.
			{
				IterDist = VSize( IterPawn.Location - Location );
				if( Closest == None || IterDist < ClosestDist )
				{
					Closest = IterPawn;
					ClosestDist = IterDist;
				}
			}
		}	
	}

	return Closest;
}

//------------------------------------------------------------------------------
function AddAffectedPlayer( Pawn Player )
{
	local int i;
	
	// Find the next available slot
	for( i = 0; i < ArrayCount(AffectedPlayers); i++ )
	{
		if( AffectedPlayers[i] == None )
		{
			AffectedPlayers[i] = Player;
			if( PlayerPawn(Player) != None )
			{
				PlayerPawn(Player).ClientAdjustGlow( -GlowScale, GlowFog );
//				PlayerPawn(Player).ClientAdjustGlow( 0.0, GlowFog );
//				InitialGlowScale[i] = PlayerPawn(Player).ConstantGlowScale;
			}
			DamageTimer[i] = 0;
			DamageTime[i] = 0;
			break;	// No need to go on.
		}
	}
}

//------------------------------------------------------------------------------
function RemoveAffectedPlayer( Pawn Player )
{
	local int i;
	
	// Find the bugger.
	for( i = 0; i < ArrayCount(AffectedPlayers); i++ )
	{
		if( AffectedPlayers[i] == Player )
		{
			AffectedPlayers[i] = None;
			if( PlayerPawn(Player) != None )
			{
//				PlayerPawn(Player).ConstantGlowScale = InitialGlowScale[i];
//				PlayerPawn(Player).ClientAdjustGlow( 0.0, -GlowFog );
				PlayerPawn(Player).ClientAdjustGlow( GlowScale, -GlowFog );
			}
			break;	// No need to go on.
		}
	}
}

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
function ProjTouch( Actor Other )
{
	if( Pawn(Other) != None )
	{
		AddAffectedPlayer( Pawn(Other) );
	}
}

//------------------------------------------------------------------------------
function ProjUnTouch( Actor Other )
{
	if( Pawn(Other) != None )
	{
		RemoveAffectedPlayer( Pawn(Other) );
	}
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	// Don't explode.
}

//------------------------------------------------------------------------------
simulated function bool CanDirectlyReachDestination( vector Dest )
{
	// Machin Shin has no need for walls.  
	// It simply goes right through them.
	return true;
}

//------------------------------------------------------------------------------
simulated function NotifyReachedDestination()
{
	SetVelocity( vect(0,0,0) );
/*
	local rotator Rot;

	// Rotate around our victim.
	Rot = rotator( Destination.Location - Location );
	Rot.Yaw += 16000;	// Less than 90 degrees.
	Rot.Pitch = 0;
	Rot.Roll = Rotation.Roll;
	SetVelocity( (vect(1,0,0) * Speed) >> Rot );
	SetRotation( Rot );
*/
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	if( HomeBase != None )
	{
		HomeBase.Destroy();
		HomeBase = None;
	}

	for( i = 0; i < ArrayCount(AmbSounds); i++ )
	{
		if( SoundProxies[i] != None )
		{
			SoundProxies[i].Destroy();
			SoundProxies[i] = None;
		}
	}

	Super.Destroyed();
}

defaultproperties
{
     AmbSounds(0)=(AmbSound=Sound'MachinShin.MachShin01',AmbSoundRadius=255,AmbSoundVolume=200)
     AmbSounds(1)=(AmbSound=Sound'MachinShin.MachShin01',AmbSoundRadius=255,AmbSoundVolume=200)
     AmbSounds(2)=(AmbSound=Sound'MachinShin.MachShin02',AmbSoundRadius=200,AmbSoundVolume=200)
     MinAnimRate=0.010000
     MaxAnimRate=0.030000
     AdditionalGlowScale=0.500000
     MaxDamageResolution=1.000000
     MinDamageResolution=0.020000
     AffectResolution=0.100000
     GlowFog=(X=0.020000,Y=0.020000,Z=0.020000)
     GlowScale=0.830000
     SearchRadius=16000.000000
     SearchResolution=2.000000
     SearchClasses(0)=Class'Engine.Pawn'
     SearchClasses(1)=Class'WOT.AngrealIllusionProjectile'
     Acceleration=20.000000
     bNotifiesDestination=False
     bGenProjTouch=True
     ProjCollisionRadius=1300.000000
     bTouchPawnsOnly=True
     speed=100.000000
     MaxSpeed=300.000000
     bCanTeleport=False
     LifeSpan=0.000000
     Style=STY_Translucent
     bMustFace=False
     Texture=None
     Skin=Texture'MachinShin.Skins.JMachinShin0'
     Mesh=Mesh'MachinShin.MachShin'
     DrawScale=47.000000
     ScaleGlow=0.150000
     bUnlit=True
     VisibilityRadius=2800.000000
     VisibilityHeight=2800.000000
     bCollideActors=False
     bCollideWorld=False
     bAllowClipping=True
     RenderIteratorClass=Class'Legend.DistanceFadeRI'
}
