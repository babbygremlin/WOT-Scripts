//=============================================================================
// SeaweedA.
//=============================================================================
class SeaweedA expands WOTDecoration;

#exec MESH IMPORT MESH=SeaweedA ANIVFILE=MODELS\SeaweedA_a.3d DATAFILE=MODELS\SeaweedA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SeaweedA X=0 Y=0 Z=75

#exec MESH SEQUENCE MESH=SeaweedA SEQ=All      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=SeaweedA SEQ=SEAWEEDA STARTFRAME=0 NUMFRAMES=40

#exec TEXTURE IMPORT NAME=JSeaweed FILE=MODELS\Seaweed.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=SeaweedA MESH=SeaweedA
#exec MESHMAP SCALE MESHMAP=SeaweedA X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SeaweedA NUM=0 TEXTURE=JSeaweed

defaultproperties
{
     bAutoAnimate=True
     bStatic=False
     bStasis=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     Mesh=Mesh'WOTDecorations.SeaweedA'
     CollisionRadius=15.000000
     CollisionHeight=15.000000
}
