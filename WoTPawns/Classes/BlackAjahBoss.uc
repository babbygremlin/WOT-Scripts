//=============================================================================
// BlackAjahBoss.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================

// The BlackAjah Boss

class BlackAjahBoss expands BlackAjahBossAssets;

#exec MESH NOTIFY MESH=BlackAjahBoss  SEQ=Shoot   TIME=0.10  FUNCTION=ShootRangedAmmo

#exec MESH NOTIFY MESH=BlackAjahBoss  SEQ=Walk    TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BlackAjahBoss  SEQ=Walk    TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BlackAjahBoss  SEQ=Run     TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BlackAjahBoss  SEQ=Run     TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=BlackAjahBoss SEQ=DeathREx TIME=0.95 FUNCTION=TransitionToCarcassNotification

defaultproperties
{
     MinOffensiveAngrealUsageInterval=3.000000
     MinDefensiveAngrealUsageInterval=1.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvTaint"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvSoulBarb"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvIce"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvDecay"
     AII_AngrealInventoryStr(6)="Angreal.AngrealInvReflect"
     AII_AngrealInventoryStr(7)="Angreal.AngrealInvShift"
     AII_AngrealInventoryStr(8)="Angreal.AngrealInvFireShield"
     AII_Priority(0)=1.000000
     AII_Priority(1)=3.000000
     AII_Priority(2)=5.000000
     AII_Priority(3)=10.000000
     AII_Priority(4)=9.000000
     AII_Priority(5)=4.000000
     AII_Priority(6)=10.000000
     AII_Priority(7)=8.000000
     AII_Priority(8)=9.000000
     AII_MinChargeGroupInterval(1)=30.000000
     AII_MinChargeGroupInterval(5)=20.000000
     BaseWalkingSpeed=156.250000
     DisguiseIcon=Texture'WOTPawns.UI.H_BlackAjahBossDisguise'
     GroundSpeedMin=625.000000
     GroundSpeedMax=625.000000
     HealthMPMin=600.000000
     HealthMPMax=600.000000
     HealthSPMin=600.000000
     HealthSPMax=600.000000
     TextureHelperClass=Class'WOTPawns.PCFemaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableBlackAjahBoss'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListBlackAjahBoss'
     AnimationTableClass=Class'WOTPawns.AnimationTableBlackAjahBoss'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     GibForSureFinalHealth=-80.000000
     GibSometimesFinalHealth=-60.000000
     GoalSuggestedSpeeds(0)=625.000000
     GoalSuggestedSpeeds(2)=625.000000
     GoalSuggestedSpeeds(3)=625.000000
     GoalSuggestedSpeeds(4)=625.000000
     GoalSuggestedSpeeds(5)=625.000000
     GoalSuggestedSpeeds(6)=156.250000
     bIsFemale=True
     GroundSpeed=625.000000
     Health=250
     DrawScale=0.760000
}
