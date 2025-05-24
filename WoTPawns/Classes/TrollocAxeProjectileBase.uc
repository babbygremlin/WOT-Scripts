//=============================================================================
// TrollocAxeProjectileBase
//=============================================================================

class TrollocAxeProjectileBase expands WotWeaponProjectile;

#exec AUDIO IMPORT FILE=Sounds\Weapon\Axe\Axe_Flight1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Axe\Axe_HitPawn1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Axe\Axe_Slash1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Axe\Axe_Slash2.wav

defaultproperties
{
     SoundHitPawn=Sound'WOTPawns.Axe_HitPawn1'
     SoundHitWall=Sound'WOTPawns.Halberd_HitWall1'
     StayStuckTime=2.000000
     FadeAwayTime=3.000000
     AmbientSound=Sound'WOTPawns.Axe_Flight1'
}
