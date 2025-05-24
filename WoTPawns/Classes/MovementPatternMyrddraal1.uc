//=============================================================================
// MovementPatternMyrddraal1.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class MovementPatternMyrddraal1 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=4.000000,MPE_Speed=650.000000,MPE_Name=Sniping,MPE_PreHint=Snipe,MPE_WaypointParams=(WP_OffsetDirection=(Y=-1.000000),WP_bRequireReachable=False))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_SelectionIntervalRel=RR_GreaterOrEqual,MPE_SelectionInterval=3.000000,MPE_GoalVelocitySizeRel=RR_Equal,MPE_bApplySpeed=True,MPE_Speed=650.000000,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=128.000000))
     MovementPatternElements(2)=(MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=40.000000,MPE_bApplySpeed=True,MPE_Speed=750.000000,MPE_Name=Attack,MPE_PreHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDistance=True,WP_OffsetDistance=64.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=100.000000))
     MovementPatternElements(3)=(MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=100.000000,MPE_bApplySpeed=True,MPE_Speed=775.000000,MPE_Name=PerformTeleportation,MPE_PreHint=MyrddraalTeleport,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_bApplyOffsetDistance=True,WP_OffsetDistance=48.000000))
}
