//=============================================================================
// PitOpening.uc
// $Author: Mpoesch $
// $Date: 10/20/99 6:58p $
// $Revision: 3 $
//=============================================================================
class PitOpening expands Teleporter;

var PitTrap ThePitTrap;

function Touch( Actor Other )
{
	if( Other.bCanTeleport )
	{
		ThePitTrap.Accept( Other );
	}
}

function bool Accept( actor Other )
{
	local rotator R;
	local Pawn P;
	local vector DeltaLocation;

	DeltaLocation = ThePitTrap.Location - Other.Location;
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

// end of PitOpening.uc

defaultproperties
{
     URL="PitTrap"
     bCollideWhenPlacing=False
     Tag=PitX
     CollisionRadius=128.000000
}
