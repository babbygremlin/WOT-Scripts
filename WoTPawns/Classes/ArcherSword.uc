//=============================================================================
// ArcherSword.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class ArcherSword expands SwordBase;

// 3rd person perspective version
#exec MESH IMPORT MESH=MArcherSwordWT ANIVFILE=MODELS\ArcherSword_a.3d DATAFILE=MODELS\ArcherSword_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MArcherSwordWT X=0 Y=0 Z=0 YAW=0 ROLL=-64 PITCH=0

#exec MESH SEQUENCE MESH=MArcherSwordWT SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=MMiscWeapons FILE=MODELS\MiscWeapons.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=MArcherSwordWT MESH=MArcherSwordWT
#exec MESHMAP SCALE MESHMAP=MArcherSwordWT X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MArcherSwordWT NUM=1 TEXTURE=MMiscWeapons
#exec MESHMAP SETTEXTURE MESHMAP=MArcherSwordWT NUM=2 TEXTURE=MMiscWeapons

// used for decorations
#exec MESH IMPORT MESH=MArcherSword ANIVFILE=MODELS\ArcherSword_a.3d DATAFILE=MODELS\ArcherSword_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MArcherSword X=0 Y=0 Z=0 YAW=0 ROLL=-64 PITCH=0

#exec MESH SEQUENCE MESH=MArcherSword SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MArcherSword MESH=MArcherSword
#exec MESHMAP SCALE MESHMAP=MArcherSword X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MArcherSword NUM=1 TEXTURE=MMiscWeapons
#exec MESHMAP SETTEXTURE MESHMAP=MArcherSword NUM=2 TEXTURE=MMiscWeapons

defaultproperties
{
     TypeCapableOfPreparation=Class'WOTPawns.Archer'
     MaxMeleeRange=65.000000
     TossedDecorationTypeString="WOTDecorations.Dec_ArcherSword"
     PlayerViewScale=0.500000
     PickupViewMesh=Mesh'WOTPawns.MArcherSwordWT'
     PickupViewScale=0.500000
     ThirdPersonMesh=Mesh'WOTPawns.MArcherSwordWT'
     ThirdPersonScale=0.500000
     MaxDesireability=0.300000
     Mesh=Mesh'WOTPawns.MArcherSwordWT'
     DrawScale=0.500000
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     MultiSkins(2)=Texture'WOTPawns.Skins.MMiscWeapons'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
