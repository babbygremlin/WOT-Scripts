//=============================================================================
// ShieldReturnToSenderReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================
// Note: Since the reflector code is using an "extended" collision cylinder
// paradigm this means that the odd projectile might get through which might
// actually result in added realism.
//=============================================================================

class ShieldReturnToSenderReflector expands ReturnToSenderReflector;

var () name IrreleventProjectileType;
var () bool bDeflect; //if set to true the reflector will deflect instead of reflect
var () bool bLeadWhenReflecting; //if set to true the reflector will reflect with leading as normal

// How accurate the shield will deflect the projectiles.
// Larger ratios (Aim/Velo) produce more deflecting behavior, while Smaller ratios are more like reflecting.
// These variables are indexed by difficulty.
var () float AimWeight[3];
var () float VeloWeight[3];



simulated function OnReflectedTouch( GenericProjectile HitProjectile )
{
	//a projectile is reflected if it is relevant and the damage is redirected
	if( IsRelevant( HitProjectile ) && RedirectImpactDamage( HitProjectile ) )
	{
		Super.OnReflectedTouch( HitProjectile );
	}
}



function bool IsRelevant( GenericProjectile HitProjectile )
{
	return ( IrreleventProjectileType == '' ) || ( !HitProjectile.IsA( IrreleventProjectileType ) );
}


//=============================================================================
// Each time a projectile is reflected, this class sends a trigger back to its
// owner with the projectile as the triggering actor.
//=============================================================================
function bool RedirectImpactDamage( GenericProjectile HitProjectile )
{
	local Pawn OwnerPawn;
	local bool bRedirectImpactDamage;
	
	OwnerPawn = Pawn( Owner );
	if( ( OwnerPawn != None ) && ( OwnerPawn.SelectedItem != None ) )
	{
		//Damage selected item
		class'Util'.static.TriggerActor( Self, OwnerPawn, None, 'Reflected' );
		OwnerPawn.SelectedItem.TakeDamage( HitProjectile.Damage, None, vect( 0, 0, 0 ), vect( 0, 0, 0 ), HitProjectile.DamageType );
		bRedirectImpactDamage = true;
	}
	return bRedirectImpactDamage;
}



function SpawnImpactEffect( vector AimLoc ) { /*Don't do any frilly stuff.*/ }



/////////////////////////
// Overriden Functions //
/////////////////////////



function DoAdjustVelocity( GenericProjectile InProjectile, GenericProjectile OutProjectile )
{
	local Vector AimDir;

	if( bDeflect )
	{
		AimDir = Normal( InProjectile.Location - OwnerLocation );

		// Make sure it always get deflected back towards the direction it came from.
		AimDir = AimDir << rotator(-InProjectile.Velocity);
		AimDir.X = Abs(AimDir.X);
		AimDir = AimDir >> rotator(-InProjectile.Velocity);

		// Make them aim towards the instigator more.
		// NOTE[aleiby]: Don't be baffled by the syntax.  This is really simple to understand once you break it down.  We're just weighting the direction vector towards either the deflect vector or the reflect vector based on Difficulty.
		AimDir = ((AimWeight[Level.Game.Difficulty]*AimDir) + (VeloWeight[Level.Game.Difficulty]*Normal(-InProjectile.Velocity))) / (AimWeight[Level.Game.Difficulty]+VeloWeight[Level.Game.Difficulty]);
		
		OutProjectile.Velocity = VSize( InProjectile.Velocity ) * AimDir;
	}
	else if( !bLeadWhenReflecting )
	{
		OutProjectile.Velocity = VSize( InProjectile.Velocity ) * Normal( InProjectile.Instigator.Location - OwnerLocation );
	}
	else
	{
		Super.DoAdjustVelocity( InProjectile, OutProjectile );
	}
}



/*
simulated function AdjustVelocity( out GenericProjectile HitProjectile )
{
	// Calc normal reflect angle.
	HitProjectile.Velocity = VSize( HitProjectile.Velocity ) * Normal( HitProjectile.Location - OwnerLocation );
}
*/

defaultproperties
{
     bLeadWhenReflecting=True
     AimWeight(0)=1.000000
     AimWeight(1)=1.000000
     VeloWeight(0)=3.000000
     VeloWeight(1)=7.000000
     VeloWeight(2)=1.000000
}
