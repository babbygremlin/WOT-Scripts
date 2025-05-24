//------------------------------------------------------------------------------
// DamageEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Wrapper for TakeDamage()
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Initialize the damage info.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class DamageEffect expands SingleVictimEffect;

// The projectile responsible for creating me.
var AngrealProjectile SourceAngrealProjectile;

// TakeDamage parameters.
var int Damage;
var Pawn EventInstigator;
var vector HitLocation;
var vector Momentum;
var name DamageType;

//------------------------------------------------------------------------------
// Initialize the TakeDamage parameters and set the SourceAngrealProjectile.
//------------------------------------------------------------------------------
function Initialize( int DDamage, Pawn EEventInstigator, vector HHitLocation, vector MMomentum, name DDamageType, AngrealProjectile SourceProj )
{
	Damage = DDamage;
	EventInstigator = EEventInstigator;
	HitLocation = HHitLocation;
	Momentum = MMomentum;
	DamageType = DDamageType;
	SourceAngrealProjectile = SourceProj;
}

//------------------------------------------------------------------------------
function Reset()
{
	Super.Reset();
	SourceAngrealProjectile = None;
	Damage = 0;
	EventInstigator = None;
	HitLocation = vect(0,0,0);
	Momentum = vect(0,0,0);
	DamageType = '';
}

//------------------------------------------------------------------------------
// TakeDamage on my Victim.
//------------------------------------------------------------------------------
function Invoke()
{
	if( Victim != None )
	{
		Victim.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType );
	}
}
	
//------------------------------------------------------------------------------
function Invokable Duplicate()
{
	local DamageEffect NewInvokable;

	NewInvokable = DamageEffect(Super.Duplicate());

	NewInvokable.SourceAngrealProjectile	= SourceAngrealProjectile;
	NewInvokable.Damage						= Damage;
	NewInvokable.EventInstigator			= EventInstigator;
	NewInvokable.HitLocation				= HitLocation;
	NewInvokable.Momentum					= Momentum;
	NewInvokable.DamageType					= DamageType;
		
	return NewInvokable;
}	

defaultproperties
{
     bDeleterious=True
}
