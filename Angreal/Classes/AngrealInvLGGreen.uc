//------------------------------------------------------------------------------
// AngrealInvLGGreen.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvLGGreen expands AngrealInvLightGlobe;

function PreBeginPlay()
{
	local AngrealInvLightGlobe Replacement;

	Replacement = Spawn( class'AngrealInvLightGlobe', Owner, Tag, Location, Rotation );
	Replacement.SetColor( 'Green' );
	Replacement.MinInitialCharges = MinInitialCharges;
	Replacement.MaxInitialCharges = MaxInitialCharges;
	Replacement.MaxCharges = MaxCharges;
	Replacement.ChargeCost = ChargeCost;
	
	Destroy();
}

defaultproperties
{
     LightType=Class'Angreal.LightGlobeGreen'
}
