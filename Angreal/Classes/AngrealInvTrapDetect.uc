//------------------------------------------------------------------------------
// AngrealInvTrapDetect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	For some time, it causes a sound when the caster gets close to 
//				a trap.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvTrapDetect expands LeechAttacher;

#exec MESH    IMPORT     MESH=AngrealTrapDetectionPickup ANIVFILE=MODELS\AngrealTrapDetection_a.3D DATAFILE=MODELS\AngrealTrapDetection_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealTrapDetectionPickup X=0 Y=0 Z=0
#exec MESH    SEQUENCE   MESH=AngrealTrapDetectionPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealTrapDetectionPickupTex FILE=MODELS\AngrealTrapDetection.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealTrapDetectionPickup MESH=AngrealTrapDetectionPickup
#exec MESHMAP SCALE      MESHMAP=AngrealTrapDetectionPickup X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=AngrealTrapDetectionPickup NUM=1 TEXTURE=AngrealTrapDetectionPickupTex

#exec AUDIO IMPORT FILE=Sounds\TrapDetect\ActivateTD.wav	GROUP=TrapDetect

#exec TEXTURE IMPORT FILE=Icons\I_TrapDetection.pcx   GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_TrapDetection.pcx   GROUP=Icons MIPS=Off

defaultproperties
{
     Duration=15.000000
     LeechClasses(0)=Class'Angreal.TrapDetectLeech'
     DurationType=DT_Lifespan
     bElementWater=True
     bElementAir=True
     bElementEarth=True
     bCommon=True
     bTraps=True
     MinInitialCharges=5
     MaxInitialCharges=15
     MaxCharges=20
     ActivateSoundName="Angreal.ActivateTD"
     MaxChargesInGroup=20
     MinChargesInGroup=10
     MinChargeGroupInterval=6.000000
     Title="Trap Detect"
     Description="For a short time, Trap Detect makes nearby traps extremely obvious, whether the traps are woven from the One Power or conventional.  As you approach a trap, a sound quickens¾but more importantly, any trap directly in your view alights with a visual cue that serves to identify both position and function.  This cue only shows the closest trap; sweeping the area is recommended to discover more."
     Quote="There was something woven into the barrier of shattered columns. He hardened the shield around himself. Great tumbled chunks of red and white stone exploded as he reached to climb, a burst of pure light and flying stone."
     StatusIconFrame=Texture'Angreal.Icons.M_TrapDetection'
     InventoryGroup=55
     PickupMessage="You got the Trap Detect ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealTrapDetectionPickup'
     StatusIcon=Texture'Angreal.Icons.I_TrapDetection'
     Texture=None
     Mesh=Mesh'Angreal.AngrealTrapDetectionPickup'
}
