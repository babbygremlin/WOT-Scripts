//=============================================================================
// MyrddraalSword.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MyrddraalSword expands SwordBase;

#exec MESH IMPORT MESH=MMyrddraalSword ANIVFILE=MODELS\MyrddraalSword_a.3D DATAFILE=MODELS\MyrddraalSword_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MMyrddraalSword X=0 Y=50 Z=0 YAW=0 ROLL=0 PITCH=0

#exec MESH SEQUENCE MESH=MMyrddraalSword SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MMyrddraalSword MESH=MMyrddraalSword
#exec MESHMAP SCALE MESHMAP=MMyrddraalSword X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     MaxMeleeRange=65.000000
     MeleeEffectiveness=2.000000
     TossedDecorationTypeString="WOTDecorations.Dec_MyrddraalSword"
     PickupViewMesh=Mesh'WOTPawns.MMyrddraalSword'
     ThirdPersonMesh=Mesh'WOTPawns.MMyrddraalSword'
     ThirdPersonScale=0.660000
     Mesh=Mesh'WOTPawns.MMyrddraalSword'
     DrawScale=0.660000
     MultiSkins(1)=Texture'WOTPawns.MMyrddraalWeapons'
     MultiSkins(2)=Texture'WOTPawns.MMyrddraalWeapons'
     CollisionRadius=5.000000
}
