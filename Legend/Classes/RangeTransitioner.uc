//=============================================================================
// RangeTransitioner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//=============================================================================

class RangeTransitioner expands AiComponent;

enum EHandlerSelection
{
	HS_FirstValid,
	HS_GoalProximity
};

enum EGoalProximity
{
	GP_Reached,
	GP_Reachable,
	GP_Visible,
	GP_Pathable,
	GP_UnNavigable,
	GP_None
};

var () EHandlerSelection	HandlerSelection;
var RangeHandler 			Handlers[ 8 ];
var	float					EntryTime;



function Destructed()
{
	local int Idx;
	
	for( Idx = 0; Idx < ArrayCount( Handlers ); Idx++ )
	{
		if( Handlers[ Idx ] != none )
		{
			Handlers[ Idx ].Delete();
			Handlers[ Idx ] = None;
		}
	}
	Super.Destructed();
}



//=============================================================================
// common handler interface
//=============================================================================



function BindIndexHandler( RangeHandler NewHandler, int HandlerIndex )
{
	//xxxrlo
	Handlers[ HandlerIndex ] = NewHandler;
}


function BindHandler( RangeHandler NewHandler )
{
	local RangeHandler SelectedHandler;
	local int Idx;
	local bool bPreviouslyBound;
	
	//see if this range handler is already bound
	for( Idx = 0; ( Idx < ArrayCount( Handlers ) && !bPreviouslyBound ); Idx++ )
	{
		if( ( Handlers[ Idx ] != none ) && ( Handlers[ Idx ] == NewHandler ) )
		{
			bPreviouslyBound = true;
		}
	}
	
	//try to find an empty slot for the new range handler
	if( !bPreviouslyBound )
	{
		for( Idx = 0; Idx < ArrayCount( Handlers ); Idx++ )
		{
			if( Handlers[ Idx ] == none )
			{
				Handlers[ Idx ] = NewHandler;
				break;
			}
		}
	}
}



function RangeHandler PerformRangeTransition( Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer,
		RangeHandler NextHandler )
{
	class'Debug'.static.DebugLog( RangeActor, "PerformRangeTransition", DebugCategoryName );
	if( NextHandler != None )
	{
		NextHandler.GetHandler().TransitionToAssociatedState( RangeActor );
	}
	return NextHandler.GetHandler();
}



function bool SelectHandler( out RangeHandler SelectedHandler,
		Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local bool bHandlerSelected;
	class'Debug'.static.DebugLog( RangeActor, "SelectHandler HandlerSelection: " $ HandlerSelection, DebugCategoryName );
	if( HandlerSelection == HS_FirstValid )
	{
		bHandlerSelected = SelectFirstValidHandler( SelectedHandler, RangeActor, Goal, Constrainer );
	}
	else if( HandlerSelection == HS_GoalProximity )
	{
		bHandlerSelected = SelectGoalProximityHandler( SelectedHandler, RangeActor, Goal, Constrainer );
	}

	if( bHandlerSelected )
	{
		SelectedHandler.DebugLog( RangeActor );
	}
	class'Debug'.static.DebugLog( RangeActor, "SelectHandler returning " $ bHandlerSelected, DebugCategoryName );
	return bHandlerSelected;
}



//=============================================================================
// first valid handler interface
//=============================================================================



function bool SelectFirstValidHandler( out RangeHandler SelectedHandler,
		Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local int Idx;
	local bool bHandlerSelected;
	
	class'Debug'.static.DebugLog( RangeActor, "SelectFirstValidHandler", DebugCategoryName );
	//attempt to find a range handler in the ones that are bound in this range transitioner
	SelectedHandler = None;
	for( Idx = 0; Idx < ArrayCount( Handlers ); Idx++ )
	{
		if( Handlers[ Idx ] != None )
		{
			if( Handlers[ Idx ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) )
			{
				SelectedHandler = Handlers[ Idx ].GetHandler();
				bHandlerSelected = true;
				break;
			}
		}
	}
	
	class'Debug'.static.DebugLog( RangeActor, "SelectFirstValidHandler SelectedHandler " $ SelectedHandler, DebugCategoryName );
	return bHandlerSelected;
}



//=============================================================================
// goal proximity handler interface
//=============================================================================



