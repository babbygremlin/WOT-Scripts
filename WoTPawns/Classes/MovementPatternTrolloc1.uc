//=============================================================================
// MovementPatternTrolloc1.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class MovementPatternTrolloc1 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=550.000000,MPE_Name=Forward_Right,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=150.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=450.000000,MPE_Name=Left,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=150.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=750.000000,MPE_Name=Charge,MPE_WaypointParams=(WP_ReqGoalDistanceRel=RR_LessOrEqual))
     MovementPatternElements(3)=(MPE_bApplySpeed=True,MPE_Speed=450.000000,MPE_Name=Left,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=150.000000))
     MovementPatternElements(4)=(MPE_bApplySpeed=True,MPE_Speed=500.000000,MPE_Name=Right,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=200.000000))
}
