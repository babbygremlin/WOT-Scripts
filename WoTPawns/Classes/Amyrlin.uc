//=============================================================================
// Amyrlin.
//=============================================================================
class Amyrlin expands WOTDecoration;

#exec MESH IMPORT MESH=Amyrlin ANIVFILE=MODELS\Amyrlin_a.3d DATAFILE=MODELS\Amyrlin_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Amyrlin X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Amyrlin SEQ=All          STARTFRAME=0 NUMFRAMES=79
#exec MESH SEQUENCE MESH=Amyrlin SEQ=BREATH       STARTFRAME=0 NUMFRAMES=8
#exec MESH SEQUENCE MESH=Amyrlin SEQ=GESTURE1     STARTFRAME=8 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Amyrlin SEQ=GESTURE2     STARTFRAME=23 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Amyrlin SEQ=GESTURETALK1 STARTFRAME=38 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Amyrlin SEQ=GESTURETALK2 STARTFRAME=53 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Amyrlin SEQ=TALK1        STARTFRAME=68 NUMFRAMES=11

#exec TEXTURE IMPORT NAME=JAmyrlin1 FILE=MODELS\Amyrlin1.PCX GROUP=Skins FLAGS=2 // Head-Torso

#exec MESHMAP NEW   MESHMAP=Amyrlin MESH=Amyrlin
#exec MESHMAP SCALE MESHMAP=Amyrlin X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Amyrlin NUM=1 TEXTURE=JAmyrlin1
#exec MESHMAP SETTEXTURE MESHMAP=Amyrlin NUM=2 TEXTURE=JAmyrlin1
#exec MESHMAP SETTEXTURE MESHMAP=Amyrlin NUM=3 TEXTURE=JAmyrlin1
#exec MESHMAP SETTEXTURE MESHMAP=Amyrlin NUM=4 TEXTURE=JAmyrlin1
#exec MESHMAP SETTEXTURE MESHMAP=Amyrlin NUM=5 TEXTURE=JAmyrlin1

defaultproperties
{
     bStatic=False
     bStasis=False
     Mesh=Mesh'WOTPawns.Amyrlin'
     DrawScale=0.480000
     CollisionRadius=17.000000
     CollisionHeight=46.000000
}
