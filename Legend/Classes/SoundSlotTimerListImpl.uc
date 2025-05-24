//=============================================================================
// SoundSlotTimerListImpl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class SoundSlotTimerListImpl expands SoundSlotTimerListInterf abstract;

// See SoundSlotTimerListInterf.uc for information on how this class works.

#exec Texture Import File=Textures\S_SoundSlotTimer.pcx GROUP=Icons Name=S_SoundSlotTimer Mips=Off Flags=2

const MaxTimedSoundSlots = 10;					// up to this many sound slots which are timed (played randomly) 
var(WOTSounds) SoundSlotTimerT SlotTimers[10];



function PreBeginPlay()
{
	Super.PreBeginPlay();
	RandomizeSoundSlotTimerList();
}



function bool TimeToDoSoundRandom( int SlotIndex )
{
	local bool bOkToDoSound;

	bOkToDoSound = false;

	// FRand determines whether slot played
	if( FRand() < SlotTimers[SlotIndex].SlotOdds )
	{
		// odds met
		if( SlotTimers[SlotIndex].bReset )
		{
			// play the slot and we will switch to timed control from now on
			bOkToDoSound = true;
		}
		else 
		{
			// make sure any time constraint is met
			if( SlotTimers[SlotIndex].MinSecsToNextSound != 0.0 )
			{
				// have to make sure some minimum time has passed since last time sound played
				if( Level.TimeSeconds >= SlotTimers[SlotIndex].NextSoundTime )
				{
					// play the slot
					bOkToDoSound = true;
				
					// make sure odds are reset to default
					SlotTimers[SlotIndex].SlotOdds = default.SlotTimers[SlotIndex].SlotOdds;
				}
				else
				{
					// make sure odds met next time we check if sound should be played
					SlotTimers[SlotIndex].SlotOdds = 1.0;
				}
			}
			else
			{
				// no time constraint -- play the sound
				bOkToDoSound = true;
			}
		}
	}
	
	if( SlotTimers[SlotIndex].bReset )
	{
		// from now on min/max times will be used (even if odds not met above)
		SlotTimers[SlotIndex].SlotOdds = 0.0;
	}

	return bOkToDoSound;
}



function bool TimeToDoSoundTimed( int SlotIndex )
{
	local bool bOkToDoSound;

	bOkToDoSound = false;

	if( Level.TimeSeconds >= SlotTimers[SlotIndex].NextSoundTime )
	{
		// time is up, return index of slot to reset
		bOkToDoSound = true;
	}

	return bOkToDoSound;
}



//=============================================================================
// Returns true if the slot isn't in the timer list. If the slot is in the 
// timer list, returns false if not enough time has passed to play a sound from
// the slot, otherwise returns true and sets SlotIndex to the index of the slot
// in the timer list (so this can be used later to reset the timer without 
// having to search for the correct slot a 2nd time).

function bool TimeToDoSound( name SoundSlot, out int ReturnedSlotIndex )
{
	local int SoundSlotIndex;
	local Name ThisSoundSlot;
	local bool bMatch;
	local bool bRetVal;

	// scan the list of slots for the first matching one:
	bMatch = false;
	ReturnedSlotIndex = NullSlotIndex;
	for( SoundSlotIndex=0; SoundSlotIndex<ArrayCount(SlotTimers); SoundSlotIndex++ )
	{
		ThisSoundSlot = SlotTimers[SoundSlotIndex].SoundSlot;

		if( ThisSoundSlot == SoundSlot )
		{
			bMatch=true;
			break;
		}
	}
	
	bRetVal = false;
	if( !bMatch )
	{
		// slot odds not controlled by SoundSlotTimerList
		bRetVal = true;
	}
	else 
	{
		// slot is controlled by this SoundSlotTimerList
		if( SlotTimers[SoundSlotIndex].SlotOdds != 0.0 )
		{
			bRetVal = TimeToDoSoundRandom( SoundSlotIndex );
		}
		else
		{
			bRetVal = TimeToDoSoundTimed( SoundSlotIndex );
		}

		if( bRetVal )
		{
			// caller can pass slot to set next sound time
			ReturnedSlotIndex = SoundSlotIndex;
		}
	}

	return bRetVal;
}



function RandomizeSoundSlotTimer( int SoundSlotIndex )
{
	local float TimeToWait;

	// set up next sound time even if SlotOdds aren't 0.0 in case time is also to be used
	TimeToWait = RandRange( SlotTimers[SoundSlotIndex].MinSecsToNextSound, SlotTimers[SoundSlotIndex].MaxSecsToNextSound );

	SlotTimers[SoundSlotIndex].NextSoundTime = Level.TimeSeconds + TimeToWait;
}



function RandomizeSoundSlotTimerList()
{
	local int SoundSlotIndex;

	for( SoundSlotIndex=0; SoundSlotIndex<ArrayCount(SlotTimers); SoundSlotIndex++ )
	{
		if( SlotTimers[SoundSlotIndex].SoundSlot != '' )
		{
			RandomizeSoundSlotTimer( SoundSlotIndex );
		}
	}
}



// only those sound slots which aren't to be played every time need be changed

defaultproperties
{
     Texture=Texture'Legend.Icons.S_SoundSlotTimer'
}
