//=============================================================================
// SoundTableArcher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class SoundTableArcher expands SoundTableWOT;

//Arc_Drown1.wav
//Arc_Gasp1.wav
//Arc_Jump1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_Acquired2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_Acquired3",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=AwaitingOrders,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_AwaitingOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=AwaitingOrders,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_AwaitingOrders2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=DieHard,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(8)=(SoundSlot=DieHard,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_DieHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=DieSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=DieSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_DieSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=GiveOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_GiveOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=Look,SoundOdds=0.200000,ESoundInfo=(SoundString="ArcherA.Arc_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="ArcherA.Arc_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=OrderGetHelp,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_OrderGetHelp1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=OrderGuard,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_OrderGuard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=OrderGuardSeal,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_OrderGuardSeal1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=OrderKillIntruder,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_OrderKillIntruder1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(25)=(SoundSlot=OrderSoundAlarm,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_OrderSoundAlarm1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(26)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_Searching1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(27)=(SoundSlot=SeeEnemy,SoundOdds=0.150000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(28)=(SoundSlot=SeeEnemy,SoundOdds=0.150000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(29)=(SoundSlot=SeeEnemy,SoundOdds=0.200000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_SeeEnemy3",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(30)=(SoundSlot=SeeEnemy,SoundOdds=0.300000,ESoundInfo=(SoundString="ArcherA.Arc_SeeEnemy4",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(31)=(SoundSlot=SeeEnemy,SoundOdds=0.200000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="ArcherA.Arc_SeeEnemy5",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(32)=(SoundSlot=SeekingRefuge,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_SeekingRefuge1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(33)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(34)=(SoundSlot=WaitingRandom,SoundOdds=0.300000,ESoundInfo=(SoundString="ArcherA.Arc_WaitingRandom1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(35)=(SoundSlot=WaitingRandom,SoundOdds=0.300000,ESoundInfo=(SoundString="ArcherA.Arc_WaitingRandom2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(37)=(SoundSlot=WeaponMeleeDraw,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_TakeOut1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(38)=(SoundSlot=WeaponMeleeSheath,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_PutAway1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="ArcherA.Arc_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(44)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="ArcherA.Arc_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(47)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash3",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(48)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash4",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
}
