//=============================================================================
// uiConsole.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 10 $
//=============================================================================
class uiConsole expands WOTConsole;

#exec Texture Import File=Textures\WOTBorder.pcx
#exec Texture Import File=Textures\WOTConsole.pcx
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapTL.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapTC.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapTR.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapBL.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapBC.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Map\MapBR.pcx GROUP=TransMap MIPS=FALSE FLAGS=2048 //PF_NoSmooth
#exec TEXTURE IMPORT FILE=Textures\TransMap\Labels\MapTabElements1.pcx GROUP=TransMap MIPS=FALSE FLAGS=2050 //PF_NoSmooth | PF_Masked
#exec TEXTURE IMPORT FILE=Textures\TransMap\Labels\GemBright.pcx GROUP=TransMap MIPS=FALSE FLAGS=2050 //PF_NoSmooth | PF_Masked

const TextBaseIndentSizeX	= 32;
const TextOffsetX			= -2;
const TextOffsetY			= 2;
const LoadMessageSizeY		= 30;
const GemRegOffset			= 9;
const AllowResizing			= false;


struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

enum EBackgroundType
{
	BGT_None,				
	BGT_NoBackground,			// black out display
	BGT_ShowTransMap,			// put up the transition map
	BGT_ShowTransMapWithLabel,	// put up the transition map with labels
	BGT_Default,				// default -- use level as background
};
	
var EBackgroundType ApplicableBackgroundType;
var WOTTransitionMapInfo ApplicableTransitionMapInfo;

var string MapTexStrTL;
var string MapTexStrTC;
var string MapTexStrTR;
var string MapTexStrBL;
var string MapTexStrBC;
var string MapTexStrBR;
var Region MapRegTL, MapRegTC, MapRegTR;
var Region MapRegBL, MapRegBC, MapRegBR;

var texture LabelTex;
var texture GemTex;

var Region LabelRegLeft, LabelRegTile, LabelRegRight;
var Region GemReg;

var int InterfaceLevel;
var int MaxLevels;

//=============================================================================

function DrawRegionSpecial( Canvas C, float X, float Y, region R, texture T )
{
	LegendCanvas(C).DrawScaledTileAt( X, Y, T, R.W, R.H, R.X, R.Y, R.W, R.H, true );
}

//=============================================================================

function DrawRegion( Canvas C, float X, float Y, region R, texture T )
{
	class'uiWindow'.static.DrawStretchedTextureSegment( C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );
}
						   
//=============================================================================

function DrawTransitionMap( Canvas C )
{
	local float OffsetX, OffsetY;

	OffsetX = Max( 0, (C.SizeX-640)/2 );
	OffsetY = Max( 0, (C.SizeY-480)/2 );

	DrawRegionSpecial( C, OffsetX+0,	OffsetY+0,   MapRegTL, Texture(DynamicLoadObject( MapTexStrTL, class'texture')) );
	DrawRegionSpecial( C, OffsetX+256,  OffsetY+0,   MapRegTC, Texture(DynamicLoadObject( MapTexStrTC, class'texture')) );
	DrawRegionSpecial( C, OffsetX+512,  OffsetY+0,   MapRegTR, Texture(DynamicLoadObject( MapTexStrTR, class'texture')) );
	DrawRegionSpecial( C, OffsetX+0,    OffsetY+224, MapRegBL, Texture(DynamicLoadObject( MapTexStrBL, class'texture')) );
	DrawRegionSpecial( C, OffsetX+256,  OffsetY+224, MapRegBC, Texture(DynamicLoadObject( MapTexStrBC, class'texture')) );
	DrawRegionSpecial( C, OffsetX+512,  OffsetY+224, MapRegBR, Texture(DynamicLoadObject( MapTexStrBR, class'texture')) );
}

//=============================================================================

