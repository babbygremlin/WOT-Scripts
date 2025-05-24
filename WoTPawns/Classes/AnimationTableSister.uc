//=============================================================================
// AnimationTableSister.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class AnimationTableSister expands AnimationTableWOT abstract;

//TBD:CrossArms

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=1.000000,AnimEndVector=(X=1.200000,Y=-3.700000),EAnimInfo=(AnimName=DEATHL,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(9)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.200000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHOOT,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=AttackRun,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackRun,AnimRate=0.900000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.900000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.200000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=Wait,AnimOdds=0.900000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=Look,AnimRate=0.200000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.800000,AnimTweenToTime=0.200000))
     AnimList(28)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(29)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(30)=(AnimSlot=GiveOrders,AnimOdds=1.000000,EAnimInfo=(AnimName=GiveOrders,AnimRate=0.340000,AnimTweenToTime=0.200000))
     AnimList(31)=(AnimSlot=Gong,AnimOdds=1.000000,EAnimInfo=(AnimName=Gong,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(32)=(AnimSlot=Report,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
}
