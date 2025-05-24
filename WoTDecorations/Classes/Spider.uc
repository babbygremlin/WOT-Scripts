//=============================================================================
// Spider.
//=============================================================================
class Spider expands WOTDecoration;

#exec MESH IMPORT MESH=Spider ANIVFILE=MODELS\Spider_a.3d DATAFILE=MODELS\Spider_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Spider X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Spider SEQ=All    STARTFRAME=0 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Spider SEQ=Spider STARTFRAME=0 NUMFRAMES=20

#exec TEXTURE IMPORT NAME=JSpider1 FILE=MODELS\Spider1.PCX GROUP=Skins FLAGS=2 // Material #16

#exec MESHMAP NEW   MESHMAP=Spider MESH=Spider
#exec MESHMAP SCALE MESHMAP=Spider X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Spider NUM=1 TEXTURE=JSpider1

defaultproperties
{
     bAutoAnimate=True
     bStatic=False
     bStasis=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     Mesh=Mesh'WOTDecorations.Spider'
}
