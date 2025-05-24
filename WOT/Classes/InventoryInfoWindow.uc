//=============================================================================
// InventoryInfoWindow.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//=============================================================================
class InventoryInfoWindow expands WOTWindow;

#exec TEXTURE IMPORT FILE=Textures\Hud\IconMask.pcx GROUP=UI MIPS=FALSE FLAGS=2050 //PF_NoSmooth | PF_Masked
#exec Font Import File=Fonts\UI\F_Element.pcx Name=F_Element

// vertical offsets
const TitleOffsetY 		= 0;				// title
const IconOffsetY		= 28;				// icon
const InfoOffsetY		= 48;				// rarity/charges
const GemBarOffsetY		= 96;				// gem bar
const SubTitleOffsetY 	= 16;				// subtitle

// misc
const IconOffsetX		= 32;				
const GemBarIndentX		= 7;				
const GemSpacing		= 64;
const SeparatorIndentX	= 32;
const ElementStrOffsetY = 2;				

// info box component coordinates
var Region DividerL, DividerC, DividerR;
var Region GemL, GemR, GemC;
var Region GemEarthOff, GemEarthOn;
var Region GemAirOff, GemAirOn;
var Region GemFireOff, GemFireOn;
var Region GemSpiritOff, GemSpiritOn;
var Region GemWaterOff, GemWaterOn;

var localized string RarityCommonStr;
var localized string RarityUncommonStr;
var localized string RarityRareStr; 
var localized string ChargesStr;
var localized string SubTitle;
var localized string EarthStr;
var localized string AirStr;
var localized string FireStr;
var localized string WaterStr;
var localized string SpiritStr;

var private int TextMarginY;				// vertical available spacing for description + separator + quote

//=============================================================================

function SetItem( Actor Item )
{
	Super.SetItem( Item );
	
	TextMarginY = 0;
}
	
//=============================================================================

function DrawAngrealGem( Canvas C, int XOffset, Region GemOnReg, Region GemOffReg, bool bRegOn, string ElementStr, int ElementStrOffsetX )
{
	local Region GemReg;
	local int GemPosX;
	local float XL, YL;
	
	if( bRegOn )
	{
		GemReg = GemOnReg;
	}
	else
	{
		GemReg = GemOffReg;
	}

	// draw On/Off gem		
	GemPosX = (WindowClipSizeX - GemReg.W)/2 + GemSpacing*XOffset;
	DrawRegion( C, GemPosX, GemBarOffsetY, GemReg, OtherTexture );

	// determine X offset for gem label text
	C.SetFont( Font( DynamicLoadObject( "WOT.F_Element", class'Font' ) ) );
	C.StrLen( ElementStr, XL, YL );
	GemPosX = GemPosX + (GemReg.W - XL)/2 + LegendCanvas(C).ScaleValX(ElementStrOffsetX);

	C.SetPos( GemPosX, GemBarOffsetY - YL + ElementStrOffsetY );
	C.DrawText( ElementStr, false );
	C.SetFont( font'WOT.F_WOTReg14' );
}

//=============================================================================

