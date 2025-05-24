//=============================================================================
// NotifierProxy.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class NotifierProxy expands LegendActorComponent native;

var Notifier ActualNotifier;



function SubjectDestroyed( Object Subject )
{
	if( ActualNotifier == Subject )
	{
		ActualNotifier = None;
	}
	Super.SubjectDestroyed( Subject );
}



function Destroyed()
{
	if( ActualNotifier != None )
	{
		ActualNotifier.DetachDestroyObserver( Self ); //the proxy no longer needs to know if the notifier is destroyed
		ActualNotifier.Delete();
		ActualNotifier = None;
	}
	Super.Destroyed();
}

defaultproperties
{
}
