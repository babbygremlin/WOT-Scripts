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
     StatusIconFrame=Texture'Angreal.Icons.M_Dartgld'
     StatusIcon=Texture'Angreal.Icons.I_Dartgld'
     Skin=Texture'Angreal.Skins.DartWhitecloak'
}
