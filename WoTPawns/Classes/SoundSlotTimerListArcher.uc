//=============================================================================
// SoundSlotTimerListArcher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class SoundSlotTimerListArcher expands SoundSlotTimerListImpl;

defaultproperties
{
     SlotTimers(0)=(SoundSlot=Acquired,SlotOdds=0.010000,MinSecsToNextSound=8.000000,MaxSecsToNextSound=15.000000,bReset=True)
     SlotTimers(1)=(SoundSlot=WaitingRandom,MinSecsToNextSound=60.000000,MaxSecsToNextSound=180.000000)
}
