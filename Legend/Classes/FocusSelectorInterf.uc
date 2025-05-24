//=============================================================================
// FocusSelectorInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class FocusSelectorInterf expands AiComponent abstract;



static function bool SelectFocus( GoalAbstracterInterf Focus,
		GoalAbstracterInterf SelectedWaypoint,
		Actor FocusingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal );

defaultproperties
{
     DebugCategoryName=FocusSelectorInterf
}
