//------------------------------------------------------------------------------
// DecreaseHealthLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//
// Description:	Decreases the victim's health over time.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Since just one point is taken from the victim's health per iteration, 
//   make sure you set the AffectResolution to how often you want that 
//   one point taken away.
//------------------------------------------------------------------------------
class DecreaseHealthLeech expands Leech;

// How often WOTPawns _react_ to being hurt with decay.
// (Health is still decreased linearly.  This is just used for 
// visual/audio feedback.)
var() float MinPainReactPerMinute;
var() float MaxPainReactPerMinute;

var float NextReact;
var float ReactTime;

// How much damage to take off per hit.
var() float DamagePerHit;

// How much momentum to transfer per hit.
var() vector Momentum;

function AffectHost( optional int Iterations )
{
	local DamageEffect DE;
	
	if( Pawn(Owner) != None && Pawn(Owner).Health > 0 )
	{
		//DE = Spawn( class'DamageEffect' );
		DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
		DE.InitializeWithLeech( Self );
		DE.Initialize( DamagePerHit * Iterations, Instigator, Owner.Location, Momentum, 'continuous', None );
		DE.SetVictim( Pawn(Owner) );
		if( WOTPawn(Owner) != None )
		{
			WOTPawn(Owner).ProcessEffect( DE );
		}
		else if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).ProcessEffect( DE );
		}
	}
	
	// Only do this if he/she is still not dead.
	if( Pawn(Owner) != None && Pawn(Owner).Health > 0 )
	{
		// Cause WOTPawns and WOTPlayers to occasionally "double-over" due to dainage of health.
		ReactTime += AffectResolution * Iterations;

		if( ReactTime >= NextReact )
		{
			NextReact = 60 / (MinPainReactPerMinute + FRand()*(MaxPainReactPerMinute-MinPainReactPerMinute));
			ReactTime = 0;

			//DE = Spawn( class'DamageEffect' );
			DE = DamageEffect( class'Invokable'.static.GetInstance( Self, class'DamageEffect' ) );
			DE.InitializeWithLeech( Self );
			DE.Initialize( 0, Instigator, Owner.Location, vect(0,0,0), class'AngrealInventory'.static.GetDamageType( SourceAngreal ), None );
			DE.SetVictim( Pawn(Owner) );
			if( WOTPawn(Owner) != None )
			{
				WOTPawn(Owner).ProcessEffect( DE );
			}
			else if( WOTPlayer(Owner) != None )
			{
				WOTPlayer(Owner).ProcessEffect( DE );
			}
		}
	}
	else
	{
		Unattach();
	}
}

defaultproperties
{
     MinPainReactPerMinute=10.000000
     MaxPainReactPerMinute=60.000000
     DamagePerHit=1.000000
     AffectResolution=0.200000
     bDeleterious=True
     bDisplayIcon=True
}
