//=============================================================================
// WOTCreatureChunk.
//=============================================================================

class WOTCreatureChunk expands WOTCarcassBase;

//=============================================================================
// Used to turn a carcass into a collection of chunks (these can be shot at and
// destroyed in turn).
//
// This class is usually used through the Carcass-derived classes where the Pawn
// carcass is "Chunked Up".
//=============================================================================

//=============================================================================
// TBD: unless RemoteRole=ROLE_DumbProxy, chunk velocity, location aren't being
// replicated properly. Not sure why at this point. Note that using 
// RemoteRole=ROLE_DumbProxy works although movement is pretty "chunky", but
// unfortunately, using this breaks the decals (they don't show up).
//
// For now I'm disabling shooting gibs in MP -- they should pbly fade away
// too quickly anyway.
//
// Might actually make sense to make gibs completely client-side (if possible)...
//=============================================================================

var() int NumGenericGibSounds;				// number of sounds in GenericGibSounds array
var() string GenericGibSounds[8];			// array of sound strings
var() string SpecialSound;					// special gib sound for specific cases
var() bool  bSpawnBlood;					// set to true to disable blood trails, bounce blood
var() float BaseGibSoundVolume;				// base volume for gib sounds
var() float BaseGibSoundPitch;				// base pitch for gib sounds
var() float GibVolumePerturbPercent;		// percent to randomize base volume by
var() float GibPitchPerturbPercent;			// percent to randomize base pitch by
var() float	MinGibSoundspeed;				// min speed above which gib sounds are played
var() float MinBounceSpeed;					// min speed above which chunk bounces
var() float DeleteChunkInitialDelaySecs;	// time after which to consider deleting chunk (randomized)
var() float DeleteChunkCheckAgainDelaySecs;	// time after which to consider deleting chunk
var() bool  bZeroYaw;						// set to true if final (landed) yaw needs to be cleared
var() bool  bZeroRoll;						// set to true if final (landed) roll needs to be cleared
var() bool  bZeroPitch;						// set to true if final (landed) pitch needs to be cleared
var() float BaseSinkRatePerSecMin; 			// min rate at which chunk sinks into ground
var() float BaseSinkRatePerSecMax; 			// max rate at which chunk sinks into ground
var() bool  bShouldSink;					// whether excess gibs should sink or be destroyed
var() float BaseInitForVelocity;			// base velocity for randomly tossing chunk

var   float TotalSinkDistance;
var   bool  bSinking;						// once set to true, gib starts to disappear into the ground
var   bool	bDoneSinking;
var   ZoneInfo DeathZone;
var	  float SinkRatePerSec;

//=============================================================================

function PostBeginPlay()
{
	if( Region.Zone.bDestructive || ((Level.Game != None) && Level.Game.bLowGore) )
	{
		Destroy();
	}
	else 
	{
		if( !bDecorative )
		{
			DeathZone = Region.Zone;
			DeathZone.NumCarcasses++;
		}

		Super.PostBeginPlay();
	}
}

//=============================================================================

function Tick( float DeltaTime )
{
	local vector NewLocation;
	local float AmountToSink;

	Super.Tick( DeltaTime );

	if( bSinking )
	{
		// carcass override -- pull gibs into ground a la Q3A
		NewLocation = Location;

		AmountToSink = DeltaTime*SinkRatePerSec;

		NewLocation.Z -= AmountToSink;

		SetLocation( NewLocation );

		TotalSinkDistance += AmountToSink;
		if( TotalSinkDistance > 2*CollisionHeight + 20 )
		{
			bDoneSinking = true;
			Destroy();
		}
	}
}

//=============================================================================

function BaseChange()
{
	if( !bDoneSinking )
	{
		TotalSinkDistance = 0.0;
		Super.BaseChange();
	}
}

//=============================================================================

function PlayGibSound()
{
	local float Volume, Pitch;
	local int SelectedSound;
	local Sound GibSound;

	if( SpecialSound == "" )
	{
		SelectedSound = Rand( NumGenericGibSounds );
		GibSound = Sound( DynamicLoadObject( GenericGibSounds[SelectedSound], class'Sound' ) );
	}
	else
	{
		GibSound = Sound( DynamicLoadObject( SpecialSound, class'Sound' ) );
	}
	
	Volume = class'util'.static.PerturbFloatPercent( BaseGibSoundVolume, GibVolumePerturbPercent );
	Pitch = class'util'.static.PerturbFloatPercent( BaseGibSoundPitch, GibPitchPerturbPercent );

	PlaySound( GibSound, SLOT_Misc, Volume,,,Pitch );
}

