//=============================================================================
// WaypointSelectorPattern.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class WaypointSelectorPattern expands WaypointSelector;

//do not use or refer to this class it is obsolete
//xxxrlodeletethisclass when levels are no longer referring to it

var () class<MovementPattern> MovementPatternClass;
var MovementPattern MovementPattern;



function Constructed()
{
	MovementPattern = new( Self )MovementPatternClass;
	Super.Constructed();
}



function Destructed()
{
	MovementPattern.Delete();
	MovementPattern = None;
	Super.Destructed();
}



static function bool GetRawMovementDestination( GoalAbstracterInterf RawMovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
/*
	local bool bGotRawDestination;

	class'Debug'.static.DebugLog( MovingActor, "GetRawMovementDestination", DebugCategoryName );
	if( MovementPattern.EvaluatePrerequisiteGoalDistance( RawMovementGoal, MovingActor, Goal ) )
	{
		if( MovementPattern.SelectPatternElement( MovingActor, Goal ) )
		{
			MovementPattern.SelectWaypointFromPatternElement( RawMovementGoal, MovingActor, Self, Constrainer, Goal );
		}
		else
		{
			Super.GetRawMovementDestination( RawMovementGoal, MovingActor, Constrainer, Goal );
		}
		MovementPattern.EvaluatePostrequisiteGoalDistance( RawMovementGoal, MovingActor, Goal );
		bGotRawDestination = true;
	}
	else
	{
		bGotRawDestination = true;
	}
	class'Debug'.static.DebugLog( MovingActor, "GetRawMovementDestination returning " $ bGotRawDestination, DebugCategoryName );
	return bGotRawDestination;
*/
}



function bool SuperGetRawMovementDestination( GoalAbstracterInterf RawMovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	Super.GetRawMovementDestination( RawMovementGoal, MovingActor, Constrainer, Goal );
}

defaultproperties
{
     DebugCategoryName=WaypointSelectorPattern
}
