//=============================================================================
// RangeHandlerFacing.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerFacing expands RangeHandler;

//face the goal if within MaxFacingRadiusFactor times the actor's collision radius
const MaxFacingRadiusFactor = 5;



function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	RadiusExtension = RangeActor.CollisionRadius * MaxFacingRadiusFactor;
	HeightExtension = 0;
	//Log( "::RangeHandlerFacing::GetActorCylinderExtension" );
	//Log( "		RadiusExtension: " $ RadiusExtension );
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal')
}
