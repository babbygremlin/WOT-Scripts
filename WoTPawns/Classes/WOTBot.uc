//=============================================================================
// WotBot.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class WotBot expands AngrealUser;

defaultproperties
{
     BaseWalkingSpeed=250.000000
     GroundSpeedMin=500.000000
     GroundSpeedMax=500.000000
     SoundSlotTimerListClass=Class'WOT.SoundSlotTimerListWOTBot'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     GoalSuggestedSpeeds(0)=500.000000
     GoalSuggestedSpeeds(2)=500.000000
     GoalSuggestedSpeeds(3)=500.000000
     GoalSuggestedSpeeds(4)=500.000000
     GoalSuggestedSpeeds(5)=500.000000
     GoalSuggestedSpeeds(6)=250.500000
     CollisionRadius=17.000000
     CollisionHeight=43.000000
}
