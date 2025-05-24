//=============================================================================
// AnimationTableBlackAjahBoss.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class AnimationTableBlackAjahBoss expands AnimationTableWOT abstract;

// TBD: Angry

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=1.000000,AnimEndVector=(X=1.000000,Y=4.500000),EAnimInfo=(AnimName=DEATHREX,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.700000,AnimTweenToTime=0.100000))
     AnimList(9)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHOOT,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=AttackRun,AnimOdds=1.000000,EAnimInfo=(AnimName=AttackRun,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=Wait,AnimOdds=0.900000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=Wait,AnimOdds=0.090000,EAnimInfo=(AnimName=SKIRTFIX,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=Wait,AnimOdds=0.010000,EAnimInfo=(AnimName=HANDSHIP,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=0.300000,AnimTweenToTime=0.600000))
     AnimList(39)=(AnimSlot=Recover,AnimOdds=1.000000,EAnimInfo=(AnimName=Recover,AnimRate=0.450000,AnimTweenToTime=0.200000))
}
