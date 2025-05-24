//=============================================================================
// OpenBookA.
//=============================================================================
class OpenBookA expands BounceableDecoration;

#exec MESH IMPORT MESH=OpenBookA ANIVFILE=MODELS\OpenBookA_a.3d DATAFILE=MODELS\OpenBookA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=OpenBookA X=0 Y=0 Z=0 Pitch=64 Yaw=0 Roll=0

#exec MESH SEQUENCE MESH=OpenBookA SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JOpenBookA0 FILE=MODELS\OpenBookA0.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JOpenBookA1 FILE=MODELS\OpenBookA1.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=OpenBookA MESH=OpenBookA
#exec MESHMAP SCALE MESHMAP=OpenBookA X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=OpenBookA NUM=0 TEXTURE=JOpenBookA0
#exec MESHMAP SETTEXTURE MESHMAP=OpenBookA NUM=1 TEXTURE=JOpenBookA1

#exec AUDIO IMPORT FILE="Sounds\Book5.wav" NAME="Book5" // GROUP="General"

defaultproperties
{
     LandSound1=Sound'WOTDecorations.Book5'
     Mesh=Mesh'WOTDecorations.OpenBookA'
     CollisionRadius=10.000000
     Mass=10.000000
     Buoyancy=9.000000
}
