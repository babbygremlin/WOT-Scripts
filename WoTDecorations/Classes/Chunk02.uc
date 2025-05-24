//=============================================================================
// Chunk02.
//=============================================================================
class Chunk02 expands Chunk01;

#exec MESH IMPORT MESH=Chunk02 ANIVFILE=MODELS\Chunk02_a.3d DATAFILE=MODELS\Chunk02_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk02 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk02 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk02 SEQ=CHUNK02 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk02 MESH=Chunk02
#exec MESHMAP SCALE MESHMAP=Chunk02 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk02 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk02'
}