function BindGoalProximityHandler( EGoalProximity NewGoalProximity, RangeHandler NewHandler )
{
	Handlers[ NewGoalProximity ] = NewHandler;
}



function bool GetGoalProximityHandler( out RangeHandler GoalProximityHandler,
	EGoalProximity GoalProximity, Actor RangeActor )
{
	local bool bHandlerExists;
	class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler", DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler GoalProximity: " $ GoalProximity, DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler GoalProximity: " $ Handlers[ GoalProximity ], DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler GoalProximity: " $ Handlers[ GoalProximity ].GetHandler(), DebugCategoryName );
	
	if( ( Handlers[ GoalProximity ] != None ) )
	{
		//this is a special case (hack) Handlers[ GoalProximity ].GetHandler()
		GoalProximityHandler = Handlers[ GoalProximity ];
		bHandlerExists = true;
		class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler GoalProximityHandler: " $ GoalProximityHandler, DebugCategoryName );
		class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler HT_AssociatedState: " $ GoalProximityHandler.Template.HT_AssociatedState, DebugCategoryName );
	}
	
	class'Debug'.static.DebugLog( RangeActor, "GetGoalProximityHandler returning " $ bHandlerExists, DebugCategoryName );
	return bHandlerExists;
}



function bool SelectGoalProximityHandler( out RangeHandler SelectedHandler,
		Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local EGoalProximity BestProximity;
	local bool bSelectedHandler;
	
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler", DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler Handlers[ EGoalProximity.GP_Reached ] " $ Handlers[ EGoalProximity.GP_Reached ], DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler Handlers[ EGoalProximity.GP_Reachable ] " $ Handlers[ EGoalProximity.GP_Reachable ], DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler Handlers[ EGoalProximity.GP_Visible ] " $ Handlers[ EGoalProximity.GP_Visible ], DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler Handlers[ EGoalProximity.GP_Pathable ] " $ Handlers[ EGoalProximity.GP_Pathable ], DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler Handlers[ EGoalProximity.GP_UnNavigable ] " $ Handlers[ EGoalProximity.GP_UnNavigable ], DebugCategoryName );
	
	if( ( Handlers[ EGoalProximity.GP_Reached ] != None ) &&
			Handlers[ EGoalProximity.GP_Reached ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) &&
			Goal.IsGoalReached( RangeActor ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler GP_Reached", DebugCategoryName );
		BestProximity = EGoalProximity.GP_Reached;
	}
	else if( ( Handlers[ EGoalProximity.GP_Reachable ] != None ) &&
			Handlers[ EGoalProximity.GP_Reachable ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) &&
			Goal.IsGoalReachable( RangeActor ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler GP_Reachable", DebugCategoryName );
		BestProximity = EGoalProximity.GP_Reachable;
	}
	else if( ( Handlers[ EGoalProximity.GP_Visible ] != None ) &&
			Handlers[ EGoalProximity.GP_Visible ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) &&
			Goal.IsGoalVisible( RangeActor ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler GP_Visible", DebugCategoryName );
		BestProximity = EGoalProximity.GP_Visible;
	}
	else if( ( Handlers[ EGoalProximity.GP_Pathable ] != None ) &&
			Handlers[ EGoalProximity.GP_Pathable ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) &&
			Goal.IsGoalPathable( RangeActor ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler GP_Pathable", DebugCategoryName );
		BestProximity = EGoalProximity.GP_Pathable;
	}
	else if( ( Handlers[ EGoalProximity.GP_UnNavigable ] != None ) &&
			Handlers[ EGoalProximity.GP_UnNavigable ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler GP_UnNavigable", DebugCategoryName );
		BestProximity = EGoalProximity.GP_UnNavigable;
	}
	else
	{
		BestProximity = EGoalProximity.GP_None;
	}
	
	bSelectedHandler = BestProximity != EGoalProximity.GP_none;
	
	if( bSelectedHandler )
	{
		SelectedHandler = Handlers[ BestProximity ];
	}
	
	class'Debug'.static.DebugLog( RangeActor, "SelectGoalProximityHandler returning " $ bSelectedHandler, DebugCategoryName );
	return bSelectedHandler;
}

defaultproperties
{
     HandlerSelection=HS_GoalProximity
     DebugCategoryName=RangeTransitioner
}
