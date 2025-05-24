//=============================================================================
// InventoryCursor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class InventoryCursor expands uiCursor;

#exec TEXTURE IMPORT FILE=Graphics\UI_ICursor.pcx		GROUP=UI MIPS=Off FLAGS=2

defaultproperties
{
     CursorIcon=Texture'WOT.UI.UI_ICursor'
     HotSpotX=16
     HotSpotY=32
     SizeX=12
     SizeY=16
}
