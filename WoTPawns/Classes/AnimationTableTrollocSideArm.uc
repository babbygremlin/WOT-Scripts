//=============================================================================
// AnimationTableTrollocSideArm.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class AnimationTableTrollocSideArm expands AnimationTableTrolloc abstract;

// The index for the ProjectileAttack has to stay the same 
// in AnimationTableTrolloc and AnimationTableTrollocSideArm.

defaultproperties
{
     AnimList(30)=(EAnimInfo=(AnimName=ATTACKTHROW1,AnimTweenToTime=0.200000))
}
