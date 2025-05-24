//------------------------------------------------------------------------------
// TriggeredCamera.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Triggerable camera for third person cinematics.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Place in a level.
// + Connect to a trigger.
// + Set InitialState (TriggerToggle, TriggerControl, TriggerTimed)
//   - Set TimerDuration for TriggerTimed.
// + Set Event to the Actor the camera will focus on.  
//   - If no event is set, the camera uses the player that triggered the camera
//     as its focus.
//   - Set bDirectional if you would rather the direction align with the
//     rotation the camera is placed with in UnrealEd.
// + Set SpeedFactor to adjust how fast the camera moves from the triggerer
//   to the DesiredLocation (location placed in the editor).
//   If SpeedFactor is zero, the camera will instantaeously move to the desired
//   location.
// + Set FollowTag (under Events) to the Tag of some Actor in your level if
//   you want the camera to follow that Actor around.  (Defaults to the location
//   that you placed the camera in the level.) -- example: Tag a moving brush.
// + Set the RetractSpeedFactor to match how fast you want the camera to retract.
//   Like SpeedFactor, larger numbers means the camera goes slower, zero mean
//   instantaeous.
// + RetractAccel ensures that the camera will eventually overtake the player.
//   This prevents the player from being able to out-run the camera when it is 
//   retracting.  Set this to a high number if you want the camera to overtake
//   the player faster.  Also, remember that you can use a lower RetractSpeedFactor
//   if you just want the camera to feel faster.
// + Set bRotRetract to false if you just want the camera to zoom into the player's
//   head.  If this variable is set to true, the rotation of the camera will try
//   to match that of the player's view rotation to give a more seamless perspective
//   change.
//------------------------------------------------------------------------------
class TriggeredCamera expands Inventory;

var Actor Focus;
var PlayerPawn Viewer;
var bool bOn;

var vector LastCameraLocation;
var vector DesiredCameraLocation;
var rotator LastCameraRotation;
var rotator DesiredCameraRotation;
var() float SpeedFactor;

var() float TimerDuration;
var float TriggerTime;

var(Events) name FollowTag;
var Actor FollowActor;

var() float RetractSpeedFactor;
var() float RetractAccel;
var() bool bRotRetract;		// Should we match the player's viewrotation when we retract?
var float RetractSpeed;
var bool bRetract;
var vector InitialLocation;
var rotator InitialRotation;
var float InitialSpeedFactor;

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function Posses( PlayerPawn InViewer )
{
	if( Viewer != None ) UnPosses( Viewer );
	if( bRetract ) UnRetract();
	bOn = True;
	Viewer = InViewer;
	Viewer.ViewTarget = self;
	LastCameraLocation = Viewer.Location + vect(0,0,1) * Viewer.BaseEyeHeight;
	LastCameraRotation = FixRot( Normalize(Viewer.ViewRotation), DesiredCameraRotation );
	
	SetLocation( LastCameraLocation );
	SetRotation( LastCameraRotation );

	// Use the first found tagged item if one exists for the focus.
	if( Event != '' ) foreach AllActors( class'Actor', Focus, Event ) break;

	// Default to the viewer.
	if( Focus == None )	Focus = Viewer;

	// Find our FollowActor.
	if( FollowTag != '' ) foreach AllActors( class'Actor', FollowActor, FollowTag ) break;
}

//------------------------------------------------------------------------------
simulated function UnPosses( PlayerPawn InViewer )
{
	bOn = False;
	Viewer = None;
	InViewer.ViewTarget = None;
	Focus = None;
}

//------------------------------------------------------------------------------
simulated function Use( Pawn User )
{
	if( !bOn )
	{
		Trigger( User, User );
	}
	else
	{
		UnTrigger( User, User );
	}
}

//------------------------------------------------------------------------------
simulated function Retract()
{
	bRetract = True;
	bDirectional = True;
	LastCameraRotation = FixRot( Normalize(Rotation), Normalize(Viewer.ViewRotation) );
	DesiredCameraRotation = Normalize(Viewer.ViewRotation);
	SpeedFactor = RetractSpeedFactor;
}

