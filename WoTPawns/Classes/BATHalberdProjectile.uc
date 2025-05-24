//=============================================================================
// BATHalberdProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class BATHalberdProjectile expands WotWeaponProjectile;

#exec MESH IMPORT MESH=MBATHalberdProjectile ANIVFILE=MODELS\BATHalberdProjectile_a.3d DATAFILE=MODELS\BATHalberdProjectile_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MBATHalberdProjectile X=0 Y=0 Z=0 YAW=64 ROLL=0 PITCH=0

#exec MESH SEQUENCE MESH=MBATHalberdProjectile SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MBATHalberdProjectile MESH=MBATHalberdProjectile
#exec MESHMAP SCALE MESHMAP=MBATHalberdProjectile X=0.1 Y=0.1 Z=0.2

#exec AUDIO IMPORT FILE=Sounds\Weapon\Halberd\Halberd_Flight1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Halberd\Halberd_HitWall1.wav

defaultproperties
{
     SoundHitPawn=Sound'WOTPawns.Sword_HitPawn1'
     SoundHitWall=Sound'WOTPawns.Halberd_HitWall1'
     bPassThroughActors=True
     StayStuckTime=2.000000
     FadeAwayTime=3.000000
     RollSpinRate=400000
     speed=2400.000000
     MaxSpeed=2400.000000
     Mesh=Mesh'WOTPawns.MBATHalberdProjectile'
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     SoundRadius=64
     SoundPitch=128
     AmbientSound=Sound'WOTPawns.Halberd_Flight1'
     CollisionRadius=5.000000
     CollisionHeight=15.000000
}
