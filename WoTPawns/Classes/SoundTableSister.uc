//=============================================================================
// SoundTableSister.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class SoundTableSister expands SoundTableWOT;

//Sis_AcceptOrders1.wav
//Sis_Acquired2.wav
//Sis_Breath1.wav
//Sis_DieSoft1.wav
//Sis_Drown1.wav
//Sis_Gasp1.wav
//Sis_Jump1.wav
//Sis_LandHard1.wav
//Sis_Look1.wav
//Sis_Searching1.wav
//Sis_SeekingRefuge1.wav

defaultproperties
{
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="SisterA.Sis_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=AwaitingOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_AwaitingOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(6)=(SoundSlot=GiveOrders,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_GiveOrders1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(8)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="SisterA.Sis_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=Misc1,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_Misc1a",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=OrderGetHelp,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_GetHelp1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=OrderGuard,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_OrderGuard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=OrderGuardSeal,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_OrderGuardSeal1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=OrderKillIntruder,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_OrderKillIntruder1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=OrderSoundAlarm,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_OrderSoundAlarm1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=ShowRespect,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=ShowRespect,SoundOdds=0.500000,GameType=GT_MultiPlayer,ESoundInfo=(SoundString="SisterA.Sis_ShowRespect2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(41)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="SisterA.Sis_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="SisterA.Sis_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
}
