//=============================================================================
// RangeHandlerRearingUp.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerRearingUp expands RangeHandlerRetreating;



function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local RetreatInstigator RetreatInstigatorGoal;
	local Vector RetreatInstigatorLocation, RetreatInstigatorExtents;
	local Vector GoalLocation;
	local float GoalRadius, GoalHalfHeight;
			
	//Log( Self $ "::RangeHandlerRetreating::IsInRange" );
	RetreatInstigatorGoal = RetreatInstigator( Goal );
	if( RetreatInstigatorGoal != none )
	{
		if( RetreatInstigatorGoal.GetRetreatInstigatorParams( RangeActor,
				RetreatInstigatorLocation, RetreatInstigatorExtents ) &&
				RetreatInstigatorGoal.GetGoalParams( RangeActor, GoalLocation, GoalRadius, GoalHalfHeight ) )
		{
			RadiusExtension = RetreatInstigatorExtents.x - GoalRadius;
			HeightExtension	= RetreatInstigatorExtents.z - GoalHalfHeight;
		}
	}
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding')
}
