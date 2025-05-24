//=============================================================================
// GoalContextInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class GoalContextInterf expands GoalBase native;

enum EGoalContextCacheItem
{
	GCCI_ReachableSuccessful,
	GCCI_ReachableUnsuccessful,
	GCCI_VisibleSuccessful,
	GCCI_VisibleUnsuccessful,
	GCCI_PathableSuccessful,
	GCCI_PathableUnsuccessful
};



static event CreateGoalContext( out GoalContextInterf NewContext,
		GoalAbstracterInterf ContextOf, Actor ContextActor );

native function bool IsContextFor( Object ContextObject );

native function bool GoalContextInit( GoalAbstracterInterf NewGoal,
		Object NewContextObject );

function BindReachedHandler( GoalReachedHandler NewReachedHandler );

native event bool GetGoalActor( out Actor CurrentGoalActor );

//=============================================================================
// path goal interface
//=============================================================================

function bool FindFirstNavigablePathGoal( GoalAbstracterInterf PathGoal );

function bool FindFirstNavigableAvoidGoalPathGoal( GoalAbstracterInterf PathGoal );

defaultproperties
{
     DebugCategoryName=GoalContextInterf
}
