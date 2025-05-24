//=============================================================================
// AnimationTableMinion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================

class AnimationTableMinion expands AnimationTableWOT abstract;

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.150000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=0.485000,AnimEndVector=(X=-1.500000),EAnimInfo=(AnimName=DEATHB,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=0.030000,AnimEndVector=(X=-1.500000),EAnimInfo=(AnimName=DEATHEX,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Death,AnimOdds=0.485000,AnimEndVector=(X=-1.500000,Y=-0.500000),EAnimInfo=(AnimName=DEATHF,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.600000,AnimTweenToTime=0.100000))
     AnimList(11)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=MeleeStandingAttack,AnimOdds=0.200000,EAnimInfo=(AnimName=ATTACKBITE,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=MeleeStandingAttack,AnimOdds=0.400000,EAnimInfo=(AnimName=ATTACKCLAWL,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=MeleeStandingAttack,AnimOdds=0.400000,EAnimInfo=(AnimName=ATTACKCLAWR,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=MeleeAttack,AnimOdds=0.500000,EAnimInfo=(AnimName=ATTACKRUNCLAWL,AnimRate=0.800000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=MeleeAttack,AnimOdds=0.500000,EAnimInfo=(AnimName=ATTACKRUNCLAWR,AnimRate=0.800000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=MeleeAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKRUNTENT,AnimRate=0.800000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=TentacleGrab,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKTENT,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.800000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(24)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(25)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(26)=(AnimSlot=Wait,AnimOdds=0.800000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(27)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=IDLE1,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(28)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=Look,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(29)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(30)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=0.100000,AnimTweenToTime=0.100000))
     AnimList(31)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=0.100000,AnimTweenToTime=0.100000))
}
