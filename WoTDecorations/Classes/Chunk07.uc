//=============================================================================
// Chunk07.
//=============================================================================
class Chunk07 expands Chunk01;

#exec MESH IMPORT MESH=Chunk07 ANIVFILE=MODELS\Chunk07_a.3d DATAFILE=MODELS\Chunk07_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk07 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk07 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk07 SEQ=CHUNK07 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk07 MESH=Chunk07
#exec MESHMAP SCALE MESHMAP=Chunk07 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk07 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk07'
}
