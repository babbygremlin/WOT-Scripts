//------------------------------------------------------------------------------
// ParticleSprayer.uc
// $Author: Jcrable $
// $Date: 10/13/99 6:01p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Place in a level.
// + Aim in the desired direction.
// + Set properties as desired.
//------------------------------------------------------------------------------
// Todo:
//
// + Decide whether ParticleSprayers should have no replication, or if they 
//   should be triggered, etc on the server-side, and have the variables
//   replicated to the clients.  Currently there is no replication.  
//   If we ever want to do puzzles with it, it should probably run server-side
//   and replicate changes to the clients.
//
// + Add rotation interpolation.
//
//------------------------------------------------------------------------------
class ParticleSprayer expands Actor
	intrinsic;

#exec OBJ LOAD FILE=Textures\WOTParticles.utx PACKAGE=ParticleSystems
#exec TEXTURE IMPORT FILE=Textures\S_ParticleSprayer.pcx GROUP=Icons MIPS=Off FLAGS=2

// Defines a cone that the particles will be sprayed from.
// An angle in degress centered on our rotation vector.
var() float Spread;

// Number of particles emitted per second.
var() float Volume;

// Direction and magnitude of acceleration to apply to particles.
var() vector Gravity;

// Sprites to be used as particles.
struct Particle
{
	var() float LifeSpan;			// Number of seconds before destruction.

	var() float Weight;				// Relative probability of being chosen with DIST_Random.

	var() float MaxInitialVelocity;	// Velocity to start out with.
	var() float MinInitialVelocity;

	var() float MaxDrawScale;		// DrawScale to start out with.
	var() float MinDrawScale;

	var() float MaxScaleGlow;		// ScaleGlow to start out with.
	var() float MinScaleGlow;

	var() byte  GrowPhase;			// Number of toggles per lifespan.	(Toggles meaning inverting the GrowRate)
	var() float MaxGrowRate;		// DrawScale per second.	(positive values mean grow)
	var() float MinGrowRate;		//							(negative values mean shrink) 

	var() byte  FadePhase;			// Number of toggles per lifespan.	(Toggles meaning inverting the FadeRate)
	var() float MaxFadeRate;		// ScaleGlow per second.	(positive values mean fade in)
	var() float MinFadeRate;		//							(negative values mean fade out)
};

// Extra mesh related data.
struct AdditionalData
{
	var() rotator MaxInitialRotation;
	var() rotator MinInitialRotation;
	var() rotator MaxRotationRate;
	var() rotator MinRotationRate;
};

// Mesh animation rates.
var(Display) float MaxAnimRate;
var(Display) float MinAnimRate;

// Number of templates in the template array.
// When adding to the template/particles array, you will have to fill the slots in order
// so as not to cause the C++ code to reference Null data.  In addition, you will have
// to explicitly define how many templates have been filled in using this variable.
var() byte NumTemplates;

// Templates used to create the actual particles from.
var() Particle Templates[16];

// Used internally for linear distributions.
// (stored seperately since adding more stuff to the Particle struct doesn't shine in 
// the face of binary compatibility too well.)
var float Frequencies[16];
var float CumulativeFreqs[16];

// If you are using Linear Distribution, you need to set this variable to True if you change
// any of the templates' weights.  This tells the RenderIterator to update itself accordingly.
// Once the RI is up to date (i.e. the next time the frame is drawn), this variable will
// automatically be reset to false.
var() bool bLinearFrequenciesChanged;

// Extra data for meshes.
var() AdditionalData MeshData[16];

// Associated sprites to use with the above templates.
// This is kept seperate from the struct since it tends to crash UnrealEd when it's part of the Templates stuct.
var() Texture Particles[16];

var() enum EDistribution
{
	DIST_Random,	// Randomly pick a particle from the particle list.
	DIST_Linear		// Cyclically iterate though the particle list.
} ParticleDistribution;

// Number of iterations to prime the particle system with.
// (Assumes a 30 fps frame rate).
var() float PrimeCount;

// How long we stay on when TriggerTimed.
var() float TimerDuration;

// Used interally for TriggerTimed (see UParticleSprayerRI.cpp).
var float InternalTimer;

// Are we initially on?
var() bool bInitiallyOn;

// Are we on? - Used internally.  Can be used to turn particle systems on and off in UnrealEd.
var() bool bOn;

// If set, particles generate from this actor's location.
var Actor FollowActor;

