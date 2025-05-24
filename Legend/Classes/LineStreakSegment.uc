//=============================================================================
// LineStreakSegment
//=============================================================================
class LineStreakSegment expands TracerSeg;

#exec MESH IMPORT MESH=LSS010 ANIVFILE=MODELS\LSS010_a.3d DATAFILE=MODELS\LSS010_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSS010 X=-303 Y=0 Z=0

#exec MESH SEQUENCE MESH=LSS010 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=LSS010 SEQ=LSS010 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JLSSWhite FILE=MODELS\LSSWhite.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLSSYellow FILE=MODELS\LSSYellow.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLSSRed FILE=MODELS\LSSRed.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLSSGreen FILE=MODELS\LSSGreen.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLSSBlue FILE=MODELS\LSSBlue.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=LSS010 MESH=LSS010
#exec MESHMAP SCALE MESHMAP=LSS010 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LSS010 NUM=0 TEXTURE=JLSSYellow

defaultproperties
{
     SegmentLength=510.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Mesh=Mesh'Legend.LSS010'
     DrawScale=16.000000
     bUnlit=True
}
