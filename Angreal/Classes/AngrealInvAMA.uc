//------------------------------------------------------------------------------
// AngrealInvAMA.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	Land-mine type trap.  When triggered, no spells can be cast 
//				within its radius for a time.  Acts like a Remove Curse 
//				centered on the trap.  Creates a temporary stationary force 
//				field.  Anything inside the shield is immune to magic attacks 
//				and effects.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvAMA expands ProjectileLauncher;

#exec MESH IMPORT MESH=AngrealAntiMagicAuraPickup ANIVFILE=models\AngrealAntiMagicAura_a.3D DATAFILE=models\AngrealAntiMagicAura_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealAntiMagicAuraPickup X=0 Y=0 Z=0 //X=0 Y=-50 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=AngrealAntiMagicAuraPickup SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JAngrealAntiMagicAura1 FILE=models\AngrealAntiMagicAura.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=AngrealAntiMagicAuraPickup MESH=AngrealAntiMagicAuraPickup
#exec MESHMAP SCALE MESHMAP=AngrealAntiMagicAuraPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealAntiMagicAuraPickup NUM=1 TEXTURE=JAngrealAntiMagicAura1

#exec TEXTURE IMPORT FILE=Icons\I_AntiMagicAura.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_AntiMagicAura.pcx        GROUP=Icons MIPS=Off

//TBI #exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\DropAM.wav	GROUP=Decay
//TBI #exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\LoopAM.wav	GROUP=Decay
//TBI #exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\EndAM.wav	GROUP=Decay

defaultproperties
{
    ProjectileClassName="Angreal.AngrealAMAProjectile"
    DurationType=1
    bElementFire=True
    bElementWater=True
    bElementAir=True
    bElementEarth=True
    bElementSpirit=True
    bUncommon=True
    bDefensive=True
    MaxInitialCharges=3
    MaxCharges=5
    MinChargeGroupInterval=4.00
    Title="Aura of Unraveling"
    Description="Immediately after the ter’angreal is laid, anyone walking nearby will trigger it.  For a short time, the area surrounding the artifact acts as a dead-zone: artifacts don’t activate, currently active effects disappear, and weaves launched"
    Quote="He reached for saidin -- and found nothing. He had not been shielded; he would have felt it, and known how to work around or break it, given time, if it was not too strong. This was as if he had been severed."
    StatusIconFrame=Texture'Icons.M_AntiMagicAura'
    InventoryGroup=67
    PickupMessage="You got the Aura of Unraveling ter'angreal"
    PickupViewMesh=Mesh'AngrealAntiMagicAuraPickup'
    StatusIcon=Texture'Icons.I_AntiMagicAura'
    Mesh=Mesh'AngrealAntiMagicAuraPickup'
    bMeshCurvy=True
}
