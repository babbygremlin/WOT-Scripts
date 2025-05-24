//=============================================================================
// AnimationTableMyrddraal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class AnimationTableMyrddraal expands AnimationTableWOT abstract;

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Death,AnimOdds=0.500000,AnimEndVector=(X=-6.500000),EAnimInfo=(AnimName=DEATHB,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=0.500000,AnimEndVector=(X=3.500000,Y=-3.000000),EAnimInfo=(AnimName=DEATHF,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=0.500000,AnimTweenToTime=0.100000))
     AnimList(9)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.500000,AnimTweenToTime=0.100000))
     AnimList(10)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(11)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.660000,EAnimInfo=(AnimName=ATTACKRUNSWIPE,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.330000,EAnimInfo=(AnimName=ATTACKRUNSKEWER,AnimRate=0.600000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHOOT,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=SeeEnemy,AnimOdds=1.000000,EAnimInfo=(AnimName=SeeEnemy,AnimRate=0.350000,AnimTweenToTime=0.100000))
     AnimList(17)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.100000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Wait,AnimOdds=0.900000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=Wait,AnimOdds=0.100000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(30)=(AnimSlot=GiveOrders,AnimOdds=1.000000,EAnimInfo=(AnimName=GiveOrders,AnimRate=0.350000,AnimTweenToTime=0.200000))
     AnimList(31)=(AnimSlot=Gong,AnimOdds=1.000000,EAnimInfo=(AnimName=Gong,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(32)=(AnimSlot=Report,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.250000,AnimTweenToTime=0.200000))
     AnimList(35)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(36)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(46)=(AnimSlot=WeaponPutAwayMelee,AnimOdds=1.000000,EAnimInfo=(AnimName=SWORDDOWN,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(47)=(AnimSlot=WeaponPutAwayRanged,AnimOdds=1.000000,EAnimInfo=(AnimName=BOWDOWN,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(48)=(AnimSlot=WeaponTakeOutMelee,AnimOdds=1.000000,EAnimInfo=(AnimName=SWORDUP,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(49)=(AnimSlot=WeaponTakeOutRanged,AnimOdds=1.000000,EAnimInfo=(AnimName=BOWUP,AnimRate=0.700000,AnimTweenToTime=0.200000))
}
