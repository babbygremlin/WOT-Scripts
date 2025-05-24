//=============================================================================
// SoundTableTrolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class SoundTableTrolloc expands SoundTableWOT;

//Tro_AwaitingOrders1.wav
//Tro_DieSoft1.wav -- using DieHard2 for now
//Tro_Drown1.wav
//Tro_Gasp1.wav
//Tro_Jump1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=AcceptOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_AcceptOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="TrollocA.Tro_Acquired2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_WaitingRandom2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_DieHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="TrollocA.Tro_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=Misc1,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_Misc1a",Slot=SLOT_Misc,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=Searching,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_Searching1",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=Searching,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_Searching2",Slot=SLOT_Talk,Volume=1.000000,Radius=512.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="TrollocA.Tro_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=SeekingRefuge,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_SeekingRefuge1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(25)=(SoundSlot=ShowRespect,SoundOdds=0.050000,ESoundInfo=(SoundString="TrollocA.Tro_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(26)=(SoundSlot=WaitingRandom,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_WaitingRandom1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(27)=(SoundSlot=WaitingRandom,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_WaitingRandom2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(41)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="TrollocA.Tro_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="TrollocA.Tro_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=0.500000,ESoundInfo=(SoundString="WOTPawns.Axe_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=0.500000,ESoundInfo=(SoundString="WOTPawns.Axe_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Axe_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
}
