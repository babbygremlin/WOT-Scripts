//=============================================================================
// MordethStatue.
//=============================================================================
class MordethStatue expands WOTDecoration;

#exec MESH IMPORT MESH=MordethStatue ANIVFILE=MODELS\MordethStatue_a.3d DATAFILE=MODELS\MordethStatue_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MordethStatue X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MordethStatue SEQ=All           STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JMordethStatue0 FILE=MODELS\MordethStatue0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=MordethStatue MESH=MordethStatue
#exec MESHMAP SCALE MESHMAP=MordethStatue X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MordethStatue NUM=0 TEXTURE=JMordethStatue0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.MordethStatue'
     DrawScale=1.500000
     CollisionRadius=15.000000
     CollisionHeight=47.000000
}
