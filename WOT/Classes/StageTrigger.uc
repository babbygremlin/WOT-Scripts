//------------------------------------------------------------------------------
// StageTrigger.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//------------------------------------------------------------------------------
class StageTrigger expands Trigger;

var() name TagDec;
var() name TagInc;
var() int MaxKeyFrame;
var() name WaterEvents[8];
var() name DispatcherTags[8];	// List of WOTDispatchers that are linked to this StageTrigger

var WOTDispatcher Dispatchers[8];

var int CurrentStage;	// Internal stage tracker (also acts as a keyframe for the mover we're affecting)

simulated function PreBeginPlay()
{
	local int x;
	local WOTDispatcher W;
	local Trigger T;
	
	Super.PreBeginPlay();

	// Find all the WOTDispatchers that are attached to us.
	//
	for( x = 0 ; x < ArrayCount( DispatcherTags ) ; x++)
	{
		Dispatchers[x] = None;
	
		foreach AllActors( class 'WOTDispatcher', W, DispatcherTags[x] )
		{
			Dispatchers[x] = W;
			break;
		}
	}
}

function EnableTriggers( BOOL bEnable )
{
	local int x;
	
	for( x = 0 ; x < ArrayCount( Dispatchers ) ; x++)
	{
		if( Dispatchers[x] != None )
		{
			if( bEnable )
			{
				Dispatchers[x].Enable( 'Trigger' );
			}
			else
			{
				Dispatchers[x].Disable( 'Trigger' );
			}
		}
	}
}

function ChangeStage( actor Other, int Delta )
{
	local ElevatorMover M;
	local WaterZone Z;
	local int i;
	local Actor A;
	
	// If we have an Event, fire it.
	//
	if( Event != '' )
	{
		foreach AllActors( class 'Actor', A, Event )
		{
			A.Trigger( self, None );
		}
	}

	// Change stage value and keep it within the defined limits.
	//	
	CurrentStage += Delta;
	
	if( CurrentStage < 0)
	{
		CurrentStage = 0;
	}

	if( CurrentStage > MaxKeyFrame )
	{
		CurrentStage = MaxKeyFrame;
	}

	// Locate any matching ElevatorMovers and move them to the proper keyframe.
	//
	foreach AllActors( class 'ElevatorMover', M, Event )
	{
		M.MoveKeyframe( CurrentStage, 1 );
	}
	
	// Loop through the array of WaterZone Tags and ...
	//
	// - if index is less then current stage, turn it off
	// - if index is greater than current stage, turn it on
	//
	for( i = 0; i < MaxKeyFrame + 1; i++ )
	{
		foreach AllActors( class 'WaterZone', Z, WaterEvents[i] )
		{
			if( WaterEvents[i] != '' )
			{
				if( i < CurrentStage )
				{
					Z.TriggerWaterZone( Other, false );
				}
				else
				{
					Z.TriggerWaterZone( Other, true );
				}
			}
		}
	}
}

defaultproperties
{
}
