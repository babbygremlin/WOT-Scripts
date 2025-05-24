//=============================================================================
// Rock04.
//=============================================================================
class Rock04 expands WOTDecoration;

#exec MESH IMPORT MESH=Rock04 ANIVFILE=MODELS\Rock04_a.3d DATAFILE=MODELS\Rock04_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rock04 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Rock04 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Rock04 SEQ=Rock04 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRock041 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // SplitRock

#exec MESHMAP NEW   MESHMAP=Rock04 MESH=Rock04
#exec MESHMAP SCALE MESHMAP=Rock04 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Rock04 NUM=1 TEXTURE=JRock041

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Rock04'
}
