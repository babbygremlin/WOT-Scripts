//=============================================================================
// WaypointSelector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class WaypointSelector expands WaypointSelectorInterf;

//selects a waypoint somewhere between the moving actor's current location and
//the goal's ultimate location
static function bool SelectWaypoint( GoalAbstracterInterf Waypoint,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	class'Debug'.static.DebugLog( MovingActor, "SelectWaypoint", default.DebugCategoryName );
	return GetMovementDestination( Waypoint, MovingActor, Constrainer, Goal );
}



//GetMovementDestination:
//if true is returned the movement destination must be directly reachable by the
//moving actor. this means that the point is in the line of sight of the moving
//actor and the point is directly reachable by the actor's available locomotion
//methods (swimming, walking...). This does not mean that the path between the
//moving actor and the movement destination is free of non-level obstructions
//(actors that are currently in the way or will be in the way before the movement
//destination is reached ).
static function bool GetMovementDestination( GoalAbstracterInterf MovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGotDestination;
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination", default.DebugCategoryName );
	bGotDestination = GetRawMovementDestination( MovementGoal, MovingActor, Constrainer, Goal );
	class'Debug'.static.DebugAssert( MovingActor, !bGotDestination || MovementGoal.IsGoalReachable( MovingActor ), "GetMovementDestination bogus unreachable valid MovementGoal ", default.DebugCategoryName );
	class'Debug'.static.DebugLog( MovingActor, "GetMovementDestination returning " $ bGotDestination, default.DebugCategoryName );
	return bGotDestination;
}



//GetRawMovementDestination:
//Determines a movement destination that is based upon the location of the
//ultimate goal. The movement destination must be guaranteed to be
//unobstructed by level geometry. The movement destination must be reachable
//from the moving actor's current location. The moving actor must be able to
//find a path from the movement destination to the ultimate goal location
//(at the time of evaluation).
static function bool GetRawMovementDestination( GoalAbstracterInterf RawMovementGoal,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGotRawDestination;
	class'Debug'.static.DebugLog( MovingActor, "GetRawMovementDestination", default.DebugCategoryName );

	bGotRawDestination = Goal.GetNavigationGoal( MovingActor, RawMovementGoal );
	if( bGotRawDestination )
	{
		RawMovementGoal.SetSuggestedSpeed( MovingActor, Goal.GetSuggestedSpeed( MovingActor ) );
	}
	class'Debug'.static.DebugLog( MovingActor, "GetRawMovementDestination returning " $ bGotRawDestination, default.DebugCategoryName );
	return bGotRawDestination;
}

defaultproperties
{
     DebugCategoryName=WaypointSelector
}
