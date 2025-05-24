//------------------------------------------------------------------------------
// IncreaseHealthEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Gives health to the victim.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize it with the amount of health to give.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class IncreaseHealthEffect expands SingleVictimEffect;

var int Health;

//------------------------------------------------------------------------------
// Sets the amount of health to give the 'victim'.
//------------------------------------------------------------------------------
function Initialize( int Amount )
{
	Health = Amount;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	Health = 0;
}

//------------------------------------------------------------------------------
// Give health to victim.
//------------------------------------------------------------------------------
function Invoke()
{
	if( WOTPlayer(Victim) != None )
	{
		WOTPlayer(Victim).IncreaseHealth( Health );
	}
	else if( WOTPawn(Victim) != None )
	{
		WOTPawn(Victim).IncreaseHealth( Health );
	}
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local IncreaseHealthEffect NewInvokable;

	NewInvokable = IncreaseHealthEffect(Super.Duplicate());

	NewInvokable.Health = Health;
	
	return NewInvokable;
}		

defaultproperties
{
}
