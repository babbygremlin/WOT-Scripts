//=============================================================================
// ObservableDirective.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================

class ObservableDirective expands LegendActorComponent abstract native;

var () private class<Actor> 	ObserverClasses[ 16 ];
var () private Name 			ObserverTags[ 16 ];
var () private Name 			ObserverNames[ 16 ];

var () private bool 			bIgnoresObservers;		//xxxrlofuture not implemented
var () private class<Actor> 	IgnoredClasses[ 16 ];	//xxxrlofuture not implemented
var () private Name 			IgnoredTags[ 16 ];		//xxxrlofuture not implemented
var () private Name 			IgnoredNames[ 16 ];		//xxxrlofuture not implemented

var () private bool 			bDurationDirective;
var private DurationNotifier	ObservationMonitor;
var () private float 			ObservationMonitorDuration;
var () Name 					Notification;
var () bool 					bShowDebugMessage;



function Destroyed()
{
	if( ObservationMonitor != None )
	{
		ObservationMonitor.Delete();
		ObservationMonitor = None;
	}
	Super.Destroyed();
}



function PostBeginPlay()
{
	if( bDurationDirective )
	{
		ObservationMonitor = DurationNotifier( class'DurationNotifier'.static.CreateNotifier( Self, 'OnObservationNotification' ) );
		ObservationMonitor.SetDuration( ObservationMonitorDuration );
		ObservationMonitor.EnableNotifier();
	}
}


	
function Trigger( Actor Other, Pawn EventInstigator )
{
	if( bShowDebugMessage )
	{
		BroadcastMessage( Self $ "::Trigger Other " $ Other $ " EventInstigator " $ EventInstigator );
		Log( Self $ "::Trigger Other " $ Other $ " EventInstigator " $ EventInstigator );
	}
	class'Debug'.static.DebugLog( Self, "Trigger", 'ObservableDirective' );
	class'Debug'.static.DebugLog( Self, "Trigger Other: " $ Other, 'ObservableDirective' );
	class'Debug'.static.DebugLog( Self, "Trigger EventInstigator: " $ EventInstigator, 'ObservableDirective' );
	DirectObservers( EventInstigator );
	Super.Trigger( Other, EventInstigator );
}



function OnObservationNotification( Notifier Notification )
{
	DirectObservers( None );
}



function MediatorDirectObserver( DirectiveMediator Mediator )
{
	class'Debug'.static.DebugLog( Self, "MediatorDirectObserver Mediator " $ Mediator, 'ObservableDirective' );
	DirectObserver( Mediator.DirectiveRecipient, None );
}



native function DirectObservers( Pawn EventInstigator );



event bool IsObserverIgnored( Actor Observer, Pawn EventInstigator )
{
	return false; //xxxrlo
}



event DirectObserver( Actor Observer, Pawn EventInstigator )
{
	if( bShowDebugMessage )
	{
		BroadcastMessage( Self $ "::DirectObserver Observer " $ Observer $ " EventInstigator " $ EventInstigator );
		Log( Self $ "::DirectObserver Observer " $ Observer $ " EventInstigator " $ EventInstigator );
	}
	class'Debug'.static.DebugLog( Self, "DirectObserver Observer: " $ Observer, 'ObservableDirective' );
	class'Util'.static.TriggerActor( Self, Observer, EventInstigator, Notification );
}



function DebugLog( Object Invoker )
{
	local int ArrayIter;
	local Actor Observer;
	class'Debug'.static.DebugLog( Invoker, "DebugLog", DebugCategoryName );
	
	//log out of the observers of this external directive
	for( ArrayIter = 0; ArrayIter < ArrayCount( ObserverClasses ); ArrayIter++ )
	{
		if( ObserverClasses[ ArrayIter ] != None )
		{
			foreach AllActors( ObserverClasses[ ArrayIter ], Observer )
			{
				class'Debug'.static.DebugLog( Invoker, "DebugLog ObserverClass[ " $ ArrayIter $ " ] " $ ObserverClasses[ ArrayIter ] $ " Observer " $ Observer, DebugCategoryName );
			}
		}
	}
	
	for( ArrayIter = 0; ArrayIter < ArrayCount( ObserverTags ); ArrayIter++ )
	{
		if( ObserverTags[ ArrayIter ] != '' )
		{
			foreach AllActors( class'Actor', Observer, ObserverTags[ ArrayIter ] )
			{
				class'Debug'.static.DebugLog( Invoker, "DebugLog ObserverTags[ " $ ArrayIter $ " ] " $ ObserverTags[ ArrayIter ] $ " Observer " $ Observer, DebugCategoryName );
			}
		}
	}
	
	for( ArrayIter = 0; ArrayIter < ArrayCount( ObserverNames ); ArrayIter++ )
	{
		if( ObserverNames[ ArrayIter ] != '' )
		{
			foreach AllActors( class'Actor', Observer )
			{
				if( Observer.Name == ObserverNames[ ArrayIter ] )
				{
					class'Debug'.static.DebugLog( Invoker, "DebugLog ObserverNames[ " $ ArrayIter $ " ] " $ ObserverNames[ ArrayIter ] $ " Observer " $ Observer, DebugCategoryName );
				}
			}
		}
	}

	class'Debug'.static.DebugLog( Invoker, "DebugLog bDurationDirective " $ bDurationDirective, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "DebugLog ObservationMonitor " $ ObservationMonitor, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "DebugLog ObservationMonitorDuration " $ ObservationMonitorDuration, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "DebugLog Notification " $ Notification, DebugCategoryName );
}



state () InitialNotifyObservers
{
	function BeginState()
	{
		class'Debug'.static.DebugLog( Self, "BeginState ", 'ObservableDirective' );
		DirectObservers( None );
	}
}

defaultproperties
{
}
