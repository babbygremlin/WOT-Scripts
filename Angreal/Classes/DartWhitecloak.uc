//=============================================================================
// DartWhitecloak.
//=============================================================================
class DartWhitecloak expands AngrealInvDart;

function PreBeginPlay()
{
	local AngrealInvDart Replacement;

	Replacement = Spawn( class'AngrealInvDart', Owner, Tag, Location, Rotation );
	Replacement.SetColor( 'Gold' );
	Replacement.MinInitialCharges = MinInitialCharges;
	Replacement.MaxInitialCharges = MaxInitialCharges;
	Replacement.MaxCharges = MaxCharges;
	Replacement.ChargeCost = ChargeCost;
	
	Destroy();
}

defaultproperties
{
    ProjectileClassName="Angreal.YellowDart"
    StatusIconFrame=Texture'Icons.M_Dartgld'
    StatusIcon=Texture'Icons.I_Dartgld'
    Skin=Texture'Skins.DartWhitecloak'
}
