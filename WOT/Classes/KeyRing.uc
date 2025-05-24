//=============================================================================
// KeyRing.
//=============================================================================
class KeyRing expands Key;

#exec MESH IMPORT MESH=KeyRing ANIVFILE=MODELS\KeyRing_a.3d DATAFILE=MODELS\KeyRing_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=KeyRing X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=KeyRing SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\KeyRing1.PCX GROUP=Keys FLAGS=2 // Ring
#exec TEXTURE IMPORT FILE=MODELS\KeyRing2.PCX GROUP=Keys PALETTE=KeyRing1 // KEYS
#exec TEXTURE IMPORT FILE=MODELS\KeyRing3.PCX GROUP=Keys PALETTE=KeyRing1 // KEYB
#exec TEXTURE IMPORT FILE=MODELS\KeyRing4.PCX GROUP=Keys PALETTE=KeyRing1 // KEYD
#exec TEXTURE IMPORT FILE=MODELS\KeyRing5.PCX GROUP=Keys PALETTE=KeyRing1 // KEYG

#exec TEXTURE IMPORT FILE=Icons\KeyRingIcon.PCX GROUP=UI MIPS=Off FLAGS=2

#exec MESHMAP NEW   MESHMAP=KeyRing MESH=KeyRing
#exec MESHMAP SCALE MESHMAP=KeyRing X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=KeyRing NUM=1 TEXTURE=KeyRing1
#exec MESHMAP SETTEXTURE MESHMAP=KeyRing NUM=2 TEXTURE=KeyRing2
#exec MESHMAP SETTEXTURE MESHMAP=KeyRing NUM=3 TEXTURE=KeyRing3
#exec MESHMAP SETTEXTURE MESHMAP=KeyRing NUM=4 TEXTURE=KeyRing4
#exec MESHMAP SETTEXTURE MESHMAP=KeyRing NUM=5 TEXTURE=KeyRing5

defaultproperties
{
     KeyPickupMessage="You found a key ring"
     PickupViewMesh=Mesh'WOT.KeyRing'
     StatusIcon=Texture'WOT.UI.KeyRingIcon'
     Style=STY_Masked
     Mesh=Mesh'WOT.KeyRing'
}
