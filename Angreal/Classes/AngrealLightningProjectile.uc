//------------------------------------------------------------------------------
// AngrealLightningProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealLightningProjectile expands CallbackProjectile;

// Our persistant streak object.
var Streak PathStreak;

// Type of streak to use.
var() class<Streak> StreakType;

// Sparks for the end piece.
var() class<ParticleSprayer> SparkType;
var ParticleSprayer Sparks;

// Startpoint of streak.
var vector SourceLocation;
var Actor SourceActor;

replication
{
	// Send SourceActor to the client when relevant.
	reliable if( Role==ROLE_Authority && (SourceActor==None || SourceActor.bNetRelevant) ) // Fix ARL: Remove when Tim fixes Actor variable replication code.
		SourceActor;

	// Send the location updates to the client if SourceActor is not relevant.
	unreliable if( Role==ROLE_Authority && SourceActor!=None && !SourceActor.bNetRelevant ) // Fix ARL: Remove second check when Tim fixes the replication code.
		SourceLocation;
}

//-----------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Sparks = Spawn( SparkType );

	PathStreak = Spawn( StreakType );

	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	Super.SetSourceAngreal( Source );
	SourceActor = Instigator;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Server: Send new locations to clients.
	// Client: Store location in case our Instigator or Owner
	//         becomes un-relevant.
	if( SourceActor != None )
	{
		SourceLocation = SourceActor.Location;
	}

	// Server send Instigator (SourceActor) to clients.
	if( Role == ROLE_Authority )
	{
		SourceActor = Instigator;
	}
	
	// Connect us with the castor via a lightning streak.
	PathStreak.End = SourceLocation;
	PathStreak.Start = Location;

	// Update sparks' position.
	Sparks.SetLocation( Location );
	Sparks.SetRotation( Rotation );

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( PathStreak != None )
	{
		PathStreak.Destroy();
		PathStreak = None;
	}

	if( Sparks != None )
	{
		Sparks.LifeSpan = 2.000000;
		Sparks.bOn = false;
		Sparks = None;
	}

	Super.Destroyed();
}

defaultproperties
{
    StreakType=Class'LightningStreak02'
    SparkType=Class'LightningSprayer02'
    HitWaterClass=Class'FireballFizzle'
    HitWaterOffset=(X=0.00,Y=0.00,Z=56.00),
    SoundRadius=64
    SoundVolume=255
    AmbientSound=Sound'LightningStrike.LoopLS'
    NetPriority=6.00
}
