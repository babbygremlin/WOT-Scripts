//=============================================================================
// MovementPatternNavigating.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class MovementPatternNavigating expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=75.000000,MPE_WaypointParams=(WP_bSelectWaypoint=True,WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=50.000000,WP_ReqTravelDistanceRel=RR_LessOrEqual,WP_ReqTravelDistance=100.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=75.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=75.000000,MPE_WaypointParams=(WP_bSelectWaypoint=True,WP_bApplyOffsetDirection=True,WP_OffsetDirection=(Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=50.000000,WP_ReqTravelDistanceRel=RR_LessOrEqual,WP_ReqTravelDistance=100.000000,WP_ReqGoalDistanceRel=RR_GreaterOrEqual,WP_ReqGoalDistance=75.000000))
     PreReqDistanceRelation=RR_GreaterOrEqual
     PreReqGoalDistance=200.000000
}
