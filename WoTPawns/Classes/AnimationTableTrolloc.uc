//=============================================================================
// AnimationTableTrolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class AnimationTableTrolloc expands AnimationTableWOT abstract;

// The index for the ProjectileAttack has to stay the same 
// in AnimationTableTrolloc and AnimationTableTrollocSideArm.

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.300000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=0.050000,AnimEndVector=(X=2.000000),EAnimInfo=(AnimName=DEATHF,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=0.850000,AnimEndVector=(X=-4.500000),EAnimInfo=(AnimName=DEATHB,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Death,AnimOdds=0.100000,EAnimInfo=(AnimName=DEATHC,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(11)=(AnimSlot=Listen,AnimOdds=1.000000,EAnimInfo=(AnimName=Listen,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.150000,AnimTweenToTime=0.300000))
     AnimList(13)=(AnimSlot=MeleeAttack,AnimOdds=0.660000,EAnimInfo=(AnimName=AttackRun,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=MeleeAttack,AnimOdds=0.330000,EAnimInfo=(AnimName=ATTACKRUNB,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.660000,EAnimInfo=(AnimName=AttackRun,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.330000,EAnimInfo=(AnimName=ATTACKRUNB,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.750000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=15.000000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=Wait,AnimOdds=0.960000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.300000))
     AnimList(23)=(AnimSlot=Wait,AnimOdds=0.035000,EAnimInfo=(AnimName=Look,AnimRate=0.150000,AnimTweenToTime=0.300000))
     AnimList(24)=(AnimSlot=Wait,AnimOdds=0.005000,EAnimInfo=(AnimName=SCRATCH,AnimRate=0.200000,AnimTweenToTime=0.300000))
     AnimList(25)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(28)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(29)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(30)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKRUNB,AnimRate=0.500000))
}
