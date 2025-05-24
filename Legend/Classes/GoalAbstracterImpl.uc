//=============================================================================
// GoalAbstracterImpl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class GoalAbstracterImpl expands GoalAbstracterInterf abstract native;

var private Actor							GoalActor;
var private Vector							GoalVector;
var private bool							bUseGoalVector;
var () bool 								bPawnsMustBeAlive;
var private float							GoalPriority;
var () private float 						GoalPriorityDistance;
var () private EGoalPriorityDistanceUsage	GoalPriorityDistanceUsage;
var () private float 						SuggestedSpeed;



//=============================================================================
// debug interface
//=============================================================================



function DebugLog( Object InvokingObject, optional coerce string Prefix, optional Name DebugCategory )
{
	local Actor CurrentGoalActor;
	local Vector CurrentGoalLocation;
	
	class'Debug'.static.DebugLog( InvokingObject, Prefix $ " " $ Self $ " GoalDebugLog", DebugCategory );
	if( GetGoalActor( InvokingObject, CurrentGoalActor ) )
	{
		class'Debug'.static.DebugLog( InvokingObject, Prefix $ " " $ Self $ " GoalActor: " $ CurrentGoalActor, DebugCategory );
	}
	else if( GetGoalLocation( InvokingObject, CurrentGoalLocation ) )
	{
		class'Debug'.static.DebugLog( InvokingObject, Prefix $ " " $ Self $ " CurrentGoalLocation: " $ CurrentGoalLocation, DebugCategory );
	}
	else
	{
		class'Debug'.static.DebugLog( InvokingObject, Prefix $ " " $ Self $ " Invalid: ", DebugCategory );
	}
	class'Debug'.static.DebugLog( InvokingObject, Prefix $ " " $ Self $ " GoalDebugLog", DebugCategory );
}

defaultproperties
{
     bPawnsMustBeAlive=True
     DebugCategoryName=GoalAbstracterImpl
}
