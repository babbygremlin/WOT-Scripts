//=============================================================================
// Chunk01.
//=============================================================================
class Chunk01 expands BounceableDecoration;

#exec MESH IMPORT MESH=Chunk01 ANIVFILE=MODELS\Chunk01_a.3d DATAFILE=MODELS\Chunk01_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Chunk01 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chunk01 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Chunk01 SEQ=CHUNK01 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JChunk0 FILE=MODELS\Chunk0.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=JChunk1 FILE=MODELS\Chunk1.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Chunk01 MESH=Chunk01
#exec MESHMAP SCALE MESHMAP=Chunk01 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Chunk01 NUM=0 TEXTURE=JChunk0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Chunk01'
     Mass=800.000000
}
