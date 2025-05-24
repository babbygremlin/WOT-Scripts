//=============================================================================
// MovementPatternTrollocMed1.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class MovementPatternTrollocMed1 expands MovementPattern;

defaultproperties
{
     MovementPatternElements(0)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=350.000000,MPE_bApplySpeed=True,MPE_Speed=700.000000,MPE_Name=AttackStrafe,MPE_PreHint=AttemptAttack,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=-1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=128.000000))
     MovementPatternElements(1)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_LessOrEqual,MPE_ApplicationGoalDistance=350.000000,MPE_bApplySpeed=True,MPE_Speed=700.000000,MPE_Name=StrafeAttack,MPE_PreHint=AttemptAttack,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=-1.000000,Y=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=128.000000))
     MovementPatternElements(2)=(MPE_bEnabled=True,MPE_ApplicationRel=RR_GreaterOrEqual,MPE_ApplicationGoalDistance=350.000000,MPE_bApplySpeed=True,MPE_Name=CloseIn,MPE_PostHint=AttemptAttack,MPE_WaypointParams=(WP_bApplyOffsetDirection=True,WP_OffsetDirection=(X=1.000000),WP_bApplyOffsetDistance=True,WP_OffsetDistance=96.000000,WP_ReqGoalDistanceRel=RR_LessOrEqual,WP_ReqGoalDistance=325.000000))
}
