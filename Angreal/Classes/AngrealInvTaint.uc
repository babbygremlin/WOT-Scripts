//------------------------------------------------------------------------------
// AngrealInvTaint.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	All artifacts held by the target are permanently tainted-if 
//				they are used, they cause damage--the rarer the artifact, the 
//				more damage.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvTaint expands ProjectileLauncher;

#exec MESH    IMPORT     MESH=AngrealTaintPickup ANIVFILE=MODELS\AngrealTaint_a.3D DATAFILE=MODELS\AngrealTaint_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealTaintPickup X=0 Y=0 Z=0 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealTaintPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealTaintPickupTex FILE=MODELS\AngrealTaint.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealTaintPickup MESH=AngrealTaintPickup
#exec MESHMAP SCALE      MESHMAP=AngrealTaintPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealTaintPickup NUM=4 TEXTURE=AngrealTaintPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Taint.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Taint.pcx          GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealTaintProjectile"
     bElementFire=True
     bElementWater=True
     bElementAir=True
     bElementEarth=True
     bElementSpirit=True
     bRare=True
     bOffensive=True
     bCombat=True
     MaxInitialCharges=2
     MaxCharges=10
     FailMessage="requires a target"
     bTargetsFriendlies=False
     MinChargeGroupInterval=8.000000
     Title="Taint"
     Description="All ter'angreal held by the target are permanently tainted. If the tainted artifacts are used, they cause damage to the user; more powerful artifacts inflict more damage."
     Quote="@It is flawed,@ she replied curtly, @lacking the buffer that makes other sa'angreal safe to use. And it apparently magnifies the taint, inducing wildness of the mind.@"
     StatusIconFrame=Texture'Angreal.Icons.M_Taint'
     InventoryGroup=63
     PickupMessage="You got the Taint ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealTaintPickup'
     StatusIcon=Texture'Angreal.Icons.I_Taint'
     Mesh=Mesh'Angreal.AngrealTaintPickup'
}
