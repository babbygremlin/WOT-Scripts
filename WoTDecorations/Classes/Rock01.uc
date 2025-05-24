//=============================================================================
// Rock01.
//=============================================================================
class Rock01 expands WOTDecoration;

#exec MESH IMPORT MESH=Rock01 ANIVFILE=MODELS\Rock01_a.3d DATAFILE=MODELS\Rock01_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rock01 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Rock01 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Rock01 SEQ=Rock01 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRock011 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=Rock01 MESH=Rock01
#exec MESHMAP SCALE MESHMAP=Rock01 X=0.3 Y=0.3 Z=0.6

#exec MESHMAP SETTEXTURE MESHMAP=Rock01 NUM=1 TEXTURE=JRock011

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Rock01'
     bUnlit=True
     CollisionRadius=48.000000
     CollisionHeight=28.000000
}
