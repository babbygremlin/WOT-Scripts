//=============================================================================
// TeleporterWithEffects.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class TeleporterWithEffects expands Teleporter;

var(Teleporter) class<actor> EnterEffectClass;
var(Teleporter) sound EnterEffectSound;
var(Teleporter) class<actor> ExitEffectClass;
var(Teleporter) sound ExitEffectSound;

simulated function bool Accept( actor Incoming )
{
	local Actor Effect;

	if( Super.Accept( Incoming ) )
	{
		if( ExitEffectClass != None )
		{
			Effect = Spawn( ExitEffectClass );
			Effect.RemoteRole = ROLE_None;
		}
		if( ExitEffectSound != None )
			PlaySound( ExitEffectSound, SLOT_None );
	}
}

// override to create unique effects at each teleporter
// Teleporter.PlayerTeleportEffect() calls GameInfo.PlayTeleportEffect()
// to create level-wide "standard" effects.
// See WOTGameInfo for implelementation.
simulated function PlayTeleportEffect( actor Incoming, bool bOut )
{
	local Actor Effect;

	if( EnterEffectClass != None )
	{
		Effect = Spawn( EnterEffectClass );
		Effect.RemoteRole = ROLE_None;
	}
	if( EnterEffectSound != None )
		PlaySound( EnterEffectSound, SLOT_None );
}

// end of TeleporterWithEffects.uc

defaultproperties
{
}
