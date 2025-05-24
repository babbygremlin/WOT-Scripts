//=============================================================================
// GothicLamp.
//=============================================================================
class GothicLamp expands WOTDecoration;

#exec MESH IMPORT MESH=GothicLamp ANIVFILE=MODELS\GothicLamp_a.3d DATAFILE=MODELS\GothicLamp_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=GothicLamp X=-25 Y=0 Z=-30

#exec MESH SEQUENCE MESH=GothicLamp SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JGothicLamp1 FILE=MODELS\GothicLamp1.PCX GROUP=Skins FLAGS=2 // GOTH

#exec MESHMAP NEW   MESHMAP=GothicLamp MESH=GothicLamp
#exec MESHMAP SCALE MESHMAP=GothicLamp X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=GothicLamp NUM=1 TEXTURE=JGothicLamp1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.GothicLamp'
     CollisionRadius=15.000000
     CollisionHeight=20.000000
}
