//=============================================================================
// SoundSlotTimerListInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class SoundSlotTimerListInterf expands LegendAssetComponent abstract;

/*=============================================================================
How this class works:

There are basically 2 ways to use this class:

1)

In most cases, leave SlotOdds=0.0 and set MinSecsToNextSound and 
MaxSecsToNextSound so a sound from the slot will be played after at least
MinSecsToNextSound seconds, and after at most MaxSecsToNextSound seconds. This
is useful for random idle (waiting) sounds for example. 

2)

In some cases, if the above method is used, when the time comes to play
the sound, at least MaxSecsToNextSound seconds will usually have passed, so
the sound will always be played. For example, a waiting NPC may see an enemy
after waiting for several minutes or longer. In this case, set the SlotOdds to
a non-0 value and these odds will determine whether or not the sound is played
the first time the slot is checked.

If bReset is set, as soon as the slot is used for the first time, the SlotOdds
will be cleared and the MinSecsToNextSound and MaxSecsToNextSound settings 
will be used thereafter.

If the SlotOdds are used and bReset is false and the Min/MaxSecsToNextSound are
set (non-zero), then these will also be respected, that is, the sound will only 
be played if the odds are met and MinSecsToNextSound seconds have passed. Set 
MaxSecsToNextSound to the same value as MinSecsToNextSound in this case or
whether the sound is played will be controlled by both the SlotOdds and the
random time between the Min and Max values (not generally useful).
=============================================================================*/



struct SoundSlotTimerT
{
	var() Name	SoundSlot;			// name of sound category (slot)
	var() float	SlotOdds;			// see above
	var() float	MinSecsToNextSound;	// min time between playing sound from sound slot
	var() float	MaxSecsToNextSound;	// max time between playing sound from sound slot
	var() bool	bReset;				// see above
	var   float	NextSoundTime;		// level time after which next sound can be played
};


const NullSlotIndex = -1;			// value returned to caller when slot should not be reset

function bool TimeToDoSound( name SoundSlot, out int SlotIndex );
function RandomizeSoundSlotTimer( int SoundSlotIndex );
function RandomizeSoundSlotTimerList();

defaultproperties
{
}
