//=============================================================================
// KeyLong.
//=============================================================================
class KeyLong expands Key;

#exec MESH IMPORT MESH=KeyLong ANIVFILE=MODELS\KeyLong_a.3d DATAFILE=MODELS\KeyLong_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=KeyLong X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=KeyLong SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\KeyLong.PCX GROUP=Keys FLAGS=2 // SKIN

#exec TEXTURE IMPORT FILE=Icons\KeyLongIcon.PCX GROUP=UI MIPS=Off FLAGS=2

#exec MESHMAP NEW   MESHMAP=KeyLong MESH=KeyLong
#exec MESHMAP SCALE MESHMAP=KeyLong X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=KeyLong NUM=0 TEXTURE=KeyLong

defaultproperties
{
     KeyPickupMessage="You found a large key"
     PickupViewMesh=Mesh'WOT.KeyLong'
     StatusIcon=Texture'WOT.UI.KeyLongIcon'
     Style=STY_Masked
     Mesh=Mesh'WOT.KeyLong'
}
