//=============================================================================
// DefensiveDetectorMinion.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class DefensiveDetectorMinion expands DefensiveDetector;

defaultproperties
{
     CollectClass=Class'WOT.WotProjectile'
     bRestrictCollectionToFOV=True
     bActiveDetection=True
     bPassiveDetection=True
     DefensivePerimeterRadiusFactor=8.000000
     DefensivePerimeterHeightFactor=3.000000
     DefensiveResponses(0)=(DR_MinResponseTime=0.010000,DR_MaxResponseTime=1.500000,DR_ResponsePreHint=AttemptDodge)
}
