//=============================================================================
// Soldier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================

//The grunt for the Whitecloak.

class Soldier expands SoldierAssets;

//only valid when the soldier/questioner has his shield
//no shield swish sound?
#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunShield		TIME=0.40 FUNCTION=PlayMeleeHitSound
#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunShield		TIME=0.45 FUNCTION=AttackRunShieldDamageTarget

#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunSwipe		TIME=0.40 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunSwipe		TIME=0.48 FUNCTION=AttackRunSwipeDamageTarget

#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunLunge		TIME=0.40 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Soldier SEQ=AttackRunLunge		TIME=0.50 FUNCTION=AttackRunLungeDamageTarget

//used for questioner
#exec MESH NOTIFY MESH=Soldier SEQ=ShldHurl				TIME=0.60 FUNCTION=ShootRangedAmmo
#exec MESH NOTIFY MESH=Soldier SEQ=ShldHurl				Time=0.25 FUNCTION=DisableDefensiveNotifier
#exec MESH NOTIFY MESH=Soldier  SEQ=Walk				TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Soldier  SEQ=Walk				TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Soldier  SEQ=Run					TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Soldier  SEQ=Run					TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Soldier  SEQ=Breath				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Soldier  SEQ=Listen				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Soldier  SEQ=Look				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Soldier  SEQ=ReactP  			TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Soldier  SEQ=ReactPLoop			TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Soldier  SEQ=DeathB				TIME=0.56 FUNCTION=TransitionToCarcassNotification
//#exec MESH NOTIFY MESH=Soldier  SEQ=DeathF				TIME=0.60 FUNCTION=TransitionToCarcassNotification

#exec AUDIO IMPORT FILE=Sounds\Weapon\Shield\Shield_Deflect1.wav

defaultproperties
{
     AttackRunShieldDamage=10.000000
     AttackRunSwipeDamage=15.000000
     AttackRunLungeDamage=15.000000
     ShieldReflectorInventoryProxyClass=Class'WOTPawns.SoldierShield'
     ShieldReflectorSoundName="WOTPawns.Shield_Deflect1"
     ShieldReflectorIrreleventProjectileType=SeekingProjectile
     bShieldReflectorDeflect=True
     BaseWalkingSpeed=160.000000
     DefaultWeaponType=Class'WOTPawns.SoldierShield'
     MeleeWeaponType=Class'WOTPawns.SoldierShield'
     GroundSpeedMin=560.000000
     GroundSpeedMax=560.000000
     HealthMPMin=150.000000
     HealthMPMax=150.000000
     HealthSPMin=150.000000
     HealthSPMax=150.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableSoldier'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListSoldier'
     AnimationTableClass=Class'WOTPawns.AnimationTableSoldier'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactorySoldier'
     GoalSuggestedSpeeds(0)=560.000000
     GoalSuggestedSpeeds(2)=560.000000
     GoalSuggestedSpeeds(3)=560.000000
     GoalSuggestedSpeeds(4)=560.000000
     GoalSuggestedSpeeds(5)=560.000000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorSoldier'
     MeleeRange=50.000000
     GroundSpeed=560.000000
     Health=150
     DrawScale=1.200000
     CollisionRadius=20.000000
     Mass=200.000000
}
