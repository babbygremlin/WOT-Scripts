//=============================================================================
// RangeHandlerRetreating.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerRetreating expands RangeHandler;



function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bGoalInRange;
	//Log( Self $ "::RangeHandlerRetreating::IsInRange" );
	if( Goal.IsA( 'RetreatInstigator' ) )
	{
		//if the goal is not a retreat instigator then the RangeActor can
		//not be in any type of retreating range
		bGoalInRange = Super.IsInRange( RangeActor, Constrainer, Goal );
/*
		 &&	DoActorAndGoalCylindersTouch( RangeActor, Goal, Constrainer );
*/
	}
	return bGoalInRange;
}



function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local RetreatInstigator RetreatInstigatorGoal;
	local Vector RetreatInstigatorLocation, RetreatInstigatorExtents;
		
	//Log( Self $ "::RangeHandlerRetreating::IsInRange" );
	RetreatInstigatorGoal = RetreatInstigator( Goal );
	if( RetreatInstigatorGoal != none )
	{
		if( RetreatInstigatorGoal.GetRetreatInstigatorParams( RangeActor, RetreatInstigatorLocation,
				RetreatInstigatorExtents ) )
		{
			RetreatInstigatorExtents *= RetreatInstigatorGoal.GetThreatInfluence( RangeActor );
			RadiusExtension = RetreatInstigatorExtents.x;
			HeightExtension	= RetreatInstigatorExtents.z;
		}
	}
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelectorRetreat',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal')
}
