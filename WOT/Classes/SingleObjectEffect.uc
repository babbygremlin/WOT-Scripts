//------------------------------------------------------------------------------
// SingleObjectEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Effects that simply effect one object and need no more 
//				information.
//------------------------------------------------------------------------------
// How to use this class:
//
// Subclass this class for effects that simply reqire a reference to an
// actor.  Implement your Invoke function and any other needed support
// fuctions.  Don't forget to Initialize() your object before Invoke 
// gets called.
//------------------------------------------------------------------------------
class SingleObjectEffect expands Invokable
	abstract;

//////////////////////
// Member variables //
//////////////////////
var Actor Item;		// What acting on? -- no pun intended.

/////////////////////
// Setup functions //
/////////////////////

//------------------------------------------------------------------------------
function Initialize( Actor NewItem )
{
    Item = NewItem;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	Item = None;
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local SingleObjectEffect NewInvokable;

	NewInvokable = SingleObjectEffect(Super.Duplicate());

	NewInvokable.Item = Item;
	
	return NewInvokable;
}

defaultproperties
{
}