function DrawLocationLabel( canvas C, int X, int Y, string Text )
{
	local float XL, YL;
	local float BaseLen;
	local float FloatNumTiles;
	local int	IntNumTiles;
	local int   TilesSoFar;
	local int	i;
	
	// 1) determine # of tiles needed to pad size of label box for text to fit
	
	// set font and determine length of text that needs to be drawn
	C.SetPos( 0, 0 );
	C.SetFont( font'F_WOTReg14', true ); // force full-size font for following size calculations
	C.StrLen( Text, XL, YL );

	// hackorama: text won't scale down by as much as the textures so scale size up if in < 640x480
	if( C.SizeX <= 320 )
	{
		XL *= 1.33;
	}
	else if( C.SizeX == 400 )
	{
		XL *= 1.10;
	}
	else if( C.SizeX == 512 )
	{
		XL *= 1.25;
	}
	
	// determine length of text area in a box with no tiles (text is indented)
	BaseLen = LabelRegLeft.W + GemReg.W + LabelRegRight.W - 2*TextBaseIndentSizeX;
	
	if( BaseLen < XL )
	{
		// determine real number of tiles to use
		FloatNumTiles = (XL - BaseLen)/LabelRegTile.W;
	
		if( FloatNumTiles > int(FloatNumTiles) )
		{
			// round up
			FloatNumTiles += 1.0;
		}

		IntNumTiles = int(FloatNumTiles);

		if( IntNumTiles % 2 != 0.0 )
		{
			IntNumTiles++;
		}
	}
	
	// 2) determine width of label box including tiles
	BaseLen = LabelRegLeft.W + GemReg.W + LabelRegRight.W + IntNumTiles*LabelRegTile.W;

	// adjust X, Y, so bottom of gem will point to desired X, Y
	X -= BaseLen/2;
	Y -= GemReg.H - GemRegOffset;

	// 3) draw UI components
			
	// draw left closing piece
	DrawRegion( C, X, Y, LabelRegLeft, LabelTex );

	// draw N/2 tiles here
	TilesSoFar=0;
	for( i=0; i<IntNumTiles/2; i++ )
	{
		DrawRegion( C, X+LabelRegLeft.W+(TilesSoFar*LabelRegTile.W), Y, LabelRegTile, LabelTex );
		TilesSoFar++;
	}

	DrawRegion( C, X+LabelRegLeft.W+(TilesSoFar*LabelRegTile.W), Y-GemRegOffset, GemReg, GemTex );
	
	// draw N/2 tiles here
	for( i=0; i<IntNumTiles/2; i++ )
	{
		DrawRegion( C, X+LabelRegLeft.W+(TilesSoFar*LabelRegTile.W)+GemReg.W, Y, LabelRegTile, LabelTex );
		TilesSoFar++;
	}

	// draw right closing piece
	DrawRegion( C, X+LabelRegLeft.W+(TilesSoFar*LabelRegTile.W)+GemReg.W, Y, LabelRegRight, LabelTex );

	// 4) draw text centered in label box
	C.bCenter = false;

	C.SetPos( LegendCanvas(C).ScaleValX( X + (LabelRegLeft.W+(TilesSoFar*LabelRegTile.W)+GemReg.W+LabelRegRight.W-XL)/2 ), LegendCanvas(C).ScaleValY( Y + (LabelRegLeft.H-YL)/2 + TextOffsetY ) );
	
	C.SetFont( font'F_WOTReg14' );
	C.DrawText( Text, false );
}

//=============================================================================

function DrawTransitionMapLabels( Canvas C )
{
	local int OffsetX, OffsetY;
	local int LabelPosX, LabelPosY;
	local string LabelText;

	if( ApplicableTransitionMapInfo != None )
	{
		// TMI from level determines destination
		LabelPosX = ApplicableTransitionMapInfo.NextX;
		LabelPosY = ApplicableTransitionMapInfo.NextY;
		LabelText = ApplicableTransitionMapInfo.NextText;
	}
	else
	{
		// new singleplayer game -- use coordinates for Mission_01
		LabelPosX = class'WOTTransitionMapInfo00'.default.NextX;
		LabelPosY = class'WOTTransitionMapInfo00'.default.NextY;
		LabelText = class'WOTTransitionMapInfo00'.default.NextText;
	}

	OffsetX = Max( (C.SizeX - 640)/2, 0 );
	OffsetY = Max( (C.SizeY - 480)/2, 0 );
	DrawLocationLabel( C, OffsetX+LabelPosX, OffsetY+LabelPosY, LabelText );
}

