//=============================================================================
// PrimitiveMovementAnimater.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PrimitiveMovementAnimater expands AiComponent;

struct AnimParamsT
{
	var Name	AP_AnimName;
	var float 	AP_TweenTime;
	var float 	AP_Rate;
	var float	AP_MinRate;
};

var () name	AnimationNames[6];
var () name	IdleAnimationName;


//=============================================================================
// begin - Animation utility functions
//=============================================================================



function LoopMovementAnim( Pawn AnimatedPawn,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	local AnimParamsT MovementAnimParams;
	InitMovementAnimParams( MovementAnimParams, AnimatedPawn,
			MovementManagerUsed, PrimitiveMovementUsed );
	LoopAnimOnParams( AnimatedPawn, MovementAnimParams );
}



function LoopRotationAnim( Actor AnimatedActor,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	local AnimParamsT RotationAnimParams;
	InitRotationAnimParams( RotationAnimParams, AnimatedActor,
			MovementManagerUsed, PrimitiveMovementUsed );
	LoopAnimOnParams( AnimatedActor, RotationAnimParams );
}



function InitMovementAnimParams( out AnimParamsT MovementAnimParams,
		Pawn AnimatedPawn,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	MovementAnimParams.AP_AnimName = GetMovementAnimationName(
			AnimatedPawn, MovementManagerUsed, PrimitiveMovementUsed );
	MovementAnimParams.AP_Rate = AnimatedPawn.MaxDesiredSpeed /
			AnimatedPawn.Default.MaxDesiredSpeed;
	MovementAnimParams.AP_TweenTime = 0;
	MovementAnimParams.AP_MinRate = 0;
}



function InitRotationAnimParams( out AnimParamsT RotationAnimParams,
		Actor AnimatedActor,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	RotationAnimParams.AP_AnimName = GetRotationAnimationName(
			AnimatedActor, MovementManagerUsed, PrimitiveMovementUsed );
	RotationAnimParams.AP_Rate = float( AnimatedActor.RotationRate.Yaw ) /
			AnimatedActor.Default.RotationRate.Yaw;
	RotationAnimParams.AP_TweenTime = 0;
	RotationAnimParams.AP_MinRate = 0;
}



function LoopAnimOnParams( Actor AnimatedActor, AnimParamsT LoopAnimParams )
{
	if( LoopAnimParams.AP_AnimName != '' )
	{
		AnimatedActor.LoopAnim( LoopAnimParams.AP_AnimName,
				LoopAnimParams.AP_Rate, LoopAnimParams.AP_TweenTime,
				LoopAnimParams.AP_MinRate );
	}
}



function TweenToIdlePosition( Actor AnimatedActor )
{
	//xxx AnimatedActor.TweenAnim( IdleAnimationName, 0.1 );
	//Log( AnimatedActor $ "::" $ Self $ "::TweenToIdlePosition" );
	AnimatedActor.TweenAnim( 'Breath', 0.1 );
}



function TweenFromStrafeAnimLoop( Actor AnimatedActor )
{
	TweenToIdlePosition( AnimatedActor );
}



function TweenFromRotationAnimLoop( Actor AnimatedActor )
{
	TweenToIdlePosition( AnimatedActor );
}




//=============================================================================
// end - Animation utility functions
//=============================================================================



function Name GetMovementAnimationName( Actor MovingActor,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	local name MovementAnimationName;
	local int AnimationNamesIdx;
	
	AnimationNamesIdx = PrimitiveMovementUsed. GetActorPrimitiveMovement(
			MovingActor, MovementManagerUsed.ReturnFocus() ) - 1;
	
	if( ( AnimationNamesIdx >= 0 ) &&
			( AnimationNamesIdx <= ArrayCount( AnimationNames ) ) )
	{
		MovementAnimationName = AnimationNames[ AnimationNamesIdx ];
	}
	
	return MovementAnimationName;
}



function Name GetRotationAnimationName( Actor MovingActor,
		MovementManagerInterf MovementManagerUsed,
		PrimitiveActorMovement PrimitiveMovementUsed )
{
	local name RotationAnimationName;
	local int AnimationNamesIdx;
	
	AnimationNamesIdx = PrimitiveMovementUsed.GetActorPrimitiveRotation(
			MovingActor, MovementManagerUsed.ReturnFocus() ) - 1;
	
	if( ( AnimationNamesIdx >= 0 ) &&
			( AnimationNamesIdx <= ArrayCount( AnimationNames ) ) )
	{
		RotationAnimationName = AnimationNames[ AnimationNamesIdx ];
	}

	return RotationAnimationName;
}

defaultproperties
{
}
