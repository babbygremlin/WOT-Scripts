//=============================================================================
// uiDefaultCursor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class uiDefaultCursor expands uiCursor;

#exec TEXTURE IMPORT FILE=TEXTURES\ArrowCursor.pcx GROUP="Cursors" MIPS=OFF MASKED=ON

defaultproperties
{
     CursorIcon=Texture'WOT.Cursors.ArrowCursor'
     HotSpotX=1
     HotSpotY=1
}
