//=============================================================================
// LScylB.
//=============================================================================
class LScylB expands LScylA;

#exec MESH IMPORT MESH=LScylB ANIVFILE=MODELS\LScylB_a.3d DATAFILE=MODELS\LScylB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LScylB X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LScylB SEQ=All    STARTFRAME=0 NUMFRAMES=20
#exec MESH SEQUENCE MESH=LScylB SEQ=LSCYLB STARTFRAME=0 NUMFRAMES=20

#exec MESHMAP NEW   MESHMAP=LScylB MESH=LScylB
#exec MESHMAP SCALE MESHMAP=LScylB X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LScylB NUM=0 TEXTURE=LScyl_A01

defaultproperties
{
     Mesh=Mesh'Angreal.LScylB'
}
