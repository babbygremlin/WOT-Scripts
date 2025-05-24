//=============================================================================
// Statue.
//=============================================================================

class Statue expands BreakableDecoration;

//=============================================================================
// If breakable and made of stone etc., we should really have rock fragments.

defaultproperties
{
     bMovable=False
     Physics=PHYS_Falling
     bDirectional=True
}