//=============================================================================

function Destroyed()
{
	// carcass count is reduced as soon as gib starts sinking (or
	// becomes a decoration ) so don't reduce it again here
	if( !bSinking )
	{
		if ( !bDecorative )
		{
			DeathZone.NumCarcasses--;
		}
	}

	Super.Destroyed();
}

//=============================================================================

function InitFor( actor Other )
{
	local vector RandDir;
	local Rotator ChunkRotator;

	if ( bDecorative )
	{
		DeathZone = Region.Zone;
		DeathZone.NumCarcasses++;
	}
	bDecorative = false;

	// Chunks are correctly scaled for most humanoid characters so scale these
	// using the relative height of the source creature if applicable (WOT's
	// model scaling is pretty well hosed compared to Unreal's).
	if( Other.IsA( 'WOTCarcassBase' ) )
	{
		DrawScale = default.DrawScale * 
					( WOTCarcassBase(Other).SourceCollisionHeight /
					  Class'WOTPlayer'.default.CollisionHeight );

		// scale mass with square of drawscale change
		if( DrawScale != default.DrawScale )
		{
			Mass = default.Mass*(DrawScale*DrawScale)/(default.DrawScale*default.DrawScale);
		}

		InheritBloodClasses( WOTCarcassBase(Other) );
	}

	// randomize rotation
	RotationRate.Yaw	= Rand(200000) - 100000;
	RotationRate.Pitch	= Rand(200000 - Abs(RotationRate.Yaw)) - 0.5 * (200000 - Abs(RotationRate.Yaw));
	RotationRate.Roll	= Rand(200000) - 100000;
	
	Velocity	= (0.2 + FRand()) * BaseInitForVelocity * Normal( VRand() );
	Velocity.Z	= (0.2 + FRand()) * BaseInitForVelocity;

	if( Region.Zone.bWaterZone )
	{
		Velocity *= 0.5;
	}

	if( FRand() < 0.3 )
	{
		Buoyancy = 1.06 * Mass; // float chunk
	}
	else
	{
		Buoyancy = 0.94 * Mass;
	}
}

//=============================================================================

function ChunkUp( int Damage )
{
	if( bHidden )
	{
		return;
	}

	Destroy();
}

//=============================================================================

simulated function Landed( vector HitNormal )
{
	local rotator FinalRot;
	local rotator SurfaceRotator;

	FinalRot = Rotation;

	if( bZeroYaw )
	{
		class'util'.static.ZeroRotParam( FinalRot.Yaw );
	}
	if( bZeroRoll )
	{
		class'util'.static.ZeroRotParam( FinalRot.Roll );
	}
	if( bZeroPitch )
	{
		class'util'.static.ZeroRotParam( FinalRot.Pitch );
	}

	SurfaceRotator = Rotator( Normal(vect(0,0,1) - HitNormal) );
	FinalRot += SurfaceRotator;

	SetRotation( FinalRot );

	SetPhysics( PHYS_None );
	SetCollision( true, false, false );

	bBounce = true;
	Enable( 'HitWall' );
}

//=============================================================================

simulated function HitWall( vector HitNormal, actor Wall )
{
	local float Speed;
	local Decal BloodDecal;

	if( bSpawnBlood )
	{
		if( HitNormal.Z ~= 0.0 )
		{
			// this seems to be needed to get decals on walls...
			BloodDecal = Spawn( BloodDecalClass,,, Location - (10 * HitNormal) );
		}
		else
		{
			BloodDecal = Spawn( BloodDecalClass,,, Location );
		}

		if( BloodDecal != None )
		{
			BloodDecal.Align( HitNormal );
		}
	}

	Velocity = RandRange(0.8, 0.6) * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	Velocity.Z = FMin(Velocity.Z * RandRange(0.8, 0.6), 700);
	Speed = VSize(Velocity);

	if( Speed > 700 )
	{
		Velocity *= 0.8;
	}

	if( Speed > MinGibSoundspeed )
	{
		PlayGibSound();
	}

	if( Speed < MinBounceSpeed )
	{
		bBounce = false;
		Disable('HitWall');
	}
}

//=============================================================================

