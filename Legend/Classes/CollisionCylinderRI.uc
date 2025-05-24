//=============================================================================
// CollisionCylinderRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class CollisionCylinderRI expands RenderIterator
	native
	noexport;

var() Texture DotTexture;

var transient ActorBuffer Dots[30];

defaultproperties
{
     DotTexture=Texture'Legend.Effects.LineDot'
}