// Absolute offset from our FollowActor (if we have one).
// Note: This is _not_ relative to the FollowActor's rotation.
var vector FollowOffset;

// Offset relative to our FollowActor.
// Note: This is maintainted internally.  
// Use SetFolowActor to attach this particle sprayer to an actor.
var vector RelativeOffset;
var rotator RelativeRotation;

// Percentage of the visibility radius used to scale the volume of the particle sprayer.
var() float VolumeScalePct;	// A number from 0.0 to 1.0.

// Clip using line of sight check?
var() bool bLOSClip;

// Minimum volume that Level->Engine-Client->ParticleDensity is allowed to scale us to.
var() float MinVolume;

// Decal support.
var(Decals) class<Decal> DecalType;	// Type of Decals to spray.
var(Decals) float DecalPercent;		// Percent of decals per particles.
var(Decals) float DecalMinLifeSpan, DecalMaxLifeSpan;	// Set to zero to use decal's default values.
var float DecalTimer;

// Interpolation.
var() bool bInterpolate;

// Grouping support.
var() bool bGrouped;
var() bool bRotationGrouped;
var() vector RotationPoint;

// Wind support.
var() bool bIsWindResistant;

// Do we need the overhead of the tick function below (for decals, etc).
var() bool bDisableTick;

/*
replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		Volume, MinVolume, 
		FollowActor, RelativeOffset, RelativeRotation;

	reliable if( Role==ROLE_Authority )
		bOn, Gravity;

	unreliable if( Role==ROLE_Authority )
		Templates, Particles;
}
*/
replication
{
	reliable if( Role==ROLE_Authority )
		Spread,
		Volume,
		Gravity,
		MaxAnimRate,
		MinAnimRate,
		NumTemplates,
		Templates,
		MeshData,
		Particles,
		ParticleDistribution,
		PrimeCount,
		TimerDuration,
		InternalTimer,
		bInitiallyOn,
		bOn,
		FollowActor,
		FollowOffset,
		RelativeOffset,
		RelativeRotation,
		VolumeScalePct,
		bLOSClip,
		MinVolume,
		DecalType,
		DecalPercent,
		DecalMinLifeSpan,
		DecalMaxLifeSpan,
		DecalTimer,
		bInterpolate,
		bGrouped,
		bRotationGrouped,
		RotationPoint,
		bIsWindResistant,
		bDisableTick;
}

//------------------------------------------------------------------------------
// Use to shift all particles in the current system by the given vector.
//------------------------------------------------------------------------------
native(1003) final function ShiftParticles( vector Delta );

//------------------------------------------------------------------------------
// Used to rotation all particles in the current system by the given rotation
// about the given point.  (Defaults to rotation about its own Location.)
//------------------------------------------------------------------------------
native(1004) final function RotateParticles( rotator Delta, optional vector Origin );

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	// Force Linear frequencies to be recalculated if used.
	bLinearFrequenciesChanged = true;

	// Ensure we start with a fresh render iterator.
	if( RenderInterface != None )
	{
		RenderInterface.Delete();
		RenderInterface = None;
	}

	Super.PreBeginPlay();
	
	bOn = bInitiallyOn;

	if( bDisableTick )
	{
		Disable('Tick');
	}
}

//------------------------------------------------------------------------------
// Toggles us on and off when triggered.
//------------------------------------------------------------------------------
simulated state() TriggerToggle
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		bOn = !bOn;
	}
}

//------------------------------------------------------------------------------
// Toggled when Triggered.
// Toggled back to initial state when UnTriggered.
//------------------------------------------------------------------------------
simulated state() TriggerControl
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		bOn = !bInitiallyOn;
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		bOn = bInitiallyOn;
	}
}

//------------------------------------------------------------------------------
// Toggled when triggered.
// Toggled back to initial state after TimerDuration seconds.
//------------------------------------------------------------------------------
simulated state() TriggerTimed
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		bOn = !bInitiallyOn;
		//SetTimer( TimerDuration, false );
		InternalTimer = TimerDuration;	// Maintained in UParticleSprayerRI.cpp
	}

