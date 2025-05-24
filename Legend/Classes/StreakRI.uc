//=============================================================================
// StreakRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class StreakRI expands RenderIterator
	native
	noexport;

var transient /*(FActorNode*)*/ Actor FirstNode;
var transient /*(FActorNode*)*/ Actor CurrentNode;
	
var PathNodeIteratorII PNI;

defaultproperties
{
}
