//------------------------------------------------------------------------------
// NullProcessEffectReflector
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Blocks all incoming Invokables.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class NullProcessEffectReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	// The buck stops here.  Don't call any other reflected functions.
}

defaultproperties
{
     Priority=255
     bRemovable=False
     bDisplayIcon=False
}
