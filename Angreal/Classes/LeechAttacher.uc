//------------------------------------------------------------------------------
// LeechAttacher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Attaches Leeches to the castor.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass.
// + Set LeechClass in default proporties.
// + Set Duration in default proporties -- Dur==0 means that the Leech
//   will never unattach itself.
// + Any other funky stuff you want to do.
// + Don't forget to set up the AngrealInventory related default proporties.
//------------------------------------------------------------------------------
// How this class works:
//
//------------------------------------------------------------------------------
class LeechAttacher expands AngrealInventory;

// How long does this effect last?
// This number gets used for all the leeches installed.
// That way they will all get unattached at the same time.
var() float Duration;
//var float NextCastTime;

// The reflector to install. 
var() class<Leech> LeechClasses[10];

// The type of Installer to use.
var() class<AttachLeechEffect> AttachLeechEffectClass;

//------------------------------------------------------------------------------
function Cast()
{
	local AttachLeechEffect Attacher;
	local int i;
/*
	// Enforce duration.
	if( Level.TimeSeconds < NextCastTime )
		return;

	NextCastTime = Level.TimeSeconds + Duration;
*/	
	for( i = 0; 
	     i < ArrayCount(LeechClasses) &&
		 LeechClasses[i] != None; 
		 i++ )
	{
		//Attacher = Spawn( AttachLeechEffectClass );
		Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, AttachLeechEffectClass ) );
		Attacher.SetSourceAngreal( Self );

		// Set its victim to be our owner so the leeches will be 
		// attached to him/her.
		Attacher.SetVictim( Pawn(Owner) );
		
		// Initialize it with the appropriate Leech type and lifespan
		Attacher.Initialize( LeechClasses[i], Duration );
			
		// Pass it off to our owner for processing.
		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).ProcessEffect( Attacher );
		}
		else if( WOTPawn(Owner) != None )
		{
			WOTPawn(Owner).ProcessEffect( Attacher );
		}
	}

	Super.Cast();
	UseCharge();
}
/*
//------------------------------------------------------------------------------
function float GetPriority()
{
	if( Level.TimeSeconds < NextCastTime )
	{
		return 0.0;
	}
	else
	{
		return Super.GetPriority();
	}
}
*/
defaultproperties
{
    AttachLeechEffectClass=Class'AttachLeechEffect'
    Priority=20.00
}
