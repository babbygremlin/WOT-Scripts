//=============================================================================
// ETInner.
//=============================================================================
class ETInner expands EarthTremorRock;

#exec MESH IMPORT MESH=ETinner ANIVFILE=MODELS\ETinner_a.3d DATAFILE=MODELS\ETinner_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ETinner X=0 Y=0 Z=28

#exec MESH SEQUENCE MESH=ETinner SEQ=All     STARTFRAME=0 NUMFRAMES=37
#exec MESH SEQUENCE MESH=ETinner SEQ=ETINNER STARTFRAME=0 NUMFRAMES=37

#exec TEXTURE IMPORT NAME=EarthTremor FILE=MODELS\EarthTremor.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=ETinner MESH=ETinner
#exec MESHMAP SCALE MESHMAP=ETinner X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=ETinner NUM=0 TEXTURE=EarthTremor

defaultproperties
{
    Mesh=Mesh'ETInner'
    DrawScale=3.00
}
