//=============================================================================
// PatrolController.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PatrolController expands ExternalDirective;

var (ExternalDirective) class<IteratorInterf> 	PatrolIteratorClass;
var (ExternalDirective) Name 					PatrolSetTag;
var PatrolSet 									AsssociatedPatrolSet;



function PostBeginPlay()
{
	local PatrolSet PotentialPatrolSet;
	
	class'Debug'.static.DebugLog( Self, "PostBeginPlay PatrolSetTag " $ PatrolSetTag, DebugCategoryName );
	if( PatrolSetTag != '' )
	{
		foreach AllActors( class'PatrolSet', PotentialPatrolSet, PatrolSetTag )
		{
			class'Debug'.static.DebugLog( Self, "PostBeginPlay PotentialPatrolSet " $ PotentialPatrolSet, DebugCategoryName );
			AsssociatedPatrolSet = PotentialPatrolSet;
		}
	}
	class'Debug'.static.DebugLog( Self, "PostBeginPlay AsssociatedPatrolSet " $ AsssociatedPatrolSet, DebugCategoryName );

	//the associated patrol set must be set up before the super is called
	Super.PostBeginPlay();
}


function DebugLog( Object Invoker )
{
	local PatrolSet PotentialPatrolSet;

	Super.DebugLog( Invoker );
	class'Debug'.static.DebugLog( Invoker, "DebugLog PatrolSetTag " $ PatrolSetTag $ " AsssociatedPatrolSet " $ AsssociatedPatrolSet, DebugCategoryName );
	if( PatrolSetTag != '' )
	{
		foreach AllActors( class'PatrolSet', PotentialPatrolSet, PatrolSetTag )
		{
			class'Debug'.static.DebugLog( Invoker, "DebugLog PotentialPatrolSet " $ PotentialPatrolSet, DebugCategoryName );
			PotentialPatrolSet.DebugLog( Invoker );
		}
	}
	
	//the associated patrol set must be set up before the super is called
	Super.PostBeginPlay();
}

defaultproperties
{
     PatrolIteratorClass=Class'Legend.IteratorOscillating'
     DirectiveGoalClass=Class'Legend.PatrolGoal'
     DirectiveGoalPriority=79.000000
     DirectiveGoalSuggestedSpeed=160.000000
     DebugCategoryName=PatrolController
     bStatic=True
     InitialState=InitialNotifyObservers
}
