//------------------------------------------------------------------------------
// AngrealInvAirShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvAirShield expands ReflectorInstaller;

#exec MESH IMPORT MESH=AngrealElementalShield ANIVFILE=MODELS\AngrealElementalShield_a.3d DATAFILE=MODELS\AngrealElementalShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealElementalShield X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=AngrealElementalShield SEQ=All          STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=AngrealElementalShield MESH=AngrealElementalShield
#exec MESHMAP SCALE MESHMAP=AngrealElementalShield X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT FILE=MODELS\ElShieldWHITE.PCX GROUP=Skins FLAGS=2

#exec TEXTURE IMPORT FILE=Icons\I_ElShieldWhite.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ElShieldWhite.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\AirShield\ActivateAS.wav	GROUP=AirShield

defaultproperties
{
    Duration=20.00
    ReflectorClasses=Class'IgnoreAirElementReflector'
    DurationType=1
    bElementAir=True
    bRare=True
    bDefensive=True
    bCombat=True
    MaxInitialCharges=3
    MaxCharges=10
    ActivateSoundName="Angreal.ActivateAS"
    Title="Air Shield"
    Description="Air Shield forms a protective barrier that prevents all air-based weaves or environmental hazards from affecting you."
    Quote="The air around him suddenly became choking soot, clogging his nostrils, shutting off breath, but he made it fresh air again, a cool mist."
    StatusIconFrame=Texture'Icons.M_ElShieldWhite'
    InventoryGroup=64
    PickupMessage="You got the Air Shield ter'angreal"
    PickupViewMesh=Mesh'AngrealElementalShield'
    PickupViewScale=0.30
    StatusIcon=Texture'Icons.I_ElShieldWhite'
    Style=2
    Skin=Texture'Skins.ElShieldWHITE'
    Mesh=Mesh'AngrealElementalShield'
    DrawScale=0.30
}
