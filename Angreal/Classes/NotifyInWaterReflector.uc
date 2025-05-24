//------------------------------------------------------------------------------
// NotifyInWaterReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Notifies listeners when the Pawn enters water.
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class NotifyInWaterReflector expands Reflector;

// Technical Note: I would generalize this to handle anyone who wants to listen
// using Interfaces, but since we do not have them currently, I will simply
// hard code it for LightningStrike's, use.

var() float PollingTime;	// How often to check if we are in water.
var float PollingTimer;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( Pawn(Owner) != None )
	{
		PollingTimer += DeltaTime;
		if( PollingTimer >= PollingTime )
		{
			PollingTimer = 0.0;
			if
			(	Pawn(Owner).FootRegion.Zone.bWaterZone
			&&	AngrealInvLightning(SourceAngreal) != None
			)
			{
				AngrealInvLightning(SourceAngreal).NotifyPawnEnteredWater( Pawn(Owner) );
			}
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function FootZoneChange( ZoneInfo newFootZone )
{
	if( newFootZone.bWaterZone && AngrealInvLightning(SourceAngreal) != None )
	{
		AngrealInvLightning(SourceAngreal).NotifyPawnEnteredWater( Pawn(Owner) );
	}

	// Reflect function call to next reflector in line.
	Super.FootZoneChange( newFootZone );
}

defaultproperties
{
     PollingTime=0.500000
     Priority=64
     bRemovable=False
     bDisplayIcon=False
}
