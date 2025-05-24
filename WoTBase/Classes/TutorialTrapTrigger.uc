//=============================================================================
// TutorialTrapTrigger.uc
// $Author: Mpoesch $
// $Date: 9/09/99 11:41a $
// $Revision: 4 $
//=============================================================================
class TutorialTrapTrigger expands Trigger;

var() name TrapType;
var() name GoodLocationEvent;
var() name BadLocationEvent;
var() name WrongTrapEvent;

function bool Validate( Trap Other, PlayerPawn Instigator )
{
	local int i;
	local Actor A;
	local Trap T;

	// ignore the question... let the Trap code find another trigger
	if( !bInitiallyActive )
	{
		return true;
	}

	if( TrapType != Other.Class.Name )
	{
		foreach AllActors( class'Actor', A, WrongTrapEvent )
		{
			A.Trigger( Other, Instigator );
		}
		return false;
	}

	// verify that the trap is within the radius of this trigger
	foreach RadiusActors( class'Trap', T, CollisionRadius )
	{
		if( T == Other )
		{
			foreach AllActors( class'Actor', A, GoodLocationEvent )
			{
				A.Trigger( Other, Instigator );
			}
			Other.bLocked = true;
			return true;
		}
	}

	// bad placement, abort!
	foreach AllActors( class'Actor', A, BadLocationEvent )
	{
		A.Trigger( Other, Instigator );
	}
	return false;
}

defaultproperties
{
     GoodLocationEvent=GoodLocation
     BadLocationEvent=BadLocation
     bInitiallyActive=False
     InitialState=OtherTriggerToggles
     bCollideActors=False
}
