//=============================================================================
// InjuredSister.
//=============================================================================
class InjuredSister expands WOTDecoration;

#exec MESH IMPORT MESH=InjuredSister ANIVFILE=MODELS\InjuredSister_a.3d DATAFILE=MODELS\InjuredSister_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=InjuredSister X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=InjuredSister SEQ=All       STARTFRAME=0 NUMFRAMES=53
#exec MESH SEQUENCE MESH=InjuredSister SEQ=AJAHPAIN1 STARTFRAME=0 NUMFRAMES=21
#exec MESH SEQUENCE MESH=InjuredSister SEQ=AJAHPAIN2 STARTFRAME=21 NUMFRAMES=16
#exec MESH SEQUENCE MESH=InjuredSister SEQ=AJAHPAIN3 STARTFRAME=37 NUMFRAMES=16

#exec TEXTURE IMPORT NAME=JSisterGreenP1 FILE=MODELS\SisterGreen_P.PCX GROUP=Skins FLAGS=2 // sis1
#exec TEXTURE IMPORT NAME=JSisterWhiteP1 FILE=MODELS\SisterWhite_P.PCX GROUP=Skins FLAGS=2 // sis1
#exec TEXTURE IMPORT NAME=JSisterYellowP1 FILE=MODELS\SisterYellow_P.PCX GROUP=Skins FLAGS=2 // sis1

#exec MESHMAP NEW   MESHMAP=InjuredSister MESH=InjuredSister
#exec MESHMAP SCALE MESHMAP=InjuredSister X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=InjuredSister NUM=1 TEXTURE=JSisterGreenP1
#exec MESHMAP SETTEXTURE MESHMAP=InjuredSister NUM=2 TEXTURE=JSisterGreenP1

defaultproperties
{
     bStatic=False
     GoreLevel=2
     bStasis=False
     Mesh=LodMesh'WOTPawns.InjuredSister'
     DrawScale=0.480000
     CollisionRadius=17.000000
     CollisionHeight=46.000000
}
