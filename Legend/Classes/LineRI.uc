//=============================================================================
// LineRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class LineRI expands RenderIterator
	native
	noexport;

var transient /*(FActorNode*)*/ Actor FirstNode;
var transient /*(FActorNode*)*/ Actor CurrentNode;

var transient vector PrevStart;
var transient vector PrevEnd;
var transient float  PrevDensity;
	

defaultproperties
{
}
