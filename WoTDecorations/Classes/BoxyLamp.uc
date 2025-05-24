//=============================================================================
// BoxyLamp.
//=============================================================================
class BoxyLamp expands WOTDecoration;

#exec MESH IMPORT MESH=BoxyLamp ANIVFILE=MODELS\BoxyLamp_a.3d DATAFILE=MODELS\BoxyLamp_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BoxyLamp X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BoxyLamp SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBoxyLamp0 FILE=MODELS\BoxyLamp0.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=JBoxyLamp1 FILE=MODELS\BoxyLamp1.PCX GROUP=Skins PALETTE=JBoxyLamp1 // BoxLamp

#exec MESHMAP NEW   MESHMAP=BoxyLamp MESH=BoxyLamp
#exec MESHMAP SCALE MESHMAP=BoxyLamp X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BoxyLamp NUM=0 TEXTURE=JBoxyLamp0
#exec MESHMAP SETTEXTURE MESHMAP=BoxyLamp NUM=1 TEXTURE=JBoxyLamp1

defaultproperties
{
     Style=STY_Masked
     Mesh=Mesh'WOTDecorations.BoxyLamp'
}
