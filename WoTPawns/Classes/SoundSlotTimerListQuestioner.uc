//=============================================================================
// SoundSlotTimerListQuestioner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class SoundSlotTimerListQuestioner expands SoundSlotTimerListImpl;

defaultproperties
{
     SlotTimers(0)=(SoundSlot=Acquired,SlotOdds=0.100000,MinSecsToNextSound=5.000000,MaxSecsToNextSound=10.000000,bReset=True)
     SlotTimers(1)=(SoundSlot=Reflected,SlotOdds=0.330000,MinSecsToNextSound=3.000000,MaxSecsToNextSound=5.000000)
}
