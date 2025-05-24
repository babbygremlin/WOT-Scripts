//=============================================================================
// SpecialEffectsTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	The is the non-replicated multiplayer savvy version of 
//				StochasticTrigger for triggering stuff like particle systems
//				that are ROLE_None, and don't need to be synced with the 
//				server.
//------------------------------------------------------------------------------

class SpecialEffectsTrigger expands Triggers;

var() name   Events[6];      		// What events to call (must be at least one event)
var() float  triggerProbability;	// The chance of the event occuring effect playing
var() float  minReCheckTime;		// Try to re-trigger the event after (min amount)
var() float  maxReCheckTime;		// Try to re-trigger the event after (max amount)
var   bool	 bIsActive;				// This trigger dispacher is activated/deactivated
var   float  reTriggerTime;
var   int    numEvents;				// The number of events available
var   Actor  triggerInstigator;   	// Who enabled this actor to dispach?

//------------------------------------------------------------------------------
simulated function BeginPlay() 
{
	local int i;
	
	// Calculate how many events the user specified
	numEvents = 6;
	for( i = 0; i < 6; i++ )
	{
		if( Events[i] == '' )
		{
			numEvents = i;
			break;
		}
	}

	reTriggerTime = RandRange( minReCheckTime, maxReCheckTime );
	SetTimer( reTriggerTime, false );
}

//------------------------------------------------------------------------------
simulated function Timer() 
{
	local int 	i;
	local Actor A;

	if( FRand() <= triggerProbability && bIsActive )
	{
		// Trigger an event
		// Which event should be initiated?
		i = Rand(numEvents);

		// Broadcast the Trigger message to all matching actors.
		if( Events[i] != '' )
			foreach AllActors( class 'Actor', A, Events[i] )
				A.Trigger( triggerInstigator, Instigator );
	}

	reTriggerTime = RandRange( minReCheckTime, maxReCheckTime );
	SetTimer( reTriggerTime, false );
}

////////////
// States //
////////////

//------------------------------------------------------------------------------
simulated state() TriggeredActive
{
	simulated function BeginState()
	{
		bIsActive = false; 		// initially the trigger dispacher is inactive
	}

	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		// StochasticTrigger is active
		if( triggerInstigator == None )
		{
			triggerInstigator = EventInstigator;
		}
		else
		{
			triggerInstigator = Other;
		}

		Instigator = EventInstigator;
		bIsActive = true;
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		// StochasticTrigger is inactive
		if( triggerInstigator == None )
		{
			triggerInstigator = EventInstigator;
		}
		else
		{
			triggerInstigator = Other;
		}

		Instigator = EventInstigator;
		bIsActive = false;
	}
}

//------------------------------------------------------------------------------
simulated state() AlwaysActive
{
	simulated function BeginState()
	{
		bIsActive = true;
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
}
