//=============================================================================
// LegendAssetComponent.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class LegendAssetComponent expands LegendActorComponent abstract;

enum EGameType
{
	GT_All,
	GT_SinglePlayer,
	GT_MultiPlayer,
	GT_Battle,
	GT_Arena,
	GT_None,
};

defaultproperties
{
}
