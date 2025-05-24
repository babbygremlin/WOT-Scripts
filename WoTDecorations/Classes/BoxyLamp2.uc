//=============================================================================
// BoxyLamp2.
//=============================================================================
class BoxyLamp2 expands BoxyLamp;

#exec MESH IMPORT MESH=BoxyLamp2 ANIVFILE=MODELS\BoxyLamp2_a.3d DATAFILE=MODELS\BoxyLamp2_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BoxyLamp2 X=0 Y=0 Z=100

#exec MESH SEQUENCE MESH=BoxyLamp2 SEQ=All       STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BoxyLamp2 SEQ=BoxyLamp2 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=BoxyLamp2 MESH=BoxyLamp2
#exec MESHMAP SCALE MESHMAP=BoxyLamp2 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BoxyLamp2 NUM=1 TEXTURE=JBoxyLamp1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.BoxyLamp2'
}
