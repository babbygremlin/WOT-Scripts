//=============================================================================
// WOTTextWindow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 11 $
//=============================================================================
class WOTTextWindow expands WOTWindow;

const TitleOffsetY 		= 0;
const SubTitleOffsetY 	= 16;
const SubTitleHeight	= 32;
const SubTitleMarginY	= 8;
const BulletOffsetX		= 56;

var Region Separator1L, Separator1R, Separator1C;
var Region Separator2L, Separator2R, Separator2C;

var private WOTTextWindowInfo WTWItem;
var private bool bCheckedSizeY;
var private float ForcedX;
var private float ForcedY;

//=============================================================================

function SetItem( Actor Item )
{
	Super.SetItem( Item );
	
	WTWItem = WOTTextWindowInfo(Item);

	if( WTWItem != None )
	{
		if( WTWItem.WindowSizeX != -1 )
		{
			WindowBaseSizeX = WTWItem.WindowSizeX;
		}

		if( WTWItem.WindowSizeY != -1 )
		{
			WindowBaseSizeY = WTWItem.WindowSizeY;
		}

		if( WTWItem.WindowOffsetX != -1 )
		{
			WindowOffsetX = WTWItem.WindowOffsetX;
		}

		if( WTWItem.WindowOffsetY != -1 )
		{
			WindowOffsetY = WTWItem.WindowOffsetY;
		}
	}
}

//=============================================================================

function GetStrFont( int nWhich, out string strFont )
{
	switch( nWhich )
	{
		case 0:
		case 1:
			strFont = "WOT.F_WOTReg08";
			break;
		case 2:
            strFont = "WOT.F_WOTIta14";
			break;
		case 3:
            strFont = "WOT.F_WOTReg14";
			break;
		case 4:
		case 5:
            strFont = "WOT.F_WOTReg30";
			break;
		default:
			strFont = "WOT.F_WOTReg14";
			break;
	}
}

//=============================================================================

function bool IsSeparator( string s, out int SeparatorType )
{
	if( instr( s, "%d=" ) == 0 )
	{
		SeparatorType = int( mid( s, 3) );
		return true;
	}
	return false;
}

//=============================================================================

function bool IsSpacing( string s, out int SpacingSize )
{
	if( instr( s, "%s=" ) == 0 )
	{
		SpacingSize = int( mid( s, 3 ) );
		return true;
	}
	return false;
}

//=============================================================================

function bool IsFont( string s, out string strFont )
{
	if( instr( s, "%f=" ) == 0 )
	{
		GetStrFont( int( mid( s, 3 ) ), strFont );
		return true;
	}
	return false;
}

//=============================================================================

function bool IsCentering( string s, out int Center )
{
	if( instr( s, "%c=" ) == 0 )
	{
		Center = int( mid( s, 3 ) );
		return true;
	}
	return false;
}

//=============================================================================

function bool IsSetX( string s, out int Val )
{
	if( instr( s, "%x=" ) == 0 )
	{
		Val = int( mid( s, 3 ) );
		return true;
	}
	return false;
}

//=============================================================================

function bool IsSetY( string s, out int Val )
{
	if( instr( s, "%y=" ) == 0 )
	{
		Val = int( mid( s, 3 ) );
		return true;
	}
	return false;
}

//=============================================================================

function bool DoBullet( Canvas C, string s )
{
	if( C.SizeX >= 512 && instr( s, "%b " ) == 0 )
	{
		return true;
	}
	return false;
}

//=============================================================================

function DrawText( Canvas C, string s, bool bCR )
{
	if( instr( s, "%b " ) == 0 )
	{
		if( C.SizeX >= 512 )
		{
			C.DrawText( Mid( s, 3), bCR );
		}
		else
		{		
			// skip any bullet indicator
			C.DrawText( "*" $ Mid( s, 3), bCR );
		}
	}
	else
	{
		C.DrawText( s, bCR );
	}
}

//=============================================================================