//=============================================================================

function DrawBorderedTransitionMap( Canvas C )
{
	// draw background (in case resolution greater than size of transition map)
 	C.SetPos(0,0);
 	C.DrawPattern( ConBackground, C.SizeX, C.SizeY, 1.0 );

	DrawTransitionMap( C );

	if( ApplicableBackgroundType == BGT_ShowTransMapWithLabel )
	{
		DrawTransitionMapLabels( C );
	}
}

//=============================================================================
// Logic for determining whether or not to draw the transition map background.

function EBackgroundType SetBackgroundType()
{
	ApplicableBackgroundType = BGT_Default;
	ApplicableTransitionMapInfo = None;
	if( Viewport.Actor.Level.LevelAction == LEVACT_Loading && WOTPlayer(Viewport.Actor) != None )
	{
		if( WOTPlayer(Viewport.Actor).GetTransitionType() == TRT_NewGame )
		{
			ApplicableBackgroundType = BGT_ShowTransMapWithLabel;
		}
		else if( WOTPlayer(Viewport.Actor).GetTransitionType() == TRT_EndOfLevel )
		{
			// leaving a singleplayer mission -- show transmap if have a TMI in the level
			foreach Viewport.Actor.AllActors( class'WOTTransitionMapInfo', ApplicableTransitionMapInfo )
			{
				break;
			}
			
			if( ApplicableTransitionMapInfo != None )
			{
				if( ApplicableTransitionMapInfo.IsA( 'WOTTransitionMapInfoNoMap' ) )
				{
					// these should be removed from levels -- no longer necessary
					ApplicableTransitionMapInfo = None;
					ApplicableBackgroundType =  BGT_NoBackground;
				}
				else		
				{
					ApplicableBackgroundType = BGT_ShowTransMapWithLabel;
				}
			}
			else
			{
				ApplicableBackgroundType =  BGT_NoBackground;
			}
		}
	}
}

//=============================================================================

function DrawBackGroundPattern( canvas C )
{
	SetBackgroundType();
	
	if( ApplicableBackgroundType == BGT_Default )
	{
		// default behavior
		Super.DrawBackGroundPattern( C );
	}
	else if( ApplicableBackgroundType == BGT_NoBackground )
	{
		// clear screen
		C.SetPos(0,0);
		C.DrawPattern( Border, C.ClipX, C.ClipY, 1.0 );
	}
	else
	{
		// show transition map, possibly with labels
		DrawBorderedTransitionMap( C );
	}
}

//=============================================================================

function PrintActionMessage( Canvas C, string BigMessage )
{
	local float XL, YL;

	C.SetFont( font'F_WOTReg30' );
	C.StrLen( BigMessage, XL, YL );

	if( ApplicableBackgroundType != BGT_ShowTransMapWithLabel )
	{
		C.SetPos( 0, (C.SizeY-YL)/2 );
	}
	else
	{
		// draw big message near bottom of screen
		C.SetPos( 0, C.SizeY-YL-1 );
	}

	C.bCenter = true;
	C.DrawText( BigMessage, false );
	C.bCenter = false;
}		

//=============================================================================

state UWindow
{
	event PostRender( canvas C )
	{
		// show transition map with no labels
		ApplicableBackgroundType = BGT_ShowTransMap;
		DrawBorderedTransitionMap( C );
		
		Super.PostRender( C );
	}
}

//=============================================================================

