//=============================================================================
// SkyboxTrigger
//=============================================================================

// When touched, the SkyboxTrigger will change the SkyZone in
// the ZoneInfo with the matching Tag.  The SkyZoneInfo is identified by
// matching the trigger's Tag against the SkyZoneInfo's Tag.

class SkyboxTrigger expands Trigger;

simulated function RelinkSkybox()
{
	local skyzoneinfo S;
	local zoneinfo Z;

	// find the skyzone that matches our "Tag"
	foreach AllActors( class'SkyZoneInfo', S, Tag )
	{
		// update all the Zones that match our "Event"
		foreach AllActors( class 'ZoneInfo', Z, Event )
		{
			Z.SkyZone = S;
		}
	}
}

//
// Called when something touches the trigger.
// Complete override of Trigger.uc implementation (copy&paste + modifications)
//
function Touch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		if( ReTriggerDelay > 0 )
		{
			if( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		// Update SkyZone in all matching actors.
		if( Event != '' )
			RelinkSkybox();

		if( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

//
// When something untouches the trigger.
// Complete override of Trigger.uc implementation -- do nothing
//
function UnTouch( actor Other )
{
}

defaultproperties
{
     CollisionRadius=80.000000
}
