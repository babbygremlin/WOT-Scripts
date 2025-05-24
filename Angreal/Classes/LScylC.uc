//=============================================================================
// LScylC.
//=============================================================================
class LScylC expands LScylA;

#exec MESH IMPORT MESH=LScylC ANIVFILE=MODELS\LScylC_a.3d DATAFILE=MODELS\LScylC_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LScylC X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LScylC SEQ=All    STARTFRAME=0 NUMFRAMES=20
#exec MESH SEQUENCE MESH=LScylC SEQ=LSCYLC STARTFRAME=0 NUMFRAMES=20

#exec MESHMAP NEW   MESHMAP=LScylC MESH=LScylC
#exec MESHMAP SCALE MESHMAP=LScylC X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LScylC NUM=0 TEXTURE=LScyl_A01

defaultproperties
{
    Mesh=Mesh'LScylC'
}
