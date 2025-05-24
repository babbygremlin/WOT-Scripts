//------------------------------------------------------------------------------
// DestroyLocalProjectilesEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	Destroys all the angreal projectiles within the given radius.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class DestroyLocalProjectilesEffect expands SingleVictimEffect;

// How far does this effect reach?
var() float EffectRadius;

//------------------------------------------------------------------------------
// Destroys all the angreal projectiles within the given radius.
//------------------------------------------------------------------------------
function Invoke()
{
	local AngrealProjectile Proj;

	foreach RadiusActors( class'AngrealProjectile', Proj, EffectRadius, Victim.Location )
	{
		Proj.Destroy();

		// NOTE[aleiby]: Play cool effect and sound.
	}
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	EffectRadius = default.EffectRadius;
}

//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local DestroyLocalProjectilesEffect NewInvokable;

	NewInvokable = DestroyLocalProjectilesEffect(Super.Duplicate());

	NewInvokable.EffectRadius = EffectRadius;
	
	return NewInvokable;
}	

defaultproperties
{
    EffectRadius=100.00
}
