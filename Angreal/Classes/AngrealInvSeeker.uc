//------------------------------------------------------------------------------
// AngrealInvSeeker.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	If fired at a target, it will seek that target and explode on 
//				impact.  If fired without a target, it will travel straight 
//				ahead and explode when it hits anything.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvSeeker expands ProjectileLauncher;

#exec MESH    IMPORT     MESH=AngrealSeekerPickup ANIVFILE=MODELS\AngrealSeeker_a.3D DATAFILE=MODELS\AngrealSeeker_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealSeekerPickup X=0 Y=0 Z=0 YAW=64
#exec MESH    SEQUENCE   MESH=AngrealSeekerPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealSeekerPickupTex FILE=MODELS\AngrealSeeker.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealSeekerPickup MESH=AngrealSeekerPickup
#exec MESHMAP SCALE      MESHMAP=AngrealSeekerPickup X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=AngrealSeekerPickup NUM=1 TEXTURE=AngrealSeekerPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Seeker.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Seeker.pcx          GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealSeekerProjectile"
     bElementFire=True
     bElementAir=True
     bUncommon=True
     bOffensive=True
     bCombat=True
     MinInitialCharges=3
     MaxInitialCharges=10
     MaxCharges=20
     Priority=2.000000
     FailMessage="requires a target"
     bTargetsFriendlies=False
     MaxChargesInGroup=3
     MinChargeGroupInterval=5.000000
     Title="Seeker"
     Description="Seeker launches an explosive projectile at a target, gathering speed as it hunts the target down.  Unless countered, Seeker explodes upon impact."
     Quote="He had made a weapon that searched Shadow Spawned through the Stone of Tear, struck them dead with a hunting lightening wherever they stood or ran or hid."
     StatusIconFrame=Texture'Angreal.Icons.M_Seeker'
     InventoryGroup=52
     PickupMessage="You got the Seeker ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealSeekerPickup'
     StatusIcon=Texture'Angreal.Icons.I_Seeker'
     Texture=None
     Mesh=Mesh'Angreal.AngrealSeekerPickup'
}
