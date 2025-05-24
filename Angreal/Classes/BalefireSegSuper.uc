//=============================================================================
// BalefireSegSuper.
//=============================================================================
class BalefireSegSuper expands TracerSeg;

#exec MESH IMPORT MESH=BF010 ANIVFILE=MODELS\BF010_a.3d DATAFILE=MODELS\BF010_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BF010 X=-303 Y=0 Z=0

#exec MESH SEQUENCE MESH=BF010 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BF010 SEQ=BF010 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBF0101 FILE=MODELS\Balefire2.PCX GROUP=Skins FLAGS=2 // BFIRE

#exec MESHMAP NEW   MESHMAP=BF010 MESH=BF010
#exec MESHMAP SCALE MESHMAP=BF010 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BF010 NUM=0 TEXTURE=JBF0101

defaultproperties
{
     SegmentType=Class'Angreal.BalefireSegLg'
     SegmentLength=512.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Mesh=Mesh'Angreal.BF010'
     DrawScale=16.000000
     bUnlit=True
}
