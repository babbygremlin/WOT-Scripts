//------------------------------------------------------------------------------
// AngrealInvEarthTremor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	Causes the earth to shake within a certain radius. Anyone on 
//				the ground within that radius takes damage and gets pushed back.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvEarthTremor expands ProjectileLauncher;

// 3-D object to be picked up
#exec MESH    IMPORT     MESH=AngrealEarthTremorPickup ANIVFILE=MODELS\AngrealEarthTremor_a.3D DATAFILE=MODELS\AngrealEarthTremor_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealEarthTremorPickup X=0 Y=0 Z=0 YAW=64
#exec MESH    SEQUENCE   MESH=AngrealEarthTremorPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealEarthTremorPickupTex FILE=MODELS\AngrealEarthTremor.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealEarthTremorPickup MESH=AngrealEarthTremorPickup
#exec MESHMAP SCALE      MESHMAP=AngrealEarthTremorPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealEarthTremorPickup NUM=5 TEXTURE=AngrealEarthTremorPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_EarthTremor.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_EarthTremor.pcx          GROUP=Icons MIPS=Off

defaultproperties
{
     ProjectileClassName="Angreal.AngrealEarthTremorProjectile"
     bElementEarth=True
     bUncommon=True
     bOffensive=True
     bCombat=True
     RoundsPerMinute=90.000000
     MinInitialCharges=3
     MaxInitialCharges=5
     MaxCharges=10
     Priority=7.000000
     MaxChargeUsedInterval=0.670000
     MinChargeGroupInterval=4.000000
     Title="Earth Tremor"
     Description="The Earth Tremor ter'angreal launches a concentrated weave of earth power. Any surface it touches erupts in a violent tremor, extremely dangerous to anyone caught within."
     Quote="Now the ground rippled, lapping toward the Trollocs like ripples in a pond, ripples that grew as they ran, growing, becoming waves of earth, rolling toward the Trollocs.  On the far slope Trollocs fell in heaps, tumbled over and over by the raging earth."
     StatusIconFrame=Texture'Angreal.Icons.M_EarthTremor'
     InventoryGroup=60
     PickupMessage="You got the Earth Tremor ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealEarthTremorPickup'
     StatusIcon=Texture'Angreal.Icons.I_EarthTremor'
     Mesh=Mesh'Angreal.AngrealEarthTremorPickup'
}
