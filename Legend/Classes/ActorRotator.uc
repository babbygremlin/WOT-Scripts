//------------------------------------------------------------------------------
// ActorRotator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//
// Description:	Used to rotate any actor or set of actors in a given level
//				using the specified parameters.
//------------------------------------------------------------------------------
// How to use this class (from UnrealEd):
//
// + Place in level.
// + Link to desired Actors in level via Tag and Event.  
//   (Set Event on the ActorRotator, and match the Tag on the desired Actors
//   with that Event.)
// + Set parameters as desired.
//   - Radius, RotationRate and Height are self explanitory.
//   - ShiftRates are how fast the above variables change.  
//     At any given moment, an ActorRotator has a Current and Next version
//     of the above variables.  The current version of the variable is changed
//     at the rate defined by its respective ShiftRate until it reaches its
//     respective Next version of the variable.  Once it reaches this Next 
//     version of the variable, a new Next version of the variable is calculated.
//     This continues indefinately.
//   - Set bUpdateActorRotation to false if you would rather have the Actor(s)
//     be responsible for updating their own rotation.  
//     Example: Attaching a ParticleSprayer whose physics are set to PHYS_Rotating.
//   - ActorRotationOffset is used to correctly align a model so it appears to
//     always be facing forward.  This is only used when bUpdateActorRotation
//     is set to True.
//     Example: You want to use a bird mesh, but when you see it in the game, 
//     it is always facing out from the center instead of in the direction it
//     is moving.  In this case you would simply set ActorRotationOffset.Yaw
//     to 90 degrees.
//   - Note of interest: If you set MinRotationRate to a negative number, the
//     Actor(s) will eventually slow down and change rotation direction.  When the
//     rotation direction changes the Actor will also be flipped to maintain
//     correct orientation.  This is only done when bUpdateActorRotation is 
//     set to True.
//   - Important note: ActorRotators will not rotate Actors whose Tag matches
//     its own tag.  This prevents ActorRotators from rotating themselves and
//     any other ActorRotators it creates in the process.  This is only relevant
//     for ActorRotators whose Tag matches its own Event.
//   - Use bLongDistance if you are going to use a lot of these in a level.
//     This will only use a single ActorRotator to rotate all the attached
//     Actors.  This means that they will all be perfectly in sync with each
//     other, but still totally random within the restraints of the set parameters.
//     The attached Actor(s) will be rotated about their initial location rather
//     than the location of the ActorRotator itself.
//
//------------------------------------------------------------------------------
// How to use this class (from UnrealScript):
//
// + Spawn.
// + Set MyActor;
// + Set desired parameters as described above.
// + Call Initialize();
//------------------------------------------------------------------------------

class ActorRotator expands Actor
	native;

var() bool bLongDistance;			// Sync all connected actors, and use their respective
									// initial locations as their origin of rotation.

var() bool bUpdateActorRotation;	
var() rotator ActorRotationOffset;	// Offset from default. -- Default: X-axis is in alignment with velocity of the actor.
var() bool bFaceIn;
var() bool bFaceOut;

var() float MinRadius;				// Distance from origin.
var() float MaxRadius;
var() float RadiusShiftRate;		// How fast we change our radius.
var() bool bBounceRadius;			// NextRadius flips from MaxHeight to MinHeight.  Never in between.
var float CurrentRadius;
var float NextRadius;

var() float MinRotationRate;		// Used to calculate roll.
var() float MaxRotationRate;
var() float RotationShiftRate;		// How fast we change our rotation rate.
var() bool bBounceRotationRate;		// NextRotationRate flips from MaxHeight to MinHeight.  Never in between.
var float CurrentRotationRate;
var float NextRotationRate;
var float FRoll;

var() float MaxHeight;				// Relative to rotation.
var() float MinHeight;
var() float HeightShiftRate;		// How fast we change our height.
var() bool bBounceHeight;			// NextHeight flips from MaxHeight to MinHeight.  Never in between.
var float CurrentHeight;
var float NextHeight;

var() class<ActorRotator> ActorRotatorClass;

var Actor MyActor;
var Actor MyActors[256];
var vector ActorOrigins[256];

replication
{
	reliable if( Role==ROLE_Authority )
		bUpdateActorRotation,
		ActorRotationOffset,
		bFaceIn,
		bFaceOut,

		MinRadius,
		MaxRadius,
		RadiusShiftRate,
		bBounceRadius,
		CurrentRadius,
		NextRadius,

		MinRotationRate,
		MaxRotationRate,
		RotationShiftRate,
		bBounceRotationRate,
		CurrentRotationRate,
		NextRotationRate,
		FRoll,

		MaxHeight,
		MinHeight,
		HeightShiftRate,
		bBounceHeight,
		CurrentHeight,
		NextHeight,

		ActorRotatorClass;
}

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();
	
	// If this object was placed in a level via UnrealEd and its Event was
	// set, this will find the first actor with a matching tag and initilize
	// us.  Then it will proceed to find the rest of the actors with matching
	// tags.  For each of these additional actors, a new ActorRotator will be
	// created (at which point GetActor() will return without doing anything
	// because its Event won't be set), all of this object's variables will
	// will be copied over to the new object, the additional actor will be
	// assigned to it, and it will be initialized.
	GetActor();
}

