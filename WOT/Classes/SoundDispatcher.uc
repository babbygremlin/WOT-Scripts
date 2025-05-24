//=============================================================================
// SoundDispatcher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//
// Receives a trigger as input, then triggers a set of events with optional delays, 
// and plays sounds on actors with tags matching the "SoundSourceTag"
//
// if the Instigator moves away from the SoundSource/Self by more than the specified 
// distance (MaxDistance) the dispatcher is suspended or terminated (as determined 
// by its bTerminate configuration).
//
// WARNING: There is no timeout for the "MaxDistance" test -- it is assumed that 
// the level designer will ensure that the SoundDispatcher is either terminated, 
// or allowed (at some point) to complete the sequence, and shut down 
// (or retrigger) normally.
//
// By default, the "Sound" is used as the sound effect, however, an optional 
// SoundTableTag may be scripted instead to support more complex dialog interactions.
//=============================================================================
class SoundDispatcher expands Trigger;

var() struct SoundEvent
{
	var() float Delay;			// relative delay *before* generating event
	var() name  Event;			// event to generate
	var() name  SoundSourceTag;	// tag to use to find sound source
	var() sound Sound;			// sound to play (ignore SoundTableTag)
	var() name  SoundTableTag;	// tag to use to find SoundTable object
	var() name  SoundTableSlot;	// Sound Table slot to use when playing
}
EventList[16];

var() ESoundSlot	SoundSlot;			// slot used to play all sounds in this SoundDispatcher
var() float			SoundVolume;		// volume used to play all sounds in this SoundDispatcher
var() bool			bSoundOverride;		// overrride setting used to play all sounds in this SoundDispatcher
var() float			SoundRadius;		// radius used to play all sounds in this SoundDispatcher
var() float			SoundPitch;			// pitch used to play all sounds in this SoundDispatcher
var() int			MaxDistance;		// distance at which dispatcher is suspended or terminated (always in range if 0)
var() bool			bFromSoundSource;	// measure MaxDistance between Instigator and SoundSource (otherwise, use Self)
var() bool			bTerminate;			// terminate dispatcher when MaxDistance is exceeded

// private variables used in the state SoundDispatcher code
var actor SoundSource;

// "local" variables used in state SoundDispatcher code
var SoundTableInterf SoundTable;
var int i;

state() SoundDispatcher
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		// track the pawn that caused the trigger for the MaxDistance evaluation
		Instigator = EventInstigator;

		GotoState( 'SoundDispatcher', 'Dispatch' );
	}

	function bool OutOfRange( Actor A )
	{
		local Actor B;

		if( bFromSoundSource && SoundSource != None )
		{
			B = SoundSource;
		}
		else
		{
			B = Self;
		}

		// if MaxDistance is 0, then always in range
		return MaxDistance != 0 && VSize( B.Location - A.Location ) > MaxDistance;
	}

Dispatch:
	Disable( 'Touch' );
	Disable( 'Trigger' );
	for( i = 0; i < ArrayCount(EventList); i++ )
	{
		while( Instigator != None && OutOfRange( Instigator ) )
		{
			if( bTerminate )
			{
				SetCollision( false );
				Stop;
			}
			Sleep( 0.1 ); // cycle 10 times/s waiting for instigator to come within range of the reference actor
		}
		if( EventList[i].Event != '' || EventList[i].SoundSourceTag != '' )
		{
			Sleep( EventList[i].Delay );
			if( EventList[i].Event != '' )
			{
				foreach AllActors( class'Actor', Target, EventList[i].Event )
				{
					Target.Trigger( Self, Instigator );
				}
			}
			if( EventList[i].SoundSourceTag != '' )
			{
				foreach AllActors( class'Actor', Target, EventList[i].SoundSourceTag )
				{
					SoundSource = Target;
					break;
				}

				if( SoundSource != None )
				{
					if( EventList[i].Sound != None )
					{
						SoundSource.PlaySound( EventList[i].Sound, SoundSlot, SoundVolume, bSoundOverride, SoundRadius, SoundPitch );
					}
					else if( EventList[i].SoundTableTag == '' )
					{
						class'util'.static.BMWarnR( Self, Self $ ": neither Sound nor SoundTableTag set for SoundDispatcher " $ "(Tag: " $ EventList[i].SoundTableTag $  " Entry: #" $ i $ ")" );
					}
					else
					{
						foreach AllActors( class'SoundTableInterf', SoundTable, EventList[i].SoundTableTag )
						{
							if( EventList[i].SoundTableSlot == '' )
							{
								class'util'.static.BMWarnR( Self, Self $ ": slot for SoundDispatcher " $ "(Tag: " $ EventList[i].SoundTableTag $ " Entry: #" $ i $ ") isn't set!" );
							}
							else
							{
								SoundTable.PlaySlotSound( SoundSource, EventList[i].SoundTableSlot, 1.0, 1.0, 1.0 );
							}
							break;
						}
					}
				}
				else
				{
					// class'util'.static.BMWarnR( Self, Self $ ": SoundSource is None -- no Actor in level has the tag: " $ EventList[i].SoundSourceTag );
				}
			}
		}
	}
	SoundSource = None;
	Enable( 'Trigger' );
	Enable( 'Touch' );
}

defaultproperties
{
     SoundSlot=SLOT_Misc
     SoundVolume=1.000000
     SoundRadius=2048.000000
     SoundPitch=1.000000
     InitialState=SoundDispatcher
     Texture=Texture'Engine.S_Dispatcher'
}
