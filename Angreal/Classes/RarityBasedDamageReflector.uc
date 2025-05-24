//------------------------------------------------------------------------------
// RarityBasedDamageReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	Damages the Owner based on rarity when a charge is used.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class RarityBasedDamageReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Notification for when a charge has been used.
//------------------------------------------------------------------------------
function ChargeUsed( AngrealInventory Ang )
{
	local DamageEffect DE;
	local int Damage;

	// How can we use a charge if we ain't got no angreal, eh?
	if( Ang == None )
	{
		warn( "We ain't got no angreal." );
		return;
	}
	//assert( Ang != None );

	// Set damage based on rarity.
	if		( Ang.bCommon	) Damage = Ang.TAINT_COMMON_DAMAGE;
	else if	( Ang.bUncommon	) Damage = Ang.TAINT_UNCOMMON_DAMAGE;
	else if	( Ang.bRare		) Damage = Ang.TAINT_RARE_DAMAGE;

	// Damage the player.
	if( Damage > 0 )
	{
		if( WOTPawn(Owner) != None )
		{
			//DE = Spawn( class'DamageEffect' );
			DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
			DE.InitializeWithReflector( Self );
			DE.Initialize( Damage, Instigator, Owner.Location, vect(0,0,0), /*class'AngrealInventory'.static.GetDamageType( SourceAngreal )*/'SelfInflicted', None );
			DE.SetVictim( Pawn(Owner) );
			WOTPawn(Owner).ProcessEffect( DE );
		}
		else if( WOTPlayer(Owner) != None )
		{
			//DE = Spawn( class'DamageEffect' );
			DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
			DE.InitializeWithReflector( Self );
			DE.Initialize( Damage, Instigator, Owner.Location, vect(0,0,0), /*class'AngrealInventory'.static.GetDamageType( SourceAngreal )*/'SelfInflicted', None );
			DE.SetVictim( Pawn(Owner) );
			WOTPlayer(Owner).ProcessEffect( DE );
		}
	}

	// Pass control onto next reflector.
	Super.ChargeUsed( Ang );
}

defaultproperties
{
     Priority=64
     bDeleterious=True
}
