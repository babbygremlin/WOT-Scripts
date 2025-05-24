//=============================================================================
// SoundTableMyrddraal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class SoundTableMyrddraal expands SoundTableWOT;

//Myr_DieSoft1.wav
//Myr_Drown1.wav
//Myr_Gasp1.wav
//Myr_Jump1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="MyrddraalA.Myr_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=AwaitingOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_AwaitingOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=256.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(8)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="MyrddraalA.Myr_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=OrderGetHelp,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_OrderGetHelp1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=OrderGuard,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_OrderGuard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=OrderGuardSeal,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_OrderGuardSeal1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=OrderKillIntruder,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_OrderKillIntruder1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(25)=(SoundSlot=OrderSoundAlarm,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_OrderSoundAlarm1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(26)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_Searching1",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(27)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(28)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="MyrddraalA.Myr_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(29)=(SoundSlot=SeekingRefuge,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_SeekRefuge1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(30)=(SoundSlot=SeekingRefuge,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_SeekRefuge2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(31)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(33)=(SoundSlot=Teleport,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Myrddraal_Teleport",Slot=SLOT_Misc,Volume=1.000000,Radius=2048.000000,Pitch=1.000000))
     SoundList(34)=(SoundSlot=Reappear,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Myrddraal_Reappear",Slot=SLOT_Misc,Volume=1.000000,Radius=2048.000000,Pitch=1.000000))
     SoundList(37)=(SoundSlot=WeaponMeleeDraw,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_TakeOut1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(38)=(SoundSlot=WeaponMeleeSheath,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_PutAway1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(39)=(SoundSlot=WeaponRangedDraw,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Crossbow_Switch1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(40)=(SoundSlot=WeaponRangedSheath,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Crossbow_Switch1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(44)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="MyrddraalA.Myr_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(47)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash3",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(48)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash4",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
}
