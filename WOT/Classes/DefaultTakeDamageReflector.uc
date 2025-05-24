//------------------------------------------------------------------------------
// DefaultTakeDamageReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Handles TakeDamage Reflected calls for WOTPlayers or WOTPawns.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultTakeDamageReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Default implementation.  Just use the superclass' implementation.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType)
{
	// Call superclass' version.
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).SuperTakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).SuperTakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	}

	// Reflect funciton call to next reflector in line.
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
