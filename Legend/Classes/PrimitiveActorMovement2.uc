//=============================================================================
// PrimitiveActorMovement2.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PrimitiveActorMovement2 expands PrimitiveActorMovement;

var EPrimitiveMovement LastPrimitiveMovement;
var EPrimitiveMovement LastPrimitiveRotation;



function InitActorPrimitiveMovement( Actor MovingActor,
		GoalAbstracterInterf MovementDestination )
{
	LastPrimitiveMovement = GetActorPrimitiveMovement( MovingActor, MovementDestination );
}



function InitActorPrimitiveRotation( Actor MovingActor,
		GoalAbstracterInterf MovementDestination )
{
	LastPrimitiveRotation = GetActorPrimitiveRotation( MovingActor, MovementDestination );
}

defaultproperties
{
}
