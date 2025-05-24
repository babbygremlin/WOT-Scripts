//------------------------------------------------------------------------------
// WOTDispatcher.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//------------------------------------------------------------------------------
class WOTDispatcher expands Dispatcher;

var Actor LastOther;

// When dispatcher is triggered...
//
function Trigger( actor Other, pawn EventInstigator )
{
	LastOther = Other;
	
	Instigator = EventInstigator;
	GotoState( 'WOTDispatch' );
}

//
// Dispatch events.
//
state WOTDispatch
{
Begin:
	Disable( 'Trigger' );
	for( i = 0; i < ArrayCount(OutEvents); i++ )
	{
		if( OutEvents[i] != '' )
		{
			Sleep( OutDelays[i] );
			foreach AllActors( class 'Actor', Target, OutEvents[i] )
			{
				Target.Trigger( Self, Instigator );
			}
			
			CheckStageTriggers( OutEvents[i] );
		}
	}
	Enable( 'Trigger' );
}

function CheckStageTriggers( name TheEvent )
{
	local StageTrigger T;
	
	// Look for StageTriggers with matching TagInc or TagDec.
	//
	foreach AllActors( class 'StageTrigger', T )
	{
		if( T.TagInc == TheEvent )
		{
			T.ChangeStage( LastOther, 1 );
		}
		
		if( T.TagDec == TheEvent )
		{
			T.ChangeStage( LastOther, -1 );
		}
	}
}

defaultproperties
{
}
