//=============================================================================
// LegendPawnNotificationMediator.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class LegendPawnNotificationMediator expands DirectiveMediator;

var (DirectiveMediator) int LegendPawnNotificationInfoIndex;
var (DirectiveMediator) Name MultiDispatchTag;
var (DirectiveMediator) bool bMultiDispatch;



function Trigger( Actor Other, Pawn EventInstigator )
{
	local ObservableDirective CurrentObservableDirective;
	local LegendPawn CurrentLegendPawn;
	local bool bTriggeredInstigator;
	
	if( bShowDebugMessage )
	{
		BroadcastMessage( Self $ "::Trigger EventInstigator " $ EventInstigator );
	}
	if( ( EventInstigator != None ) && EventInstigator.IsA( 'LegendPawn' ) )
	{
		Super.Trigger( Other, EventInstigator );
		bTriggeredInstigator = true;
	}
	if( !bTriggeredInstigator || bMultiDispatch )
	{
		foreach AllActors( class'LegendPawn', CurrentLegendPawn, MultiDispatchTag )
		{
			if( !bTriggeredInstigator || ( CurrentLegendPawn != EventInstigator ) )
			{
				Super.Trigger( Other, CurrentLegendPawn );
			}
		}
	}
}

defaultproperties
{
}
