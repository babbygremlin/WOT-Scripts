//=============================================================================
// WaterZone.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class WaterZone expands WOTZoneInfo;

/*SBB replace with water sounds from Eric
#exec AUDIO IMPORT FILE="Sounds\Generic\WaterEntrySound.wav"
#exec AUDIO IMPORT FILE="Sounds\Generic\WaterExitSound.wav"
*/

defaultproperties
{
     bLeechZone=True
     LeechClasses(0)=Class'WOT.WaterFOVLeech'
     EntryActor=Class'WOT.WaterImpact'
     ExitActor=Class'WOT.WaterImpact'
     bWaterZone=True
     ViewFlash=(X=-0.078000,Y=-0.078000,Z=-0.078000)
     ViewFog=(X=0.128900,Y=0.195300,Z=0.175780)
}
