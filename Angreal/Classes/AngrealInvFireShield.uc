//------------------------------------------------------------------------------
// AngrealInvFireShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvFireShield expands ReflectorInstaller;

#exec TEXTURE IMPORT FILE=MODELS\ElShieldRED.PCX GROUP=Skins FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\I_ElShieldRed.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ElShieldRed.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\FireShield\ActivateFS.wav	GROUP=FireShield

defaultproperties
{
    Duration=20.00
    ReflectorClasses=Class'IgnoreFireElementReflector'
    DurationType=1
    bElementFire=True
    bRare=True
    bDefensive=True
    bCombat=True
    MaxInitialCharges=3
    MaxCharges=10
    ActivateSoundName="Angreal.ActivateFS"
    MaxChargesInGroup=2
    Title="Fire Shield"
    Description="Fire Shield forms a protective barrier that prevents all fire-based weaves or environmental hazards from affecting you."
    Quote="She filled the corridor around his with fire from wall to wall, floor to ceiling fire so hot the stone itself smoked.  Rahvin screamed in the middle of the flame and staggered away from her.  A heartbeat, less, and he stood, inside the flame but surrounded by clear air.  Every scrap of saidar she could channel was going into that inferno, but he held it at bay."
    StatusIconFrame=Texture'Icons.M_ElShieldRed'
    InventoryGroup=64
    PickupMessage="You got the Fire Shield ter'angreal"
    PickupViewMesh=Mesh'AngrealElementalShield'
    PickupViewScale=0.30
    StatusIcon=Texture'Icons.I_ElShieldRed'
    Style=2
    Skin=Texture'Skins.ElShieldRED'
    Mesh=Mesh'AngrealElementalShield'
    DrawScale=0.30
}
