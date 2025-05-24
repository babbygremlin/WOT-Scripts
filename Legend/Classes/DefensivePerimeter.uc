//=============================================================================
// DefensivePerimeter.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class DefensivePerimeter expands NotifierProxy;



function Touch( Actor Other )
{
	DefensiveDetector( ActualNotifier ).OnPerimeterCompromised( Other );
	Super.Touch( Other );
}

defaultproperties
{
     bCanTeleport=True
     bCollideActors=True
}
