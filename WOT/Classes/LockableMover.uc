//=============================================================================
// LockableMover.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class LockableMover expands Mover;

var() bool bUnlocked;
var() bool bStayUnlocked;

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
var Actor UnlockingActor;

var bool bNoBump;

function bool CheckForKey( pawn Pawn )
{
	local Inventory Inv;

	for( Inv = Pawn.Inventory; Inv!=None; Inv = Inv.Inventory )   
	{
		// if the inventory "Event" matches the Mover's "Tag", this is the key
		if( Inv.Event == Tag )
			return true;
	}
	
	return false;
}

state() BumpOpenTimed
{
	function Bump( actor Other )
	{
		if( bNoBump ) return;

		if( !bUnlocked )
		{
			if( Pawn(Other) != None )
			{
				if( CheckForKey( Pawn(Other) ) )
				{
					if( bStayUnlocked )
					{
						bUnlocked = true;
					}

					if( WOTPlayer(Other) != None && UnLockMessage != "" )
					{
						WOTPlayer(Other).HandMessage( UnLockMessage, UnLockMessageDuration );
					}
					PlaySound( UnLockSound, SLOT_None );

					UnlockingActor = Other;
					GotoState('BumpOpenTimed', 'FinishUnlock');
					bNoBump = true;
					return;
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
					return;
				}
			}
		}

		Super.Bump( Other );
	}

FinishUnlock:
	Sleep( UnLockDuration );
	bNoBump = false;
	Super.Bump( UnlockingActor );
}

// end of LockableMover.uc

defaultproperties
{
     MinLockSoundTime=1.000000
     LockedMessage="The door is locked."
     UnLockMessage="You use the key to unlock the door."
     LockedMessageDuration=4.000000
     UnLockMessageDuration=4.000000
}
