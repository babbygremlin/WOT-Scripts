//=============================================================================
// TaintExpGeoB.
//=============================================================================
class TaintExpGeoB expands TaintExpAssets;

#exec MESH IMPORT MESH=TaintExpGeoB ANIVFILE=MODELS\TaintExpGeoB_a.3d DATAFILE=MODELS\TaintExpGeoB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TaintExpGeoB X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TaintExpGeoB SEQ=All          STARTFRAME=0 NUMFRAMES=13

#exec MESHMAP NEW   MESHMAP=TaintExpGeoB MESH=TaintExpGeoB
#exec MESHMAP SCALE MESHMAP=TaintExpGeoB X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     NumAnimFrames=13
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=IceTexture'Angreal.Taint.YeloIce'
     Mesh=Mesh'Angreal.TaintExpGeoB'
}
