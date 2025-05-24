//------------------------------------------------------------------------------
// AngrealInvSoulBarb.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	For a short time, target will take damage every time he  uses 
//				a charge -- the rarer an artifact, the more damage he takes.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvSoulBarb expands ProjectileLauncher;

#exec MESH    IMPORT     MESH=AngrealSoulBarbPickup ANIVFILE=MODELS\AngrealSoulBarb_a.3D DATAFILE=MODELS\AngrealSoulBarb_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealSoulBarbPickup X=0 Y=0 Z=0 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealSoulBarbPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealSoulBarbPickupTex FILE=MODELS\AngrealSoulBarb.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealSoulBarbPickup MESH=AngrealSoulBarbPickup
#exec MESHMAP SCALE      MESHMAP=AngrealSoulBarbPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealSoulBarbPickup NUM=4 TEXTURE=AngrealSoulBarbPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_SoulBarb.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_SoulBarb.pcx          GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealSoulBarbProjectile"
     DurationType=DT_Lifespan
     bElementSpirit=True
     bCommon=True
     bOffensive=True
     bCombat=True
     MinInitialCharges=3
     MaxInitialCharges=5
     MaxCharges=10
     Priority=9.000000
     FailMessage="requires a target"
     bTargetsFriendlies=False
     MinChargeGroupInterval=20.000000
     Title="Soul Barb"
     Description="For a short time, Soul Barb's target takes damage whenever he activates an artifact--more powerful artifacts inflict more damage."
     Quote="Agony in his chest, as if his heart was about to explode, in his head, white-hot nails driving into his brain, pain so strong that even in the Void he wanted to scream."
     StatusIconFrame=Texture'Angreal.Icons.M_SoulBarb'
     InventoryGroup=56
     PickupMessage="You got the Soul Barb ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealSoulBarbPickup'
     StatusIcon=Texture'Angreal.Icons.I_SoulBarb'
     Mesh=Mesh'Angreal.AngrealSoulBarbPickup'
}
