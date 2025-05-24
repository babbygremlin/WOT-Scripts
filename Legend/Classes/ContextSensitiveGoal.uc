//=============================================================================
// ContextSensitiveGoal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class ContextSensitiveGoal expands ContextInsensitiveGoal native;

var () private class<GoalContextInterf> GoalContextType;
var private GoalContextInterf GoalContexts[ 16 ];
var private int LastGoalContextIdx;

defaultproperties
{
     GoalContextType=Class'Legend.GoalContext'
     DebugCategoryName=ContextSensitiveGoal
}
