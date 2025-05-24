//=============================================================================
// Chunk06.
//=============================================================================
class Chunk06 expands Chunk01;

#exec MESH IMPORT MESH=Chunk06 ANIVFILE=MODELS\Chunk06_a.3d DATAFILE=MODELS\Chunk06_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk06 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk06 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk06 SEQ=CHUNK06 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk06 MESH=Chunk06
#exec MESHMAP SCALE MESHMAP=Chunk06 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk06 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk06'
}
