//=============================================================================
// MovementPatternMyrddraal0.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MovementPatternMyrddraal0 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=200.000000,MPE_bApplySpeed=True,MPE_Speed=625.000000,MPE_Name=Charge,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
     MovementPatternElements(1)=(MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=150.000000,MPE_bApplySpeed=True,MPE_Speed=650.000000,MPE_Name=Attacking1,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=32.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=70.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=48.000000,MPE_bApplySpeed=True,MPE_Speed=625.000000,MPE_Name=Attacking2,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=32.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
     MovementPatternElements(3)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=96.000000,MPE_bApplySpeed=True,MPE_Speed=550.000000,MPE_Name=BackOff,MPE_WaypointParams=(WP_bApplyOffsetDistance=True,WP_OffsetDistance=96.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=96.000000))
     MovementPatternElements(4)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=32.000000,MPE_bApplySpeed=True,MPE_Speed=500.000000,MPE_Name=Charge3,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
     MovementPatternElements(5)=(MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=75.000000,MPE_bApplySpeed=True,MPE_Speed=450.000000,MPE_Name=BackOff,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=1.000000),WP_bApplyOffsetDistance=True))
     MovementPatternElements(6)=(MPE_bApplySpeed=True,MPE_Speed=550.000000,MPE_Name=LungeAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=60.000000))
}
