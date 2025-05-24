//=============================================================================
// FocusSelectorTurnAround.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class FocusSelectorTurnAround expands FocusSelectorOnActor;

//use the moving actor to initialize the focus
static function SelectFocusFromActor( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Vector FocusLocation;
	local Rotator FocusRotation;

	class'Debug'.static.DebugLog( FocusingActor, "FocusSelectorTurnAround::SelectFocusFromActor", default.DebugCategoryName );
	FocusLocation = FocusingActor.Location - Vector( FocusingActor.Rotation );
	FocusRotation = Rotator( FocusLocation - FocusingActor.Location );
	Focus.AssignVector( FocusingActor, FocusLocation, false );
	Focus.SetAssociatedRotation( FocusingActor, FocusRotation );
}

defaultproperties
{
}
