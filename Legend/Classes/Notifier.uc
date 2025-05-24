//=============================================================================
// Notifier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class Notifier expands LegendObjectComponent native;

var private Name CallbackFunctionName;
var () const class<NotifierProxy> NotifierProxyClass;
var NotifierProxy ThisNotifierProxy;
var Name Notification;
var const bool bEnabled;



function SubjectDestroyed( Object Subject )
{
	if( ThisNotifierProxy == Subject )
	{
		ThisNotifierProxy = None;
	}
	Super.SubjectDestroyed( Subject );
}



static function Notifier CreateNotifier( Actor NotifierOuter, optional Name NotifierCallbackFunctionName )
{
	local Notifier CreatedNotifier;
	local NotifierProxy CreatedNotifierProxy;
	CreatedNotifier = New( NotifierOuter )default.class;
	if( default.NotifierProxyClass != None )
	{
		//since this notifier does not have an event name it must have a trigger proxy
		//so it can have something to pass to the notified actors trigger function
		CreatedNotifierProxy = NotifierOuter.Spawn( default.NotifierProxyClass, NotifierOuter );
		if( ( CreatedNotifierProxy != None ) && CreatedNotifierProxy.AttachDestroyObserver( CreatedNotifier ) )
		{
			//the notifier needs to know if the proxy is destroyed
			CreatedNotifier.ThisNotifierProxy = CreatedNotifierProxy;
			if( CreatedNotifier.AttachDestroyObserver( CreatedNotifier.ThisNotifierProxy ) )
			{
				//the proxy needs to know if the notifier is destroyed
				CreatedNotifier.ThisNotifierProxy.ActualNotifier = CreatedNotifier;
			}
		}
	}
	CreatedNotifier.CallbackFunctionName = NotifierCallbackFunctionName;
	return CreatedNotifier;
}



function Destructed()
{
	if( ThisNotifierProxy != None )
	{
		ThisNotifierProxy.DetachDestroyObserver( Self ); //the notifier no longer needs to know if the proxy is destroyed
		ThisNotifierProxy.ActualNotifier = None;
		ThisNotifierProxy.Destroy();
		ThisNotifierProxy = None;
	}
	Super.Destructed();
}



native event EnableNotifier();
native event DisableNotifier();
native final function Notify( optional Object Observer );

defaultproperties
{
     NotifierProxyClass=Class'Legend.NotifierProxy'
}
