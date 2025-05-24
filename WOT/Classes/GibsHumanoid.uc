//------------------------------------------------------------------------------
// GibsHumanoid.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
class GibsHumanoid expands Gibs;

// Textures
#exec TEXTURE IMPORT FILE=MODELS\Gibs\ArmLegFlesh.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull01.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull02.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull03.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull04.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull05.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull06.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\Skull07.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\SkullBlood.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\Gibs\SkullBloodBlack.PCX GROUP=Skins FLAGS=2

// Arm
#exec MESH IMPORT MESH=Arm ANIVFILE=MODELS\Gibs\GibFleshArm_a.3d DATAFILE=MODELS\Gibs\GibFleshArm_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Arm X=0 Y=0 Z=0 Pitch=64 Yaw=-15 Roll=0
#exec MESH SEQUENCE MESH=Arm SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Arm MESH=Arm
#exec MESHMAP SCALE MESHMAP=Arm X=0.10 Y=0.10 Z=0.20
#exec MESHMAP SETTEXTURE MESHMAP=Arm NUM=0 TEXTURE=ArmLegFlesh

// Leg
#exec MESH IMPORT MESH=Leg ANIVFILE=MODELS\Gibs\GibFleshLeg_a.3d DATAFILE=MODELS\Gibs\GibFleshLeg_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Leg X= Y=0 Z=0 Pitch=64 Yaw=0 Roll=0
#exec MESH SEQUENCE MESH=Leg SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Leg MESH=Leg
#exec MESHMAP SCALE MESHMAP=Leg X=0.10 Y=0.10 Z=0.20
#exec MESHMAP SETTEXTURE MESHMAP=Leg NUM=0 TEXTURE=ArmLegFlesh

// Leg (bent)
#exec MESH IMPORT MESH=LegBent ANIVFILE=MODELS\Gibs\GibLegBent_a.3d DATAFILE=MODELS\Gibs\GibLegBent_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LegBent X=-50 Y=-15 Z=-40 Pitch=0 Yaw=0 Roll=64
#exec MESH SEQUENCE MESH=LegBent SEQ=All      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=LegBent MESH=LegBent
#exec MESHMAP SCALE MESHMAP=LegBent X=0.10 Y=0.10 Z=0.20
#exec MESHMAP SETTEXTURE MESHMAP=LegBent NUM=0 TEXTURE=ArmLegFlesh

// Skull
#exec MESH IMPORT MESH=Skull ANIVFILE=MODELS\Gibs\Skull_a.3d DATAFILE=MODELS\Gibs\Skull_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Skull X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=Skull SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Skull MESH=Skull
#exec MESHMAP SCALE MESHMAP=Skull X=0.025 Y=0.025 Z=0.05
#exec MESHMAP SETTEXTURE MESHMAP=Skull NUM=0 TEXTURE=Skull03

defaultproperties
{
     Fragments(5)=Mesh'WOT.Arm'
     Fragments(6)=Mesh'WOT.Leg'
     Fragments(7)=Mesh'WOT.Skull'
     numFragmentTypes=8
}
