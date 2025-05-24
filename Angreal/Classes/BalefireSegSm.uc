//=============================================================================
// BalefireSegSm.
//=============================================================================
class BalefireSegSm expands TracerSeg;

#exec MESH IMPORT MESH=BF100 ANIVFILE=MODELS\BF100_a.3d DATAFILE=MODELS\BF100_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BF100 X=-159 Y=0 Z=0

#exec MESH SEQUENCE MESH=BF100 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BF100 SEQ=BF100 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBF1001 FILE=MODELS\Balefire2.PCX GROUP=Skins FLAGS=2 // BFIRE
#exec TEXTURE IMPORT NAME=JBF1002 FILE=MODELS\Balefire3.PCX GROUP=Skins FLAGS=2 // BFIRE

#exec MESHMAP NEW   MESHMAP=BF100 MESH=BF100
#exec MESHMAP SCALE MESHMAP=BF100 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BF100 NUM=0 TEXTURE=JBF1001

defaultproperties
{
     FadedTexture=Texture'Angreal.Skins.JBF1002'
     SegmentLength=64.000000
     FadeTime=0.200000
     FadeInterval=0.150000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Mesh=Mesh'Angreal.BF100'
     DrawScale=2.000000
     bUnlit=True
}
