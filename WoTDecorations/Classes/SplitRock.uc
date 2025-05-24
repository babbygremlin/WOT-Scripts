//=============================================================================
// SplitRock.
//=============================================================================
class SplitRock expands WOTDecoration;

#exec MESH IMPORT MESH=SplitRock ANIVFILE=MODELS\SplitRock_a.3d DATAFILE=MODELS\SplitRock_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=SplitRock X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=SplitRock SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JSplitRock1 FILE=MODELS\rock011.pcx GROUP=Skins FLAGS=2 // SplitRock

#exec MESHMAP NEW   MESHMAP=SplitRock MESH=SplitRock
#exec MESHMAP SCALE MESHMAP=SplitRock X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=SplitRock NUM=1 TEXTURE=JSplitRock1

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.SplitRock'
}
