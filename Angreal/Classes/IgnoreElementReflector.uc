//------------------------------------------------------------------------------
// IgnoreElementReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	Superclass for all Ignore*ElementReflectors where * is Air,
//				Earth, Fire, Spirit or Water.  This allows us to maintain all
//				the common code in one place.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass.
// + Override ProcessEffect() and call the IgnoreEffect() on the effects
//   you wish to ignore and Super.ProcessEffect() on all the rest.
//------------------------------------------------------------------------------
class IgnoreElementReflector expands Reflector
	abstract;

var() class<ShieldParticleMesh> ImpactType;

var() Sound DeflectSound;

var() name TriggerEvent;

var() name IgnoredDamageType;	// Air, Earth, Fire, Water or Spirit.

//////////////////////////
// Overridden Functions //
//////////////////////////

//------------------------------------------------------------------------------
function Install( Pawn NewHost )
{
	local Actor IterA;
	local AppearEffect AE;

	Super.Install( NewHost );

	if( NewHost != None && Owner == NewHost )
	{
		if( TriggerEvent != '' )
			foreach AllActors( class'Actor', IterA, TriggerEvent )
				IterA.Trigger( Self, Pawn(Owner) );

		RemoveDeleteriousEffects();

		AE = Spawn( class'AppearEffect' );
		if( WOTPlayer(Owner) != None )
		{
			AE.SetColors( WOTPlayer(Owner).PlayerColor );
		}
		else
		{
			AE.SetColors( 'Green' );
		}
		AE.bFadeIn = false;
		AE.SetAppearActor( Owner );
	}
}

//------------------------------------------------------------------------------
function Uninstall()
{
	local Actor IterA;

	if( Pawn(Owner) != None && TriggerEvent != '' )
		foreach AllActors( class'Actor', IterA, TriggerEvent )
			IterA.UnTrigger( Self, Pawn(Owner) );

	Super.Uninstall();
}

//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, name DamageType )
{
	if( class'AngrealInventory'.static.DamageTypeContains( DamageType, IgnoredDamageType ) )
	{
		SpawnImpactEffect( Hitlocation );
	}
	else
	{
		// Pass on to next reflector.
		Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	}
}

//////////////////////
// Helper Functions //
//////////////////////

//------------------------------------------------------------------------------
function IgnoreEffect( Invokable I )
{
	// Don't ignore good things, or things we do to ourself (like taint damage).
	if( !I.bDeleterious || I.SourceAngreal == SourceAngreal )
	{
		Super.ProcessEffect( I );
	}
	else
	{
		if( I.SourceProjectile != None )
		{
			// Aim towards the projectile.
			SpawnImpactEffect( I.SourceProjectile.Location );

			// Don't let GenericProjectiles explode.
			if( GenericProjectile(I.SourceProjectile) != None )
			{
				GenericProjectile(I.SourceProjectile).bExplode = false;

				// We have to destroy it manually since it won't explode now.
				I.SourceProjectile.Destroy();
			}
		}
		else if( I.Instigator != Owner )
		{
			// Aim towards the instigator.
			SpawnImpactEffect( I.Instigator.Location );
		}
	}
}

//------------------------------------------------------------------------------
function SpawnImpactEffect( vector AimLoc )
{
	local ShieldParticleMesh Visual;

	// Spawn cool effect.
	Visual = Spawn( ImpactType, Owner,, Owner.Location );
	//Visual.SetFollowActor( Owner );

	// Play cool sound.
	if( DeflectSound != None )
	{
		Owner.PlaySound( DeflectSound );
	}
}

//------------------------------------------------------------------------------
function RemoveDeleteriousEffects()
{
	local Leech L;
	local Reflector R;

	local LeechIterator IterL;
	local ReflectorIterator IterR;

	IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(Owner) );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.bDeleterious && L.bRemovable && InvIsIgnored( L.SourceAngreal ) )
		{
			L.UnAttach();
			L.Destroy();
		}
	}
	IterL.Reset();
	IterL = None;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(Owner) );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.bDeleterious && R.bRemovable && InvIsIgnored( R.SourceAngreal ) )
		{
			R.UnInstall();
			R.Destroy();
		}
	}
	IterR.Reset();
	IterR = None;
}

//------------------------------------------------------------------------------
function bool InvIsIgnored( AngrealInventory Inv )
{
	return false;	// Override in subclasses.
}

defaultproperties
{
    TriggerEvent=ElementalTriggered
    Priority=255
    bRemoveExisting=True
}