function Draw( canvas C )
{
	local WOTInventory Inv;
	local AngrealInventory Ang;
	local float XL1, YL1, XL2, YL2;

	Inv = WOTInventory( WindowItem );
	if( Inv == None )
	{
		warn( WindowItem $ " is not a child of WOTInventory." );
		return;
	}

	Super.Draw( C );

	C.bCenter = true;
	C.SetFont( font'WOT.F_WOTReg14' );
	LegendCanvas(C).DrawTextAt( 0, TitleOffsetY, Inv.Title, font'WOT.F_WOTReg30' );

	LegendCanvas(C).DrawIconAt( Inv.StatusIcon, Min( C.SizeX, WindowClipSizeX)/2-IconOffsetX, IconOffsetY );
	LegendCanvas(C).DrawIconAt( texture'IconMask', Min( C.SizeX, WindowClipSizeX)/2-IconOffsetX, IconOffsetY );

	Ang = AngrealInventory(Inv);
	if( Ang != None )
	{
		C.bCenter = false;
		if( Ang.bRare )
			LegendCanvas(C).DrawTextAt( 0, InfoOffsetY, RarityRareStr, font'WOT.F_WOTReg14' );
		else if( Ang.bUncommon )
			LegendCanvas(C).DrawTextAt( 0, InfoOffsetY, RarityUncommonStr, font'WOT.F_WOTReg14' );
		else
			LegendCanvas(C).DrawTextAt( 0, InfoOffsetY, RarityCommonStr, font'WOT.F_WOTReg14' );
			
		C.StrLen( default.ChargesStr, XL1, YL1 );

		if( Ang.ChargeCost == 0 )
		{
			ChargesStr = "  :";
		}
		else
		{
			ChargesStr = "  " $ Ang.CurCharges;
		}

		C.SetFont( font'WOT.F_Charge' );
		C.StrLen( ChargesStr, XL2, YL2 );
		C.SetFont( font'WOT.F_WOTReg14' );
		LegendCanvas(C).DrawTextAt( WindowClipSizeX-XL1-XL2, InfoOffsetY, default.ChargesStr, font'WOT.F_WOTReg14' );
		LegendCanvas(C).DrawTextAt( WindowClipSizeX-XL2, InfoOffsetY, ChargesStr, font'WOT.F_Charge' );

		// gem bar
		ExpandWindow( C );
		DrawSeparator( C, 0, GemBarOffsetY+WindowBorderY, GemBarIndentX, GemL, GemC, GemR, OtherTexture );
		RestoreWindow( C );
		
		// gems
		DrawAngrealGem( C, -2,	GemEarthOn, 	GemEarthOff,	Ang.bElementEarth,	EarthStr,  -4 );
		DrawAngrealGem( C, -1, 	GemAirOn, 		GemAirOff, 		Ang.bElementAir,	AirStr,    -1 );
		DrawAngrealGem( C,  0, 	GemFireOn, 		GemFireOff, 	Ang.bElementFire,	FireStr,   -2 );
		DrawAngrealGem( C,  1, 	GemWaterOn,  	GemWaterOff, 	Ang.bElementWater,	WaterStr,  -1 );
		DrawAngrealGem( C,  2, 	GemSpiritOn, 	GemSpiritOff,	Ang.bElementSpirit,	SpiritStr, -1 );
	}

	if( TextMarginY == 0 )
	{	
		// will calculate TextMarginY first time through only
		C.Style = ERenderStyle.STY_None;
	}

	// draw wrapped description and quote text
	C.bCenter = true;
	C.SetPos( 0, C.CurY+GemC.H+8+TextMarginY/4 );
	C.DrawText( Inv.Description, false );
	
	// thin separator
	DrawSeparator( C, 0, C.CurY+TextMarginY/4, SeparatorIndentX, DividerL, DividerC, DividerR, OtherTexture );
	
	C.SetPos( 0, C.CurY+DividerL.H+8+TextMarginY/4 );
	C.SetFont( Font( DynamicLoadObject( "WOT.F_WOTIta14", class'Font' ) ) );
	C.DrawText( Inv.Quote, false );

	if( TextMarginY == 0 )
	{	
		WindowBaseSizeY = default.WindowSizeY;
		WindowOffsetY = default.WindowOffsetY;
		if( C.CurY+SubTitleOffsetY > WindowClipSizeY )
		{
			WindowBaseSizeY = Min( WindowSizeY+(C.CurY+SubTitleOffsetY-WindowClipSizeY), C.SizeY );
			WindowOffsetY = WindowOffsetY - (WindowBaseSizeY - default.WindowSizeY)/2;
			if( WindowOffsetY >= 0 )
			{
				WindowOffsetY = 0;
			}
		}

		TextMarginY = Max( (WindowBaseSizeY - 2*WindowBorderY) - SubTitleOffsetY - 8 - C.CurY, 1 );
	}
		
	if( SubTitle != "" )
	{
		LegendCanvas(C).DrawTextAt( 0, WindowClipSizeY-SubTitleOffsetY, SubTitle, font'WOT.F_WOTReg14', false, false );
	}	

	// reset the canvas data to make sure we don't interfere with the ClientMessage() output
	C.SetOrigin( 0, 0 );
	C.SetClip( C.SizeX, C.SizeY );
	C.SetPos( 0, 0 );
	C.bCenter = false;
	C.Style = ERenderStyle.STY_Normal;
}

//end of InventoryInfoWindow.uc

defaultproperties
{
     DividerL=(X=16,Y=224,W=16,H=16)
     DividerC=(X=32,Y=224,W=32,H=16)
     DividerR=(X=64,Y=224,W=16,H=16)
     GemL=(Y=192,W=64,H=32)
     GemR=(X=64,Y=192,W=64,H=32)
     GemC=(Y=224,W=16,H=32)
     GemEarthOff=(W=64,H=32)
     GemEarthOn=(X=64,W=64,H=32)
     GemAirOff=(Y=32,W=64,H=32)
     GemAirOn=(X=64,Y=32,W=64,H=32)
     GemFireOff=(Y=64,W=64,H=32)
     GemFireOn=(X=64,Y=64,W=64,H=32)
     GemSpiritOff=(Y=96,W=64,H=32)
     GemSpiritOn=(X=64,Y=96,W=64,H=32)
     GemWaterOff=(Y=128,W=64,H=32)
     GemWaterOn=(X=64,Y=128,W=64,H=32)
     bPauseGame=True
     MinimumResolution="640x480"
     WindowOffsetY=-48
     WindowSizeY=352
}
