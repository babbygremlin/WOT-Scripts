//------------------------------------------------------------------------------
// WOTFootZoneChangeReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Handles FootZoneChanges for HealZones for WOTPlayers or WOTPawns.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class WOTFootZoneChangeReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function FootZoneChange( ZoneInfo newFootZone )
{
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).SuperFootZoneChange( newFootZone );
	}
	else if( WOTPawn(Owner) != None )
	{
		WOTPawn(Owner).SuperFootZoneChange( newFootZone );
	}
	
	if( WOTZoneInfo( newFootZone ) != None && WOTZoneInfo( newFootZone ).bHealZone )
	{
		if( Pawn(Owner) != None )
		{
			Pawn(Owner).PainTime = 0.01;
		}
	}

	// Reflect function call to next reflector in line.
	Super.FootZoneChange( newFootZone );
}

defaultproperties
{
     Priority=128
     bRemovable=False
     bDisplayIcon=False
}
