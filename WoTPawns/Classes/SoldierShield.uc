//=============================================================================
// SoldierShield.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class SoldierShield expands WotWeapon;

// 3rd person perspective version
#exec MESH IMPORT MESH=MSoldierShieldWT ANIVFILE=MODELS\SoldierShield_a.3d DATAFILE=MODELS\SoldierShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MSoldierShieldWT X=0 Y=20 Z=0 YAW=0 ROLL=64 PITCH=94

#exec MESH SEQUENCE MESH=MSoldierShieldWT SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=MSoldierShield0 FILE=MODELS\SoldierShield0.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=MSoldierShield1 FILE=MODELS\SoldierShield1.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=MSoldierShield2 FILE=MODELS\SoldierShield2.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=MSoldierShieldWT MESH=SoldierShield
#exec MESHMAP SCALE MESHMAP=MSoldierShieldWT X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MSoldierShieldWT NUM=0 TEXTURE=MSoldierShield0

// used for decorations
#exec MESH IMPORT MESH=MSoldierShield ANIVFILE=MODELS\SoldierShield_a.3d DATAFILE=MODELS\SoldierShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MSoldierShield X=0 Y=20 Z=0 YAW=0 ROLL=64 PITCH=64

#exec MESH SEQUENCE MESH=MSoldierShield SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MSoldierShield MESH=SoldierShield
#exec MESHMAP SCALE MESHMAP=MSoldierShield X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MSoldierShield NUM=0 TEXTURE=MSoldierShield0

#exec AUDIO IMPORT FILE=Sounds\Weapon\Shield\Shield_Destroyed1.wav

//=============================================================================

defaultproperties
{
     MaxMeleeRange=65.000000
     Health=150
     DamageSkin0=Texture'WOTPawns.Skins.MSoldierShield0'
     DamageSkin1=Texture'WOTPawns.Skins.MSoldierShield1'
     DamageSkin2=Texture'WOTPawns.Skins.MSoldierShield2'
     TossedDecorationTypeString="WOTDecorations.Dec_SoldierShield"
     DestroyedSoundString="WOTPawns.Shield_Destroyed1"
     PickupViewMesh=Mesh'WOTPawns.MSoldierShieldWT'
     ThirdPersonMesh=Mesh'WOTPawns.MSoldierShieldWT'
     bDirectional=True
     Style=STY_Masked
     Mesh=Mesh'WOTPawns.MSoldierShieldWT'
     ScaleGlow=2.000000
     bNoSmooth=False
     CollisionRadius=20.000000
     CollisionHeight=2.000000
}
