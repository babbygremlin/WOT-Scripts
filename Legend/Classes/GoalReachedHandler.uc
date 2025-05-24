//=============================================================================
// GoalReachedHandler.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class GoalReachedHandler expands AiComponent;



function OnUltimateGoalReachedBy( Object ContextObject, GoalAbstracterInterf ReachedGoal )
{
	class'Debug'.static.DebugLog( ContextObject, "OnGoalReachedBy ReachedHandler " $ Self, DebugCategoryName );
	class'Debug'.static.DebugLog( ContextObject, "OnGoalReachedBy reached goal " $ Outer, DebugCategoryName );
	class'Debug'.static.DebugLog( ContextObject, "OnGoalReachedBy goal reached by " $ ContextObject, DebugCategoryName );
	OnIntermediateGoalReachedBy( ContextObject, ReachedGoal );
}



function OnIntermediateGoalReachedBy( Object ContextObject, GoalAbstracterInterf ReachedGoal )
{
/*
	local Actor ContextActor;
	local Pawn ContextPawn;

	Super.OnUltimateGoalReachedBy( ContextObject, ReachedGoal );
	ContextActor = Actor( ContextObject );
	if( ContextActor != None )
	{
		//ContextActor.Velocity = Vect( 0, 0, 0 );
		//ContextActor.Acceleration = ContextActor.Acceleration / 8;
		ContextPawn = Pawn( ContextActor );
		if( ContextPawn != None )
		{
			ContextPawn.Destination = ContextPawn.Location;
		}
	}
*/
}

defaultproperties
{
     DebugCategoryName=GoalReachedHandler
}
