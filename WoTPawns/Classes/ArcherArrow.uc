//=============================================================================
// ArcherArrow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class ArcherArrow expands WotWeaponProjectile;

#exec MESH IMPORT MESH=MArcherArrow ANIVFILE=MODELS\ArcherArrow_a.3d DATAFILE=MODELS\ArcherArrow_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MArcherArrow X=0 Y=0 Z=0 YAW=0 ROLL=0 PITCH=64

#exec MESH SEQUENCE MESH=MArcherArrow SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MArcherArrow MESH=MArcherArrow
#exec MESHMAP SCALE MESHMAP=MArcherArrow X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MArcherArrow NUM=1 TEXTURE=JArcher1
#exec MESHMAP SETTEXTURE MESHMAP=MArcherArrow NUM=2 TEXTURE=JArcher1

#exec AUDIO IMPORT FILE=Sounds\Weapon\Arrow\Arrow_Flight1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Arrow\Arrow_Tossed1.wav

simulated function Explode( vector HitLocation, Vector HitNormal )
{
	Spawn( class'ArrowTrail',,, HitLocation, rotator(Velocity) );
	Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
     SoundHitPawn=Sound'WOTPawns.Crossbow_HitPawn1'
     SoundHitWall=Sound'WOTPawns.Crossbow_HitWall1'
     StayStuckTime=30.000000
     FadeAwayTime=2.000000
     RollSpinRate=200000
     speed=16384.000000
     MaxSpeed=16384.000000
     SpawnSound=Sound'WOTPawns.Crossbow_Shoot1'
     Mesh=Mesh'WOTPawns.MArcherArrow'
     AmbientSound=Sound'WOTPawns.Arrow_Flight1'
}
