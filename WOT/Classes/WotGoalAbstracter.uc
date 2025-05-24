//=============================================================================
// WotGoalAbstracter.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class WotGoalAbstracter expands ContextSensitiveGoal;

const SealAltarHalfHeight = 32.0;
const SealAltarRadius = 32.0;
const BaseAlarmRadius = 160.0;



static function DetermineGoalActorParams( Object InvokingObject, Actor CurrentGoalActor, out Vector GoalLocation, out float GoalRadius, out float GoalHalfHeight )
{
	class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams CurrentGoalActor " $ CurrentGoalActor, default.DebugCategoryName );
	if( CurrentGoalActor.IsA( 'SealAltar' ) )
	{
		class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams isa SealAltar", default.DebugCategoryName );
		GoalLocation = CurrentGoalActor.Location;
		GoalRadius = SealAltarRadius;
		GoalHalfHeight = SealAltarHalfHeight;
	}
	else if( CurrentGoalActor.IsA( 'Alarm' )  )
	{
		class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams isa Alarm", default.DebugCategoryName );
		GoalLocation = CurrentGoalActor.Location;
		GoalRadius = BaseAlarmRadius;
		GoalHalfHeight = CurrentGoalActor.CollisionHeight;
	}
 	else if( InvokingObject.IsA( 'Actor' ) && CurrentGoalActor.IsA( 'Grunt' ) )
 	{
 		if( !Grunt( CurrentGoalActor ).bIsPlayer && Grunt( CurrentGoalActor ).IsFriendly( Actor( InvokingObject ) ) )
		{
			//the goal is a grunt
			//the goal is not a player
			//the grunt is friendly or can't tell
			GoalLocation = CurrentGoalActor.Location;
			GoalHalfHeight = CurrentGoalActor.CollisionHeight;
			if( CurrentGoalActor.IsA( 'Captain' ) )
			{
				class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams isa friendly captain", default.DebugCategoryName );
				GoalRadius = Captain( CurrentGoalActor ).FindHelpRadius;
			}
			else
			{
				class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams isa friendly grunt", default.DebugCategoryName );
				GoalRadius = CurrentGoalActor.CollisionRadius * 4;
			}
		}
		else
		{
			Super.DetermineGoalActorParams( InvokingObject, CurrentGoalActor, GoalLocation, GoalRadius, GoalHalfHeight );
		}
	}
	else
	{
		Super.DetermineGoalActorParams( InvokingObject, CurrentGoalActor, GoalLocation, GoalRadius, GoalHalfHeight );
	}
	class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams GoalLocation " $ GoalLocation, default.DebugCategoryName );
	class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams GoalHalfHeight " $ GoalHalfHeight, default.DebugCategoryName );
	class'Debug'.static.DebugLog( InvokingObject, "DetermineGoalActorParams GoalRadius " $ GoalRadius, default.DebugCategoryName );
}

defaultproperties
{
     DebugCategoryName=WotGoalAbstracter
}
