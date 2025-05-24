//=============================================================================
// SoundTableMinion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class SoundTableMinion expands SoundTableWOT;

//Min_AcceptOrders1.wav
//Min_AwaitingOrders1.wav
//Min_Acquired1.wav
//Min_Acquired2.wav
//Min_DieSoft1.wav
//Min_Drown1.wav
//Min_Gasp1.wav
//Min_Jump1.wav
//Min_LandHard1.wav
//Min_LandSoft1.wav
//Min_Look1.wav
//Min_Searching1.wav
//Min_SeekingRefuge1.wav
//Min_ShowRespect1.wav
//Min_WaitingRandom1.wav

defaultproperties
{
     SoundList(0)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(7)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(8)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(9)=(SoundSlot=Jump,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_Jump1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=768.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="MinionA.Min_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_Searching1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=ATTACKBITE,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_AttackBite1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=AttackClaw,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_AttackClaw2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=AttackTentacle,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_AttackTentacle2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="MinionA.Min_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(44)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="MinionA.Min_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
}
