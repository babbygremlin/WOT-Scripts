//------------------------------------------------------------------------------
// AngrealInvAbsorb.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	For a short time, any spell that hits or targets the caster is 
//				absorbed into his inventory.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvAbsorb expands ReflectorInstaller;

#exec MESH    IMPORT     MESH=AngrealAbsorbPickup ANIVFILE=MODELS\AngrealAbsorb_a.3D DATAFILE=MODELS\AngrealAbsorb_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealAbsorbPickup X=0 Y=0 Z=0 YAW=64
#exec MESH    SEQUENCE   MESH=AngrealAbsorbPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealAbsorbPickupTex FILE=MODELS\AngrealAbsorb.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealAbsorbPickup MESH=AngrealAbsorbPickup
#exec MESHMAP SCALE      MESHMAP=AngrealAbsorbPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealAbsorbPickup NUM=3 TEXTURE=AngrealAbsorbPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Absorb.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Absorb.pcx          GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Absorb\ActivateABS.wav		GROUP=Absorb

     //ReflectorClasses(0)=Class'Angreal.IgnoreDamageEffectsReflector'

defaultproperties
{
     Duration=8.000000
     ReflectorClasses(0)=Class'Angreal.AbsorbReflector'
     DurationType=DT_Lifespan
     bElementFire=True
     bElementWater=True
     bElementAir=True
     bElementEarth=True
     bElementSpirit=True
     bRare=True
     bDefensive=True
     bCombat=True
     MaxInitialCharges=2
     MaxCharges=5
     ActivateSoundName="Angreal.ActivateABS"
     MinChargeGroupInterval=7.000000
     Title="Absorb"
     Description="Absorb weaves a shield around you for a short time.  If a weave from another ter'angreal strikes it, the artifact that generated that weave is snatched from the owner's grasp and placed in your inventory."
     Quote="@How did you...?@ Elayne said wonderingly. @The flows just... vanished.@"
     StatusIconFrame=Texture'Angreal.Icons.M_Absorb'
     InventoryGroup=50
     PickupMessage="You got the Absorb ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealAbsorbPickup'
     StatusIcon=Texture'Angreal.Icons.I_Absorb'
     Texture=None
     Mesh=Mesh'Angreal.AngrealAbsorbPickup'
}
