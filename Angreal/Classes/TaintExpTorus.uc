//=============================================================================
// TaintExpTorus.
//=============================================================================
class TaintExpTorus expands TaintExpAssets;

#exec MESH IMPORT MESH=TaintExpTorus ANIVFILE=MODELS\TaintExpTorus_a.3d DATAFILE=MODELS\TaintExpTorus_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TaintExpTorus X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TaintExpTorus SEQ=All           STARTFRAME=0 NUMFRAMES=15

#exec MESHMAP NEW   MESHMAP=TaintExpTorus MESH=TaintExpTorus
#exec MESHMAP SCALE MESHMAP=TaintExpTorus X=0.1 Y=0.1 Z=0.2

defaultproperties
{
    NumAnimFrames=15
    DrawType=2
    Style=3
    Texture=IceTexture'Taint.RedIce'
    Mesh=Mesh'TaintExpTorus'
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightRadius=10
}
