//=============================================================================
// AnimationTableArcher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================

class AnimationTableArcher expands AnimationTableWOT abstract;

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=0.500000,EAnimInfo=(AnimName=DEATHF,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=0.500000,EAnimInfo=(AnimName=DEATHB,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.250000,AnimTweenToTime=0.100000))
     AnimList(10)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.750000,EAnimInfo=(AnimName=ATTACKRUNSWIPE,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.250000,EAnimInfo=(AnimName=ATTACKRUNSKEWER,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHOOT,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Wait,AnimOdds=0.800000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=Wait,AnimOdds=0.800000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=HitKneel,AnimOdds=1.000000,EAnimInfo=(AnimName=KNEELHIT,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(23)=(AnimSlot=HitHardKneel,AnimOdds=1.000000,EAnimInfo=(AnimName=KNEELHITH,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(24)=(AnimSlot=DEATHKNEEL,AnimOdds=1.000000,AnimEndVector=(Y=-2.500000),EAnimInfo=(AnimName=DEATHKNEEL,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(25)=(AnimSlot=KNEEL,AnimOdds=1.000000,EAnimInfo=(AnimName=KNEEL,AnimRate=0.750000,AnimTweenToTime=0.500000))
     AnimList(26)=(AnimSlot=Draw,AnimOdds=1.000000,EAnimInfo=(AnimName=Draw,AnimRate=0.400000,AnimTweenToTime=0.500000))
     AnimList(27)=(AnimSlot=RELEASE,AnimOdds=1.000000,EAnimInfo=(AnimName=RELEASE,AnimRate=0.400000,AnimTweenToTime=0.500000))
     AnimList(28)=(AnimSlot=GETUP,AnimOdds=1.000000,EAnimInfo=(AnimName=GETUP,AnimRate=0.750000,AnimTweenToTime=0.500000))
     AnimList(29)=(AnimSlot=GiveOrders,AnimOdds=1.000000,EAnimInfo=(AnimName=GiveOrders,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(30)=(AnimSlot=Gong,AnimOdds=1.000000,EAnimInfo=(AnimName=Gong,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(31)=(AnimSlot=Report,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(32)=(AnimSlot=WeaponPutAwayMelee,AnimOdds=1.000000,EAnimInfo=(AnimName=SheathSword,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(33)=(AnimSlot=WeaponTakeOutMelee,AnimOdds=1.000000,EAnimInfo=(AnimName=DRAWSWRD,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(40)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(41)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=0.300000,AnimTweenToTime=0.100000))
}
