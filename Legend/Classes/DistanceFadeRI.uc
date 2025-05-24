//=============================================================================
// DistanceFadeRI.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class DistanceFadeRI expands RenderIterator
	native
	noexport;

var() float FadeDistance;

var transient ActorBuffer FadedVersion;

defaultproperties
{
     FadeDistance=500.000000
}
