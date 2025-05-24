//=============================================================================
// Firecracker.
//=============================================================================
class Firecracker expands WOTDecoration;

#exec MESH IMPORT MESH=Firecracker ANIVFILE=MODELS\Firecracker_a.3d DATAFILE=MODELS\Firecracker_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Firecracker X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Firecracker SEQ=All         STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\FCnormal.PCX	GROUP=Firecracker FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\FCblue.PCX		GROUP=Firecracker FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\FCgreen.PCX	GROUP=Firecracker FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\FCred.PCX		GROUP=Firecracker FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\FCyellow.PCX	GROUP=Firecracker FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Firecracker MESH=Firecracker
#exec MESHMAP SCALE MESHMAP=Firecracker X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Firecracker NUM=0 TEXTURE=FCnormal

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Firecracker'
}
