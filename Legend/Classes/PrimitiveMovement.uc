//=============================================================================
// PrimitiveMovement.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PrimitiveMovement expands AiComponent;

enum EPrimitiveMovement
{
	PM_None,
	PM_MoveForward,
	PM_MoveBackward,
	PM_StrafeLeft,
	PM_StrafeRight,
	PM_RotateLeft,
	PM_RotateRight
};



static function EPrimitiveMovement GetPrimitiveMovement( int DeltaYaw )
{
	local EPrimitiveMovement PrimitiveMovement;

	if( ( DeltaYaw >= -8192 ) && ( DeltaYaw <= 8192 ) )
	{
		//the forward ninety degrees
		PrimitiveMovement = PM_MoveForward;
	}
	else if( ( DeltaYaw < -8192 ) && ( DeltaYaw > -24576 ) )
	{
		//the left ninety degrees
		PrimitiveMovement = PM_StrafeLeft;
	}
	else if( ( DeltaYaw > 8192 ) && ( DeltaYaw < 24576 ) )
	{
		//the right ninety degrees
		PrimitiveMovement = PM_StrafeRight;
	}
	else if( ( ( DeltaYaw <= -24576 ) && ( DeltaYaw >= -32768 ) ) ||
			( ( DeltaYaw >= 24576 ) && ( DeltaYaw <= 32768 ) ) )
	{
		//the rear ninety degrees
		PrimitiveMovement = PM_MoveBackward;
	}
	else
	{
		PrimitiveMovement = PM_None;
		Log( "::MovementManager::GetPrimitiveMovement hyper bogus!" );
		Log( "::MovementManager::GetPrimitiveMovement DeltaYaw: " $ DeltaYaw );
	}
	return PrimitiveMovement;
}



static function EPrimitiveMovement GetPrimitiveRotation( int DeltaYaw )
{
	local EPrimitiveMovement PrimitiveMovementRotation;
 	if( DeltaYaw > 0 )
 	{
		PrimitiveMovementRotation = PM_RotateRight;
	}
	else
	{
		PrimitiveMovementRotation = PM_RotateLeft;
	}
	return PrimitiveMovementRotation;
}



static function int MakeMinimumRotationComponent( int RotationComponent )
{
	local bool bComponentInitiallyPositive;
	
	if( RotationComponent != 0 )
	{
	 	if( RotationComponent > 0 )
	 	{
	 		//initially going right
			bComponentInitiallyPositive = true;
		}
		else
		{
	 		//initially going left
			bComponentInitiallyPositive = true;
		}
		
		RotationComponent = RotationComponent & 65535;
		
		if( RotationComponent > 32767 )
	 	{
	 		//looped around turning to the other way
	 		RotationComponent = RotationComponent & 32767;
	 		if( bComponentInitiallyPositive )
	 		{
	 			//was going right but it is shorter to go left
		 		RotationComponent = RotationComponent - 32767;
		 	}
		 	else
		 	{
	 			//was going left but it is shorter to go right
			 	RotationComponent = 32767 - RotationComponent;
	 		}
	 	}
	}
	return RotationComponent;
}

defaultproperties
{
}
