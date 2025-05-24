//------------------------------------------------------------------------------
// AngrealInvSpiritShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvSpiritShield expands ReflectorInstaller;

#exec TEXTURE IMPORT FILE=MODELS\ElShieldGOLD.PCX GROUP=Skins FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\I_ElShieldGold.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ElShieldGold.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\SpiritShield\ActivateSS.wav	GROUP=SpiritShield

defaultproperties
{
     Duration=20.000000
     ReflectorClasses(0)=Class'Angreal.IgnoreSpiritElementReflector'
     DurationType=DT_Lifespan
     bElementSpirit=True
     bRare=True
     bDefensive=True
     bCombat=True
     MaxInitialCharges=3
     MaxCharges=10
     ActivateSoundName="Angreal.ActivateSS"
     Title="Spirit Shield"
     Description="Spirit Shield forms a protective barrier that prevents all spirit-based weaves or environmental hazards from affecting you."
     Quote="With all her strength Nynaeve wove a shield of Spirit and hurled it between the other woman and saidar. Tried to hurl it between; it was like chopping at a tree with a paper hatchet."
     StatusIconFrame=Texture'Angreal.Icons.M_ElShieldGold'
     InventoryGroup=64
     PickupMessage="You got the Spirit Shield ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealElementalShield'
     PickupViewScale=0.300000
     StatusIcon=Texture'Angreal.Icons.I_ElShieldGold'
     Style=STY_Masked
     Skin=Texture'Angreal.Skins.ElShieldGOLD'
     Mesh=Mesh'Angreal.AngrealElementalShield'
     DrawScale=0.300000
}
