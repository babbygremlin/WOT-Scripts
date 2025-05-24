//=============================================================================
// LSwingsB.
//=============================================================================
class LSwingsB expands LSwingsA;

#exec MESH IMPORT MESH=LSwingsB ANIVFILE=MODELS\LSwingsB_a.3d DATAFILE=MODELS\LSwingsB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSwingsB X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LSwingsB SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=LSwingsB MESH=LSwingsB
#exec MESHMAP SCALE MESHMAP=LSwingsB X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LSwingsB NUM=0 TEXTURE=LSwings06

defaultproperties
{
     Mesh=Mesh'Angreal.LSwingsB'
}
