//=============================================================================
// RandomTrigger.
//=============================================================================
class RandomTrigger expands Trigger;

// The probability that this trigger will work.
var() float TriggerProbability;		// Number between 0.0 and 1.0

function Touch( actor Other )
{
	local actor A;
	if( IsRelevant( Other ) )
	{
		if( ReTriggerDelay > 0 )
		{
			if( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		
		if( FRand() <= TriggerProbability )
		{
			// Broadcast the Trigger message to all matching actors.
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );
	
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
}

defaultproperties
{
}
