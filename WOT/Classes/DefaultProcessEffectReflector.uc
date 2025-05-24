//------------------------------------------------------------------------------
// DefaultProcessEffectReflector
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Handles ProcessEffect reflected calls in the default manner
//				by simply calling the given Invokable's Invoke() routine.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultProcessEffectReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Default implementation.  Simply calls the Invokable's Invoke() routine.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	I.Invoke();	

	// The buck stops here.  Don't call any other reflected functions.
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
