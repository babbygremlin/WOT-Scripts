//=============================================================================
// BATHalberd.
//=============================================================================
class BATHalberd expands WotThrowableWeapon;

#exec MESH IMPORT MESH=MBATHalberd ANIVFILE=MODELS\BATHalberd_a.3d DATAFILE=MODELS\BATHalberd_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MBATHalberd X=0 Y=0 Z=0 YAW=0 ROLL=0 PITCH=0

#exec MESH SEQUENCE MESH=MBATHalberd SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MBATHalberd MESH=MBATHalberd
#exec MESHMAP SCALE MESHMAP=MBATHalberd X=0.1 Y=0.1 Z=0.2

//=============================================================================

defaultproperties
{
     MaxMeleeRange=65.000000
     MeleeEffectiveness=1.000000
     MinProjectileRange=150.000000
     MaxProjectileRange=10000.000000
     ProjectileEffectiveness=2.000000
     WotWeaponProjectileType=Class'WOTPawns.BATHalberdProjectile'
     TossedDecorationTypeString="WOTDecorations.Dec_BATHalberd"
     PickupViewMesh=Mesh'WOTPawns.MBATHalberd'
     ThirdPersonMesh=Mesh'WOTPawns.MBATHalberd'
     bDirectional=True
     Mesh=Mesh'WOTPawns.MBATHalberd'
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     CollisionRadius=5.000000
     CollisionHeight=15.000000
}
