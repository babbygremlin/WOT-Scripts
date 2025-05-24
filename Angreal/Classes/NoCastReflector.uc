//------------------------------------------------------------------------------
// NoCastReflector
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Aborts calls to UseAngreal and CeaseUsingAngreal.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class NoCastReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//-----------------------------------------------------------------------------
// Turn the currently selected angreal on.
//-----------------------------------------------------------------------------
function UseAngreal()
{
	// Do _not_ pass Go, do _not_ collect $200.
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal off.
//-----------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	// Do _not_ pass Go, do _not_ collect $200.
}

defaultproperties
{
    Priority=255
}
