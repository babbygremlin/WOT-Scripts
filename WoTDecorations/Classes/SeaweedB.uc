//=============================================================================
// SeaweedB.
//=============================================================================
class SeaweedB expands SeaweedA;

#exec MESH IMPORT MESH=SeaweedB ANIVFILE=MODELS\SeaweedB_a.3d DATAFILE=MODELS\SeaweedB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SeaweedB X=0 Y=0 Z=60

#exec MESH SEQUENCE MESH=SeaweedB SEQ=All      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=SeaweedB SEQ=SEAWEEDB STARTFRAME=0 NUMFRAMES=40

#exec MESHMAP NEW   MESHMAP=SeaweedB MESH=SeaweedB
#exec MESHMAP SCALE MESHMAP=SeaweedB X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SeaweedB NUM=0 TEXTURE=JSeaweed

defaultproperties
{
     Mesh=Mesh'WOTDecorations.SeaweedB'
     CollisionRadius=12.000000
     CollisionHeight=12.000000
}
