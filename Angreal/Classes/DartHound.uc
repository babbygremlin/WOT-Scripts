//=============================================================================
// DartHound.
//=============================================================================
class DartHound expands AngrealInvDart;

function PreBeginPlay()
{
	local AngrealInvDart Replacement;

	Replacement = Spawn( class'AngrealInvDart', Owner, Tag, Location, Rotation );
	Replacement.SetColor( 'Purple' );
	Replacement.MinInitialCharges = MinInitialCharges;
	Replacement.MaxInitialCharges = MaxInitialCharges;
	Replacement.MaxCharges = MaxCharges;
	Replacement.ChargeCost = ChargeCost;
	
	Destroy();
}

defaultproperties
{
    ProjectileClassName="Angreal.PurpleDart"
    StatusIconFrame=Texture'Icons.M_Dartgr'
    StatusIcon=Texture'Icons.I_Dartgr'
    Skin=Texture'Skins.DartHound'
}
