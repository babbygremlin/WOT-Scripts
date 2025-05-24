//------------------------------------------------------------------------------
// NoBadEffectsReflector
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Blocks all deleterious incoming Invokables.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class NoBadEffectsReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( !I.bDeleterious )
	{
		Super.ProcessEffect( I );
	}
}

defaultproperties
{
    Priority=255
    bRemovable=False
    bDisplayIcon=False
}
