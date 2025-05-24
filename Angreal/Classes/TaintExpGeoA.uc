//=============================================================================
// TaintExpGeoA.
//=============================================================================
class TaintExpGeoA expands TaintExpAssets;

#exec MESH IMPORT MESH=TaintExpGeoA ANIVFILE=MODELS\TaintExpGeoA_a.3d DATAFILE=MODELS\TaintExpGeoA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TaintExpGeoA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TaintExpGeoA SEQ=All          STARTFRAME=0 NUMFRAMES=13

#exec MESHMAP NEW   MESHMAP=TaintExpGeoA MESH=TaintExpGeoA
#exec MESHMAP SCALE MESHMAP=TaintExpGeoA X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     NumAnimFrames=13
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=IceTexture'Angreal.Taint.RedIce'
     Mesh=Mesh'Angreal.TaintExpGeoA'
}
