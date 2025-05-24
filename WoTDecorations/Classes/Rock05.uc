//=============================================================================
// Rock05.
//=============================================================================
class Rock05 expands WOTDecoration;

#exec MESH IMPORT MESH=Rock05 ANIVFILE=MODELS\Rock05_a.3d DATAFILE=MODELS\Rock05_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rock05 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Rock05 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Rock05 SEQ=Rock05 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRock051 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // SplitRock

#exec MESHMAP NEW   MESHMAP=Rock05 MESH=Rock05
#exec MESHMAP SCALE MESHMAP=Rock05 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Rock05 NUM=1 TEXTURE=JRock051

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Rock05'
}
