//=============================================================================
// Sister.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

// the captain for the Aes Sedai

class Sister expands SisterAssets;

defaultproperties
{
     MinOffensiveAngrealUsageInterval=4.000000
     MinDefensiveAngrealUsageInterval=2.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvShift"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvShield"
     AII_Priority(0)=1.000000
     AII_Priority(1)=9.000000
     AII_Priority(2)=9.000000
     AII_Priority(3)=10.000000
     AII_Priority(4)=9.000000
     AII_MinChargesInGroup(1)=5
     AII_MaxChargesInGroup(1)=8
     BaseWalkingSpeed=110.000000
     GroundSpeedMin=440.000000
     GroundSpeedMax=440.000000
     HealthMPMin=350.000000
     HealthMPMax=350.000000
     HealthSPMin=350.000000
     HealthSPMax=350.000000
     TextureHelperClass=Class'WOTPawns.PCFemaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableSister'
     AnimationTableClass=Class'WOTPawns.AnimationTableSister'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     GoalSuggestedSpeeds(0)=440.000000
     GoalSuggestedSpeeds(2)=440.000000
     GoalSuggestedSpeeds(3)=440.000000
     GoalSuggestedSpeeds(4)=440.000000
     GoalSuggestedSpeeds(5)=440.000000
     GoalSuggestedSpeeds(6)=110.000000
     bIsFemale=True
     GroundSpeed=440.000000
}
