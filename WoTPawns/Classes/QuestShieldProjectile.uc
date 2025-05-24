//=============================================================================
// QuestShieldProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class QuestShieldProjectile expands WotWeaponProjectile;

#exec AUDIO IMPORT FILE=Sounds\Weapon\Shield\Shield_HitWall1.wav

defaultproperties
{
     SoundHitPawn=Sound'WOTPawns.Sword_HitPawn1'
     SoundHitWall=Sound'WOTPawns.Shield_HitWall1'
     bPassThroughActors=True
     StayStuckTime=2.500000
     FadeAwayTime=1.000000
     bMotionBlur=True
     YawSpinRate=400000
     speed=2400.000000
     MaxSpeed=2400.000000
     Damage=25.000000
     Rotation=(Roll=545555)
     Style=STY_Masked
     Mesh=Mesh'WOTPawns.MQuestionerShield'
     SoundRadius=64
     SoundPitch=192
     AmbientSound=Sound'WOTPawns.Arrow_Flight1'
}
