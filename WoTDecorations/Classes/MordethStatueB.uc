//=============================================================================
// MordethStatueB.
//=============================================================================
class MordethStatueB expands MordethStatue;

#exec MESH IMPORT MESH=MordethStatueB ANIVFILE=MODELS\MordethStatueB_a.3d DATAFILE=MODELS\MordethStatueB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MordethStatueB X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MordethStatueB SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MordethStatueB MESH=MordethStatueB
#exec MESHMAP SCALE MESHMAP=MordethStatueB X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MordethStatueB NUM=0 TEXTURE=JMordethStatue0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.MordethStatueB'
}
