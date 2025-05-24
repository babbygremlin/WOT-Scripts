//=============================================================================
// BalefireSegLg.
//=============================================================================
class BalefireSegLg expands TracerSeg;

#exec MESH IMPORT MESH=BF025 ANIVFILE=MODELS\BF025_a.3d DATAFILE=MODELS\BF025_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BF025 X=-279 Y=0 Z=0

#exec MESH SEQUENCE MESH=BF025 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BF025 SEQ=BF025 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBF0251 FILE=MODELS\Balefire2.PCX GROUP=Skins FLAGS=2 // BFIRE

#exec MESHMAP NEW   MESHMAP=BF025 MESH=BF025
#exec MESHMAP SCALE MESHMAP=BF025 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BF025 NUM=0 TEXTURE=JBF0251

defaultproperties
{
    SegmentType=Class'BalefireSegMed'
    SegmentLength=256.00
    DrawType=2
    Style=3
    Texture=None
    Mesh=Mesh'BF025'
    DrawScale=8.00
    bUnlit=True
}
