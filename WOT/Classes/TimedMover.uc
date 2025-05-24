//=============================================================================
// TimedMover.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class TimedMover expands Mover;

var enum eMoverState 
{
	MVSTATE_Opening,
	MVSTATE_Closing,
} MoverState;

var(TimedMover) float Delays[8];
var(TimedMover) float MoveTimes[8];
var(TimedMover) sound Sounds[8];

var int x;



function EnableTriggers( BOOL Enable )
{
	local Trigger T;
	
	// Find the matching triggers for this mover.
	foreach AllActors( class 'Trigger', T )
	{
		if( T.Event == Tag )
		{
			if( Enable )
			{
				T.Enable( 'Touch' );
				T.Enable( 'Trigger' );
			}
			else
			{
				T.Disable( 'Touch' );
				T.Disable( 'Trigger' );
			}
		}
	}
}



function SetMoverState( eMoverState State )
{
	MoverState = State;
}


//=============================================================================
// state TriggerDoor
//=============================================================================


state() TriggerTimedMover 
{

	function Trigger( actor Other, pawn EventInstigator )
	{
		GotoState(  , 'OpenStart' );
	}
	
	function InterpolateEnd( actor Other ) 
	{
		AmbientSound = None;
	}
	
OpenStart:

	EnableTriggers( FALSE );
	x = 1;

Open:
	
	// Step forward through the keyframes
	SetMoverState( MVSTATE_Opening );
	PlaySound( OpeningSound, SLOT_None );
	
	for( x = x ; x < NumKeys ; x++ )
	{
		InterpolateTo( x, MoveTimes[x] );
		AmbientSound = Sounds[x];
		FinishInterpolation();
	
		Sleep( Delays[x] );
	}

	FinishedOpening();
		
	// Stop here if we need to
	//
	if( bTriggerOnceOnly )
	{
		GotoState('');
	}

CloseStart:

	x = NumKeys - 2;

Close:

	// Step backwards through the keyframes
	//
	SetMoverState( MVSTATE_Closing );
	PlaySound( ClosingSound, SLOT_None );
	
	for( x = x ; x > -1 ; x-- )
	{
		InterpolateTo( x, MoveTimes[x] );
		AmbientSound = Sounds[x];
		FinishInterpolation();
	
		Sleep( Delays[x] );
	}
	
	FinishedClosing();

	EnableTriggers( TRUE );
	Stop;
}



function MakeGroupReturn()
{
	bInterpolating = false;
	AmbientSound = None;
	
	if( MoverState == MVSTATE_OPENING )
	{
		GoToState( , 'Close' );
	}
	if( MoverState == MVSTATE_CLOSING )
	{
		GoToState( , 'Open' );
	}
}



function MakeGroupStop()
{
	bInterpolating = false;
	AmbientSound = None;
	EnableTriggers( TRUE );
}

defaultproperties
{
}
