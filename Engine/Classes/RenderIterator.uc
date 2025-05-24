//=============================================================================
// RenderIterator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//=============================================================================

//#if 1//NEW

class RenderIterator expands Object
	native
	noexport;

struct ActorBuffer
{
	var byte Padding[540];
};

struct ActorNode
{
	var ActorBuffer ActorProxy;
	var Actor NextNode;
};

var()			int			MaxItems;
var				int			Index;
var transient	PlayerPawn	Observer;
var transient	Actor		Frame;	// just a generic pointer used for binary compatibility only (FSceneNode*).

//#endif

// end of RenderIterator.uc


defaultproperties
{
    MaxItems=1
}
