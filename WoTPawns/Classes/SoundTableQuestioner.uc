//=============================================================================
// SoundTableQuestioner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class SoundTableQuestioner expands SoundTableWOT;

//Que_Drown1.wav
//Que_Gasp1.wav

// renamed misc1/2 acquired4/5?

defaultproperties
{
     SoundList(0)=(SoundSlot=Acquired,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Acquired1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(1)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="QuestionerA.Que_Acquired2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(2)=(SoundSlot=Acquired,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="QuestionerA.Que_Acquired3",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(3)=(SoundSlot=Breath,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Breath1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(4)=(SoundSlot=DieHard,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_DieHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(5)=(SoundSlot=DieSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_DieSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(10)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(11)=(SoundSlot=HitHard,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitHard2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(12)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(13)=(SoundSlot=HitSoft,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(14)=(SoundSlot=Jump,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Jump1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(15)=(SoundSlot=LandHard,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_LandHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(16)=(SoundSlot=LandSoft,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_LandSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(17)=(SoundSlot=Look,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Look1",Slot=SLOT_Talk,Volume=1.000000,Radius=384.000000,Pitch=1.000000))
     SoundList(18)=(SoundSlot=MeleeHitEnemyTaunt,SoundOdds=0.200000,ESoundInfo=(SoundString="QuestionerA.Que_MeleeHitEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(19)=(SoundSlot=MeleeKilledEnemyTaunt,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_MeleeKilledEnemyTaunt1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(20)=(SoundSlot=Reflected,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_Misc1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(21)=(SoundSlot=Reflected,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_Misc2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(22)=(SoundSlot=Recover,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Recover1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(23)=(SoundSlot=Searching,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_Searching1",Slot=SLOT_Talk,Volume=1.000000,Radius=256.000000,Pitch=1.000000))
     SoundList(24)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_SeeEnemy1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(25)=(SoundSlot=SeeEnemy,SoundOdds=1.000000,GameType=GT_SinglePlayer,ESoundInfo=(SoundString="QuestionerA.Que_SeeEnemy2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(26)=(SoundSlot=ShowRespect,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_ShowRespect1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(41)=(SoundSlot=Gasp,SoundOdds=1.000000,ESoundInfo=(SoundString="QuestionerA.Que_HitHard1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(42)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitSoft1",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(43)=(SoundSlot=Drown,SoundOdds=0.500000,ESoundInfo=(SoundString="QuestionerA.Que_HitSoft2",Slot=SLOT_Talk,Volume=1.000000,Pitch=1.000000))
     SoundList(44)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash1",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(45)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash2",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(46)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash3",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(47)=(SoundSlot=WeaponMeleeAttack,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_Slash4",Slot=SLOT_Misc,Volume=1.000000,Pitch=1.000000))
     SoundList(48)=(SoundSlot=WeaponMeleeHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Sword_HitPawn1",Slot=SLOT_Interact,Volume=1.000000,Pitch=1.000000))
     SoundList(49)=(SoundSlot=WeaponMeleeShieldHitEnemy,SoundOdds=1.000000,ESoundInfo=(SoundString="WOTPawns.Shield_HitPawn1",Slot=SLOT_Misc,Volume=1.000000,Pitch=0.750000))
}
