//=============================================================================
// AnimationTableWhitecloak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class AnimationTableWhitecloak expands AnimationTableWOT abstract;

defaultproperties
{
     AnimList(0)=(AnimSlot=Attack,AnimOdds=1.000000,EAnimInfo=(AnimName=Attack,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=AttackRun,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackRun,AnimRate=0.500000))
     AnimList(2)=(AnimSlot=AttackRunL,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackRunL,AnimRate=0.500000))
     AnimList(3)=(AnimSlot=AttackRunR,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackRunR,AnimRate=0.500000))
     AnimList(4)=(AnimSlot=AttackWalk,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackWalk,AnimRate=0.350000))
     AnimList(5)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.050000,AnimTweenToTime=1.000000))
     AnimList(6)=(AnimSlot=Death,AnimOdds=0.500000,AnimEndVector=(X=5.500000,Y=2.000000),EAnimInfo=(AnimName=DEATHF,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=Death,AnimOdds=0.500000,EAnimInfo=(AnimName=DEATHR,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=0.800000,AnimTweenToTime=0.400000))
     AnimList(14)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.450000,AnimTweenToTime=0.100000))
     AnimList(15)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.600000))
     AnimList(17)=(AnimSlot=RunL,AnimOdds=1.000000,EAnimInfo=(AnimName=RunL,AnimRate=0.600000))
     AnimList(18)=(AnimSlot=RunR,AnimOdds=1.000000,EAnimInfo=(AnimName=RunR,AnimRate=0.600000))
     AnimList(19)=(AnimSlot=Swim,AnimOdds=1.000000,EAnimInfo=(AnimName=Swim,AnimRate=0.340000))
     AnimList(20)=(AnimSlot=Wait,AnimOdds=0.900000,EAnimInfo=(AnimName=Breath,AnimRate=0.050000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=Look,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.600000))
     AnimList(49)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=Attack,AnimRate=1.000000,AnimTweenToTime=0.200000))
}
