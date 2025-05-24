//=============================================================================
// DoorMover.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================
class DoorMover expands Mover;

var enum eDoorState 
{
	DRSTATE_FW_Opening,
	DRSTATE_FW_Closing,
	DRSTATE_BK_Opening,
	DRSTATE_BK_Closing
} DoorState;

var() bool bLockable;			// Is this door locked?  If FALSE, door behaves normally.
var() bool bStayUnlocked;		// Once unlocked, door stays unlocked - no more unlocked messages/sounds.

var() sound LockedSound;
var() sound UnLockSound;

var() float MinLockSoundTime;	// Minimum time between locked sound playing.
var float LastLockedSoundTime;

var() localized string LockedMessage;
var() localized string UnLockMessage;
var() float LockedMessageDuration;
var() float UnLockMessageDuration;

var() float UnLockDuration;	// Amount of time between the player unlocking the door,
							// and the door actually starting to open.
							// Generally, the length of the UnlockSound.

var bool bUnlocked;
	
function BeginPlay()
{
	bUnlocked = !bLockable;
}
					
function bool IsUnlocked( actor Other )
{
	// If we are not lockable, we are always unlocked.
	//
	if( !bLockable )
	{
		return true;
	}
	
	if( Pawn(Other) != None )
	{
		if( CheckForKey( Pawn(Other) ) )
		{
			if( bStayUnlocked && bUnlocked )
			{
				return true;
			}
			
			if( WOTPlayer(Other) != None && UnLockMessage != "" )
			{
				WOTPlayer(Other).HandMessage( UnLockMessage, UnLockMessageDuration );
			}
			PlaySound( UnLockSound, SLOT_None );

			bUnlocked = true;
		}
		else
		{
			if( Level.TimeSeconds >= LastLockedSoundTime + MinLockSoundTime )
			{
				if( WOTPlayer(Other) != None && LockedMessage != "" )
				{
					WOTPlayer(Other).HandMessage( LockedMessage, LockedMessageDuration );
				}
				PlaySound( LockedSound, SLOT_None );
				LastLockedSoundTime = Level.TimeSeconds;
			}
		}
	}
		
	return bUnlocked;
}

function EnableTriggers( bool Enable )
{
	local DoorTrigger D;
	
	// Find the matching triggers for this door.
	foreach AllActors( class 'DoorTrigger', D )
	{
		if( D.Event == Tag )
		{
			if( Enable )
			{
				D.Enable( 'Touch' );
			}
			else
			{
				D.Disable( 'Touch' );
			}
		}
	}
}

function SetDoorState( eDoorState State )
{
	DoorState = State;
}

function bool CheckForKey( pawn Pawn )
{
	local Inventory Inv;

	for( Inv = Pawn.Inventory; Inv!=None; Inv = Inv.Inventory )   
	{
		// if the inventory "Event" matches the Mover's "Tag", this is the key
		if( Inv.Event == Tag )
		{
			return true;
		}
	}
	
	return false;
}

//=============================================================================
// state TriggerDoor
//=============================================================================


state() TriggerDoor 
{
	function InterpolateEnd( actor Other ) 
	{
		AmbientSound = None;
	}
	
ForwardOpening:

	SetDoorState( DRSTATE_FW_Opening );
	
	EnableTriggers( false );
	
	InterpolateTo( 1, MoveTime );
	PlaySound( OpeningSound, SLOT_None );
	AmbientSound = MoveAmbientSound;
	FinishInterpolation();
	FinishedOpening();

	Sleep( StayOpenTime );

ForwardClosing:

	SetDoorState( DRSTATE_FW_Closing );
	
	InterpolateTo( 0, MoveTime );
	PlaySound( ClosingSound, SLOT_None );
	AmbientSound = MoveAmbientSound;
	FinishInterpolation();
	FinishedClosing();

	EnableTriggers( true );
	Stop;

BackwardOpening:

	EnableTriggers( false );
	
	SetDoorState( DRSTATE_BK_Opening );
	
	InterpolateTo( 2, MoveTime );
	PlaySound( OpeningSound, SLOT_None );
	AmbientSound = MoveAmbientSound;
	FinishInterpolation();
	FinishedOpening();

	Sleep( StayOpenTime );

BackwardClosing:
	
	SetDoorState( DRSTATE_BK_Closing );
	
	InterpolateTo( 0, MoveTime );
	PlaySound( ClosingSound, SLOT_None );
	AmbientSound = MoveAmbientSound;
	FinishInterpolation();
	FinishedClosing();

	EnableTriggers( true );
	Stop;
}



function MakeGroupReturn()
{
	bInterpolating = false;
	AmbientSound = None;
	
	if( DoorState == DRSTATE_FW_OPENING)
	{
		GoToState( , 'ForwardClosing' );
	}
	if( DoorState == DRSTATE_FW_CLOSING)
	{
		GoToState( , 'ForwardOpening' );
	}
	if( DoorState == DRSTATE_BK_OPENING)
	{
		GoToState( , 'BackwardClosing' );
	}
	if( DoorState == DRSTATE_BK_CLOSING)
	{
		GoToState( , 'BackwardOpening' );
	}
}



function MakeGroupStop()
{
	bInterpolating = false;
	AmbientSound = None;
	EnableTriggers( true );
}

defaultproperties
{
}
