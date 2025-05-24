//=============================================================================
// SwordBase.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class SwordBase expands WotWeapon;

#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_HitPawn1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_PutAway1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_Slash1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_Slash2.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_Slash3.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_Slash4.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_TakeOut1.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Sword\Sword_HitWall1.wav

defaultproperties
{
     bDirectional=True
     bNoSmooth=False
}
