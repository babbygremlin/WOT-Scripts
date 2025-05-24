//------------------------------------------------------------------------------
// AngrealInvWaterShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvWaterShield expands ReflectorInstaller;

#exec TEXTURE IMPORT FILE=MODELS\ElShieldBLUE.PCX GROUP=Skins FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\I_ElShieldBlue.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ElShieldBlue.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\WaterShield\ActivateWS.wav	GROUP=WaterShield

defaultproperties
{
     Duration=20.000000
     ReflectorClasses(0)=Class'Angreal.IgnoreWaterElementReflector'
     DurationType=DT_Shield
     bElementWater=True
     bRare=True
     bDefensive=True
     bCombat=True
     MaxInitialCharges=3
     MaxCharges=10
     ActivateSoundName="Angreal.ActivateWS"
     Title="Water Shield"
     Description="Water Shield forms a protective barrier that prevents all water-based weaves or environmental hazards from affecting you."
     Quote="The water roiled, throwing him about violently. No breath left. He tried to think of air, or the water being air. Suddenly, it was."
     StatusIconFrame=Texture'Angreal.Icons.M_ElShieldBlue'
     InventoryGroup=64
     PickupMessage="You got the Water Shield ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealElementalShield'
     PickupViewScale=0.300000
     StatusIcon=Texture'Angreal.Icons.I_ElShieldBlue'
     Style=STY_Masked
     Skin=Texture'Angreal.Skins.ElShieldBLUE'
     Mesh=Mesh'Angreal.AngrealElementalShield'
     DrawScale=0.300000
}
