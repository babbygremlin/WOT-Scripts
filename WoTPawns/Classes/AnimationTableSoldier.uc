//=============================================================================
// AnimationTableSoldier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class AnimationTableSoldier expands AnimationTableWOT abstract;

// TBD: GetUp
// TBD: TurnCrch

// Some anims, e.g. ProjectileAttack, Recover are for the questioner

defaultproperties
{
     AnimList(0)=(AnimSlot=Breath,AnimOdds=1.000000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(1)=(AnimSlot=Crouch,AnimOdds=1.000000,EAnimInfo=(AnimName=Crouch,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(2)=(AnimSlot=Death,AnimOdds=1.000000,AnimEndVector=(X=-3.000000),EAnimInfo=(AnimName=DEATHB,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(3)=(AnimSlot=Fall,AnimOdds=1.000000,EAnimInfo=(AnimName=Fall,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(4)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitB,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(5)=(AnimSlot=Hit,AnimOdds=0.500000,EAnimInfo=(AnimName=HitF,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(6)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitBHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(7)=(AnimSlot=HitHard,AnimOdds=0.500000,EAnimInfo=(AnimName=HitFHard,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(8)=(AnimSlot=HITCROUCH,AnimOdds=0.500000,EAnimInfo=(AnimName=HITCROUCH,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(9)=(AnimSlot=Jump,AnimOdds=1.000000,EAnimInfo=(AnimName=Jump,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(10)=(AnimSlot=Land,AnimOdds=1.000000,EAnimInfo=(AnimName=Landed,AnimRate=0.300000,AnimTweenToTime=0.100000))
     AnimList(11)=(AnimSlot=Listen,AnimOdds=1.000000,EAnimInfo=(AnimName=Listen,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(12)=(AnimSlot=Look,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(13)=(AnimSlot=MeleeAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKRUNSWIPE,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(14)=(AnimSlot=MeleeAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=ATTACKRUNLUNGE,AnimRate=0.500000,AnimTweenToTime=0.200000))
     AnimList(15)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.450000,EAnimInfo=(AnimName=ATTACKRUNSWIPE,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(16)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.300000,EAnimInfo=(AnimName=ATTACKRUNLUNGE,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(17)=(AnimSlot=MeleeWeaponAttack,AnimOdds=0.250000,EAnimInfo=(AnimName=ATTACKRUNSHIELD,AnimRate=0.550000,AnimTweenToTime=0.200000))
     AnimList(18)=(AnimSlot=ProjectileAttack,AnimOdds=1.000000,EAnimInfo=(AnimName=SHLDHURL,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(19)=(AnimSlot=Run,AnimOdds=1.000000,EAnimInfo=(AnimName=Run,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(20)=(AnimSlot=Search,AnimOdds=1.000000,EAnimInfo=(AnimName=Look,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(21)=(AnimSlot=ShowRespect,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactP,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(22)=(AnimSlot=ShowRespectLoop,AnimOdds=1.000000,EAnimInfo=(AnimName=ReactPLoop,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(23)=(AnimSlot=Wait,AnimOdds=0.800000,EAnimInfo=(AnimName=Breath,AnimRate=0.150000,AnimTweenToTime=0.200000))
     AnimList(24)=(AnimSlot=Wait,AnimOdds=0.150000,EAnimInfo=(AnimName=Look,AnimRate=0.400000,AnimTweenToTime=0.200000))
     AnimList(25)=(AnimSlot=Wait,AnimOdds=0.050000,EAnimInfo=(AnimName=CHECKSWORD,AnimRate=0.300000,AnimTweenToTime=0.200000))
     AnimList(26)=(AnimSlot=Walk,AnimOdds=1.000000,EAnimInfo=(AnimName=Walk,AnimRate=0.700000,AnimTweenToTime=0.200000))
     AnimList(30)=(AnimSlot=Crouching,AnimOdds=1.000000,EAnimInfo=(AnimName=Crouching,AnimRate=0.100000,AnimTweenToTime=0.100000))
     AnimList(39)=(AnimSlot=Recover,AnimOdds=1.000000,EAnimInfo=(AnimName=Recover,AnimRate=1.000000,AnimTweenToTime=0.200000))
     AnimList(40)=(AnimSlot=DodgeLeft,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeLeft,AnimRate=1.000000,AnimTweenToTime=0.100000))
     AnimList(41)=(AnimSlot=DodgeRight,AnimOdds=1.000000,EAnimInfo=(AnimName=DodgeRight,AnimRate=1.000000,AnimTweenToTime=0.100000))
}
