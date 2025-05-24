//------------------------------------------------------------------------------
// LightningDamageNotifyer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	Notifies our SourceAngreal when our Owner takes damage.
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class LightningDamageNotifyer expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType)
{
	AngrealInvLightning(SourceAngreal).NotifyDamagedBy( InstigatedBy );

	// Reflect funciton call to next reflector in line.
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

defaultproperties
{
     Priority=64
     bRemovable=False
     bDisplayIcon=False
}
