//=============================================================================
// RangeIterator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class RangeIterator expands AiComponent;

var private RangeHandler		CurrentHandler;
var private RangeHandler		SelectedHandler;
var private RangeTransitioner	CurrentTransitioner;



function RangeHandler GetCurrentHandler()
{
	return CurrentHandler;
}



function RangeHandler GetSelectedHandler()
{
	return SelectedHandler;
}



function bool SelectNextHandler( Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local bool bSelected;
	//Log( RangeActor $ "::SelectNextHandler" );
	bSelected = CurrentTransitioner.SelectHandler( SelectedHandler, RangeActor, Goal, Constrainer );
	if( !bSelected )
	{
		SelectedHandler = None;	
	}
	return bSelected;
}



function bool TransitionToNextHandler( Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local bool bValidNextHandler;
	
	//Log( RangeActor $ "::TransitionToNextHandler" );
	if( SelectNextHandler( RangeActor, Goal, Constrainer ) )
	{
		TransitionToSelectedHandler( RangeActor, Goal, Constrainer );
		bValidNextHandler = true;
	}
	return bValidNextHandler;
}



function bool TransitionToSelectedHandler( Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local bool bValidNextHandler;

	//Log( RangeActor $ "::TransitionToSelectedHandler" );
	if( GetSelectedHandler() != None )
	{
		TransitionToHandler( RangeActor, Goal, Constrainer, GetSelectedHandler() );
		bValidNextHandler = true;
	}
	return bValidNextHandler;
}



function TransitionToHandler( Actor RangeActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer,
		RangeHandler GivenHandler )
{
	//Log( RangeActor $ "::TransitionToHandler" );
	assert( GivenHandler != None );
	if( RangeActor.Level.bStartUp )
	{
		CurrentTransitioner.EntryTime = RangeActor.Level.TimeSeconds;
	}
	else
	{
		CurrentTransitioner.EntryTime = 0;
	}
	SelectedHandler = None;
	CurrentHandler = CurrentTransitioner.PerformRangeTransition( RangeActor, Goal, Constrainer, GivenHandler );
}



function BindRangeTransitioner( RangeTransitioner NewTransitioner )
{
	if( CurrentTransitioner != NewTransitioner )
	{
		CurrentTransitioner = NewTransitioner;
		CurrentHandler = None;
		SelectedHandler = None;
	}
}

defaultproperties
{
     DebugCategoryName=RangeIterator
}
