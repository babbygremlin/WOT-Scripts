//=============================================================================
// RangeHandlerAttacking.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerAttacking expands RangeHandler;

//attack the goal if within MaxAttackingRadiusFactor
//times the actor's collision radius
const MaxAttackingRadiusFactor = 2.5;



function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	RadiusExtension = RangeActor.CollisionRadius * MaxAttackingRadiusFactor;
	HeightExtension = 0;
	//Log( "::RangeHandlerAttacking::GetActorCylinderExtension" );
	//Log( "		RadiusExtension: " $ RadiusExtension );
}

defaultproperties
{
     Template=(HT_SelectorClassWpt=Class'Legend.WaypointSelectorHolding',HT_SelectorClassFcs=Class'Legend.FocusSelectorOnGoal',HT_MinEntryInterval=1.000000)
}
