//=============================================================================
// AnimationTableBATrolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class AnimationTableBATrolloc expands AnimationTableWOT abstract;

// TBD: Pickup
// TBD: Yelling

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=0.330000,AnimEndVector=(X=-3.000000),EAnimInfo=(AnimName=DEATHB,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=0.330000,AnimEndVector=(X=-0.750000,Y=2.500000),EAnimInfo=(AnimName=DEATHR,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(10)=(AnimSlot=Listen,AnimOdds=1.000000,EAnimInfo=(AnimName=Listen,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=MeleeAttack,AnimOdds=0.600000,EAnimInfo=(AnimName=ATTACKRUNDBLEPUNCH,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=MeleeAttack,AnimOdds=0.400000,EAnimInfo=(AnimName=Charge,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.200000,EAnimInfo=(AnimName=ATTACKJAB,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.200000,EAnimInfo=(AnimName=LONGJAB,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.500000,EAnimInfo=(AnimName=ATTACKRUNDBLESWIPE,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=MeleeWeaponAttack,EAnimInfo=(AnimName=Charge,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=THROWHALBERD,AnimRate=0.450000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.650000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(23)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(24)=(AnimSlot=Wait,AnimOdds=0.900000,EAnimInfo=(AnimName=Breath,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(25)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(26)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(39)=(AnimSlot=Recover,AnimOdds=1.000000,EAnimInfo=(AnimName=Recover,AnimRate=0.450000,AnimTweenToTime=0.200000))
}
