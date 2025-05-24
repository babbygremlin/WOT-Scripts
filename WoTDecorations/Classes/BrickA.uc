//=============================================================================
// BrickA.
//=============================================================================
class BrickA expands BounceableDecoration;

#exec MESH IMPORT MESH=BrickA ANIVFILE=MODELS\BrickA_a.3d DATAFILE=MODELS\BrickA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BrickA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BrickA SEQ=All    STARTFRAME=0 NUMFRAMES=1

// Alternate skins.
#exec TEXTURE IMPORT FILE=MODELS\GREYBLUEBrick.pcx	GROUP=Bricks FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\GREYBrick.pcx		GROUP=Bricks FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\GREYBROWNBrick.pcx	GROUP=Bricks FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\GREYREDBrick.pcx	GROUP=Bricks FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\BROWNBrick.pcx		GROUP=Bricks FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\REDBrick.pcx		GROUP=Bricks FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=BrickA MESH=BrickA
#exec MESHMAP SCALE MESHMAP=BrickA X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BrickA NUM=0 TEXTURE=GREYBrick

#exec AUDIO IMPORT FILE="Sounds\Chunk1.wav" NAME="Chunk1" // GROUP="General"

defaultproperties
{
     LandSound1=Sound'WOTDecorations.Chunk1'
     Mesh=Mesh'WOTDecorations.BrickA'
     CollisionHeight=8.000000
}
