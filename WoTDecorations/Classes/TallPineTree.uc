//=============================================================================
// TallPineTree.
//=============================================================================
class TallPineTree expands WOTDecoration;

#exec MESH IMPORT MESH=TallPineTree ANIVFILE=MODELS\TallPine_a.3d DATAFILE=MODELS\TallPine_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TallPineTree X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TallPineTree SEQ=All          STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JTallPineTree1 FILE=MODELS\TallPine1.PCX GROUP=Skins FLAGS=2 

#exec MESHMAP NEW   MESHMAP=TallPineTree MESH=TallPineTree
#exec MESHMAP SCALE MESHMAP=TallPineTree X=2.0 Y=2.0 Z=4.0

#exec MESHMAP SETTEXTURE MESHMAP=TallPineTree NUM=0 TEXTURE=JTallPineTree1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.TallPineTree'
     bUnlit=True
     CollisionRadius=48.000000
     CollisionHeight=435.000000
}
