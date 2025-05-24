//=============================================================================
// SkullTorchWith.
//=============================================================================
class SkullTorchWith expands WOTDecoration;

#exec MESH IMPORT MESH=SkullTorchWith ANIVFILE=MODELS\SkullTorchWith_a.3d DATAFILE=MODELS\SkullTorchWith_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SkullTorchWith X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SkullTorchWith SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JSkullTorchWith1 FILE=MODELS\SkullTorch1.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=SkullTorchWith MESH=SkullTorchWith
#exec MESHMAP SCALE MESHMAP=SkullTorchWith X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SkullTorchWith NUM=0 TEXTURE=JSkullTorchWith1

defaultproperties
{
     Texture=Texture'WOTDecorations.Skins.JSkullTorchWith1'
     Mesh=Mesh'WOTDecorations.SkullTorchWith'
}
