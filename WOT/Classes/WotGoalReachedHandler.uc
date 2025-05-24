//=============================================================================
// WotGoalReachedHandler.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class WotGoalReachedHandler expands GoalReachedHandler;



function OnUltimateGoalReachedBy( Object ContextObject, GoalAbstracterInterf ReachedGoal )
{
	Super.OnUltimateGoalReachedBy( ContextObject, ReachedGoal );
	if( ContextObject.IsA( 'Captain' ) )
	{
	}
	else if( ContextObject.IsA( 'Grunt' ) )
	{
	}
}

defaultproperties
{
}
