//------------------------------------------------------------------------------
// AngrealInvEarthShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvEarthShield expands ReflectorInstaller;

#exec TEXTURE IMPORT FILE=MODELS\ElShieldGREEN.PCX GROUP=Skins FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\I_ElShieldGreen.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ElShieldGreen.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\EarthShield\ActivateES.wav	GROUP=EarthShield

defaultproperties
{
     Duration=20.000000
     ReflectorClasses(0)=Class'Angreal.IgnoreEarthElementReflector'
     DurationType=DT_Lifespan
     bElementEarth=True
     bRare=True
     bDefensive=True
     bCombat=True
     MaxInitialCharges=3
     MaxCharges=10
     ActivateSoundName="Angreal.ActivateES"
     Title="Earth Shield"
     Description="Earth Shield forms a protective barrier that prevents all earth-based weaves or environmental hazards from affecting you."
     Quote="He did not seem to feel the thrashing of the ground that had him now at one angle, now at another.  His balance never shifted, no matter how he was tossed."
     StatusIconFrame=Texture'Angreal.Icons.M_ElShieldGreen'
     InventoryGroup=64
     PickupMessage="You got the Earth Shield ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealElementalShield'
     PickupViewScale=0.300000
     StatusIcon=Texture'Angreal.Icons.I_ElShieldGreen'
     Style=STY_Masked
     Skin=Texture'Angreal.Skins.ElShieldGREEN'
     Mesh=Mesh'Angreal.AngrealElementalShield'
     DrawScale=0.300000
}
