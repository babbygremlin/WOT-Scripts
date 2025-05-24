//=============================================================================
// PatrolGoalContext.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PatrolGoalContext expands GoalContext;

var IteratorInterf PatrolSetIterator;



static event function CreateGoalContext( out GoalContextInterf NewContextInterf,
		GoalAbstracterInterf ContextOf,
		Actor ContextActor )
{
	local PatrolGoalContext NewPatrolGoalContext;
	local ExternalDirective Directive;
	local PatrolController ThisPatrolController;
	
	class'Debug'.static.DebugLog( ContextActor, "CreateGoalContext", default.DebugCategoryName );

	Super.CreateGoalContext( NewContextInterf, ContextOf, ContextActor );
	NewPatrolGoalContext = PatrolGoalContext( NewContextInterf );
	if( NewPatrolGoalContext.GetDirective( Directive ) )
	{
		ThisPatrolController = PatrolController( Directive );
		if( ThisPatrolController != None )
		{
			class'Debug'.static.DebugLog( ContextActor, "CreateGoalContext PatrolIteratorClass: " $ ThisPatrolController.PatrolIteratorClass, default.DebugCategoryName );
			class'Debug'.static.DebugLog( ContextActor, "CreateGoalContext CurrentPatrolSet: " $ ThisPatrolController.AsssociatedPatrolSet, default.DebugCategoryName );
			
			NewPatrolGoalContext.PatrolSetIterator = new( ThisPatrolController )ThisPatrolController.PatrolIteratorClass ;
			NewPatrolGoalContext.PatrolSetIterator.BindCollection( ThisPatrolController.AsssociatedPatrolSet.ActualCollection );
			NewPatrolGoalContext.PatrolSetIterator.GetFirstIndex();
		}
	}
}



function Destructed()
{
	PatrolSetIterator.Delete();
	PatrolSetIterator = None;
	Super.Destructed();
}



function bool GetDirective( out ExternalDirective Directive )
{
	local Actor GoalActor;
	local bool bSuccess;

	if( Super.GetGoalActor( GoalActor ) )
	{
		Directive = ExternalDirective( GoalActor );
		bSuccess = Directive != None;
	}
	return bSuccess;
}



function bool UltimateGoalReached()
{
	local Object CollectionItem;
	local bool bReachedEnd;

	//class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached", DebugCategoryName );
	
	if( PatrolSetIterator.GetCurrentItem( CollectionItem ) )
	{
		//class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached reached " $ CollectionItem, DebugCategoryName );
	}
	
	Super.UltimateGoalReached();
	bReachedEnd = !PatrolSetIterator.GetNextIndex();
	//xxxrlo PatrolSetIterator.GetNextIndex();
	//xxxrlo bReachedEnd = false;

	if( PatrolSetIterator.GetCurrentItem( CollectionItem ) )
	{
		//class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached next " $ CollectionItem, DebugCategoryName );
	}

	//class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached bReachedEnd " $ bReachedEnd, DebugCategoryName );
	return bReachedEnd;
}



function bool GetGoalActor( out Actor CurrentGoalActor )
{
	local bool bReturn;
	local Object CollectionItem;

	if( PatrolSetIterator.GetCurrentItem( CollectionItem ) && CollectionItem.IsA( 'Actor' ) )
	{
		CurrentGoalActor = Actor( CollectionItem );
		bReturn = true;
	}
	
	//class'Debug'.static.DebugLog( ContextObject, "GetGoalActor CurrentGoalActor: " $ CurrentGoalActor, DebugCategoryName );
	//class'Debug'.static.DebugLog( ContextObject, "GetGoalActor returning " $ bReturn, DebugCategoryName );
	return bReturn;
}

defaultproperties
{
     DebugCategoryName=PatrolGoalContext
}
