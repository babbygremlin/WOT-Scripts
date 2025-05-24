//------------------------------------------------------------------------------
// ForkEffectsReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ForkEffectsReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// If we receive a "bad" Invokable, shove it back into its Instigator's face,
// but also give a copy to ourself.
//
// Note: This function is non re-entrant.
//------------------------------------------------------------------------------
singular function ProcessEffect( Invokable I )
{
	//local Invokable Copy;

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

		if( Owner != I.Instigator )
		{
			//Copy = I.Duplicate();
			//Copy.Instigator = Pawn(Owner);
			I.Instigator = Pawn(Owner);

			if( WOTPlayer(Owner) != None )
			{
				WOTPlayer(Owner).ProcessEffect( I/*Copy*/ );
			}
			else if( WOTPawn(Owner) != None )
			{
				WOTPawn(Owner).ProcessEffect( I/*Copy*/ );
			}
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
     bRemoveExisting=True
     bDisplayIcon=False
}