function TakeDamage( int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType )
{
	if( Level.NetMode == NM_Standalone )
	{
		// this doesn't work with ROLE_SimulatedProxy and with ROLE_DumbProxy, the decals break
		SetPhysics( PHYS_Falling );
		bBobbing = false;
		Velocity += Momentum/Mass;
	}

	if( bSpawnBlood )
	{
		SpawnBlood( HitLocation, DamageCarcassBloodClassStr );
	}

	if( bTakesDamage )
	{
		CumulativeDamage += Damage;

		if( (DamageType != 'PainZone' && Damage > FMin(15, Mass)) || (CumulativeDamage > Mass) )
		{
			ChunkUp( Damage );
		}
	}
}

//=============================================================================
// Dying state
//=============================================================================

auto state Dying
{
	ignores TakeDamage;

Begin:
	if( bDecorative )
	{
		SetPhysics( PHYS_None );
	}

	Sleep(0.35);
	SetCollision( true, false, false );
	GotoState('Dead');
}	

//=============================================================================

function StartSinking()
{
	local vector CCOffset;

	if( bShouldSink && !Region.Zone.bWaterZone )
	{
		SetPhysics( Phys_None );
		SetCollision( false, false, false );
		bCollideWorld = false;

	   	// Shift the collision cylinder way up so center of gibs won't sink out
	   	// of sight before the mesh (engine makes these bUnlit otherwise). This
	   	// seems to be the easiest way to fix this problem -- can't find another
	   	// (real problem is that Actor->Region.iLeaf becomes INDEX_NONE in SetupForActor).
		CCOffset.x = 0;
		CCOffset.y = 0;
		CCOffset.z = 4*CollisionHeight;
		class'Util'.static.ShiftCollisionCylinder( Self, CCOffset );

		SinkRatePerSec = RandRange( BaseSinkRatePerSecMin, BaseSinkRatePerSecMax );

		bSinking = true;
	}
	else
	{
		Destroy();
	}
}

//=============================================================================
// Dead state
//=============================================================================

state Dead 
{
	function Timer()
	{
		// extra check for bDecorative to disable cleanup (e.g. for rats)
		if( !bDecorative )
		{
			if((DeathZone.NumCarcasses > DeathZone.MaxCarcasses) ||
				((Level.NetMode != NM_Standalone) || Level.Game.IsA('giCombatBase')) )
			{
				// too many carcasses (includes chunks) or non-SP game -- get rid of gib
				DeathZone.NumCarcasses--;

				StartSinking();
			}
			else
			{
				// check again in a bit
				SetTimer( DeleteChunkCheckAgainDelaySecs, false  );
			}
		}
		else
		{
			// became a "decoration"
			DeathZone.NumCarcasses--;
		}
	}
	
	function BeginState()
	{
		if( bPermanent || bDecorative )
		{
			// gib will never be destroyed (gibs from gibbed carcasses will be cleaned up)
			LifeSpan = 0.0;
		}
		else
		{
			// will check periodically to see if gib should be destroyed
			SetTimer( class'util'.static.PerturbFloatPercent( DeleteChunkInitialDelaySecs, 50.0 ), false );
		}
	}
}

//=============================================================================

defaultproperties
{
     NumGenericGibSounds=5
     GenericGibSounds(0)="WOT.GibBounce1"
     GenericGibSounds(1)="WOT.GibBounce2"
     GenericGibSounds(2)="WOT.GibBounce3"
     GenericGibSounds(3)="WOT.GibBounce4"
     GenericGibSounds(4)="WOT.GibBounce5"
     bSpawnBlood=True
     BaseGibSoundVolume=1.000000
     BaseGibSoundPitch=1.000000
     GibVolumePerturbPercent=30.000000
     GibPitchPerturbPercent=30.000000
     MinGibSoundspeed=100.000000
     MinBounceSpeed=120.000000
     DeleteChunkInitialDelaySecs=8.000000
     DeleteChunkCheckAgainDelaySecs=2.000000
     BaseSinkRatePerSecMin=1.000000
     BaseSinkRatePerSecMax=12.000000
     bShouldSink=True
     BaseInitForVelocity=200.000000
     PainZoneDamageScale=0.100000
     GoreLevel=3
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bCollideActors=False
     bBounce=True
     bFixedRotationDir=True
     Mass=30.000000
     Buoyancy=27.000000
     RotationRate=(Pitch=30000,Roll=30000)
}
