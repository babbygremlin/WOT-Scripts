//=============================================================================
// StateTransitionDirective.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================


class StateTransitionDirective expands ObservableDirective;

enum EExplicitBehavior
{
	EB_Die,
	EB_Guard,
	EB_Patrol,
	EB_Roam
};

defaultproperties
{
}
