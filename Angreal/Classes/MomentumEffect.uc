//------------------------------------------------------------------------------
// MomentumEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Throws the victim.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize it with the amount of momentum to transfer.
// + Set the Victim.
// + Set the SourceAngreal.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class MomentumEffect expands SingleVictimEffect;

var vector Momentum;

//------------------------------------------------------------------------------
// Sets the momentum to give to the victim.
//------------------------------------------------------------------------------
function Initialize( vector Momentum )
{
	Self.Momentum = Momentum;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	Momentum = vect(0,0,0);
}

//------------------------------------------------------------------------------
// Throw the victim.
//------------------------------------------------------------------------------
function Invoke()
{
	Victim.AddVelocity( Momentum );
}
	
//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local MomentumEffect NewInvokable;

	NewInvokable = MomentumEffect(Super.Duplicate());

	NewInvokable.Momentum = Momentum;
		
	return NewInvokable;
}

defaultproperties
{
     bDeleterious=True
}
