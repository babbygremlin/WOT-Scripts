//=============================================================================
// SpecialEventTrigger.uc
//
// Engine.SpecialEvent with WOT-specific mods, and derivation from "Trigger"
// instead of "Triggers.Actor".
//=============================================================================
class SpecialEventTrigger expands Trigger;

//-----------------------------------------------------------------------------
// Variables.

var() int        Damage;         // For DamagePlayer state.
var() name		 DamageType;
var() localized string DamageString;
var() sound      Sound;          // For PlaySoundEffect state.
var() float      SoundEffectVolume;
var() float      SoundEffectRadius;
var() float      SoundEffectPitch;
var() bool       bBroadcast;     // To broadcast the message to all players.
var() bool       bPlayerViewRot; // Whether player can rotate the view while pathing.

//-----------------------------------------------------------------------------
// Functions.

// copy&paste from Trigger.uc overriding Trigger() calling convention and adding
// bBroadcast check for ClientMessage()
function Touch( actor Other )
{
	local actor A;
	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
		{
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Other, Other.Instigator );
		}
		else
		{
			Trigger( Other, Other.Instigator );
		}
		
		if( Message != "" )
		{
			if( bBroadcast )
			{
				BroadcastMessage( Message, true );
			}
			else if( Other.Instigator != None )
			{
				Other.Instigator.ClientMessage( Message );
			}
		}
		
		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
		{
			Pawn(Other).SpecialGoal = None;
		}

		if( bTriggerOnceOnly )
		{
			// Ignore future touches.
			SetCollision(False);
		}
		else if ( RepeatTriggerTime > 0 )
		{
			SetTimer(RepeatTriggerTime, false);
		}
	}
}

//-----------------------------------------------------------------------------
// States.

// Just display the message.
state() DisplayMessage
{
}

// Damage the instigator who caused this event.
state() DamageInstigator
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		Global.Trigger( Self, EventInstigator );
		
		if ( Other.IsA('PlayerPawn') )
			Level.Game.SpecialDamageString = DamageString;

		if( Damage >= 0 )
			Other.TakeDamage( Damage, EventInstigator, EventInstigator.Location, Vect(0,0,0), DamageType);
		else if( Pawn(Other) != None )
			Pawn(Other).Health = Min( Pawn(Other).Health + -Damage, Pawn(Other).default.Health );
	}
}

// Kill the instigator who caused this event.
state() KillInstigator
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		Global.Trigger( Self, EventInstigator );
		if ( Other.IsA('PlayerPawn') )
			Level.Game.SpecialDamageString = DamageString;
		if( EventInstigator != None )
			EventInstigator.Died( None, DamageType, EventInstigator.Location );
	}
}

// Play a sound.
state() PlaySoundEffect
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		Global.Trigger( Self, EventInstigator );
		PlaySound( Sound,, SoundEffectVolume,, SoundEffectRadius, SoundEffectPitch );
	}
}

// Play a sound.
state() PlayersPlaySoundEffect
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local pawn P;

		Global.Trigger( Self, EventInstigator );

		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		{
			if ( P.bIsPlayer && P.IsA('PlayerPawn') )
			{
				PlayerPawn(P).ClientPlaySound(Sound);
			}
		}
	}
}

// Place Ambient sound effect on player
state() PlayAmbientSoundEffect
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		Global.Trigger( Self, EventInstigator );
		EventInstigator.AmbientSound = AmbientSound;
	}
}


// Send the player on a spline path through the level.
state() PlayerPath
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local InterpolationPoint i;
		Global.Trigger( Self, EventInstigator );
		if( EventInstigator!=None && EventInstigator.bIsPlayer && (Level.NetMode == NM_Standalone) )
		{
			foreach AllActors( class 'InterpolationPoint', i, Event )
			{
				if( i.Position == 0 )
				{
					EventInstigator.GotoState('');
					EventInstigator.SetCollision(True,false,false);
					EventInstigator.bCollideWorld = False;
					EventInstigator.Target = i;
					EventInstigator.SetPhysics(PHYS_Interpolating);
					EventInstigator.PhysRate = 1.0;
					EventInstigator.PhysAlpha = 0.0;
					EventInstigator.bInterpolating = true;
					EventInstigator.AmbientSound = AmbientSound;
				}
			}
		}
	}
}

defaultproperties
{
     SoundEffectVolume=1.000000
     SoundEffectRadius=2000.000000
     SoundEffectPitch=1.000000
     Texture=Texture'Engine.S_SpecialEvent'
}
