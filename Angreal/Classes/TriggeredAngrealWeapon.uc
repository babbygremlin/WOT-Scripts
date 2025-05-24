//------------------------------------------------------------------------------
// TriggeredAngrealWeapon.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class TriggeredAngrealWeapon expands Effects;

var() bool bInitiallyOn;
var bool bOn;

var bool bInitialized;

var() class<WOTPlayer> CastorType;
var WOTPlayer Castor;

var() class<AngrealInventory> ArtifactType;
var AngrealInventory Artifact;

var() float CastRate;
var float CastTimer;
var bool bCasting;

var() float CastDuration;

var() bool bSustained;

var(Object) float TimedDelay;
var float TriggerTime;

var Trigger MyTrigger;

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function PostBeginPlay()
{	
	Super.PostBeginPlay();
	
	SetTimer( 0.1, False );
}

//------------------------------------------------------------------------------
simulated function Initialize()
{	
	bInitialized = True;
	
	bOn = bInitiallyOn;

	Castor = Spawn( CastorType,,, Location, Rotation );
	Castor.ViewRotation = Rotation;
	Castor.bHidden = True;
	Artifact = Spawn( ArtifactType,,, Location );
	Artifact.ChargeCost = 0.0;
	Artifact.Touch( Castor );
	
	if( bOn ) TurnOn();
	
	MyTrigger = Spawn( class'Trigger',,, Location );
	MyTrigger.SetCollisionSize( CollisionRadius, CollisionHeight );
	MyTrigger.ReTriggerDelay = 0.5;
	Tag = Name;
	MyTrigger.Event = Tag;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( MyTrigger != None ) MyTrigger.Destroy();
	if( Castor    != None ) Castor.Destroy();
	if( Artifact  != None ) Artifact.Destroy();
	
	Super.Destroyed();
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function TurnOn()
{
	bOn = True;
	BroadcastMessage( "Starting "$Artifact.Title );

	Castor.bHidden = False;
	bHidden = True;

	if( bSustained ) Artifact.Cast();
}

//------------------------------------------------------------------------------
simulated function TurnOff()
{
	bOn = False;
	BroadcastMessage( "Stopping "$Artifact.Title );

	Castor.bHidden = True;
	bHidden = False;

	if( bSustained ) Artifact.UnCast();
}

////////////
// States //
////////////

//------------------------------------------------------------------------------
// Toggles us on and off when triggered.
//------------------------------------------------------------------------------
simulated state() TriggerToggle
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( !bOn )	TurnOn();
		else		TurnOff();
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
		if( !bOn )	TurnOn();
		else		TurnOff();
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		if( !bOn )	TurnOn();
		else		TurnOff();
	}
}

//------------------------------------------------------------------------------
// Toggled when triggered.
// Toggled back to initial state after TimedDelay seconds.
//------------------------------------------------------------------------------
simulated state() TriggerTimed
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		TriggerTime = Level.TimeSeconds + TimedDelay;

		if( !bOn )	TurnOn();
		else		TurnOff();
	}
	
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		if( Level.TimeSeconds >= TriggerTime )
		{
			if( !bOn )	TurnOn();
			else		TurnOff();
		}
	}
}

///////////
// Logic //
///////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bOn && !bSustained && bInitialized )
	{
		CastTimer -= DeltaTime;
		if( CastTimer < 0 )
		{
			CastTimer = CastRate;
			if( !bCasting )
			{
				bCasting = True;
				Artifact.Cast();
				SetTimer( CastDuration, False );
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	if( !bInitialized )
	{
		Initialize();
	}
	
	if( bCasting )
	{
		Artifact.UnCast();
		bCasting = False;
	}
}

defaultproperties
{
     InitialState=TriggerToggle
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=Mesh'Angreal.Frozen'
     CollisionRadius=35.000000
     CollisionHeight=40.000000
}
