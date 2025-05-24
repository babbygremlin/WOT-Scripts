//=============================================================================
// SkullTorchWithout.
//=============================================================================
class SkullTorchWithout expands WOTDecoration;

#exec MESH IMPORT MESH=SkullTorchWithout ANIVFILE=MODELS\SkullTorchWithout_a.3d DATAFILE=MODELS\SkullTorchWithout_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SkullTorchWithout X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SkullTorchWithout SEQ=All               STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=SkullTorchWithout MESH=SkullTorchWithout
#exec MESHMAP SCALE MESHMAP=SkullTorchWithout X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     Texture=Texture'WOTDecorations.Skins.JSkullTorchWith1'
     Mesh=Mesh'WOTDecorations.SkullTorchWithout'
}
