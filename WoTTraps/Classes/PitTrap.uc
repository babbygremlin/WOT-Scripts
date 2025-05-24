//=============================================================================
// PitTrap.uc
// $Author: Mpoesch $
// $Date: 10/20/99 10:59p $
// $Revision: 7 $
//=============================================================================
class PitTrap expands Teleporter;

var() int			TrapRadius;
var   PitOpening	ThePitOpening;

function Destroyed()
{
	ThePitOpening.ThePitTrap = None;
	ThePitOpening = None;

	Super.Destroyed();
}

function Hide()
{
	SetCollision( false, false, false );
}

function Show()
{
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}

auto state Waiting
{
	function Bump( actor Other )
	{
		Touch( Other );
	}
	
	function Touch( actor Other )
	{
		local int i;

		if( Pit(Owner).IsInactive( Other ) )
		{
			return;
		}

		// disable the inbound teleporter while a seal or mover is touching
		for( i = 0; i < ArrayCount(Touching); i++ )
		{
			if( Touching[i] != None && Touching[i].IsA( 'Seal' ) )
			{
				return;
			}
		}

		if( Other.bCanTeleport )
		{
			ThePitOpening.Accept( Other );
		}
	}

	function bool Accept( actor Other )
	{
		local rotator R;
		local Pawn P;
		local vector DeltaLocation;

		DeltaLocation = ThePitOpening.Location - Other.Location;
		DeltaLocation.z = 0;
		P = Pawn( Other );
		if( P != None )
		{
			R = P.ViewRotation;
		}
		if( Super.Accept( Other ) )
		{
			Other.SetLocation( Other.Location - DeltaLocation );
			if( P != None )
			{
				P.ViewRotation = R;
			}
		}
	}
}

// end of PitTrap.uc

defaultproperties
{
     TrapRadius=56
     URL="PitOpening"
     bStatic=False
     Tag=PitTrap
     ScaleGlow=0.050000
     CollisionRadius=50.000000
     CollisionHeight=8.000000
}
