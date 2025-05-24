//=============================================================================
// KeyShort.
//=============================================================================
class KeyShort expands Key;

#exec MESH IMPORT MESH=KeyShort ANIVFILE=MODELS\KeyShort_a.3d DATAFILE=MODELS\KeyShort_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=KeyShort X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=KeyShort SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\KeyShort.PCX GROUP=Keys FLAGS=2 // SKIN

#exec TEXTURE IMPORT FILE=Icons\KeyShortIcon.PCX GROUP=UI MIPS=Off FLAGS=2

#exec MESHMAP NEW   MESHMAP=KeyShort MESH=KeyShort
#exec MESHMAP SCALE MESHMAP=KeyShort X=0.04 Y=0.04 Z=0.08

#exec MESHMAP SETTEXTURE MESHMAP=KeyShort NUM=0 TEXTURE=KeyShort

defaultproperties
{
     KeyPickupMessage="You found a small key"
     PickupViewMesh=Mesh'WOT.KeyShort'
     StatusIcon=Texture'WOT.UI.KeyShortIcon'
     Style=STY_Masked
     Mesh=Mesh'WOT.KeyShort'
}
