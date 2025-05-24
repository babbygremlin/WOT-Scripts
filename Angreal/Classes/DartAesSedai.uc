//=============================================================================
// DartAesSedai.
//=============================================================================
class DartAesSedai expands AngrealInvDart;

function PreBeginPlay()
{
	local AngrealInvDart Replacement;

	Replacement = Spawn( class'AngrealInvDart', Owner, Tag, Location, Rotation );
	Replacement.SetColor( 'Blue' );
	Replacement.MinInitialCharges = MinInitialCharges;
	Replacement.MaxInitialCharges = MaxInitialCharges;
	Replacement.MaxCharges = MaxCharges;
	Replacement.ChargeCost = ChargeCost;
	
	Destroy();
}

defaultproperties
{
}
