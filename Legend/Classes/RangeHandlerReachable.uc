//=============================================================================
// RangeHandlerReachable.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerReachable expands RangeHandler;



function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	//Log( Self $ "::RangeHandlerReachable::IsInRange" );
	return Super.IsInRange( RangeActor, Constrainer, Goal ) &&
			Goal.IsGoalReachable( RangeActor );
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelector',HT_ObjIntersectReq=OIR_Forbid)
}
