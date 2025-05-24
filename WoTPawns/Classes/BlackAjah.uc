//=============================================================================
// BlackAjah.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class BlackAjah expands Sister;

#exec TEXTURE IMPORT NAME=JBlackAjahBlack1 FILE=MODELS\SisterBlack1.PCX GROUP=Skins FLAGS=2 // Ajah1

defaultproperties
{
     MinOffensiveAngrealUsageInterval=5.000000
     MinDefensiveAngrealUsageInterval=4.000000
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvDecay"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvRemoveCurse"
     AII_Priority(1)=4.000000
     AII_Priority(2)=5.000000
     AII_Priority(3)=6.000000
     AII_Priority(4)=8.000000
     AII_Priority(5)=10.000000
     AII_MinChargesInGroup(2)=5
     AII_MaxChargesInGroup(2)=8
     AII_MinChargeGroupInterval(3)=30.000000
     AII_MinChargeGroupInterval(5)=10.000000
     BaseWalkingSpeed=125.000000
     GroundSpeedMin=500.000000
     GroundSpeedMax=500.000000
     SoundTableClass=Class'WOTPawns.SoundTableBlackAjah'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListBlackAjah'
     GoalSuggestedSpeeds(0)=500.000000
     GoalSuggestedSpeeds(2)=500.000000
     GoalSuggestedSpeeds(3)=500.000000
     GoalSuggestedSpeeds(4)=500.000000
     GoalSuggestedSpeeds(5)=500.000000
     GoalSuggestedSpeeds(6)=125.000000
     GroundSpeed=500.000000
     Health=125
     MultiSkins(1)=Texture'WOTPawns.Skins.JBlackAjahBlack1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JBlackAjahBlack1'
}