//------------------------------------------------------------------------------
simulated function Initialize()
{
	CurrentRadius		= RandRange( MinRadius, MaxRadius );
	CurrentRotationRate	= RandRange( MinRotationRate, MaxRotationRate );
	CurrentHeight		= RandRange( MinHeight, MaxHeight );
	
	CalcNextRadius();
	CalcNextRotationRate();
	CalcNextHeight();
	
	// Randomize initial rotation.
	FRoll = 0xFFFF * FRand();
}

//////////////////////////
// Engine notifications //
//////////////////////////

/* -- Moved to C++ (EARI)
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local rotator Rot;
	local vector X, Y, Z, Offset;
	local int i;
	
	Super.Tick( DeltaTime );

	// Fail if we don't have an Actor to work with.
	if( MyActor == None )
	{
		return;
	}
	
	// Update modifiers.
	UpdateRadius( DeltaTime );
	UpdateRotationRate( DeltaTime );
	UpdateHeight( DeltaTime );
		
	// Update rotation.
	Rot = Rotation;
	FRoll += CurrentRotationRate * DeltaTime;
	Rot.Roll = int(FRoll) & 0xFFFF;		// Keep in range.
	SetRotation( Rot );
	
	// Update MyActor's position.
	GetAxes( Rotation, X, Y, Z );
	Offset = CurrentHeight*X + CurrentRadius*Y;
	if( !bLongDistance )
	{
		MyActor.SetLocation( Location + Offset );
	}
	else
	{
		for( i = 0; i < ArrayCount(MyActors) && MyActors[i] != None; i++ )
		{
			MyActors[i].SetLocation( ActorOrigins[i] + Offset );
		}
	}
	
	// Update MyActor's orientation.
	if( bFaceIn )
	{
		MyActor.SetRotation( rotator((Location + CurrentHeight*X) - MyActor.Location) );
	}
	else if( bFaceOut )
	{
		MyActor.SetRotation( rotator(MyActor.Location - (Location + CurrentHeight*X)) );
	}
	else if( bUpdateActorRotation )
	{
		if( CurrentRotationRate > 0 )	Rot = rotator(-Z) + ActorRotationOffset;
		else							Rot = rotator(Z) + ActorRotationOffset;

		if( !bLongDistance )
		{
			MyActor.SetRotation( Rot );
		}
		else
		{
			for( i = 0; i < ArrayCount(MyActors) && MyActors[i] != None; i++ )
			{
				MyActors[i].SetRotation( Rot );
			}
		}
	}
}
*/
//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Searches for all the actors with matching tags, links up with the first
// one, and creates copies for all the rest.
//------------------------------------------------------------------------------
simulated function GetActor()
{
	local Actor IterA;
	local ActorRotator AR;
	local int i;
	
	if( Event != '' )
	{
		foreach AllActors( class'Actor', IterA, Event )
		{
			if( IterA.Tag == Tag )
			{
				// Don't rotate objects whose tag matches our own.
				// This includes ourself and any ActorRotators we create.
			}
			else if( bLongDistance )
			{
				if( i >= ArrayCount(MyActors) )
				{
					warn( "Maximum number of Actors exceeded. ("$ArrayCount(MyActors)$") -- Continuing without errors.  Excess Actors will not be rotated." );
					break;
				}

				MyActors[i] = IterA;
				ActorOrigins[i] = IterA.Location;
				
				i++;
			}
			else if( MyActor == None )
			{
				MyActor = IterA;
				Initialize();
			}
			else
			{
				AR = Spawn( ActorRotatorClass, Owner, Tag, Location, Rotation );
				AR.Copy( Self );
				AR.MyActor = IterA;
				AR.Initialize();
			}
		}

		// Clean out rest of array and initalize rest of vars.
		if( bLongDistance )
		{
			while( i < ArrayCount(MyActors) )
			{
				MyActors[i++] = None;
			}

			Initialize();
		}
	}
}

