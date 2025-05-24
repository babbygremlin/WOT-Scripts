//=============================================================================
// DefensiveDetectorQuestioner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class DefensiveDetectorQuestioner expands DefensiveDetector;

defaultproperties
{
     CollectClass=Class'WOT.WotProjectile'
     bRestrictCollectionToFOV=True
     ExplicitClassRejections(1)=Class'WOT.WotWeaponProjectile'
     bActiveDetection=True
     DefensiveResponses(0)=(DR_MinResponseTime=0.050000,DR_MaxResponseTime=1.000000,DR_ResponsePreHint=AttemptDodge)
}
