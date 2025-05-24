//=============================================================================
// PrimitiveActorMovement.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PrimitiveActorMovement expands PrimitiveMovement;



static function EPrimitiveMovement GetActorPrimitiveMovement( Actor MovingActor,
		GoalAbstracterInterf Focus )
{
	local int 					DeltaYaw;
	local EPrimitiveMovement	PrimitiveMovement;
	local Rotator 				FocusRotation;
	
	Focus.GetAssociatedRotation( MovingActor, FocusRotation );
	DeltaYaw = MakeMinimumRotationComponent( FocusRotation.Yaw - MovingActor.Rotation.Yaw );
	PrimitiveMovement = GetPrimitiveMovement( DeltaYaw );

	return PrimitiveMovement;
}



static function EPrimitiveMovement GetActorPrimitiveRotation( Actor MovingActor,
		GoalAbstracterInterf Focus )
{
	local int 					DeltaYaw;
	local EPrimitiveMovement	PrimitiveMovement;
	local Rotator 				FocusRotation;
	
	Focus.GetAssociatedRotation( MovingActor, FocusRotation );
	DeltaYaw = MakeMinimumRotationComponent( FocusRotation.Yaw - MovingActor.Rotation.Yaw );
	PrimitiveMovement = GetPrimitiveRotation( DeltaYaw );

	return PrimitiveMovement;
}

defaultproperties
{
}