//------------------------------------------------------------------------------
simulated function Copy( ActorRotator Template )
{
	bUpdateActorRotation	= Template.bUpdateActorRotation;
	ActorRotationOffset		= Template.ActorRotationOffset;
	MinRadius				= Template.MinRadius;
	MaxRadius				= Template.MaxRadius;
	RadiusShiftRate			= Template.RadiusShiftRate;	
	CurrentRadius			= Template.CurrentRadius;
	NextRadius				= Template.NextRadius;
	MinRotationRate			= Template.MinRotationRate;	
	MaxRotationRate			= Template.MaxRotationRate;
	RotationShiftRate		= Template.RotationShiftRate;	
	CurrentRotationRate		= Template.CurrentRotationRate;
	NextRotationRate		= Template.NextRotationRate;
	MaxHeight				= Template.MaxHeight;			
	MinHeight				= Template.MinHeight;
	HeightShiftRate			= Template.HeightShiftRate;	
	CurrentHeight			= Template.CurrentHeight;
	NextHeight				= Template.NextHeight;
	VisibilityRadius		= Template.VisibilityRadius;
	VisibilityHeight		= Template.VisibilityHeight;
	MyActor					= Template.MyActor;
	bHidden					= Template.bHidden;
	
	SetPhysics				( Template.Physics );
	bFixedRotationDir		= Template.bFixedRotationDir;
	RotationRate			= Template.RotationRate;

	SetBase					( Template.Base );
	AttachTag				= Template.AttachTag;
	Tag						= Template.Tag;
}

/////////////
// Natives //
/////////////

native(1010) final function Update( float DeltaTime );
native(1011) final function UpdateRadius( float DeltaTime );
native(1012) final function UpdateRotationRate( float DeltaTime );
native(1013) final function UpdateHeight( float DeltaTime );
native(1014) final function CalcNextRadius();
native(1015) final function CalcNextRotationRate();
native(1016) final function CalcNextHeight();

/* -- Moved to C++ (EARI)
//------------------------------------------------------------------------------
simulated function UpdateRadius( float DeltaTime )
{
	if( CurrentRadius < NextRadius )
	{
		CurrentRadius += RadiusShiftRate * DeltaTime;
		
		if( CurrentRadius >= NextRadius )
		{
			CalcNextRadius();
		}
	}
	else
	{
		CurrentRadius -= RadiusShiftRate * DeltaTime;
		
		if( CurrentRadius <= NextRadius )
		{
			CalcNextRadius();
		}
	}
}

//------------------------------------------------------------------------------
simulated function UpdateRotationRate( float DeltaTime )
{
	if( CurrentRotationRate < NextRotationRate )
	{
		CurrentRotationRate += RotationShiftRate * DeltaTime;
		
		if( CurrentRotationRate >= NextRotationRate )
		{
			CalcNextRotationRate();
		}
	}
	else
	{
		CurrentRotationRate -= RotationShiftRate * DeltaTime;
		
		if( CurrentRotationRate <= NextRotationRate )
		{
			CalcNextRotationRate();
		}
	}
}

//------------------------------------------------------------------------------
simulated function UpdateHeight( float DeltaTime )
{
	if( CurrentHeight < NextHeight )
	{
		CurrentHeight += HeightShiftRate * DeltaTime;
		
		if( CurrentHeight >= NextHeight )
		{
			CalcNextHeight();
		}
	}
	else
	{
		CurrentHeight -= HeightShiftRate * DeltaTime;
		
		if( CurrentHeight <= NextHeight )
		{
			CalcNextHeight();
		}
	}
}

//------------------------------------------------------------------------------
simulated function CalcNextRadius()
{
	if( bBounceRadius )
	{
		if( NextRadius == MinRadius ) 	NextRadius = MaxRadius;
		else							NextRadius = MinRadius;
	}
	else
	{
		NextRadius = RandRange( MinRadius, MaxRadius );
	}
}

//------------------------------------------------------------------------------
simulated function CalcNextRotationRate()
{
	if( bBounceRotationRate )
	{
		if( NextRotationRate == MinRotationRate ) 	NextRotationRate = MaxRotationRate;
		else										NextRotationRate = MinRotationRate;
	}
	else
	{
		NextRotationRate = RandRange( MinRotationRate, MaxRotationRate );
	}
}

//------------------------------------------------------------------------------
simulated function CalcNextHeight()
{
	if( bBounceHeight )
	{
		if( NextHeight == MinHeight ) 	NextHeight = MaxHeight;
		else							NextHeight = MinHeight;
	}
	else
	{
		NextHeight = RandRange( MinHeight, MaxHeight );
	}
}
*/

defaultproperties
{
     bUpdateActorRotation=True
     ActorRotatorClass=Class'Legend.ActorRotator'
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
     bMustFace=False
     VisibilityRadius=5000.000000
     VisibilityHeight=5000.000000
     RenderIteratorClass=Class'Legend.ActorRotatorRI'
}
