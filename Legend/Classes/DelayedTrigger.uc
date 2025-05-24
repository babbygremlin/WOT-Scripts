//=============================================================================
// DelayedTrigger.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class DelayedTrigger expands LegendActorComponent;

var private Actor TriggeringActor;
var private Actor TriggeredActor;
var private float TriggerTime;
var private Pawn EventInstigator;
var private Name TriggerEvent;

function Initialize( Actor GivenTriggeringActor, Actor GivenTriggeredActor, float DelaySecs, optional Pawn Instigator, optional Name Event )
{
	TriggeringActor	= GivenTriggeringActor;
	TriggeredActor 	= GivenTriggeredActor;
	TriggerTime 	= Level.TimeSeconds+DelaySecs;
	EventInstigator = Instigator;
	TriggerEvent 	= Event;
}

//------------------------------------------------------------------------------

simulated function Tick( float DeltaTime )
{
	if( TriggeredActor != None && Level.TimeSeconds >= TriggerTime )
	{
		class'util'.static.TriggerActor( TriggeringActor, TriggeredActor, EventInstigator, TriggerEvent );
		Destroy();
	}
}

defaultproperties
{
}
