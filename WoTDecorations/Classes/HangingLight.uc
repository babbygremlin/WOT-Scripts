//=============================================================================
// HangingLight.
//=============================================================================
class HangingLight expands WOTDecoration;

#exec MESH IMPORT MESH=HangingLight ANIVFILE=MODELS\HangLite_a.3d DATAFILE=MODELS\HangLite_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=HangingLight X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=HangingLight SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JHangingLight1 FILE=MODELS\HangLite.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=HangingLight MESH=HangingLight
#exec MESHMAP SCALE MESHMAP=HangingLight X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=HangingLight NUM=1 TEXTURE=JHangingLight1

defaultproperties
{
     bStatic=False
     Mesh=Mesh'WOTDecorations.HangingLight'
     CollisionHeight=17.000000
}
