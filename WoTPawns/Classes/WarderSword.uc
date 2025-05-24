//=============================================================================
// WarderSword.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class WarderSword expands SwordBase;

// 3rd person perspective version
#exec MESH IMPORT MESH=MWarderSwordWT ANIVFILE=MODELS\WarderSword_a.3d DATAFILE=MODELS\WarderSword_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MWarderSwordWT X=0 Y=-20 Z=0 YAW=-10 ROLL=30 PITCH=70

#exec MESH SEQUENCE MESH=MWarderSwordWT SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MWarderSwordWT MESH=MWarderSwordWT
#exec MESHMAP SCALE MESHMAP=MWarderSwordWT X=0.1 Y=0.1 Z=0.2

// used for decorations
#exec MESH IMPORT MESH=MWarderSword ANIVFILE=MODELS\WarderSword_a.3d DATAFILE=MODELS\WarderSword_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MWarderSword X=0 Y=-20 Z=0 YAW=0 ROLL=48 PITCH=64

#exec MESH SEQUENCE MESH=MWarderSword SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MWarderSword MESH=MWarderSword
#exec MESHMAP SCALE MESHMAP=MWarderSword X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     MaxMeleeRange=65.000000
     TossedDecorationTypeString="WOTDecorations.Dec_WarderSword"
     PlayerViewScale=0.500000
     PickupViewMesh=Mesh'WOTPawns.MWarderSwordWT'
     PickupViewScale=0.500000
     ThirdPersonMesh=Mesh'WOTPawns.MWarderSwordWT'
     ThirdPersonScale=0.500000
     Mesh=Mesh'WOTPawns.MWarderSwordWT'
     DrawScale=0.500000
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     MultiSkins(2)=Texture'WOTPawns.Skins.MMiscWeapons'
     CollisionHeight=4.000000
}
