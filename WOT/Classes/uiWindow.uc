//=============================================================================
// uiWindow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================
class uiWindow expands uiComponent abstract;

var() int WindowOffsetX;		// window X offset from upper-left corner of centered window
var() int WindowOffsetY;		// window Y offset from upper-left corner of centered window
var() int WindowSizeX;			// window width
var() int WindowSizeY;			// window height
var() int WindowBorderX;		// window drawing area horizontal border
var() int WindowBorderY;		// window drawing area vertical border
var   int WindowPosX;			// window's X offset on canvas
var   int WindowPosY;			// window's Y offset on canvas
var   int WindowClipPosX;		// draw area's X offset on canvas
var   int WindowClipPosY;		// draw area's Y offset on canvas
var	  int WindowClipSizeX;		// draw area width
var   int WindowClipSizeY;		// draw area height
var   int WindowBaseSizeX;		// copy of original WindowSizeX for object used for resizing
var   int WindowBaseSizeY;		// copy of original WindowSizeY for object used for resizing

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

//this object contains the information that is being rendered in the subclass
var actor WindowItem;

//=============================================================================

function PreBeginPlay()
{
	Super.PreBeginPlay();

	WindowBaseSizeX = default.WindowSizeX;	
	WindowBaseSizeY = default.WindowSizeY;	
}
	
//=============================================================================

function SetItem( actor Item )
{
	WindowItem = Item;
}

//=============================================================================

function Destroyed()
{
	WindowItem = None;
	Super.Destroyed();
}

//=============================================================================

function ExpandWindow( Canvas C )
{
	WindowClipPosX	= LegendCanvas(C).ScaleValX( WindowPosX );
	WindowClipPosY	= LegendCanvas(C).ScaleValY( WindowPosY );
	WindowClipSizeX	= LegendCanvas(C).ScaleValX( WindowSizeX );
	WindowClipSizeY	= LegendCanvas(C).ScaleValY( WindowSizeY );

	C.SetOrigin( WindowClipPosX, WindowClipPosY );
	C.SetClip( WindowClipSizeX, WindowClipSizeY );
}

//=============================================================================

function RestoreWindow( Canvas C )
{
	WindowClipPosX	= LegendCanvas(C).ScaleValX( WindowPosX + WindowBorderX );
	WindowClipPosY	= LegendCanvas(C).ScaleValY( WindowPosY + WindowBorderY );
	WindowClipSizeX	= LegendCanvas(C).ScaleValX( WindowSizeX - 2*WindowBorderX );
	WindowClipSizeY	= LegendCanvas(C).ScaleValY( WindowSizeY - 2*WindowBorderY );

	C.SetOrigin( WindowClipPosX, WindowClipPosY );
	C.SetClip( WindowClipSizeX, WindowClipSizeY );
}

//=============================================================================
//override this function in the subclass to draw the window

function Draw( canvas C );

//=============================================================================

static function DrawRegion( Canvas C, float X, float Y, region R, texture T )
{
	DrawStretchedTextureSegment( C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );
}

//=============================================================================

static function TileRegion( Canvas C, float X, float Y, float W, float H, region R, texture T )
{
	local float U, V, dX, dY, tX, tY;
	local float TexW, TexH;
	local float SizeW, SizeH;
	
	if( W < 0 )
	{
		W = -W;
	}
	if( H < 0 )
	{
		H = -H;
	}
	tX = R.X;
	dX = R.W;
	if( dX < 0 )
	{
		tX += 1;
		X += dX+1;
		dX = -dX;
	}
	tY = R.Y;
	dY = R.H;
	if( dY < 0 )
	{
		tY += 1;
		Y += dY+1;
		dY = -dY;
	}
	
	TexW = R.W;
	TexH = R.H;
	SizeW = dX;
	SizeH = dY;
	for( U = 0; U < W; U += dX )
	{
		if( U+dX > W )
		{
			// last piece might be a fraction of the whole texture
			TexW = (W-U);
			SizeW = TexW;
		}
		
		for( V = 0; V < H; V += dY )
		{
			if( V+dY > H )
			{
				// last piece might be a fraction of the whole texture
				TexH = (H-V);
				SizeH = TexH;
			}			 		   
						
			DrawStretchedTextureSegment( C, X+U, Y+V, SizeW, SizeH, tX, tY, TexW, TexH, T );
		}
	}
}

//=============================================================================

static function FillRegion( Canvas C, float X, float Y, float W, float H, region R, texture T )
{
//log( "  FillRegion( "$X$","$Y$" )" );
	DrawStretchedTextureSegment( C, X, Y, W, H, R.X, R.Y, R.W, R.H, T );
}

//=============================================================================

static function DrawStretchedTextureSegment( Canvas C, float X, float Y, float W, float H, float tX, float tY, float tW, float tH, texture T )
{
	if( W < 0 )
	{			
		X += W+1;
		W = -W;
		tX += 1;
	}
	if( H < 0 )
	{
		Y += H+1;
		H = -H;
		tY += 1;		 
	}

	LegendCanvas(C).DrawScaledTileAt( X, Y, T, W, H, tX, tY, tW, tH );
}
						 
//=============================================================================

static function DrawRegionSpecial( Canvas C, float X, float Y, region R, texture T )
{
	LegendCanvas(C).DrawScaledTileAt( X, Y, T, R.W, R.H, R.X, R.Y, R.W, R.H, true );
}

//end of uiWindow.uc

defaultproperties
{
     WindowSizeX=544
     WindowSizeY=384
     WindowBorderX=64
     WindowBorderY=24
}
