//=============================================================================
// DoorTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================
class DoorTrigger expands Trigger;

var() enum EDirection 
{
	DIR_Forward,		// Moves to keyframe 1, then back to 0
	DIR_Backward,		// Moves to keyframe 2, then back to 0
} Direction;

function DispatchTrigger( Actor Target, Actor Other, Pawn OtherInstigator )
{
	if( DoorMover( Target ) != None )
	{	
		if( DoorMover( Target ).IsUnlocked( Other ))
		{
			if( Direction == DIR_Forward )
			{
				Target.GotoState( , 'ForwardOpening' );
			}
			else
			{
				Target.GotoState( , 'BackwardOpening' );
			}
		}
	}
	else
	{
		Super.DispatchTrigger( Target, Other, OtherInstigator );
	}
}

defaultproperties
{
}
