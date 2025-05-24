//=============================================================================
// Tree.
//=============================================================================
class Tree expands WOTDecoration;

#exec MESH IMPORT MESH=Tree ANIVFILE=MODELS\Tree_a.3d DATAFILE=MODELS\Tree_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Tree X=0 Y=0 Z=0 YAW=64 PITCH=0 ROLL=0

#exec MESH SEQUENCE MESH=Tree SEQ=All  STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JTree0 FILE=MODELS\Tree0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Tree MESH=Tree
#exec MESHMAP SCALE MESHMAP=Tree X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Tree NUM=0 TEXTURE=JTree0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Tree'
     DrawScale=12.000000
     bUnlit=True
     CollisionRadius=48.000000
     CollisionHeight=379.000000
}
