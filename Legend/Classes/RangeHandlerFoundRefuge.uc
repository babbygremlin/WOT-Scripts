//=============================================================================
// RangeHandlerFoundRefuge.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerFoundRefuge expands RangeHandler;

function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGoalInRange;
	if( Super.IsInRange( RangeActor, Constrainer, Goal ) )
	{
		bGoalInRange = HasFoundRefuge( RangeActor, Constrainer, Goal );
	}
	
	return bGoalInRange;
}



function bool HasFoundRefuge( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	return !Goal.IsVisibleByGoal( RangeActor );
}

defaultproperties
{
}
