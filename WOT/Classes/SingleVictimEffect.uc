//------------------------------------------------------------------------------
// SingleVictimEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Effects that need a single vicitm specified before they can be 
//				invoked.
//------------------------------------------------------------------------------
// How to use this class:
//
// Subclass this for any effects that simply need to effect one pawn.
// Remember to call the SetVictim before Invoke gets called.
// Simply override Invoke in your subclass and include any helper
// functions needed to support it.
//------------------------------------------------------------------------------
// Note for the sane:
//
// You may be asking, why not just use the SingleObjectEffect.  The answer
// lies in "purpose".  If you are subclassing a SingleVictimEffect, it makes
// it clear that the purpose of your class is to effect a "person".  
// SingleObjectEffects can work on anything and convey no purpose to the 
// reader.  There are two extremes I could have gone to when creating these
// interfaces.  First, I could have created an interface for every single 
// combination I needed - which would have kind of defeated the purpose of
// creating the interfaces in the first place.  Second, I could have created
// an interface that took one actor, two actors, three actors, and so on for
// as many parameters as I needed.  I choose something in between.  The 
// benifit of this approach is that purpose gets built into the class 
// hierarchy and makes it easier for you, the reader, to understand. 
//
// As it turns out, I never used SingleObjectEffect... oh well.
//------------------------------------------------------------------------------
class SingleVictimEffect expands Invokable
	abstract;

//////////////////////
// Member variables //
//////////////////////
var Pawn Victim;	// Who are we effecting?

/////////////////////
// Setup functions //
/////////////////////

//------------------------------------------------------------------------------
function SetVictim( Pawn NewVictim )
{
    Victim = NewVictim;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	Victim = None;
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local SingleVictimEffect NewInvokable;

	NewInvokable = SingleVictimEffect(Super.Duplicate());

	NewInvokable.Victim = Victim;
	
	return NewInvokable;
}

defaultproperties
{
}
