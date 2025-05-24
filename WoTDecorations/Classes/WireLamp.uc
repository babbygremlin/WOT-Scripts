//=============================================================================
// WireLamp.
//=============================================================================
class WireLamp expands WOTDecoration;

#exec MESH IMPORT MESH=WireLamp ANIVFILE=MODELS\WireLamp_a.3d DATAFILE=MODELS\WireLamp_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WireLamp X=0 Y=0 Z=0       

#exec MESH SEQUENCE MESH=WireLamp SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JWireLamp1 FILE=MODELS\WireLamp1.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=WireLamp MESH=WireLamp
#exec MESHMAP SCALE MESHMAP=WireLamp X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=WireLamp NUM=1 TEXTURE=JWireLamp1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.WireLamp'
     CollisionHeight=30.000000
}
