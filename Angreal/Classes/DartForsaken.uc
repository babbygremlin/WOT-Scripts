//=============================================================================
// DartForsaken.
//=============================================================================
class DartForsaken expands AngrealInvDart;

function PreBeginPlay()
{
	local AngrealInvDart Replacement;

	Replacement = Spawn( class'AngrealInvDart', Owner, Tag, Location, Rotation );
	Replacement.SetColor( 'Red' );
	Replacement.MinInitialCharges = MinInitialCharges;
	Replacement.MaxInitialCharges = MaxInitialCharges;
	Replacement.MaxCharges = MaxCharges;
	Replacement.ChargeCost = ChargeCost;
	
	Destroy();
}

defaultproperties
{
    ProjectileClassName="Angreal.RedDart"
    StatusIconFrame=Texture'Icons.M_Dartblck'
    StatusIcon=Texture'Icons.I_Dartblck'
    Skin=Texture'Skins.DartForsaken'
}
