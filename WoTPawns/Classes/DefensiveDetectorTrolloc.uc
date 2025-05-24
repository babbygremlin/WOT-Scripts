//=============================================================================
// DefensiveDetectorTrolloc.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class DefensiveDetectorTrolloc expands DefensiveDetector;

defaultproperties
{
     CollectClass=Class'WOT.WotProjectile'
     bRestrictCollectionToFOV=True
     bActiveDetection=True
     bPassiveDetection=True
     DefensiveResponses(0)=(DR_MinResponseTime=0.050000,DR_MaxResponseTime=1.500000,DR_ResponsePreHint=AttemptDodge)
}
