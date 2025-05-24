//=============================================================================
// FocusSelectorOnWaypoint.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class FocusSelectorOnWaypoint expands FocusSelectorOnGoal;



//this function defines the default behavior of the moving actor's focus
//during movement override this function to control what the actor focus
//on while moving.
static function bool SelectFocus( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector GoalLocation;

	class'Debug'.static.DebugLog( FocusingActor, "SelectFocus", default.DebugCategoryName );
	if( SelectedWaypoint.GetGoalLocation( FocusingActor, GoalLocation ) &&
			GoalLocation != FocusingActor.Location )
	{
		//the actor is going to move
		SelectFocusFromWaypoint( Focus, SelectedWaypoint, FocusingActor,
				Constrainer, Goal );
	}
	else
	{
		SelectFocusFromGoal( Focus, SelectedWaypoint, FocusingActor,
				Constrainer, Goal );
	}
	return true;
}



//if the moving actor is going to move, initialize the focus to focus on
//the current value of the Waypoint otherwise initialize the the focus to
//the moving actor's current rotation.
static function SelectFocusFromWaypoint( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector GoalLocation, FocusLocation;
	local Rotator FocusRotation;

	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromWaypoint", default.DebugCategoryName );
	if( SelectedWaypoint.GetGoalLocation( FocusingActor, GoalLocation ) &&
			GoalLocation != FocusingActor.Location )
	{
		//the actor is going to move
		Constrainer.ConstrainActorFocusAndRotation( FocusLocation, FocusRotation,
				GoalLocation, FocusingActor );
		Focus.AssignVector( FocusingActor, FocusLocation, false );
		Focus.SetAssociatedRotation( FocusingActor, FocusRotation );
	}
	else
	{
		SelectFocusFromActor( Focus, SelectedWaypoint, FocusingActor,
				Constrainer, Goal );
	}
}

defaultproperties
{
}
