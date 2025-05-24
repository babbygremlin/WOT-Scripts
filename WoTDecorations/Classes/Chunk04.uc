//=============================================================================
// Chunk04.
//=============================================================================
class Chunk04 expands Chunk01;

#exec MESH IMPORT MESH=Chunk04 ANIVFILE=MODELS\Chunk04_a.3d DATAFILE=MODELS\Chunk04_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk04 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk04 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk04 SEQ=CHUNK04 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk04 MESH=Chunk04
#exec MESHMAP SCALE MESHMAP=Chunk04 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk04 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk04'
}
