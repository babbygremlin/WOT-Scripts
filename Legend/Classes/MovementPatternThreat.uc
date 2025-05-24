//=============================================================================
// MovementPatternThreat.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class MovementPatternThreat expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=200.000000,MPE_Name=MoveRight,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=200.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=400.000000,MPE_Name=MoveLeft,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=400.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=200.000000,MPE_Name=MoveRight,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=200.000000))
     MovementPatternElements(3)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=200.000000,MPE_Name=MoveBackward,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=200.000000))
     MovementPatternElements(4)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=200.000000,MPE_Name=MoveForward,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=400.000000))
     MovementPatternElements(5)=(MPE_bEnabled=True,MPE_bApplySpeed=True,MPE_Speed=200.000000,MPE_Name=MoveBackward,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=200.000000))
     PreReqDistanceRelation=RR_GreaterOrEqual
     PreReqGoalDistance=200.000000
}
