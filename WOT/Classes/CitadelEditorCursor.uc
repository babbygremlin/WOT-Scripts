//=============================================================================
// CitadelEditorCursor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================
class CitadelEditorCursor expands uiCursor;

#exec TEXTURE IMPORT FILE=Graphics\UI_CECursor.pcx		GROUP=UI MIPS=Off FLAGS=2

defaultproperties
{
     CursorIcon=Texture'WOT.UI.UI_CECursor'
     HotSpotX=7
     HotSpotY=7
     SizeX=16
     SizeY=16
}
