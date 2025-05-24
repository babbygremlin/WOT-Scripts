//------------------------------------------------------------------------------
// AngrealInvExpWard.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	Drop. The next person who comes close will trigger an explosion.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvExpWard expands ProjectileLauncher;

#exec MESH IMPORT MESH=AngrealLandMinePickup ANIVFILE=models\AngrealLandMine_a.3D DATAFILE=models\AngrealLandMine_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealLandMinePickup X=0 Y=-50 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=AngrealLandMinePickup SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JAngrealLandMine1 FILE=models\AngrealLandMine.PCX GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=AngrealLandMinePickup MESH=AngrealLandMinePickup
#exec MESHMAP SCALE MESHMAP=AngrealLandMinePickup X=0.06 Y=0.06 Z=0.12
#exec MESHMAP SETTEXTURE MESHMAP=AngrealLandMinePickup NUM=4 TEXTURE=JAngrealLandMine1

#exec TEXTURE IMPORT FILE=Icons\I_LandMine.pcx        GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_LandMine.pcx        GROUP=Icons MIPS=Off

defaultproperties
{
    ProjectileClassName="Angreal.AngrealExpWardProjectile"
    bElementFire=True
    bElementEarth=True
    bCommon=True
    bTraps=True
    RoundsPerMinute=240.00
    MinInitialCharges=5
    MaxInitialCharges=10
    MaxCharges=25
    MaxChargesInGroup=5
    MinChargesInGroup=3
    MaxChargeUsedInterval=0.25
    MinChargeGroupInterval=10.00
    Title="Explosive Ward"
    Description="Activating the ter'angreal affixes a Ward upon any surface.  Walking near to the Ward causes it to unravel in an explosion of Earth.  If nothing triggers it, the weave automatically explodes after a while."
    Quote="With a roar the ground in front of him erupted in a narrow fountain of dirt and rocks higher than his head."
    StatusIconFrame=Texture'Icons.M_LandMine'
    InventoryGroup=58
    PickupMessage="You got the Explosive Ward ter'angreal"
    PickupViewMesh=Mesh'AngrealLandMinePickup'
    PickupViewScale=0.50
    StatusIcon=Texture'Icons.I_LandMine'
    Mesh=Mesh'AngrealLandMinePickup'
    DrawScale=0.50
}
