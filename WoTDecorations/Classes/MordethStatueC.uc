//=============================================================================
// MordethStatueC.
//=============================================================================
class MordethStatueC expands MordethStatue;

#exec MESH IMPORT MESH=MordethStatueC ANIVFILE=MODELS\MordethStatueC_a.3d DATAFILE=MODELS\MordethStatueC_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MordethStatueC X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MordethStatueC SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MordethStatueC MESH=MordethStatueC
#exec MESHMAP SCALE MESHMAP=MordethStatueC X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MordethStatueC NUM=0 TEXTURE=JMordethStatue0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.MordethStatueC'
}