simulated function Draw( canvas C )
{
	local int i;
	local string strCurrent;
	local string strFont;
	local int SeparatorType;
	local int SpacingSize;
	local int Center;
	local int SavedY;
	local Font TempFont;
	local int Val;
	local float PosX, PosY;
					
	if( WTWItem == None )
	{
		warn( WindowItem $ " is not a child of WOTTextWindowInfo." );
		return;
	}

	if( !bCheckedSizeY )
	{
		C.Style = ERenderStyle.STY_None;
	}
	
	Super.Draw( C );

	C.bCenter = true;
	C.SetFont( font'WOT.F_WOTReg14' );
	if( WTWItem.Title != "" )
	{
		LegendCanvas(C).DrawTextAt( 0, TitleOffsetY, WTWItem.Title, font'F_WOTReg14' );
	}
	
	ForcedX=-1;
	ForcedY=-1;
	for( i=0; i<ArrayCount(WTWItem.Content) && WTWItem.Content[i] != ""; i++ )
	{
		strCurrent = WTWItem.Content[i];
		if( IsSeparator( strCurrent, SeparatorType ) )
		{
			// draw a separator (border)
			
			if( SeparatorType == 1 ) // thick: all the way to the window frame
			{
				ExpandWindow( C );

				DrawSeparator( C, 0, C.CurY+WindowBorderY, 4, Separator1L, Separator1C, Separator1R, OtherTexture );

				RestoreWindow( C );
				C.SetPos( 0, C.CurY+Separator1L.H+8 );
			}
			else if( SeparatorType == 2 ) // thin: centered in clip arean
			{
				DrawSeparator( C, 0, C.CurY, 16, Separator2L, Separator2C, Separator2R, OtherTexture );
				C.SetPos( 0, C.CurY+Separator2L.H+8 );
			}
			else
			{
				warn( Self $ "::Draw: invalid separator type specified: " $ SeparatorType );
			}
		}
		else if( IsSpacing( strCurrent, SpacingSize ) )
		{
			// move SpacingSize units down
			C.SetPos( C.CurX, C.CurY+SpacingSize );
		}
		else if( IsCentering( strCurrent, Center ) )
		{
			// set centering
			C.bCenter = bool( Center );
		}
		else if( IsSetX( strCurrent, Val ) )
		{
			// set X position to use (-1 clears)
			ForcedX = Val;
		}
		else if( IsSetY( strCurrent, Val ) )
		{
			// set Y position to use (-1 clears)
			ForcedY = Val;
		}
		else if( IsFont( strCurrent, strFont ) )
		{
			// change font
			TempFont = Font( DynamicLoadObject( strFont, class'Font', true ) ); 
			if( TempFont != None )
			{
				C.SetFont( TempFont );
			}
			else
			{
				C.SetFont( font'WOT.F_WOTReg14' );
				warn( Self $ "::Draw: Error loading font: " $ strFont );
			}
		}
		else if( strCurrent != "" )
		{
			// draw text
			if( DoBullet( C, strCurrent ) )
			{
				// draw bullet outside of left border without changing line offset
				SavedY = C.CurY;
	
				ExpandWindow( C );

				// draw bullet (* will become a bullet in all fonts)
				if( C.SizeX == 512 )
				{
					C.SetPos( LegendCanvas(C).ScaleValX( BulletOffsetX ), LegendCanvas(C).ScaleValY( SavedY+WindowBorderY ) + 6 );
				}
				else
				{
					C.SetPos( LegendCanvas(C).ScaleValX( BulletOffsetX ), LegendCanvas(C).ScaleValY( SavedY+WindowBorderY ) );
				}
				C.DrawText( "*", false );
			
				RestoreWindow( C );

				C.SetPos( 0, SavedY );
			}

			if( ForcedX == -1 )
			{
				PosX = 0;
			}
			else
			{
				PosX = LegendCanvas(C).ScaleValX(ForcedX);
			}
			if( ForcedY == -1 )
			{
				PosY = C.CurY;
			}
			else
			{
				PosY = LegendCanvas(C).ScaleValY(ForcedY);
			}
					
			C.SetPos( PosX, PosY );
			DrawText( C, strCurrent, false );
		}
	}

	if( WTWItem.SubTitle != "" )
	{
		C.bCenter = true;
		LegendCanvas(C).DrawTextAt( 0, Max( C.CurY+SubTitleMarginY, WindowClipSizeY-SubTitleOffsetY), WTWItem.SubTitle, font'F_WOTReg14', false, false );
	}	

	if( !bCheckedSizeY )
	{
		if( C.CurY > WindowClipSizeY )
		{
			WindowBaseSizeY = Min( WindowSizeY+(C.CurY-WindowClipSizeY), C.SizeY );
		}

		bCheckedSizeY = true;		
	}
		
	// reset the canvas data to make sure we don't interfere with the ClientMessage() output
	C.SetOrigin( 0, 0 );
	C.SetClip( C.SizeX, C.SizeY );
	C.SetPos( 0, 0 );
	C.bCenter = false;
	C.Style = ERenderStyle.STY_Normal;
}

//end of WOTTextWindow.uc

defaultproperties
{
     Separator1L=(X=48,Y=160,W=48,H=32)
     Separator1R=(X=80,Y=160,W=48,H=32)
     Separator1C=(X=80,Y=160,W=16,H=32)
     Separator2L=(X=16,Y=224,W=16,H=16)
     Separator2R=(X=64,Y=224,W=16,H=16)
     Separator2C=(X=32,Y=224,W=32,H=16)
     ForcedX=-1.000000
     ForcedY=-1.000000
     bPauseGame=True
     bHideUI=True
     WindowSizeX=640
     WindowSizeY=480
}