simulated function bool MouseEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local uiHUD H;

	H = uiHUD( Viewport.Actor.myHUD );
	if( H != None && H.Mouse != None )
	{		
		switch( Key )
		{
		case IK_MouseX:
			H.Mouse.MoveX( Delta * Min( ( ( Viewport.Actor.MouseSensitivity + 3.0 ) / 4.0 ), 2.0 ) );
			return true;
		case IK_MouseY:
			H.Mouse.MoveY( - Delta * Min( ( ( Viewport.Actor.MouseSensitivity + 3.0 ) / 4.0 ), 2.0 ) );
			return true;
		case IK_LeftMouse:
			if( Action == IST_Press )
				H.Mouse.LeftMouseDown();
			else if( Action == IST_Release )
				H.Mouse.LeftMouseUp();
			return true;
		case IK_RightMouse:
			if( Action == IST_Press )
				H.Mouse.RightMouseDown();
			else if( Action == IST_Release )
				H.Mouse.RightMouseUp();
			return true;
		}
	}

	return false;
}

//=============================================================================

event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local uiHUD H;

	MouseEvent( Key, Action, Delta );

	H = uiHUD( Viewport.Actor.myHUD );
	if( H != None && H.KeyEvent( int(Key), int(Action), Delta ) )
	{
		return true;
	}

	return Super.KeyEvent( Key, Action, Delta );
}

//=============================================================================
// JAM: View up and view down are slightly hacked:
// BorderSize 0 and 1 are different states, but look the same (on my monitor at least)
// The functions as written essentially skip one of these states.

exec function ViewUp()
{
	if( AllowResizing ) 
	{
		Super.ViewUp();
		if( BorderSize == 0 && InterfaceLevel < MaxLevels - 1 ) 
		{
			InterfaceLevel++;
		}
	} 
	else 
	{
		BorderSize = 0;

		if( BorderSize == 0 && InterfaceLevel < MaxLevels - 1 ) 
		{
			InterfaceLevel++;
		}
	}
}

//=============================================================================

exec function ViewDown()
{
	if( AllowResizing ) 
	{
		if( InterfaceLevel > 0 ) 
		{
			InterfaceLevel--;
			BorderSize = 0; // Shouldn't be necessary, but...
		} 
		if( InterfaceLevel == 0 )
		{
			Super.ViewDown();
		}
	} 
	else 
	{
		BorderSize = 0;

		if( InterfaceLevel > 0 ) 
		{
			InterfaceLevel--;
		} 
	}
}

//=============================================================================

function SetConsoleFont( Canvas C )
{
	if( ConsolePos >= 0.0001 )
	{
        C.Font = Font'Engine.SmallFont';
    }
    else
    {
	    Super.SetConsoleFont( C );
    }
}
    
//=============================================================================

function string GetShortMessage( int LineNum )
{
	if( MsgType[LineNum] == 'Message' )
	{
		// don't echo left/right/center/generic messages to top of console
		return "";
	}
	else
	{
		return MsgText[LineNum];
	}
}

//end of uiConsole.uc

defaultproperties
{
     MapTexStrTL="WOT.TransMap.MapTL"
     MapTexStrTC="WOT.TransMap.MapTC"
     MapTexStrTR="WOT.TransMap.MapTR"
     MapTexStrBL="WOT.TransMap.MapBL"
     MapTexStrBC="WOT.TransMap.MapBC"
     MapTexStrBR="WOT.TransMap.MapBR"
     MapRegTL=(W=256,H=256)
     MapRegTC=(W=256,H=256)
     MapRegTR=(W=128,H=256)
     MapRegBL=(Y=32,W=256,H=256)
     MapRegBC=(Y=32,W=256,H=256)
     MapRegBR=(Y=32,W=128,H=256)
     LabelTex=Texture'WOT.TransMap.MapTabElements1'
     GemTex=Texture'WOT.TransMap.GemBright'
     LabelRegLeft=(W=32,H=43)
     LabelRegTile=(X=32,W=16,H=43)
     LabelRegRight=(X=48,W=32,H=43)
     GemReg=(W=64,H=75)
     MaxLevels=3
     SavedPasswords(0)="38.201.159.30=ad"
     ShowDesktop=True
     ConBackground=Texture'WOT.WOTConsole'
     Border=Texture'WOT.WOTBorder'
}
