//=============================================================================
// SoundTableInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class SoundTableInterf expands LegendAssetComponent abstract;



enum EGameType
{
	GT_All,
	GT_SinglePlayer,
	GT_MultiPlayer,
	GT_Battle,
	GT_Arena,
	GT_None,
};



struct EngineSoundInfoT
{
	var() string			SoundString;		// "package.group.name" for actual sound to play
	var() ESoundSlot		Slot;				// slot to pass to PlaySound
	var() float				Volume;				// volume to pass to PlaySound
	var() bool				bNoOverride;		// bNoOverride flag to pass to PlaySound
	var() float				Radius;				// radius to pass to PlaySound
	var() float				Pitch;				// pitch to pass to PlaySound
};



struct SoundInfoT
{
	var() Name				SoundSlot;			// sound category (can have multiple sounds per slot)
	var() float				SoundOdds; 			// Odds of sound being used (within a slot)
	var() EGameType			GameType;			// game type(s) where sound is used
	
	var() EngineSoundInfoT	ESoundInfo;			// PlaySound parameters
};



const DefaultPitch = 1.0;						// default pitch if not given

static function SoundTableInterf GetInstance( Actor Owner );
static function RandomizeSoundSlotTimerList( SoundSlotTimerListInterf SlotTimerList );
function PlaySlotSound( Actor SourceActor, name SoundSlot, float VolumeMultiplier, float RadiusMultiplier, float PitchMultiplier, optional SoundSlotTimerListInterf SlotTimerList );

defaultproperties
{
}
