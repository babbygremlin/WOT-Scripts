//=============================================================================
// DirectiveMediator.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class DirectiveMediator expands LegendActorComponent;

var Actor DirectiveRecipient;
var () Name DirectiveTagName;
//xxxrlofuture var () bool bDirectiveEvaluate;
var () bool bShowDebugMessage;


function Trigger( Actor Other, Pawn EventInstigator )
{
	local ObservableDirective CurrentObservableDirective;
	if( bShowDebugMessage )
	{
		BroadcastMessage( Self $ "::Trigger EventInstigator " $ EventInstigator $ " DirectiveTagName " $ DirectiveTagName );
	}
	DirectiveRecipient = EventInstigator;
	foreach AllActors( class'ObservableDirective', CurrentObservableDirective, DirectiveTagName )
	{
		if( bShowDebugMessage )
		{
			BroadcastMessage( Self $ " calling MediatorDirectObserver on " $ CurrentObservableDirective $ " on behalf of " $ DirectiveRecipient );
			Log( Self $ " calling MediatorDirectObserver on " $ CurrentObservableDirective $ " on behalf of " $ DirectiveRecipient );
		}
		CurrentObservableDirective.MediatorDirectObserver( Self );
	}
}

defaultproperties
{
}
