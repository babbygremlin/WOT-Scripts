//=============================================================================
// WOTEffects.
//=============================================================================
class WOTEffects expands Effects;

// derive any effects that can be cancelled by balefire from WOTEffects (not Unreal's Effects)

//=============================================================================
function BalefireHit()
{
	// derived classes should override BalefireHit() as appropriate
}

// end of WOTEffects

defaultproperties
{
}
