//=============================================================================
// uiCursor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class uiCursor expands uiObject
	abstract;

var() texture CursorIcon;
var() int HotSpotX;
var() int HotSpotY;
var() int SizeX;
var() int SizeY;

event PreBeginPlay()
{
	Super.PreBeginPlay();
	assert( uiMouse(Owner) != None );
	assert( CursorIcon != None );
}

simulated function Draw( canvas Canvas )
{
	Canvas.Style = Style;
	Canvas.SetPos( uiMouse(Owner).CurrentX - HotSpotX, uiMouse(Owner).CurrentY - HotSpotY );
	Canvas.DrawTile( CursorIcon,
		CursorIcon.USize, 
		CursorIcon.VSize, 
		0,0, 
		CursorIcon.USize,
		CursorIcon.VSize		
	);
}

//end of uiCursor.uc

defaultproperties
{
     Style=STY_Masked
}