/* -- Moved to UParticleSprayerRI.cpp
	simulated function Timer()
	{
		bOn = bInitiallyOn;
	}
*/
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local Decal D;
	local int Index;
	local float IScaledVolume;	// inverse scaled volume.

	Super.Tick( DeltaTime );

	// Create new decals as needed.
	if( DecalType != None && bOn && NumTemplates > 0 && Volume > 0.0 )
	{
		DecalTimer += DeltaTime;
		IScaledVolume = 1.0 / (Volume * DecalPercent);
		while( DecalTimer >= IScaledVolume )
		{
			// Update the timer according to the set Volume.
			DecalTimer -= IScaledVolume;

			// Throw a decal using a random Template.
			Index = Rand( NumTemplates );
			D = Spawn( DecalType,,, Location );
			if( D != None )
			{
				D.Velocity = class'Util'.static.CalcSprayDirection( Rotation, Spread ) * RandRange( Templates[Index].MinInitialVelocity, Templates[Index].MaxInitialVelocity );
				D.LifeSpan = RandRange( DecalMinLifeSpan, DecalMaxLifeSpan );
			}
		}
	}

	// Update location.
	if( FollowActor != None )
	{
		FollowOffset = RelativeOffset >> FollowActor.Rotation;
		SetLocation( FollowActor.Location + FollowOffset );
		SetRotation( FollowActor.Rotation + RelativeRotation );
	}
}

//------------------------------------------------------------------------------
// Use this instead of SetBase to attach a particle sprayer to an Actor.
// Set the location and rotation of the particle sprayer relative to the
// actor you are attaching it to, before calling this function.
//------------------------------------------------------------------------------
simulated function SetFollowActor( Actor Other )
{
	FollowActor = Other;
	RelativeOffset = (Location - Other.Location) << FollowActor.Rotation;
	FollowOffset = RelativeOffset >> FollowActor.Rotation;

	RelativeRotation = Rotation - Other.Rotation;
}

