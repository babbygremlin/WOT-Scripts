//=============================================================================
// MovementPatternLegion0.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class MovementPatternLegion0 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=64.000000,MPE_bApplySpeed=True,MPE_Speed=500.000000,MPE_Name=ClosingIN,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=75.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=32.000000))
     MovementPatternElements(1)=(MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=64.000000,MPE_bApplySpeed=True,MPE_Name=BackingOff,MPE_PreHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=64.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=128.000000))
}
