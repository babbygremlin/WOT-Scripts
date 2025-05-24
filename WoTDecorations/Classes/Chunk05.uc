//=============================================================================
// Chunk05.
//=============================================================================
class Chunk05 expands Chunk01;

#exec MESH IMPORT MESH=Chunk05 ANIVFILE=MODELS\Chunk05_a.3d DATAFILE=MODELS\Chunk05_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk05 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk05 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk05 SEQ=CHUNK05 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk05 MESH=Chunk05
#exec MESHMAP SCALE MESHMAP=Chunk05 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk05 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk05'
}
