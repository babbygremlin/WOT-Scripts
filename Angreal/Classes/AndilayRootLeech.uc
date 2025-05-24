//------------------------------------------------------------------------------
// AndilayRootLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class AndilayRootLeech expands Leech;

var() float MaxAffectResolution;
var() float MinAffectResolution;

var() float MaxHealSpeed;	// The fastest you can travel and still get healed.

var() int HealingAmount;	// Amount given per AffectResolution.

var() int NumCharges;		// Number of health points to give to Owner.

var() int MaxCharges;		// Maximum number of charges we can have at a given moment in time.

var int PeakCharges;

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	local IncreaseHealthEffect Healer;

	if( Owner != None && Pawn(Owner).Health > 0 )
	{
		// Don't use if we're already at a max.
		if( Pawn(Owner).Health < Pawn(Owner).default.Health )
		{
			//Healer = Spawn( class'IncreaseHealthEffect' );
			Healer = IncreaseHealthEffect( class'Invokable'.static.GetInstance( Self, class'IncreaseHealthEffect' ) );
			Healer.Initialize( GetCharges() );
			Healer.SetVictim( Pawn(Owner) );
			Healer.InitializeWithLeech( Self );
			if( WOTPlayer(Owner) != None )
			{
				WOTPlayer(Owner).ProcessEffect( Healer );
			}
			else if( WOTPawn(Owner) != None )
			{
				WOTPawn(Owner).ProcessEffect( Healer );
			}

			// See if we are all used up.
			if( NumCharges <= 0 )
			{
				UnAttach();
				Destroy();
			}
		}
	}
	else
	{
		Unattach();
		Destroy();
	}
}

//------------------------------------------------------------------------------
function GiveCharges( int Amount )
{
	NumCharges = Min( NumCharges + Amount, MaxCharges );
}

//------------------------------------------------------------------------------
function int GetCharges()
{
	local int Charges;

	if( NumCharges >= HealingAmount )
	{
		Charges = HealingAmount;
		NumCharges -= HealingAmount;
	}
	else
	{
		Charges = NumCharges;
		NumCharges = 0;
	}

	return Charges;
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	local float Scalar;

	if( Owner != None )
	{
		// Regulate AffectResolution based on Owner's speed.
		Scalar = VSize(Owner.Velocity) / MaxHealSpeed;	// The faster they go, the slower they get healed.
		AffectResolution = MinAffectResolution + (Scalar * (MaxAffectResolution - MinAffectResolution));

		// Hack for icon info.
		// NOTE[aleiby]: Fix this hack (requires Add/RemoveIconInfo redesign).
		PeakCharges = Max( PeakCharges, NumCharges );
		if( PeakCharges > 0 )
		{
			LifeSpan = (float(NumCharges) / float(PeakCharges)) * default.LifeSpan;
		}
	}

	Super.Tick( DeltaTime );
}

defaultproperties
{
    MaxAffectResolution=0.80
    MinAffectResolution=0.20
    MaxHealSpeed=400.00
    HealingAmount=1
    MaxCharges=100
    AffectResolution=10000.00
    bDisplayIcon=True
    bRemovable=False
    bSingular=True
    LifeSpan=10000.00
}