//------------------------------------------------------------------------------
simulated function UnRetract()
{
	bRetract = False;
	RetractSpeed = 0.0;
	bDirectional = default.bDirectional;
	SpeedFactor = InitialSpeedFactor;
	DesiredCameraLocation = InitialLocation;
	DesiredCameraRotation = InitialRotation;
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
		if( !bOn )
		{
			if( PlayerPawn(Other) != None )
			{
				Posses( PlayerPawn(Other) );
			}
			else if( PlayerPawn(EventInstigator) != None )
			{
				Posses( PlayerPawn(EventInstigator) );
			}
		}
		else
		{
			if( PlayerPawn(Other) != None )
			{
				Retract();
			}
			else if( PlayerPawn(EventInstigator) != None )
			{
				Retract();
			}
		}
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
		if( PlayerPawn(Other) != None )
		{
			Posses( PlayerPawn(Other) );
		}
		else if( PlayerPawn(EventInstigator) != None )
		{
			Posses( PlayerPawn(EventInstigator) );
		}
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		if( PlayerPawn(Other) != None )
		{
			Retract();
		}
		else if( PlayerPawn(EventInstigator) != None )
		{
			Retract();
		}
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
		TriggerTime = Level.TimeSeconds + TimerDuration;

		if( PlayerPawn(Other) != None )
		{
			Posses( PlayerPawn(Other) );
		}
		else if( PlayerPawn(EventInstigator) != None )
		{
			Posses( PlayerPawn(EventInstigator) );
		}
	}
	
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		if( Level.TimeSeconds >= TriggerTime )
		{
			if( Viewer != None )
			{
				Retract();
			}
		}
	}
}

////////////////////
// Initialization //
////////////////////

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	DesiredCameraLocation = Location;
	DesiredCameraRotation = Normalize(Rotation);
	InitialSpeedFactor = SpeedFactor;
	InitialLocation = DesiredCameraLocation;
	InitialRotation = DesiredCameraRotation;
}

///////////
// Logic //
///////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bOn && Viewer != None )
	{
		if( Viewer.ViewTarget == Self )
		{
			if( Viewer.Health > 0 )
			{
				CalcNewPosition( DeltaTime );
			}
			else
			{
				UnPosses( Viewer );
			}
		}
		else
		{
			bOn = false;
			Viewer = None;
			Focus = None;
		}
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function CalcNewPosition( float DeltaTime )
{
	local vector DiffV, DesiredV, PrevV;
	local rotator DiffR;
	
	if( bRetract )
	{	
		if( RetractSpeedFactor > 0.0 )
		{
			DesiredCameraLocation = Viewer.Location + vect(0,0,1)*Viewer.BaseEyeHeight;
			DiffV = DesiredCameraLocation - LastCameraLocation;

			PrevV = LastCameraLocation;
			RetractSpeed += (RetractAccel * DeltaTime);
			LastCameraLocation = LastCameraLocation + (DiffV/RetractSpeedFactor) + (Normal(DesiredCameraLocation-LastCameraLocation)*(RetractSpeed*DeltaTime));
			
			// Check if we passed our desired location.
			if( !class'Util'.static.VectorAproxEqual( Normal(DesiredCameraLocation-PrevV), Normal(DesiredCameraLocation-LastCameraLocation) ) )
			{
				UnPosses( Viewer );
				UnRetract();
			}
		}
		else
		{
			UnPosses( Viewer );
		}
	}
	else
	{
		if( FollowActor != None )	DesiredV = FollowActor.Location;
		else						DesiredV = DesiredCameraLocation;

		if( SpeedFactor > 0.0 )
		{
			DiffV = DesiredV - LastCameraLocation;
			LastCameraLocation += DiffV/SpeedFactor;
		}
		else
		{
			LastCameraLocation = DesiredV;
		}
	}

	SetLocation( LastCameraLocation );
	
	if( bDirectional )
	{
		DiffR = DesiredCameraRotation - LastCameraRotation;
		LastCameraRotation += DiffR/SpeedFactor;
		SetRotation( LastCameraRotation );
	}
	else
	{
		SetRotation( rotator(Focus.Location - Location) );
	}
}

//------------------------------------------------------------------------------
simulated function rotator FixRot( rotator Rot, rotator RefRot )
{
	if( Abs(RefRot.Pitch - Rot.Pitch) > 0x8000 ) Rot.Pitch += 0x10000;
	if( Abs(RefRot.Yaw   - Rot.Yaw)   > 0x8000 ) Rot.Yaw   += 0x10000;
	if( Abs(RefRot.Roll  - Rot.Roll)  > 0x8000 ) Rot.Roll  += 0x10000;
	return Rot;
}

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
function BecomePickup()
{
	Super.BecomePickup();
	
	bHidden = true;
	SetCollision( false, false, false );
}

//------------------------------------------------------------------------------
auto state Idle2
{
	simulated function BeginState()
	{
		Super.BeginState();
		BecomeItem();
	}
}

defaultproperties
{
     SpeedFactor=10.000000
     RetractAccel=250.000000
     bRotRetract=True
     bAmbientGlow=False
     bHidden=True
     bIsItemGoal=False
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Camera'
     AmbientGlow=0
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
}
