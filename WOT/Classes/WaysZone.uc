//=============================================================================
// WaysZone.
//=============================================================================
class WaysZone expands WOTZoneInfo
	intrinsic;

var() float Visibility; 	// Unreal units (distance to BSP render clip)

var() byte WaysBrightness;	// ambient glow surrounding player in this zone
var() byte WaysSaturation;
var() byte WaysHue;
var() byte WaysRadius;

event ActorEntered( actor Other )
{
	if( PlayerPawn(Other)!=None )
	{
		// turn the player's ambient glow on
		PlayerPawn(Other).LightType			= LT_Steady;
		PlayerPawn(Other).LightEffect		= LE_NonIncidence;
		PlayerPawn(Other).LightBrightness	= WaysBrightness;
		PlayerPawn(Other).LightSaturation	= WaysSaturation;
		PlayerPawn(Other).LightRadius		= WaysRadius;
	}
}

event ActorLeaving( actor Other )
{
	if( PlayerPawn(Other)!=None )
	{
		// turn the player's ambient glow off
		PlayerPawn(Other).LightType = LT_None;
	}
}

// end of WaysZone.uc

defaultproperties
{
     Visibility=1024.000000
     WaysBrightness=24
     WaysSaturation=255
     WaysRadius=32
}
