//------------------------------------------------------------------------------
// ShieldReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Redirects half of the damage to a shield element.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ShieldReflector expands Reflector;

#exec AUDIO IMPORT FILE=Sounds\Shield\DeflectSD.wav         GROUP=Shield

// Percentage of damage redirected to the shield. (0 to 100)
var() int ShieldReduceDamagePct;

// The sound played when damage is redirected by shield.
var() Sound ShieldDeflectSound;

// Max shield points the owner can have when using this.
var() int MaxShieldHitPoints;

// Used to alternate damage calculations.
var bool bCalcOrder;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function Install( Pawn NewHost )
{
	if( WOTPlayer(NewHost) != None )
	{
		WOTPlayer(NewHost).ShieldHitPoints = MaxShieldHitPoints;
	}
	else if( WOTPawn(NewHost) != None )
	{
		WOTPawn(NewHost).ShieldHitPoints = MaxShieldHitPoints;
	}

	Super.Install( NewHost );

	// Catch failure.
	if( Owner != NewHost )
	{
		if( WOTPlayer(NewHost) != None )
		{
			WOTPlayer(NewHost).ShieldHitPoints = 0;
		}
		else if( WOTPawn(NewHost) != None )
		{
			WOTPawn(NewHost).ShieldHitPoints = 0;
		}
	}
}

//------------------------------------------------------------------------------
function UnInstall()
{
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).ShieldHitPoints = 0;
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).ShieldHitPoints = 0;
	}

	Super.UnInstall();
}

//------------------------------------------------------------------------------
// Redirect half of the damage to a shield element.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType)
{
	local int PlayerDamage, ShieldDamage;
	local bool bUnInstall;

	// Compute percentages of damage applied to player and shield.
	bCalcOrder = !bCalcOrder;	// Alternate order of calculations (to even out rounding errors).
	if( bCalcOrder )
	{
		PlayerDamage = Damage * ShieldReduceDamagePct / 100;
		ShieldDamage = Damage - PlayerDamage;
	}
	else
	{
		ShieldDamage = Damage * ShieldReduceDamagePct / 100;
		PlayerDamage = Damage - ShieldDamage;
	}
    
    Owner.PlaySound( ShieldDeflectSound );

	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).ShieldHitPoints -= ShieldDamage;

		if( WOTPlayer(Owner).ShieldHitPoints <= 0 ) 
		{
			// Apply excess damage to player.
			// (Note: this is actually addition since ShieldHitPoints is negative.)
			PlayerDamage -= WOTPlayer(Owner).ShieldHitPoints;
			WOTPlayer(Owner).ShieldHitPoints = 0;

			bUnInstall = true;
		}
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).ShieldHitPoints -= ShieldDamage;

		if( WOTPawn(Owner).ShieldHitPoints <= 0 ) 
		{
			// Apply excess damage to player.
			// (Note: this is actually addition since ShieldHitPoints is negative.)
			PlayerDamage -= WOTPawn(Owner).ShieldHitPoints;
			WOTPawn(Owner).ShieldHitPoints = 0;

			bUnInstall = true;
		}
	}
	// Reflect function call to next reflector in line using only half of the
	// original damage.
	if( PlayerDamage > 0 )
	{
		Super.TakeDamage( PlayerDamage, InstigatedBy, HitLocation, Momentum, DamageType );
	}

	// This needs to be done last.
	if( bUnInstall )
	{
		UnInstall();
	}
}

//------------------------------------------------------------------------------
function float GetDuration()
{
	local float Duration;

	if( WOTPlayer(Owner) != None )
	{
		Duration = WOTPlayer(Owner).ShieldHitPoints;
	}
	else if( WOTPawn(Owner) != None )
	{
		Duration = WOTPawn(Owner).ShieldHitPoints;
	}
	else
	{
		Duration = MaxShieldHitPoints;
	}

	return Duration;
}

defaultproperties
{
     ShieldReduceDamagePct=50
     ShieldDeflectSound=Sound'Angreal.Shield.DeflectSD'
     MaxShieldHitPoints=50
     Priority=225
     bRemoveExisting=True
}
