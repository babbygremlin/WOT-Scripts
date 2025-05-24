//------------------------------------------------------------------------------
// DamageTakeDamageReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//------------------------------------------------------------------------------
class DamageTakeDamageReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Default implementation.  Just use the superclass' implementation.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType)
{
	local bool bDoDamage;

	bDoDamage = true;

	if( !Owner.IsA( 'Pawn' ) )
	{
		// not a pawn
		bDoDamage = false;
	}
	else 
	{
		if( Pawn(Owner).Health <= 0 )
		{
			// already dead
			bDoDamage = false;
		}
		else if( (Owner.Tag == 'balefired') && (Pawn(Owner).Health - Damage <= 0) ) 
		{
			// was killed (or will be) by balefire
			bDoDamage = false;
		}
	}

	if( bDoDamage )
	{
		if( WOTPlayer(Owner) != None && WOTPlayer(Owner).ReducedDamageType != 'All' && WOTPlayer(Owner).AssetsHelper != None )
		{
			WOTPlayer(Owner).AssetsHelper.HandleDamage( Damage, HitLocation, DamageType );
		}
		else if( WOTPawn(Owner) != None && WOTPawn(Owner).AssetsHelper != None )
		{
			WOTPawn(Owner).AssetsHelper.HandleDamage( Damage, HitLocation, DamageType );
		}
	}

	// Reflect function call to next reflector in line.
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
