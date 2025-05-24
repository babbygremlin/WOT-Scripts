//=============================================================================
// DefensiveDetectorAngrealUser.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class DefensiveDetectorAngrealUser expands DefensiveDetector;

defaultproperties
{
     CollectClass=Class'WOT.AngrealProjectile'
     bPassiveDetection=True
     DefensivePerimeterRadiusFactor=8.000000
     DefensivePerimeterHeightFactor=3.000000
     DefensiveResponses(0)=(DR_MinResponseTime=0.010000,DR_MaxResponseTime=5.000000)
}
