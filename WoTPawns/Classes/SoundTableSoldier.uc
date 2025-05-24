//=============================================================================
// SoundTableSoldier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class SoundTableSoldier expands SoundTableWOT;

//Sol_AwaitingOrders1.wav
//Sol_Drown1.wav
//Sol_Gasp1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SoldierA.Sol_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SoldierA.Sol_Acquired2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_Acquired3",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(8)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=Jump,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_Jump1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="SoldierA.Sol_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_Searching1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000))
     SoundList(18)=(SoundSlot=SeeEnemy,SoundOdds=0.100000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SoldierA.Sol_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=SeeEnemy,SoundOdds=0.150000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SoldierA.Sol_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=SeeEnemy,SoundOdds=0.100000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SoldierA.Sol_SeeEnemy3",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=SeeEnemy,SoundOdds=0.150000,ESoundInfo=(SoundString="SoldierA.Sol_SeeEnemy4",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=SeeEnemy,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=SeekingRefuge,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_SeekingRefuge1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(41)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="SoldierA.Sol_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="SoldierA.Sol_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(44)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash3",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(47)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash4",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(48)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeShieldHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Shield_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=0.750000))
}
