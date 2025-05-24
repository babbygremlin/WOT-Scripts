//=============================================================================
// InjuredWarder.
//=============================================================================
class InjuredWarder expands WOTDecoration;

#exec MESH IMPORT MESH=InjuredWarder ANIVFILE=MODELS\InjuredWarder_a.3d DATAFILE=MODELS\InjuredWarder_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=InjuredWarder X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=InjuredWarder SEQ=All       STARTFRAME=0 NUMFRAMES=48
#exec MESH SEQUENCE MESH=InjuredWarder SEQ=WARDPAIN1 STARTFRAME=0 NUMFRAMES=19
#exec MESH SEQUENCE MESH=InjuredWarder SEQ=WARDPAIN2 STARTFRAME=19 NUMFRAMES=15
#exec MESH SEQUENCE MESH=InjuredWarder SEQ=WARDPAIN3 STARTFRAME=34 NUMFRAMES=14

#exec TEXTURE IMPORT NAME=JWarderP1 FILE=MODELS\Warder_P.PCX GROUP=Skins FLAGS=2 // Warder1

#exec MESHMAP NEW   MESHMAP=InjuredWarder MESH=InjuredWarder
#exec MESHMAP SCALE MESHMAP=InjuredWarder X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=InjuredWarder NUM=1 TEXTURE=JWarderP1
#exec MESHMAP SETTEXTURE MESHMAP=InjuredWarder NUM=2 TEXTURE=JWarderP1
#exec MESHMAP SETTEXTURE MESHMAP=InjuredWarder NUM=4 TEXTURE=JWarderP1

defaultproperties
{
     bStatic=False
     GoreLevel=2
     bStasis=False
     Mesh=LodMesh'WOTPawns.InjuredWarder'
     DrawScale=0.480000
     CollisionRadius=17.000000
     CollisionHeight=46.000000
}
