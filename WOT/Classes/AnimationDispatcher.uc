//=============================================================================
// AnimationDispatcher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Receives a trigger as input, then triggers a set of events with optional delays, 
// and plays animations [and sounds] on actors with tags matching the 
// "AnimationSourceTag"
//
// If the Instigator moves away from the AnimationSource/Self by more than the specified 
// distance (MaxDistance) the dispatcher is suspended or terminated (as determined 
// by its bTerminate configuration).
//
// WARNING: There is no timeout for the "MaxDistance" test -- it is assumed that 
// the level designer will ensure that the AnimationDispatcher is either terminated, 
// or allowed (at some point) to complete the sequence, and shut down 
// (or retrigger) normally.
//
//=============================================================================
class AnimationDispatcher expands Trigger;

enum EAnimPlayType
{
	APT_Play,
	APT_Loop,
	APT_TweenPlay,
	APT_TweenLoop,
	APT_Tween,
};

var() struct AnimationEvent
{
	var() float			AnimDelay;			// relative delay *before* generating animation event
	var() name			Event;				// event to generate
	var() name			AnimationSourceTag;	// tag to use to find animation source
	var() EAnimPlayType AnimType;			// how to play anim
	var() name			Anim;				// animation to play
	var() float			AnimRate;			// rate to use (if applicable for AnimType)
	var() float			AnimTweenTime;		// tween to time to use (if applicable for AnimType)
	var() float			SoundDelay;			// delay after animation started before playing sound
	var() sound			Sound;				// sound to play (ignore SoundTableTag)
}
EventList[16];

var() int MaxDistance;		// distance at which dispatcher is suspended or terminated (always in range if 0)
var() bool bTerminate;		// terminate dispatcher when MaxDistance is exceeded

// private variables used in the state AnimationDispatcher code
var actor AnimationSource;

// "local" variables used in state AnimationDispatcher code
var int i;

state() AnimationDispatcher
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		// track the pawn that caused the trigger for the MaxDistance evaluation
		Instigator = EventInstigator;

		GotoState( 'AnimationDispatcher', 'Dispatch' );
	}

	function bool OutOfRange( Actor A )
	{
		// if MaxDistance is 0, then always in range
		return MaxDistance != 0 && VSize( AnimationSource.Location - A.Location ) > MaxDistance;
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
		if( EventList[i].Event != '' || EventList[i].AnimationSourceTag != '' )
		{
			Sleep( EventList[i].AnimDelay );
			if( EventList[i].Event != '' )
			{
				foreach AllActors( class'Actor', Target, EventList[i].Event )
				{
					Target.Trigger( Self, Instigator );
				}
			}
			if( EventList[i].AnimationSourceTag != '' )
			{
				foreach AllActors( class'Actor', Target, EventList[i].AnimationSourceTag )
				{
					AnimationSource = Target;
					break;
				}

				if( EventList[i].Anim != '' )
				{
					switch( EventList[i].AnimType )
					{
						case APT_Play:
							AnimationSource.PlayAnim( EventList[i].Anim, EventList[i].AnimRate );
							break;
							
						case APT_Loop:
							AnimationSource.LoopAnim( EventList[i].Anim, EventList[i].AnimRate );
							break;

						case APT_TweenPlay:
							AnimationSource.PlayAnim( EventList[i].Anim, EventList[i].AnimRate, EventList[i].AnimTweenTime );
							break;

						case APT_TweenLoop:
							AnimationSource.LoopAnim( EventList[i].Anim, EventList[i].AnimRate, EventList[i].AnimTweenTime );
							break;

						case APT_Tween:
							AnimationSource.TweenAnim( EventList[i].Anim, EventList[i].AnimTweenTime );
							break;

						default:
							warn( Self $ " invalid AnimType" );
					}
				}
				if( EventList[i].Sound != None )
				{
					Sleep( EventList[i].SoundDelay );
					AnimationSource.PlaySound( EventList[i].Sound );
				}
			}
		}
	}
	AnimationSource = None;
	Enable( 'Trigger' );
	Enable( 'Touch' );
}

defaultproperties
{
     InitialState=AnimationDispatcher
     Texture=Texture'Engine.S_Dispatcher'
}
