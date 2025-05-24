//=============================================================================
// MovementPatternTrollocWeak0.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MovementPatternTrollocWeak0 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=16.000000,MPE_bApplySpeed=True,MPE_Speed=475.000000,MPE_Name=Pursue,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=16.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=16.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=32.000000,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=2.000000,MPE_GoalVelocitySizeRel=RR_LessOrEqual,MPE_GoalVelocitySize=64.000000,MPE_bApplySpeed=True,MPE_Speed=475.000000,MPE_Name=BackOff1,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=128.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=64.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=32.000000,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=3.000000,MPE_GoalVelocitySizeRel=RR_Equal,MPE_bApplySpeed=True,MPE_Speed=500.000000,MPE_Name=BackOff2,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=48.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=96.000000))
     MovementPatternElements(3)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=96.000000,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=2.000000,MPE_GoalVelocitySizeRel=RR_LessOrEqual,MPE_GoalVelocitySize=64.000000,MPE_bApplySpeed=True,MPE_Speed=425.000000,MPE_Name=Lunge1,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=96.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
     MovementPatternElements(4)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=96.000000,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=2.500000,MPE_GoalVelocitySizeRel=RR_Equal,MPE_bApplySpeed=True,MPE_Speed=450.000000,MPE_Name=Lunge2,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=96.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
}
