//------------------------------------------------------------------------------
// IgnoreDamageEffectsReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	If we receive a damage effect, we throw it away.
//				This should have a fairly high priority since we don't
//				want any other Reflector to handle it first.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class IgnoreDamageEffectsReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Only pass this effect on to latter reflectors if it is NOT a DamageEffect.
//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if( DamageEffect(I) == None )
	{
		Super.ProcessEffect( I );
	}
	else if( GenericProjectile(DamageEffect(I).SourceAngrealProjectile) != None )
	{
		// NOTE[aleiby]: This might bite us in the butt if the angreal specification
		// changes too much.
		//
		// This seems like kind-of a hack, but it's really the best place to 
		// put it.  Essentially, if you're not going to take damage from an 
		// AngrealProjectile, then the projectile shouldn't explode.
		// The only time this reflector should be installed is when the 
		// reflect reflector is also installed, and if that reflector is 
		// installed the only types of Projectiles that will reach you,
		// use DamageEffects to affect the player.  Thus making it not explode
		// and destroying it are ok using the current angreal specification.
		//
		GenericProjectile(DamageEffect(I).SourceAngrealProjectile).bExplode = false;

		// We have to destroy it manually since it won't explode now.
		DamageEffect(I).SourceAngrealProjectile.Destroy();
	}
	else
	{
		// Just throw it away.
	}
}

defaultproperties
{
    Priority=255
    bDisplayIcon=False
}
