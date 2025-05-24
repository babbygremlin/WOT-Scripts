//=============================================================================
// DecalManagerRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class DecalManagerRI expands RenderIterator
	native
	noexport;

var transient /*(FActorNode*)*/ Actor FirstNode;
var transient /*(FActorNode*)*/ Actor CurrentNode;

var transient int DecalCount;
var transient float PreviousTickTime;
	

defaultproperties
{
}
