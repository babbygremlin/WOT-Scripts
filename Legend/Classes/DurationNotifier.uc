//=============================================================================
// DurationNotifier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class DurationNotifier expands Notifier native;

var const float Duration;
var const float ElapsedTime;
var () bool bRandomizeElapsedTime;
var () const editconst Name DurationElapsedNotification;
/*
if this value is passed to SetDuration then the notifier will not notify the
observer when the duration elapses the elapsed time will continue to
accumulate. This makes a duration notifier act like a normal notifier (it
only notifies when notify is called)
*/
var () const editconst float NotifierDurationNever;

native final function bool SetDuration( float NewDuration );
native final function bool HasDurationElapsed();
native final function OnReflectedTick( Actor TickedActor, float DeltaTime );
native event OnDurationElapsed( Actor TickedActor );

defaultproperties
{
     bRandomizeElapsedTime=True
     DurationElapsedNotification=DurationNotifierElapsed
     NotifierDurationNever=-1.000000
}
