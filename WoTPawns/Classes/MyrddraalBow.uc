//=============================================================================
// MyrddraalBow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class MyrddraalBow expands WotWeapon;

// 3rd person perspective version
#exec MESH IMPORT MESH=MMyrddraalBowWT ANIVFILE=MODELS\MyrddraalBow_a.3D DATAFILE=MODELS\MyrddraalBow_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MMyrddraalBowWT X=0 Y=-20 Z=0 YAW=-4 ROLL=128 PITCH=6

#exec MESH SEQUENCE MESH=MMyrddraalBowWT SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MMyrddraalBowWT MESH=MMyrddraalBowWT
#exec MESHMAP SCALE MESHMAP=MMyrddraalBowWT X=0.1 Y=0.1 Z=0.2

// used for decorations
#exec MESH IMPORT MESH=MMyrddraalBow ANIVFILE=MODELS\MyrddraalBow_a.3D DATAFILE=MODELS\MyrddraalBow_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MMyrddraalBow X=0 Y=-20 Z=0 YAW=-9 ROLL=128 PITCH=2

#exec MESH SEQUENCE MESH=MMyrddraalBow SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MMyrddraalBow MESH=MMyrddraalBow
#exec MESHMAP SCALE MESHMAP=MMyrddraalBow X=0.1 Y=0.1 Z=0.2


#exec AUDIO IMPORT FILE=Sounds\Weapon\Crossbow\Crossbow_Tossed1.wav

defaultproperties
{
     TypeCapableOfPreparation=Class'WOTPawns.Myrddraal'
     MinProjectileRange=250.000000
     MaxProjectileRange=10000.000000
     WotWeaponProjectileType=Class'WOTPawns.MyrddraalBolt'
     TossedDecorationTypeString="WOTDecorations.Dec_MyrddraalBow"
     InventoryGroup=2
     PickupViewMesh=Mesh'WOTPawns.MMyrddraalBowWT'
     ThirdPersonMesh=Mesh'WOTPawns.MMyrddraalBowWT'
     bDirectional=True
     Mesh=Mesh'WOTPawns.MMyrddraalBowWT'
     bNoSmooth=False
     MultiSkins(1)=Texture'WOTPawns.MMyrddraalWeapons'
     MultiSkins(2)=Texture'WOTPawns.MMyrddraalWeapons'
     CollisionHeight=5.000000
}
