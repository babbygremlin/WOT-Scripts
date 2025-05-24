//------------------------------------------------------------------------------
// ShakeViewEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Wrapper for PlayerPawn::ShakeView()
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize the shake view info.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class ShakeViewEffect expands SingleVictimEffect;

// ShakeView parameters.
var float ShakeTime;
var float RollMag;
var float VertMag;

//------------------------------------------------------------------------------
// Initialize the ShakeView parameters.
//------------------------------------------------------------------------------
function Initialize( float STime, float RMag, float VMag )
{
	ShakeTime = STime;
	RollMag = RMag;
	VertMag = VMag;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	ShakeTime = 0.0;
	RollMag = 0.0;
	VertMag = 0.0;
}

//------------------------------------------------------------------------------
// ShakeView on my Victim.
//------------------------------------------------------------------------------
function Invoke()
{
	if( PlayerPawn(Victim) != None )
	{
		PlayerPawn(Victim).ShakeView( ShakeTime, RollMag, VertMag );
	}
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local ShakeViewEffect NewInvokable;

	NewInvokable = ShakeViewEffect(Super.Duplicate());

	NewInvokable.ShakeTime	= ShakeTime;
	NewInvokable.RollMag	= RollMag;
	NewInvokable.VertMag	= VertMag;
		
	return NewInvokable;
}	

defaultproperties
{
     bDeleterious=True
}