//------------------------------------------------------------------------------
// Struct Accessor functions.
//
// (Due to "Context expression: Variable is too large (896 bytes, 255 max)" limitation of UnrealScript.)
//------------------------------------------------------------------------------
simulated function SetParticleLifeSpan				( float LifeSpan,			int Index ){	Templates[ Index ].LifeSpan				= LifeSpan;				}
simulated function SetParticleWeight				( float Weight,				int Index ){	Templates[ Index ].Weight				= Weight;				}
simulated function SetParticleMaxInitialVelocity	( float MaxInitialVelocity,	int Index ){	Templates[ Index ].MaxInitialVelocity	= MaxInitialVelocity;	}
simulated function SetParticleMinInitialVelocity	( float MinInitialVelocity,	int Index ){	Templates[ Index ].MinInitialVelocity	= MinInitialVelocity;	}
simulated function SetParticleMaxDrawScale			( float MaxDrawScale,		int Index ){	Templates[ Index ].MaxDrawScale			= MaxDrawScale;			}
simulated function SetParticleMinDrawScale			( float MinDrawScale,		int Index ){	Templates[ Index ].MinDrawScale			= MinDrawScale;			}
simulated function SetParticleMaxScaleGlow			( float MaxScaleGlow,		int Index ){	Templates[ Index ].MaxScaleGlow			= MaxScaleGlow;			}
simulated function SetParticleMinScaleGlow			( float MinScaleGlow,		int Index ){	Templates[ Index ].MinScaleGlow			= MinScaleGlow;			}
simulated function SetParticleGrowPhase				( byte  GrowPhase,			int Index ){	Templates[ Index ].GrowPhase			= GrowPhase;			}
simulated function SetParticleMaxGrowRate			( float MaxGrowRate,		int Index ){	Templates[ Index ].MaxGrowRate			= MaxGrowRate;			}
simulated function SetParticleMinGrowRate			( float MinGrowRate,		int Index ){	Templates[ Index ].MinGrowRate			= MinGrowRate;			}
simulated function SetParticleFadePhase				( byte  FadePhase,			int Index ){	Templates[ Index ].FadePhase			= FadePhase;			}
simulated function SetParticleMaxFadeRate			( float MaxFadeRate,		int Index ){	Templates[ Index ].MaxFadeRate			= MaxFadeRate;			}
simulated function SetParticleMinFadeRate			( float MinFadeRate,		int Index ){	Templates[ Index ].MinFadeRate			= MinFadeRate;			}
//------------------------------------------------------------------------------
simulated function float GetParticleLifeSpan			( int Index ){	return Templates[ Index ].LifeSpan;				}
simulated function float GetParticleWeight				( int Index ){	return Templates[ Index ].Weight;				}
simulated function float GetParticleMaxInitialVelocity	( int Index ){	return Templates[ Index ].MaxInitialVelocity;	}
simulated function float GetParticleMinInitialVelocity	( int Index ){	return Templates[ Index ].MinInitialVelocity;	}
simulated function float GetParticleMaxDrawScale		( int Index ){	return Templates[ Index ].MaxDrawScale;			}
simulated function float GetParticleMinDrawScale		( int Index ){	return Templates[ Index ].MinDrawScale;			}
simulated function float GetParticleMaxScaleGlow		( int Index ){	return Templates[ Index ].MaxScaleGlow;			}
simulated function float GetParticleMinScaleGlow		( int Index ){	return Templates[ Index ].MinScaleGlow;			}
simulated function byte  GetParticleGrowPhase			( int Index ){	return Templates[ Index ].GrowPhase;			}
simulated function float GetParticleMaxGrowRate			( int Index ){	return Templates[ Index ].MaxGrowRate;			}
simulated function float GetParticleMinGrowRate			( int Index ){	return Templates[ Index ].MinGrowRate;			}
simulated function byte  GetParticleFadePhase			( int Index ){	return Templates[ Index ].FadePhase;			}
simulated function float GetParticleMaxFadeRate			( int Index ){	return Templates[ Index ].MaxFadeRate;			}
simulated function float GetParticleMinFadeRate			( int Index ){	return Templates[ Index ].MinFadeRate;			}
//------------------------------------------------------------------------------
simulated function float GetDefaultParticleLifeSpan				( int Index ){	return default.Templates[ Index ].LifeSpan;				}
simulated function float GetDefaultParticleWeight				( int Index ){	return default.Templates[ Index ].Weight;				}
simulated function float GetDefaultParticleMaxInitialVelocity	( int Index ){	return default.Templates[ Index ].MaxInitialVelocity;	}
simulated function float GetDefaultParticleMinInitialVelocity	( int Index ){	return default.Templates[ Index ].MinInitialVelocity;	}
simulated function float GetDefaultParticleMaxDrawScale			( int Index ){	return default.Templates[ Index ].MaxDrawScale;			}
simulated function float GetDefaultParticleMinDrawScale			( int Index ){	return default.Templates[ Index ].MinDrawScale;			}
simulated function float GetDefaultParticleMaxScaleGlow			( int Index ){	return default.Templates[ Index ].MaxScaleGlow;			}
simulated function float GetDefaultParticleMinScaleGlow			( int Index ){	return default.Templates[ Index ].MinScaleGlow;			}
simulated function byte  GetDefaultParticleGrowPhase			( int Index ){	return default.Templates[ Index ].GrowPhase;			}
simulated function float GetDefaultParticleMaxGrowRate			( int Index ){	return default.Templates[ Index ].MaxGrowRate;			}
simulated function float GetDefaultParticleMinGrowRate			( int Index ){	return default.Templates[ Index ].MinGrowRate;			}
simulated function byte  GetDefaultParticleFadePhase			( int Index ){	return default.Templates[ Index ].FadePhase;			}
simulated function float GetDefaultParticleMaxFadeRate			( int Index ){	return default.Templates[ Index ].MaxFadeRate;			}
simulated function float GetDefaultParticleMinFadeRate			( int Index ){	return default.Templates[ Index ].MinFadeRate;			}
//------------------------------------------------------------------------------

defaultproperties
{
     Spread=45.000000
     Volume=10.000000
     Templates(0)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(1)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(2)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(3)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(4)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(5)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(6)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(7)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(8)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(9)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(10)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(11)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(12)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(13)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(14)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     Templates(15)=(LifeSpan=1.000000,Weight=1.000000,MaxDrawScale=1.000000,MinDrawScale=1.000000,MaxScaleGlow=1.000000,MinScaleGlow=1.000000)
     bLinearFrequenciesChanged=True
     bInitiallyOn=True
     VolumeScalePct=0.500000
     DecalPercent=0.100000
     bDisableTick=True
     bStatic=True
     RemoteRole=ROLE_None
     Rotation=(Pitch=16384)
     bSpecialRotationRep=True
     bDirectional=True
     Style=STY_Translucent
     SpriteProjForward=0.000000
     Texture=Texture'ParticleSystems.Icons.S_ParticleSprayer'
     VisibilityRadius=1600.000000
     VisibilityHeight=1600.000000
     bGameRelevant=True
     RenderIteratorClass=Class'ParticleSystems.ParticleSprayerRI'
}
