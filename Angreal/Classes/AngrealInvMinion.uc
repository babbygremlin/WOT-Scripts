//------------------------------------------------------------------------------
// AngrealInvMinion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	Give castor a grunt to place in his/her citadel.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvMinion expands ResourceSpawner;

#exec MESH IMPORT MESH=AngrealMinionPickup ANIVFILE=MODELS\AngrealMinion_a.3D DATAFILE=MODELS\AngrealMinion_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealMinionPickup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=AngrealMinionPickup SEQ=All       STARTFRAME=0   NUMFRAMES=1 //348

#exec TEXTURE IMPORT NAME=JAngrealMinion1 FILE=MODELS\AngrealMinion1.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=AngrealMinionPickup MESH=AngrealMinionPickup
#exec MESHMAP SCALE MESHMAP=AngrealMinionPickup X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AngrealMinionPickup NUM=1 TEXTURE=JAngrealMinion1

#exec TEXTURE IMPORT FILE=ICONS\I_Minion.pcx GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=ICONS\M_Minion.pcx GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Minion\ActivateMN.wav GROUP=Minion

//=============================================================================
function class<WOTPawn> GetResourceClass()
{
	return class'WOTPlayer'.static.GetTroop( Owner, 'Grunt' );
}

defaultproperties
{
    LimitWarning="You already have one Minion under your control."
    TopSparkle=Texture'ParticleSystems.Appear.APinkCorona'
    BottomSparkle=Texture'ParticleSystems.Appear.ABlueCorona'
    bElementSpirit=True
    bRare=True
    MaxCharges=5
    ActivateSoundName="Angreal.ActivateMN"
    MinChargeGroupInterval=10.00
    Title="Minion"
    Description="The Minion ter'angreal summons a @grunt@ or soldier of the type that you command."
    Quote="Trollocs leaped out of thin air, huge bestial shapes and eyelesss faces distorted with a rage to kill, scythe-like swords and blades of deadly black steel seeking his blood"
    StatusIconFrame=Texture'Icons.M_Minion'
    PickupMessage="You got the Minion ter'angreal"
    PickupViewMesh=Mesh'AngrealMinionPickup'
    PickupViewScale=0.80
    StatusIcon=Texture'Icons.I_Minion'
    Mesh=Mesh'AngrealMinionPickup'
    DrawScale=0.80
}
