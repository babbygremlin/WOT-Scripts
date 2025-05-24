//=============================================================================
// KeyMedium.
//=============================================================================
class KeyMedium expands Key;

#exec MESH IMPORT MESH=KeyMedium ANIVFILE=MODELS\KeyMedium_a.3d DATAFILE=MODELS\KeyMedium_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=KeyMedium X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=KeyMedium SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\KeyMediumGOLD.PCX GROUP=Keys FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\KeyMediumBRONZE.PCX GROUP=Keys FLAGS=2 // SKIN

#exec TEXTURE IMPORT FILE=Icons\KeyMediumIcon.PCX GROUP=UI MIPS=Off FLAGS=2

#exec MESHMAP NEW   MESHMAP=KeyMedium MESH=KeyMedium
#exec MESHMAP SCALE MESHMAP=KeyMedium X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=KeyMedium NUM=0 TEXTURE=KeyMediumGOLD

defaultproperties
{
     KeyPickupMessage="You found an ornate key"
     PickupViewMesh=Mesh'WOT.KeyMedium'
     StatusIcon=Texture'WOT.UI.KeyMediumIcon'
     Style=STY_Masked
     Mesh=Mesh'WOT.KeyMedium'
}
