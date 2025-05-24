//=============================================================================
// RangeHandlerMeleeAttacking.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerMeleeAttacking expands RangeHandler;



function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	RadiusExtension = Constrainer.GetCurrentMaxMeleeDistance( RangeActor );
	HeightExtension	= FMax( 0, Constrainer.GetCurrentMaxMeleeDistance( RangeActor ) -
			RangeActor.CollisionHeight );
	//Log( "::RangeHandlerMeleeAttacking::GetActorCylinderExtension" );
	//Log( "		RadiusExtension: " $ RadiusExtension );
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_ObjIntersectReq=OIR_Require)
}
