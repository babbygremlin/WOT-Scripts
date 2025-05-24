//=============================================================================
// DefaultCursor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================
class DefaultCursor expands uiCursor;

#exec TEXTURE IMPORT FILE=TEXTURES\ArrowCursor.pcx GROUP=Cursors NAME=ArrowCursor MIPS=OFF MASKED=ON

defaultproperties
{
     CursorIcon=Texture'WOT.Cursors.ArrowCursor'
     HotSpotX=1
     HotSpotY=1
     SizeX=12
     SizeY=16
}
