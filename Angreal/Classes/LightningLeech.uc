//------------------------------------------------------------------------------
// LightningLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningLeech expands Leech;

// Damage vars.
var DecreaseHealthLeech DHL;
var float DamagePerSecond;

// Linked list support.  (maintained by AngrealInvLightning)
var LightningLeech NextLightningLeech;

// Notifiers.
var NotifyInWaterReflector WaterNotifier;

// Our persistant streak object.
var Streak PathStreak;

// Type of streak to use.
var() class<Streak> StreakType;

// Impact visuals.
var LSImpact ImpactEffect;
var() float ImpactRollRate;
var float ImpactRoll;

// Type of sparks to use.
var() class<ParticleSprayer> SparkType;
var ParticleSprayer Sparks;

// Endpoints of streak.
var vector SourceLocation;
var vector TargetLocation;
var Actor SourceActor;

replication
{
	// Fix ARL: remove extra checks when Tim fixes the replication code.

	// Send SourceActor to the client when relevant.
	reliable if( Role==ROLE_Authority && (SourceActor==None || SourceActor.bNetRelevant) ) // Remove when Tim fixes Actor variable replication code.
		SourceActor;

	// Send the location updates to the client if Instigator is not relevant.
	unreliable if( Role==ROLE_Authority && SourceActor!=None && !SourceActor.bNetRelevant )
		SourceLocation;

	// Send the location updates to the client if Owner is not relevant.
	unreliable if( Role==ROLE_Authority && Owner!=None && !Owner.bNetRelevant )
		TargetLocation;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Create visuals.
	ImpactEffect = Spawn( class'LSImpact' );
	PathStreak = Spawn( StreakType );
	Sparks = Spawn( SparkType );
}

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	Super.AttachTo( NewHost );

	if( Owner != None && Owner == NewHost )
	{
		// Let our owner know we were successfully attached to someone.
		if( AngrealInvLightning(SourceAngreal) != None )
		{
			AngrealInvLightning(SourceAngreal).NotifyAttached( Self );
		}

		// We don't need no stinkin' LeechAttacherEffect because we is a Leech.
		DHL = Spawn( class'DecreaseHealthLeech' );
		DHL.InitializeWithLeech( Self );
		DHL.AffectResolution = 1.0 / DamagePerSecond;
		DHL.AttachTo( Pawn(Owner) );
		
		InstallNotifiers();
	}
}

//------------------------------------------------------------------------------
function UnAttach()
{
	if( AngrealInvLightning(SourceAngreal) != None && Pawn(Owner) != None )
	{
		AngrealInvLightning(SourceAngreal).RemoveVictim( Pawn(Owner), true );
	}
	UnInstallNotifiers();
	Super.UnAttach();
}

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( Pawn(Owner) == None || Pawn(Owner).Health <= 0 )
	{
		UnAttach();
		Destroy();
	}
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
	local int i;
	local vector Dir;
	local rotator ImpactRot;

	// Validate Owner.
	if( Owner == None )
	{
		UnAttach();
		Destroy();
		return;
	}

	// Update damage rate.
	if( Role == ROLE_Authority && DHL != None )
	{
		DHL.AffectResolution = 1.0 / DamagePerSecond;
	}

	// Server: Send new locations to clients.
	// Client: Store location in case our Instigator or Owner
	//         becomes un-relevant.
	if( SourceActor != None )
	{
		SourceLocation = SourceActor.Location;
	}
	if( Owner != None )
	{
		TargetLocation = Owner.Location;
	}

	// Server send Instigator (SourceActor) to clients.
	if( Role == ROLE_Authority )
	{
		SourceActor = Instigator;
	}

	// Calculate a normal vector that points from the 
	// victim to the castor.
	Dir = Normal(SourceLocation - TargetLocation);
	Dir.z = 0.0;

	// Connect castor and victim with lightning streak.
	if( PathStreak != None )
	{
		PathStreak.Start = SourceLocation;
		PathStreak.End = TargetLocation + (Dir * Owner.CollisionRadius);
		PathStreak.ScaleGlow = ScaleGlow;
	}

	// Update Sparks location.
	if( Sparks != None )
	{
		Sparks.SetLocation( PathStreak.End );
		Sparks.SetRotation( rotator(Dir) );
	}

	// Realign effects.
	if( ImpactEffect != None )
	{
		ImpactRoll += ImpactRollRate * DeltaTime;
		ImpactRot = rotator(vect(0,0,1));
		ImpactRot.Roll = ImpactRoll;
		ImpactEffect.SetLocation( TargetLocation );
		ImpactEffect.SetRotation( ImpactRot );
		ImpactEffect.ScaleGlow = ScaleGlow;
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	// Game logic (server-side only).
	if( Role == ROLE_Authority )
	{
		if( DHL != None )
		{
			DHL.UnAttach();
			DHL.Destroy();
		}

/* -- OBE
		if( Role == ROLE_Authority && ProjLeechArtifact(SourceAngreal) != None )
		{
			ProjLeechArtifact(SourceAngreal).NotifyDestinationLost();
		}	
*/
	}
	
	if( ImpactEffect != None )
	{
		ImpactEffect.Destroy();
		ImpactEffect = None;
	}

	if( Sparks != None )
	{
		Sparks.LifeSpan = 2.000000;
		Sparks.bOn = false;
		Sparks = None;
	}

	if( PathStreak != None )
	{
		PathStreak.Destroy();
		PathStreak = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
function InstallNotifiers()
{
	// WaterNotifier.
	if( WaterNotifier == None )
	{
		WaterNotifier = Spawn( class'NotifyInWaterReflector' );
		WaterNotifier.InitializeWithLeech( Self );
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

defaultproperties
{
    StreakType=Class'LightningStreak02'
    ImpactRollRate=25000.00
    SparkType=Class'LightningSparks'
    AffectResolution=0.20
    bDeleterious=True
    RemoteRole=2
    bAlwaysRelevant=True
    SoundRadius=64
    SoundVolume=255
    AmbientSound=Sound'LightningStrike.LoopLS'
    NetPriority=6.00
}
