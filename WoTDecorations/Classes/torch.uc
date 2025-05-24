//=============================================================================
// Torch.
//=============================================================================
class Torch expands WOTDecoration;

#exec MESH IMPORT MESH=Torch ANIVFILE=MODELS\Torch_a.3d DATAFILE=MODELS\Torch_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Torch X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=Torch SEQ=All   STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JTorch1 FILE=MODELS\Torch1.PCX GROUP=Skins FLAGS=2 // Torch

#exec MESHMAP NEW   MESHMAP=Torch MESH=Torch
#exec MESHMAP SCALE MESHMAP=Torch X=0.07 Y=0.07 Z=0.14

#exec MESHMAP SETTEXTURE MESHMAP=Torch NUM=1 TEXTURE=JTorch1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.torch'
     CollisionRadius=10.700000
}
