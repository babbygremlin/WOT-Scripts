//=============================================================================
// HangingLightChain.
//=============================================================================
class HangingLightChain expands WOTDecoration;

#exec MESH IMPORT MESH=HangingLightChain ANIVFILE=MODELS\Chain_a.3d DATAFILE=MODELS\Chain_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=HangingLightChain X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=HangingLightChain SEQ=All   STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JHangingLightChain0 FILE=MODELS\HangLite.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=HangingLightChain MESH=Chain
#exec MESHMAP SCALE MESHMAP=HangingLightChain X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=HangingLightChain NUM=0 TEXTURE=JHangingLightChain0

defaultproperties
{
     bStatic=False
     Mesh=Mesh'WOTDecorations.HangingLightChain'
     CollisionRadius=8.000000
     CollisionHeight=18.000000
}
