//------------------------------------------------------------------------------
// SourceDestinationEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Effects that need both a source and a destination object before
//				they can be invoked.
//------------------------------------------------------------------------------
// How to use this class:
//
// Subclass this class for effects that require both a source and destination 
// object.  Then implement the Invoke function to provide the functionality
// then the proverbial trigger is fired.  Include and helper functions you need
// and don't forget to call the initialize function before the Invoke function
// gets called.
//------------------------------------------------------------------------------
class SourceDestinationEffect expands Invokable
	abstract;

//////////////////////
// Member variables //
//////////////////////
var Actor Source;		// What are we originating from?
var Actor Destination;	// Where are we going to?

/////////////////////
// Setup functions //
/////////////////////

//------------------------------------------------------------------------------
function Initialize( Actor NewSource, Actor NewDestination )
{
    Source = NewSource;
	Destination = NewDestination;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	Source = None;
	Destination = None;
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local SourceDestinationEffect NewInvokable;

	NewInvokable = SourceDestinationEffect(Super.Duplicate());

	NewInvokable.Source			= Source;
	NewInvokable.Destination	= Destination;
	
	return NewInvokable;
}

defaultproperties
{
}
