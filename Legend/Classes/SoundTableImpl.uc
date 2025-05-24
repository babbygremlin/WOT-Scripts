//=============================================================================
// SoundTableImpl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//=============================================================================

class SoundTableImpl expands SoundTableInterf abstract;

#exec Texture Import File=Textures\S_SoundTable.pcx GROUP=Icons Name=S_SoundTable Mips=Off Flags=2

var(WOTSounds) bool			bSelfTest;			// only enable for testing!
var(WOTSounds) SoundInfoT	SoundList[50];		// list of all sounds for this class



function PostBeginPlay()
{
	Super.PostBeginPlay();

    if( bSelfTest )
	{
		SoundTableSelfTest();
	}
}

//=============================================================================
// Limit class to one instance per owner.

static function SoundTableInterf GetTypeInstance( Actor Owner, Class<SoundTableInterf> C )
{
	local Actor A;
	local SoundTableInterf ReturnedSoundTable;

	ForEach Owner.AllActors( C, A )
	{
		// has to be an *exact* match -- not a subclass matching a superclass
		if( C == A.class && A.Tag == '' )
		{
			ReturnedSoundTable = SoundTableInterf( A );
			break;
		}
	}

	if( ReturnedSoundTable == None )
	{
		ReturnedSoundTable = Owner.Spawn( C );
	}

	ReturnedSoundTable.SetOwner( Owner );

	return ReturnedSoundTable;
}



static function SoundTableInterf GetInstance( Actor Owner )
{
	return GetTypeInstance( Owner, default.class );
}



function bool SoundIsValidForGameType( Actor SourceActor, EGameType GameType )
{
	return true;
}



function SetupAndPlaySound( Actor SourceActor, Sound SelectedSound, int SelectedIndex, float VolumeMultiplier, float RadiusMultiplier, float PitchMultiplier )
{
	local ESoundSlot TSoundSlot;
	local float	TSoundVolume;
	local bool bTSoundNoOverride;
	local float	TSoundRadius;
	local float	TSoundPitch;

	// fetch PlaySound parameters and assign default values where applicable
	TSoundSlot = SoundList[ SelectedIndex ].ESoundInfo.Slot;
	
	TSoundVolume = SoundList[ SelectedIndex ].ESoundInfo.Volume;
	if( TSoundVolume ~= 0.0 )
	{
		TSoundVolume = SourceActor.TransientSoundVolume;
	}
	
	bTSoundNoOverride = SoundList[ SelectedIndex ].ESoundInfo.bNoOverride;
	
	TSoundRadius = SoundList[ SelectedIndex ].ESoundInfo.Radius;
	if( TSoundRadius ~= 0.0 )
	{
		TSoundRadius = SourceActor.TransientSoundRadius;
	}
	
	TSoundPitch = SoundList[ SelectedIndex ].ESoundInfo.Pitch;
	if( TSoundPitch ~= 0.0 )
	{
		TSoundPitch = DefaultPitch;
	}
	
	TSoundVolume = TSoundVolume*VolumeMultiplier;
	TSoundRadius = TSoundRadius*RadiusMultiplier;
	TSoundPitch  = TSoundPitch*PitchMultiplier;

	// class'util'.static.BMLog( SourceActor, "Sound: " $ SelectedSound $ " Slot:" $ TSoundSlot $ ", Vol:" $ TSoundVolume $ ", NoOver:" $ bTSoundNoOverride $ ", Radius: " $ TSoundRadius $ ", Pitch:" $ TSoundPitch );
	SourceActor.PlaySound( SelectedSound, 
						   TSoundSlot,
						   TSoundVolume,
						   bTSoundNoOverride,
						   TSoundRadius,
						   TSoundPitch );

	// xxxrlo: this is a fairly expensive function to call -- accounts 
	// for about 70% of the overhead for calling PlaySlotSound
	// make sure pawns 'hear' this noise if close enough
	SourceActor.MakeNoise( 1.0 );
}



