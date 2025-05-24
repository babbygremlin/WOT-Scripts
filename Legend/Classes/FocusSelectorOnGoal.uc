//=============================================================================
// FocusSelectorOnGoal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class FocusSelectorOnGoal expands FocusSelectorOnActor;



static function bool SelectFocus( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocus", default.DebugCategoryName );
	SelectFocusFromGoal( Focus, SelectedWaypoint, FocusingActor, Constrainer, Goal );
	return true;
}



//attempt to initialize the focus from the goal if not possible
//initialize the focus from the moving actor
static function SelectFocusFromGoal( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector GoalLocation, FocusLocation;
	local Rotator FocusRotation;

	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal", default.DebugCategoryName );
	if( Goal.GetGoalLocation( FocusingActor, GoalLocation ) )
	{
		//focus on the goal
		Constrainer.ConstrainActorFocusAndRotation( FocusLocation, FocusRotation, GoalLocation, FocusingActor );
		Focus.AssignObject( FocusingActor, Goal );
		Focus.SetAssociatedRotation( FocusingActor, FocusRotation );
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal GoalLocation: " $ GoalLocation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal FocusLocation: " $ FocusLocation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal FocusRotation: " $ FocusRotation, default.DebugCategoryName );
	}
	else
	{
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal calling super", default.DebugCategoryName );
		SelectFocusFromActor( Focus, SelectedWaypoint, FocusingActor, Constrainer, Goal );
	}
	
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal Focus: " $ Focus, default.DebugCategoryName );
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal FocusRotation: " $ FocusRotation, default.DebugCategoryName );
}

defaultproperties
{
}
