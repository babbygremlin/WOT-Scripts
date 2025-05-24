//=============================================================================
// Moon.
//=============================================================================
class Moon expands WOTDecoration;

#exec MESH IMPORT MESH=Moon ANIVFILE=MODELS\Moon_a.3d DATAFILE=MODELS\Moon_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Moon X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Moon SEQ=All  STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JMoon0 FILE=MODELS\Moon0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Moon MESH=Moon
#exec MESHMAP SCALE MESHMAP=Moon X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Moon NUM=0 TEXTURE=JMoon0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Moon'
}
