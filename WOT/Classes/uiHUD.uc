//=============================================================================
// uiHUD.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================
class uiHUD expands HUD;

var int SizeX, SizeY;                   // Size of the object

var bool bHide;							// hide the HUD

var() class<uiMouse> MouseClass;
var uiMouse Mouse;
var() class<uiCursor> CursorClass;
var() uiWindow ActiveWindows[2];

// event interface, override as needed
simulated function LeftMouseDown();
simulated function LeftMouseUp();
simulated function RightMouseDown();
simulated function RightMouseUp();
simulated function bool KeyEvent( int Key, int Action, FLOAT Delta ) { return false; }

//=============================================================================

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	if( MouseClass != None )
	{
		Mouse = Spawn( MouseClass, Self );
		if( Mouse != None && CursorClass != None )
		{
			Mouse.SetCursor( CursorClass );
		}
	}
}

//=============================================================================

simulated function Destroyed()
{
	RemoveWindows();
	if( Mouse != None )
	{
		Mouse.Destroy();
		Mouse = None;
	}
	Super.Destroyed();
}

//=============================================================================

simulated event PreRender( canvas C )
{
	SizeX = C.SizeX;
	SizeY = C.SizeY;
	Super.PreRender( C );
}

//=============================================================================

simulated event PostRender( canvas C )
{
	local int i;

	Super.PostRender( C );
	for( i = 0; i < ArrayCount(ActiveWindows); i++ )
	{
		if( ActiveWindows[i] != None )
		{
			ActiveWindows[i].Draw( C );
		}
	}
}

//=============================================================================

simulated function bool IsWindowActive( optional class<uiWindow> WindowType )
{
	local int i;

	for( i = 0; i < ArrayCount(ActiveWindows); i++ )
	{
		if( ActiveWindows[i] != None && ( WindowType == None || ActiveWindows[i].IsA( WindowType.name ) ) )
		{
			return true;
		}
	}

	return false;
}

//=============================================================================

simulated function RemoveWindows()
{
	local int i;

	for( i = 0; i < ArrayCount(ActiveWindows); i++ )
	{
		if( ActiveWindows[i] != None )
		{
			ActiveWindows[i].Destroy();
			ActiveWindows[i] = None;
		}
	}
}

//=============================================================================

simulated function AddWindow( class<uiWindow> WindowType, actor WindowItem )
{
	local int i;

	for( i = 0; i < ArrayCount(ActiveWindows); i++ )
	{
		if( ActiveWindows[i] == None )
		{
			ActiveWindows[i] = Spawn( WindowType );
			ActiveWindows[i].SetItem( WindowItem );
			break;
		}
	}
}

//=============================================================================

simulated function UpdateWindows( class<uiWindow> WindowType, actor WindowItem )
{
	local int i;

	for( i = 0; i < ArrayCount(ActiveWindows); i++ )
	{
		if( ActiveWindows[i] != None && ActiveWindows[i].Class == WindowType )
		{
			ActiveWindows[i].SetItem( WindowItem );
		}
	}
}

//end of uiHUD.uc

defaultproperties
{
}
