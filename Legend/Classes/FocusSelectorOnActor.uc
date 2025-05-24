//=============================================================================
// FocusSelectorOnActor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class FocusSelectorOnActor expands FocusSelectorInterf;



static function bool SelectFocus( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocus", default.DebugCategoryName );
	SelectFocusFromActor( Focus, SelectedWaypoint, FocusingActor, Constrainer, Goal );
	return true;
}



//use the moving actor to initialize the focus
static function SelectFocusFromActor( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromActor", default.DebugCategoryName );
	Focus.AssignVector( FocusingActor, FocusingActor.Location, false );
	Focus.SetAssociatedRotation( FocusingActor, FocusingActor.Rotation );
}



//xxxrlo this should not be here
static function SelectFocusFromGivenActor( GoalAbstracterInterf Focus,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		Actor FocalActor )
{
	local Vector FocusLocation;
	local Rotator FocusRotation;
	
	class'Debug'.static.DebugLog( FocusingActor, "SelectFocusFromGivenActor", default.DebugCategoryName );

	FocusRotation = Rotator( FocalActor.Location - FocusingActor.Location );
	FocusLocation = FocalActor.Location;

	//Constrainer.ConstrainActorFocusAndRotation( FocusLocation, FocusRotation, FocalActor.Location, FocusingActor );
	
	Focus.AssignVector( FocusingActor, FocusLocation, false );
	Focus.SetAssociatedRotation( FocusingActor, FocusRotation );
}

defaultproperties
{
}
