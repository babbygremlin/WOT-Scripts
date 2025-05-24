//=============================================================================
// MovementPatternBATrolloc0.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class MovementPatternBATrolloc0 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=150.000000,MPE_bApplySpeed=True,MPE_Speed=750.000000,MPE_Name=Charge,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=48.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=64.000000,MPE_GoalVelocitySizeRel=RR_Equal,MPE_bApplySpeed=True,MPE_Speed=500.000000,MPE_Name=BackOff,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=32.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=128.000000))
}
