//=============================================================================
// ContextInsensitiveGoal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class ContextInsensitiveGoal expands GoalAbstracterImpl native;

var private Rotator	AssociatedRotation;
var private bool	bUseAssociatedRotation;

defaultproperties
{
     DebugCategoryName=ContextInsensitiveGoal
}
