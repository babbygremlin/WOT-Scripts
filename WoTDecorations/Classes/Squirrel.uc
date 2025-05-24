//=============================================================================
// Squirrel.
//=============================================================================
class Squirrel expands WOTDecoration;

#exec MESH IMPORT MESH=Squirrel ANIVFILE=MODELS\Squirrel_a.3d DATAFILE=MODELS\Squirrel_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Squirrel X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Squirrel SEQ=All       STARTFRAME=0 NUMFRAMES=43
#exec MESH SEQUENCE MESH=Squirrel SEQ=RUN       STARTFRAME=0 NUMFRAMES=11
#exec MESH SEQUENCE MESH=Squirrel SEQ=TAILSWING STARTFRAME=11 NUMFRAMES=17
#exec MESH SEQUENCE MESH=Squirrel SEQ=TAILUP    STARTFRAME=28 NUMFRAMES=15

#exec TEXTURE IMPORT NAME=JSquirrel0 FILE=MODELS\Squirrel0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Squirrel MESH=Squirrel
#exec MESHMAP SCALE MESHMAP=Squirrel X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Squirrel NUM=0 TEXTURE=JSquirrel0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Squirrel'
}
