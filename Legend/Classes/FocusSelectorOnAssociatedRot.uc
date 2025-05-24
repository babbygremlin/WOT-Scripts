//=============================================================================
// FocusSelectorOnAssociatedRot.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class FocusSelectorOnAssociatedRot expands FocusSelectorOnGoal;



//attempt to initialize the focus from the goal location and rotation
static function SelectFocusFromGoal( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector GoalLocation, FocusLocation, ConstrainedFocusLocation;
	local Rotator AssociatedGoalRotation, ConstrainedFocusRotation;
		
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal", default.DebugCategoryName );
	
	if( Goal.GetAssociatedRotation( FocusingActor, AssociatedGoalRotation ) &&
			Goal.GetGoalLocation( FocusingActor, GoalLocation ) )
	{
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal GoalLocation: " $ GoalLocation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGoal AssociatedGoalRotation: " $ AssociatedGoalRotation, default.DebugCategoryName );
		
		FocusLocation = GoalLocation +	Vector( AssociatedGoalRotation ) * 200;
		Constrainer.ConstrainActorFocusAndRotation( ConstrainedFocusLocation,
				ConstrainedFocusRotation, FocusLocation, FocusingActor );
		
		Focus.AssignVector( FocusingActor, ConstrainedFocusLocation, false );
		Focus.SetAssociatedRotation( FocusingActor, ConstrainedFocusRotation );
	}
	else
	{
		Super.SelectFocusFromGoal( Focus, SelectedWaypoint, FocusingActor, 	Constrainer, Goal );
	}
}

defaultproperties
{
}
