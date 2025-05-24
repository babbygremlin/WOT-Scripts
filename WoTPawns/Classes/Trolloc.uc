//=============================================================================
// Trolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================

class Trolloc expands TrollocAssets;

#exec MESH NOTIFY MESH=Trolloc SEQ=AttackRun			TIME=0.65 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Trolloc SEQ=AttackRun            TIME=0.75 FUNCTION=AttackRunDamageTarget

#exec MESH NOTIFY MESH=Trolloc SEQ=AttackRunB			TIME=0.60 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Trolloc SEQ=AttackRunB			TIME=0.70 FUNCTION=AttackRunBDamageTarget
#exec MESH NOTIFY MESH=Trolloc SEQ=AttackThrow1			Time=0.05 FUNCTION=DisableDefensiveNotifier

#exec MESH NOTIFY MESH=Trolloc SEQ=Walk					TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Walk					TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Run					TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Run					TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Trolloc SEQ=Breath				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Listen				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Look					TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Trolloc SEQ=ReactP  				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Trolloc SEQ=ReactPLoop			TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Trolloc SEQ=Scratch				TIME=0.20 FUNCTION=PlayAnimSound

//#exec MESH NOTIFY MESH=Trolloc SEQ=DeathBNew			TIME=0.50 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Trolloc SEQ=DeathB				TIME=0.44 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Trolloc SEQ=DeathF				TIME=0.90 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Trolloc SEQ=DeathC				TIME=0.44 FUNCTION=TransitionToCarcassNotification

var () float AttackRunDamage;
var () float AttackRunBDamage;

const ScratchAnim = 'Scratch';



//=============================================================================
//	WaitingWaitingIdle state
//=============================================================================

state() WaitingIdle
{
	function PlayAnimSound()
	{
		class'Debug'.static.DebugLog( Self, Class $ ":PlayAnimSound" );

		switch( AnimSequence )
		{
			// can't start right at the start of the scratch animations
			case ScratchAnim:
				MySoundTable.PlaySlotSound( Self, MySoundTable.Misc1SoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;

			default:
            	Global.PlayAnimSound();
		}
	}
}

//=============================================================================
//	PerformMeleeAttack state
//=============================================================================

state PerformMeleeAttack
{
	function AttackRunDamageTarget()
	{
		AttackDamageTarget( AttackRunDamage, 0.0, 'Cutup' );
	}

	function AttackRunBDamageTarget()
	{
		AttackDamageTarget( AttackRunBDamage, -0.5, 'Sliced' );
	}
}

//=============================================================================
//	PerformMeleeWeaponAttack state
//=============================================================================

state PerformMeleeWeaponAttack
{
	function AttackRunDamageTarget()
	{
		AttackDamageTarget( AttackRunDamage, 0.0, 'Cutup' );
	}

	function AttackRunBDamageTarget()
	{
		AttackDamageTarget( AttackRunBDamage, -0.5, 'Sliced' );
	}
}

defaultproperties
{
     AttackRunDamage=15.000000
     AttackRunBDamage=10.000000
     BaseWalkingSpeed=110.000000
     RangedWeaponType=Class'WOTPawns.TrollocStrongAxeProxy'
     GroundSpeedMin=440.000000
     GroundSpeedMax=440.000000
     HealthMPMin=150.000000
     HealthMPMax=150.000000
     HealthSPMin=150.000000
     HealthSPMax=150.000000
     TextureHelperClass=Class'WOTPawns.NPCTrollocTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableTrolloc'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListTrolloc'
     AnimationTableClass=Class'WOTPawns.AnimationTableTrolloc'
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryTrolloc'
     GoalSuggestedSpeeds(0)=440.000000
     GoalSuggestedSpeeds(2)=440.000000
     GoalSuggestedSpeeds(3)=440.000000
     GoalSuggestedSpeeds(4)=440.000000
     GoalSuggestedSpeeds(5)=440.000000
     GoalSuggestedSpeeds(6)=110.000000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorTrolloc'
     DurationNotifierDurations(7)=1.500000
     DodgeVelocityFactor=200.000000
     DodgeVelocityAlltitude=80.000000
     MeleeRange=50.000000
     GroundSpeed=440.000000
     BaseEyeHeight=52.000000
     Health=150
     DrawScale=1.480000
     CollisionRadius=28.000000
     CollisionHeight=56.000000
     Mass=275.000000
}
