//=============================================================================
// PineTree.
//=============================================================================
class PineTree expands WOTDecoration;

#exec MESH IMPORT MESH=Pine ANIVFILE=MODELS\Pine_a.3d DATAFILE=MODELS\Pine_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Pine X=0 Y=0 Z=0 ROLL=64

#exec MESH SEQUENCE MESH=Pine SEQ=All  STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JPine1 FILE=MODELS\Pine1.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Pine MESH=Pine
#exec MESHMAP SCALE MESHMAP=Pine X=2.0 Y=2.0 Z=4.0

#exec MESHMAP SETTEXTURE MESHMAP=Pine NUM=0 TEXTURE=JPine1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Pine'
     bUnlit=True
     CollisionRadius=192.000000
     CollisionHeight=256.000000
}
