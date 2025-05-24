//------------------------------------------------------------------------------
// ReflectEffectsReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ReflectEffectsReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// If we receive a "bad" Invokable, shove it back into its Instigator's face.
//
// Note: This function is non re-entrant.
//------------------------------------------------------------------------------
singular function ProcessEffect( Invokable I )
{
	if( I.bDeleterious )
	{
		if( WOTPlayer(I.Instigator) != None )
		{
			WOTPlayer(I.Instigator).ProcessEffect( I );
		}
		else if( WOTPawn(I.Instigator) != None )
		{
			WOTPawn(I.Instigator).ProcessEffect( I );
		}
	}
	else
	{
		Super.ProcessEffect( I );
	}
}

defaultproperties
{
     Priority=248
     bDisplayIcon=False
}
