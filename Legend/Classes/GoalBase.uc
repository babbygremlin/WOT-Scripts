//=============================================================================
// GoalBase.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================

class GoalBase expands AiComponent abstract native;


enum EGoalPriorityDistanceUsage
{
	GPDU_Unused,
	GPDU_ZeroIfGreater,
	GPDU_ZeroIfLess,
	//rlofuture GPDU_ScaleIfGreater,
	//rlofuture GPDU_ScallIfLess,
};

/*
enum EGoalVisibility
{
	GV_VisibilityUnknown,
	GV_VisibilityVisible,
	GV_VisibilityNotVisible
};
*/

var () const editconst Name LocationGoalName;

const SuggestedSpeedUnused = -1.0;

const SuggestedSpeed_Unused = -1;
const Priority_Unused = -1;
const PriorityDistance_Unused = -1;
const PriorityDistanceUsage_Unused = -1.0;
const PriorityDistanceUsage_ZeroIfGreater = -2.0;
const PriorityDistanceUsage_ZeroIfLess = -3.0;

//=============================================================================
// private interface
//=============================================================================

native static function bool IsCloseEnough( Object First, Object Second );
native static event DetermineGoalActorParams( Object InvokingObject, Actor CurrentGoalActor, out Vector GoalLocation, out float GoalRadius, out float GoalHalfHeight );

defaultproperties
{
     LocationGoalName=LocationGoal
}
