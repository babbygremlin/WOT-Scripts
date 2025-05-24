//=============================================================================
// WotPathNode.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
// PathNodes with flags for special properties (these can be combined).
//=============================================================================

class WotPathNode expands PathNode;

#exec Texture Import File=Textures\S_WotPathNode.pcx GROUP=Icons Name=S_WotPathNode Mips=Off Flags=2

var() private bool bDark;
var() private bool bSnipe;

function bool GetDarkFlag()
{
	return bDark;
}



function bool GetSnipeFlag()
{
	return bSnipe;
}

defaultproperties
{
     Texture=Texture'WOT.Icons.S_WotPathNode'
}
