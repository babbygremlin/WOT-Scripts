//=============================================================================
// SoundTableWarder.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class SoundTableWarder expands SoundTableWOT;

//War_AwaitingOrders1.wav
//War_DieSoft1.wav
//War_Drown1.wav
//War_Gasp1.wav
//War_Jump1.wav
//War_Look1.wav
//War_Searching1.wav
//War_SeekingRefuge1.wav
//War_WaitingRandom1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=0.200000,ESoundInfo=(SoundString="WarderA.War_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="WarderA.War_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=Misc1,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_Misc1a",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=Searching,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_Searching1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=Searching,SoundOdds=0.400000,ESoundInfo=(SoundString="WarderA.War_Searching2",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(25)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(41)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="WarderA.War_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="WarderA.War_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(47)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash3",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(48)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash4",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
}
