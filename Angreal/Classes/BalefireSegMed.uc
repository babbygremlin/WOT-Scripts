//=============================================================================
// BalefireSegMed.
//=============================================================================
class BalefireSegMed expands TracerSeg;

#exec MESH IMPORT MESH=BF050 ANIVFILE=MODELS\BF050_a.3d DATAFILE=MODELS\BF050_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BF050 X=-239 Y=0 Z=0

#exec MESH SEQUENCE MESH=BF050 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BF050 SEQ=BF050 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBF0501 FILE=MODELS\Balefire2.PCX GROUP=Skins FLAGS=2 // BFIRE

#exec MESHMAP NEW   MESHMAP=BF050 MESH=BF050
#exec MESHMAP SCALE MESHMAP=BF050 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BF050 NUM=0 TEXTURE=JBF0501

defaultproperties
{
    SegmentType=Class'BalefireSegSm'
    SegmentLength=128.00
    DrawType=2
    Style=3
    Texture=None
    Mesh=Mesh'BF050'
    DrawScale=4.00
    bUnlit=True
}
