//=============================================================================
// LineStreakSegmentVert
//=============================================================================
class LineStreakSegmentVert expands TracerSeg;

#exec MESH IMPORT MESH=LSS010V ANIVFILE=MODELS\LSS010_a.3d DATAFILE=MODELS\LSS010_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LSS010V X=-303 Y=0 Z=0 ROLL=60

#exec MESH SEQUENCE MESH=LSS010V SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=LSS010V SEQ=LSS010V STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=LSS010V MESH=LSS010V
#exec MESHMAP SCALE MESHMAP=LSS010V X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     SegmentLength=510.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Skin=Texture'Legend.Skins.JLSSGreen'
     Mesh=Mesh'Legend.LSS010V'
     DrawScale=16.000000
     bUnlit=True
}
