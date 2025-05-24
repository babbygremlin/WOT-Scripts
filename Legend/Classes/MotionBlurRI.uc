//=============================================================================
// MotionBlurRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class MotionBlurRI expands RenderIterator
	native
	noexport;

// Set MaxItems to be the number of follow copies.

// Private variables to preserve binary compatibility with C++ code.
var transient /*(FActorNode*)*/ Actor FirstNode;	// These are just plain ordinary pointers.
var transient /*(FActorNode*)*/ Actor CurrentNode;
var transient int NumNodes;

// end of MotionBlurRI.uc

defaultproperties
{
     MaxItems=10
}
