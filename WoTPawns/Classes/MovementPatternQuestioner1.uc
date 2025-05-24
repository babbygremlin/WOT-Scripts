//=============================================================================
// MovementPatternQuestioner1.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class MovementPatternQuestioner1 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=100.000000,MPE_bApplySpeed=True,MPE_Speed=750.000000,MPE_Name=ShieldThrow1,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=64.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=200.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=100.000000,MPE_bApplySpeed=True,MPE_Speed=750.000000,MPE_PostHint=BackOff,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=96.000000,WP_ReqTravelDistanceRel=RR_GreaterOrEqual,WP_ReqTravelDistance=250.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=350.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=200.000000,MPE_bApplySpeed=True,MPE_Speed=825.000000,MPE_Name=Charge,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=100.000000))
}
