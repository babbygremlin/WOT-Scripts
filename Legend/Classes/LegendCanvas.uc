//=============================================================================
// LegendCanvas.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 11 $
//=============================================================================

class LegendCanvas expands Canvas intrinsic;

const BaseSizeX = 640.0;
const BaseSizeY = 480.0;

var float FactorX;
var float FactorY;

//=============================================================================

function DoSetScale( out float OutFactorX, out float OutFactorY, optional bool bScaleUp )
{
	OutFactorX = 1.0;
	if( (SizeX >= 1) && (SizeX < BaseSizeX || bScaleUp) ) 
	{
		OutFactorX = float(SizeX) / BaseSizeX;
	}

	OutFactorY = 1.0;
	if( (SizeY >= 1) && (SizeY < BaseSizeY || bScaleUp) ) 
	{
		OutFactorY = float(SizeY) / BaseSizeY;
	}
}

//=============================================================================

function SetScale()
{
	DoSetScale( FactorX, FactorY, false );
}

//=============================================================================

function DrawIconAt( texture Tex, float XL, float YL, optional float Scale )
{
	SetPos( XL * FactorX, YL * FactorY );
	if( Scale==0.0 )
	{
		Scale = 1.0;
	}

	DrawTile( Tex, Tex.USize * Scale * FactorX, Tex.VSize * Scale * FactorY, 0, 0, Tex.USize, Tex.VSize );
}

//=============================================================================

function DrawScaledTileAt( float PosX, float PosY, texture T, float W, float H, float tX, float tY, float tW, float tH, optional bool bHack, optional bool bScaleUp )
{
	local float TileFactorX, TileFactorY;

	DoSetScale( TileFactorX, TileFactorY, bScaleUp );

	SetPos( PosX * TileFactorX, PosY * TileFactorY );
	if( bHack )
	{
		// rot: not sure why some textures need to be drawn this way -- find cause and remove bHack
		DrawTile( T, W*TileFactorX, H*TileFactorY, 0, 0, T.USize, T.VSize );
	}
	else
	{
		DrawTile( T, W*TileFactorX, H*TileFactorY, tX, tY, tW, tH );
	}
}

//=============================================================================

function SetFont( Font NewFont, optional bool bForce )
{
	local string FontStr;
	local font TempFont;
	local font FontToUse;

	if( SizeX < 512 && !bForce )
	{
		// swap font if an _S version is available
		FontStr = string( NewFont ) $ "_S";

		TempFont = Font( DynamicLoadObject( FontStr, class'Font', true ) );
		if( TempFont != None )
		{
			NewFont = TempFont;
		}
		else if( instr( FontStr, "F_Element" ) != -1 )
		{
			// special handling for inventory info element name font
			TempFont = Font( DynamicLoadObject( "WOT.F_WOTReg08", class'Font', true ) );
			if( TempFont != None )
			{
				NewFont = TempFont;
			}
		}
		else if( instr( FontStr, "F_WOTIta14" ) != -1 )
		{
			// special handling for italic fonts
			TempFont = Font( DynamicLoadObject( "WOT.F_WOTReg14_S", class'Font', true ) );
			if( TempFont != None )
			{
				NewFont = TempFont;
			}
		}
	}

	Font = NewFont;
}

//=============================================================================
// Code outside this class should call DrawTextAt or DrawScaledTextAt. Set
// bForce to force the given font to be used (a scaled down font won't be
// substitured).

/*private*/ function DoDrawScaledTextAt( float XL, float YL, coerce string Text, font NewFont, bool bCR, bool bForce, bool bCenterX, bool bScale )
{
	local font OldFont;
	local float TextSizeX, TextSizeY;
			
	if( NewFont != None )
	{
		OldFont = Font;
		SetFont( NewFont, bForce );
	}

	if( bScale )
	{	
		XL *= FactorX;
		YL *= FactorY;
	}

	if( bCenterX )
	{
		// default behavior when Canvas.bCenter is set is to center Text in current window (ClipX)
		// if bCenterX is set, we will center the text on the given X coordinate (assumes fits in window)
		StrLen( Text, TextSizeX, TextSizeY );
		XL = XL - TextSizeX/2;
		
		if( bCenter )
		{
			warn( "LegendCanvas.DoDrawScaledTextAt: both bCenterX and bCenter set -- this doesn't make sense" );
		}
	}
		
	SetPos( XL, YL );
	DrawText( Text, bCR );

	if( NewFont != None )
	{
		Font = OldFont;
	}
}

//=============================================================================
// Scales XL and YL coordinates based on current FactorX and FactorY settings
// (which are 1.0 for resolutions of 640x480 or greater, < 1.0 for
// lower resolutions). You probably want to use DrawTextAt instead of this
// function if you are drawing relative to the screen size (e.g. at SizeX/SizeY).

function DrawScaledTextAt( float XL, float YL, coerce string Text, optional font NewFont, optional bool bCR, optional bool bForce, optional bool bCenterX )
{
	DoDrawScaledTextAt( XL, YL, Text, NewFont, bCR, bForce, bCenterX, true );
}

//=============================================================================

function DrawTextAt( float XL, float YL, coerce string Text, optional font NewFont, optional bool bCR, optional bool bForce, optional bool bCenterX )
{
	DoDrawScaledTextAt( XL, YL, Text, NewFont, bCR, bForce, bCenterX, false );
}

//=============================================================================

function float ScaleValX( float Val )
{
	return Val*FactorX;
}

//=============================================================================

function float ScaleValY( float Val )
{
	return Val*FactorY;
}

// end of LegendCanvas.uc

defaultproperties
{
     FactorX=1.000000
     Factory=1.000000
}
