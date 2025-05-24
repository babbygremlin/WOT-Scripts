//=============================================================================
// TrollocMed.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class TrollocMed expands Trolloc;

defaultproperties
{
     BaseWalkingSpeed=97.500000
     RangedWeaponType=Class'WOTPawns.TrollocMedAxeProxy'
     GroundSpeedMin=390.000000
     GroundSpeedMax=390.000000
     HealthMPMin=100.000000
     HealthMPMax=100.000000
     HealthSPMin=100.000000
     HealthSPMax=100.000000
     AnimationTableClass=Class'WOTPawns.AnimationTableTrollocSideArm'
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryTrollocMed'
     GoalSuggestedSpeeds(0)=390.000000
     GoalSuggestedSpeeds(2)=390.000000
     GoalSuggestedSpeeds(3)=390.000000
     GoalSuggestedSpeeds(4)=390.000000
     GoalSuggestedSpeeds(5)=390.000000
     GoalSuggestedSpeeds(6)=97.500000
     DurationNotifierDurations(7)=-1.000000
     GroundSpeed=340.000000
     Health=100
     DrawScale=1.370000
     MultiSkins(1)=Texture'WOTPawns.Skins.TBird'
     CollisionRadius=26.000000
     CollisionHeight=52.000000
     Mass=225.000000
}
