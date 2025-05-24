//=============================================================================
// Sitter.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

// The champion for the Aes Sedai.

class Sitter expands SisterAssets;

#exec TEXTURE IMPORT NAME=JSitterBrown1 FILE=MODELS\SitterBrown1.PCX GROUP=Skins FLAGS=2 // Ajah1

#exec TEXTURE IMPORT FILE=Icons\Champions\H_SitterDisguise.PCX GROUP=UI MIPS=Off

defaultproperties
{
     MinOffensiveAngrealUsageInterval=3.000000
     MinDefensiveAngrealUsageInterval=2.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvEarthTremor"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvSoulBarb"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvEarthShield"
     AII_AngrealInventoryStr(6)="Angreal.AngrealInvRemoveCurse"
     AII_AngrealInventoryStr(7)="Angreal.AngrealInvFireShield"
     AII_Priority(0)=1.000000
     AII_Priority(1)=8.000000
     AII_Priority(2)=7.000000
     AII_Priority(3)=6.000000
     AII_Priority(4)=9.000000
     AII_Priority(5)=10.000000
     AII_Priority(6)=9.000000
     AII_Priority(7)=8.000000
     AII_MinChargeGroupInterval(1)=15.000000
     AII_MinChargeGroupInterval(6)=10.000000
     BaseWalkingSpeed=125.000000
     DisguiseIcon=Texture'WOTPawns.UI.H_SitterDisguise'
     GroundSpeedMin=500.000000
     GroundSpeedMax=500.000000
     HealthMPMin=425.000000
     HealthMPMax=425.000000
     HealthSPMin=425.000000
     HealthSPMax=425.000000
     TextureHelperClass=Class'WOTPawns.PCFemaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableSitter'
     AnimationTableClass=Class'WOTPawns.AnimationTableSister'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     GoalSuggestedSpeeds(0)=500.000000
     GoalSuggestedSpeeds(2)=500.000000
     GoalSuggestedSpeeds(3)=500.000000
     GoalSuggestedSpeeds(4)=500.000000
     GoalSuggestedSpeeds(5)=500.000000
     GoalSuggestedSpeeds(6)=125.000000
     bIsFemale=True
     GroundSpeed=500.000000
     Health=300
     MultiSkins(1)=Texture'WOTPawns.Skins.JSitterBrown1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JSitterBrown1'
}
