//=============================================================================
// RangeHandlerVisible.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerVisible expands RangeHandler;

var (RangeHandler) bool bGoalRequiresActorVisibility;
var (RangeHandler) bool bActorRequiresGoalVisibility;



function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bInRange;
	
	//Log( Self $ "::RangeHandlerVisible::IsInRange" );
	if( Super.IsInRange( RangeActor, Constrainer, Goal ) )
	{
		bInRange = ( ( !bGoalRequiresActorVisibility || Goal.IsVisibleByGoal( RangeActor ) ) &&
				( !bActorRequiresGoalVisibility || Goal.IsGoalVisible( RangeActor ) ) );
	}
	//Log( Self $ "::RangeHandlerVisible::IsInRange returning " $ bInRange );
	return bInRange;
}

defaultproperties
{
     bActorRequiresGoalVisibility=True
}
