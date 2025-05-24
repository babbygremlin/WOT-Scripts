//=============================================================================
// SeaweedC.
//=============================================================================
class SeaweedC expands SeaweedA;

#exec MESH IMPORT MESH=SeaweedC ANIVFILE=MODELS\SeaweedC_a.3d DATAFILE=MODELS\SeaweedC_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SeaweedC X=0 Y=0 Z=60

#exec MESH SEQUENCE MESH=SeaweedC SEQ=All      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=SeaweedC SEQ=SEAWEEDC STARTFRAME=0 NUMFRAMES=40

#exec MESHMAP NEW   MESHMAP=SeaweedC MESH=SeaweedC
#exec MESHMAP SCALE MESHMAP=SeaweedC X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SeaweedC NUM=0 TEXTURE=JSeaweed

defaultproperties
{
     Mesh=Mesh'WOTDecorations.SeaweedC'
     CollisionRadius=12.000000
     CollisionHeight=12.000000
}
