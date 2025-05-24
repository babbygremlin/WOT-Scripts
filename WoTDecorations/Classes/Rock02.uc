//=============================================================================
// Rock02.
//=============================================================================
class Rock02 expands WOTDecoration;

#exec MESH IMPORT MESH=Rock02 ANIVFILE=MODELS\Rock02_a.3d DATAFILE=MODELS\Rock02_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rock02 X=0 Y=0 Z=0       

#exec MESH SEQUENCE MESH=Rock02 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Rock02 SEQ=Rock02 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRock021 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // SplitRock

#exec MESHMAP NEW   MESHMAP=Rock02 MESH=Rock02
#exec MESHMAP SCALE MESHMAP=Rock02 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Rock02 NUM=1 TEXTURE=JRock021

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Rock02'
}
