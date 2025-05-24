//=============================================================================
// SoundTableBATrolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class SoundTableBATrolloc expands SoundTableWOT;

//BAT_AwaitingOrders1.wav
//BAT_DieSoft1.wav
//BAT_Drown1.wav
//BAT_Gasp1.wav
//BAT_Jump1.wav
//BAT_LandHard1.wav
//BAT_LandSoft1.wav
//BAT_Look1.wav
//BAT_Misc1a.wav
//BAT_Recover1.wav
//BAT_Searching1.wav
//BAT_WaitingRandom1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="BATrollocA.BAT_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_Acquired2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="BATrollocA.BAT_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="BATrollocA.BAT_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="BATrollocA.BAT_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="BATrollocA.BAT_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="BATrollocA.BAT_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="BATrollocA.BAT_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=Recover,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_Recover1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_Searching1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=WaitingRandom,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_WaitingRandom1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=1.000000,ESoundInfo=(SoundString="BATrollocA.BAT_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Axe_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Axe_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Axe_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
}
