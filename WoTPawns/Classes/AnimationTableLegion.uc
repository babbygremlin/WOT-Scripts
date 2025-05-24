//=============================================================================
// AnimationTableLegion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class AnimationTableLegion expands AnimationTableWOT abstract;

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=1.000000,AnimEndVector=(Y=-1.000000),EAnimInfo=(AnimName=DEATHL,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.700000,AnimTweenToTime=0.100000))
     AnimList(10)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=MeleeAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKSTOMP1,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=MeleeAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKSTOMP2,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHOOT,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Wait,AnimOdds=0.800000,EAnimInfo=(AnimName=Breath,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=Wait,AnimOdds=0.150000,EAnimInfo=(AnimName=Look,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=Wait,AnimOdds=0.050000,EAnimInfo=(AnimName=LOOKGROAN,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(39)=(AnimSlot=Recover,AnimOdds=1.000000,EAnimInfo=(AnimName=Recover,AnimRate=0.550000,AnimTweenToTime=0.200000))
}