function LoadAndPlaySound( Actor SourceActor, int SelectedIndex, float VolumeMultiplier, float RadiusMultiplier, float PitchMultiplier )
{
	local Sound SelectedSound;

	SelectedSound = Sound( DynamicLoadObject( SoundList[ SelectedIndex ].ESoundInfo.SoundString, class'Sound' ) );

	if( SelectedSound != None )
	{
		SetupAndPlaySound( SourceActor, SelectedSound, SelectedIndex, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
	}
	else
	{
		// DynamicLoadObject should never fail
		class'util'.static.BMWarnR( Self, SourceActor $ "::PlayRandomSlotSound: error loading sound: " $ SoundList[ SelectedIndex ].ESoundInfo.SoundString $ " (" $ Tag $ ")" );
	}
}



function PlayRandomSlotSound( Actor SourceActor, name SoundSlot, float VolumeMultiplier, float RadiusMultiplier, float PitchMultiplier )
{
	local int SoundSlotIndex;
	local int NumMatchingSounds;
	local float TotalOdds;
	local float RandVal;
	local int MatchingEntries[50];
	local Name ThisSoundSlot;
	local int SelectedIndex;

	NumMatchingSounds = 0;
	TotalOdds = 0.0;
	for( SoundSlotIndex=0; SoundSlotIndex<ArrayCount(SoundList); SoundSlotIndex++ )
	{
		ThisSoundSlot = SoundList[SoundSlotIndex].SoundSlot;

		if( ThisSoundSlot == SoundSlot && SoundIsValidForGameType( SourceActor, SoundList[SoundSlotIndex].GameType ) )
		{
			// slot name isn't empty and it matches given slot name and
			// sound is allowed for the current type of game
			if( SoundList[SoundSlotIndex].ESoundInfo.SoundString == "" )
			{
				class'util'.static.BMWarnR( Self, SourceActor $ "::PlayRandomSlotSound: Sound #" $ SoundSlotIndex $ " isn't set for slot " $ SoundSlot $ " (" $ Tag $ ")" );
			}
			else
			{
				MatchingEntries[NumMatchingSounds] = SoundSlotIndex;
				NumMatchingSounds++;
				TotalOdds += SoundList[SoundSlotIndex].SoundOdds;
			}
		}
	}

	if( NumMatchingSounds >= 1 && TotalOdds >= 0.0 )
	{
		if( NumMatchingSounds == 1 )
		{
			// Special case: if only 1 sound, it's odds determine whether it
			// is played at all. This makes a SoundSlotTimerList unnecessary.
			if( FRand() < TotalOdds )
			{
				LoadAndPlaySound( SourceActor, MatchingEntries[0], VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
			}
		}
		else
		{
			RandVal = FRand() * TotalOdds;

			TotalOdds = 0.0;

			for( SoundSlotIndex=0; SoundSlotIndex<NumMatchingSounds; SoundSlotIndex++ )
			{
				TotalOdds += SoundList[ MatchingEntries[SoundSlotIndex] ].SoundOdds;

				if( TotalOdds >= RandVal )
				{
					SelectedIndex = MatchingEntries[SoundSlotIndex];

					LoadAndPlaySound( SourceActor, SelectedIndex, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );

					break;
				}
			}
		}
	}
	else
	{
		// error: no sounds for the given slot found in the SoundTable or odds total 0.0

		if( NumMatchingSounds == 0 )
		{
			// SoundTables do not have to have every slot defined
			// this just means that no sound will be played for the slot.
		}
		else
		{
			class'util'.static.BMWarnR( Self, SourceActor $ ": PlayRandomSlotSound: total odds for " $ SoundSlot $ " are <= 0.0" $ " (" $ Tag $ ")" );
		}
	}
}



function PlaySlotSound( Actor SourceActor, name SoundSlot, float VolumeMultiplier, float RadiusMultiplier, float PitchMultiplier, optional SoundSlotTimerListInterf SlotTimerList )
{
	local int TimeIsUpSlotIndex;

	if( SoundSlot != '' )
	{
		if( SlotTimerList != None )
		{
			if( SlotTimerList.TimeToDoSound( SoundSlot, TimeIsUpSlotIndex ) )
			{
				PlayRandomSlotSound( SourceActor, SoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );

				if( TimeIsUpSlotIndex != SlotTimerList.NullSlotIndex )
				{
					SlotTimerList.RandomizeSoundSlotTimer( TimeIsUpSlotIndex );
				}
			}
		}
		else
		{
		 	PlayRandomSlotSound( SourceActor, SoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
		}
	}
	else
	{
		class'util'.static.BMWarnR( Self, SourceActor $ SourceActor $ "::PlaySlotSound: slot is NULL " $ " (" $ Tag $ ")" );
	}
}



//=============================================================================
// Report any slots which are missing from the SoundTable. It is possible to
// not have some (even many) slots defined in a particular sound table, but 
// this may make it easier to spot problems.

function bool VerifySlots();



//=============================================================================
// Make sure that the given slot (from a SoundTable) is valid. This test will
// fail for "new" slots that are created in a SoundTable which is placed in a
// level then played through a SoundDispatcher, for example, so this test is
// only intended to help with setting up the "standard" SoundTables.


function bool VerifySlot( Name SoundSlot );



//=============================================================================
// Loads and plays every sound in the sound table. Use for testing only -- this
// will eat up a lot of memory.

function SoundTableSelfTest()
{
	local int SoundSlotIndex;

	class'util'.static.BMLog( Self, "" );
	class'util'.static.BMLog( Self, Self.Class $ " SoundTable self-test begin!" );

	VerifySlots();

	for( SoundSlotIndex=0; SoundSlotIndex<ArrayCount(SoundList); SoundSlotIndex++ )
	{
		if( SoundList[SoundSlotIndex].SoundSlot != '' /*&& (SoundList[SoundSlotIndex].GameType != GT_None)*/ )
		{
			if( VerifySlot( SoundList[SoundSlotIndex].SoundSlot ) )
			{
	  			LoadAndPlaySound( Self, SoundSlotIndex, 1.0, 1.0, 1.0 );
			}
			else
			{
				class'util'.static.BMWarnR( Self, "Slot " $ SoundList[SoundSlotIndex].SoundSlot $ " is invalid for " $ Self.Name $ " (" $ Tag $ ")" );
			}
  		}
  	}
	class'util'.static.BMLog( Self, Self.Class $ " SoundTable self-test end!" );
	class'util'.static.BMLog( Self, "" );
}

defaultproperties
{
     Texture=Texture'Legend.Icons.S_SoundTable'
}
