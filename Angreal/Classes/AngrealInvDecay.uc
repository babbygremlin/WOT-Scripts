//------------------------------------------------------------------------------
// AngrealInvDecay.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	The target becomes permanently cursed; all of his numbers start
//				to decrease, including health, armor, and artifact charges.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvDecay expands ProjectileLauncher;

// temporarily uses Taint model for pickup

#exec MESH    IMPORT     MESH=AngrealDecayPickup ANIVFILE=MODELS\AngrealDecay_a.3D DATAFILE=MODELS\AngrealDecay_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealDecayPickup X=0 Y=0 Z=0 PITCH=-64
#exec MESH    SEQUENCE   MESH=AngrealDecayPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealDecayPickupTex FILE=MODELS\AngrealDecay.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealDecayPickup MESH=AngrealDecayPickup
#exec MESHMAP SCALE      MESHMAP=AngrealDecayPickup X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=AngrealDecayPickup NUM=1 TEXTURE=AngrealDecayPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Decay.pcx				GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Decay.pcx				GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Decay\LaunchDC.wav	GROUP=Decay //TBI
#exec AUDIO IMPORT FILE=Sounds\Decay\LoopDC.wav		GROUP=Decay //TBI
#exec AUDIO IMPORT FILE=Sounds\Decay\HitDC.wav		GROUP=Decay //TBI

defaultproperties
{
    ProjectileClassName="Angreal.AngrealDecayProjectile"
    DurationType=1
    bElementWater=True
    bElementSpirit=True
    bRare=True
    bOffensive=True
    bCombat=True
    RoundsPerMinute=30.00
    MinInitialCharges=3
    MaxInitialCharges=5
    MaxCharges=10
    Priority=3.00
    FailMessage="requires a target"
    bTargetsFriendlies=False
    MaxChargeUsedInterval=2.00
    MinChargeGroupInterval=4.00
    Title="Decay"
    Description="For a short while, Decay slowly drains away both the target's health and the charges of all held artifacts."
    Quote="They would not die right away; they might even live to make it beyond the city walls.  Long enough for the dead to be far off, not here to frighten the next Myrddraal that came."
    StatusIconFrame=Texture'Icons.M_Decay'
    InventoryGroup=57
    PickupMessage="You got the Decay ter'angreal"
    PickupViewMesh=Mesh'AngrealDecayPickup'
    StatusIcon=Texture'Icons.I_Decay'
    Texture=None
    Mesh=Mesh'AngrealDecayPickup'
    DrawScale=0.75
}
