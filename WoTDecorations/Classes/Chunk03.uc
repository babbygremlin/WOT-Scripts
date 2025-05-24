//=============================================================================
// Chunk03.
//=============================================================================
class Chunk03 expands Chunk01;

#exec MESH IMPORT MESH=Chunk03 ANIVFILE=MODELS\Chunk03_a.3d DATAFILE=MODELS\Chunk03_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk03 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk03 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk03 SEQ=CHUNK03 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chunk03 MESH=Chunk03
#exec MESHMAP SCALE MESHMAP=Chunk03 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk03 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk03'
}
