//------------------------------------------------------------------------------
// AngrealInvFireball.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	Fires a fireball projectile.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvFireball expands ProjectileLauncher;

// 3-D object to be picked up
#exec MESH    IMPORT     MESH=AngrealFireballPickup ANIVFILE=MODELS\AngrealFireball_a.3D DATAFILE=MODELS\AngrealFireball_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealFireballPickup X=0 Y=0 Z=0 YAW=64
#exec MESH    SEQUENCE   MESH=AngrealFireballPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealFireballPickupTex FILE=MODELS\AngrealFireball.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealFireballPickup MESH=AngrealFireballPickup
#exec MESHMAP SCALE      MESHMAP=AngrealFireballPickup X=0.02 Y=0.02 Z=0.04
#exec MESHMAP SETTEXTURE MESHMAP=AngrealFireballPickup NUM=2 TEXTURE=AngrealFireballPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Fireball.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Fireball.pcx        GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealFireballProjectile"
     bElementFire=True
     bCommon=True
     bOffensive=True
     bCombat=True
     RoundsPerMinute=90.000000
     MinInitialCharges=10
     MaxInitialCharges=20
     MaxCharges=35
     Priority=9.000000
     MaxChargesInGroup=6
     MinChargesInGroup=3
     MaxChargeUsedInterval=0.670000
     Title="Fireball"
     Description="The Fireball ter'angreal launches a concentrated weave of fire. It explodes upon impact with anything except water, which causes it to fizzle."
     Quote="A head sized fireball flashed down the street toward her. She leaped back just before it exploded against the corner where her own head had been, showering her with stone chips."
     StatusIconFrame=Texture'Angreal.Icons.M_Fireball'
     InventoryGroup=51
     PickupMessage="You got the Fireball ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealFireballPickup'
     StatusIcon=Texture'Angreal.Icons.I_Fireball'
     Mesh=Mesh'Angreal.AngrealFireballPickup'
     DrawScale=1.300000
}
