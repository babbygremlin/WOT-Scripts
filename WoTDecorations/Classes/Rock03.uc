//=============================================================================
// Rock03.
//=============================================================================
class Rock03 expands WOTDecoration;

#exec MESH IMPORT MESH=Rock03 ANIVFILE=MODELS\Rock03_a.3d DATAFILE=MODELS\Rock03_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rock03 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Rock03 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Rock03 SEQ=Rock03 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRock031 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // SplitRock

#exec MESHMAP NEW   MESHMAP=Rock03 MESH=Rock03
#exec MESHMAP SCALE MESHMAP=Rock03 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Rock03 NUM=1 TEXTURE=JRock031

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Rock03'
}
