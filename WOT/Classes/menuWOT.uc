//=============================================================================
// menuWOT.uc
//
// Master class of all WOT menus.  Contains style-specific utilities
// for all menu types (e.g., menuLong, and menuShort).
//=============================================================================
class menuWOT expands Menu abstract;

#exec Texture Import File=Textures\Menu\Slide1.pcx Name=Slide1 MIPS=OFF FLAGS=2
#exec Texture Import File=Textures\Menu\Slide2.pcx Name=Slide2 MIPS=OFF FLAGS=2
#exec Texture Import File=Textures\Menu\Slide3.pcx Name=Slide3 MIPS=OFF FLAGS=2
#exec Texture Import File=Textures\Menu\Slide4.pcx Name=Slide4 MIPS=OFF FLAGS=2

#exec AUDIO IMPORT FILE=Sounds\UI\Menu\Select.WAV
#exec AUDIO IMPORT FILE=Sounds\UI\Menu\MoveSelector.WAV

//=============================================================================

const MaxHelpPanelWidthRatio= 0.80;		// ratio of total horizontal space to limit help panel width
const LeftColumnOffsetX		= 160;		// offset of start of left and right columns from center of screen
const RightColumnOffsetX	= 80;		// offset of start of left and right columns from center of screen

// used for controlling column formatting
enum EListColumn
{
	LC_None, 							// default (LC_Center)
	LC_Center,							// menu list is centered
	LC_Left,              				// menu list goes on left
	LC_Right,              				// menu list goes on right
};

// subclass-configurable menu element settings:
var() int MenuTitleOffsetY;				// vertical offset of menu title (if any) from top of screen
var() int MenuListCenterOffsetY;		// vertical offset of menu list from default centered position
var() int HelpPanelOffsetFromBottom;	// vertical offset of help text (if any) from bottom of screen
var() float SpaceYRatioLoRes;			// space between menu list entries = height/SpaceRatio (default: 3)
var() float SpaceYRatioHiRes;			// space between menu list entries = height/SpaceRatio (default: 3)

var() bool bMenuHelp;					// set to false if no help text at botton of screen
var() bool bLargeFont;					// if true, menu list entries will use larger font (e.g. main menu)

// misc
var() int  DisabledLevel;				// RGB level to use for disabled (grayed-out) menu entries

// lazy loaded stuff
var string MenuModifySoundName;
var string MenuSelectSoundName;

// misc internal:
var int MenuListSpacingY;
var int CenterMenuListOffsetX, LeftMenuListOffsetX, RightMenuListOffsetX;
var EListColumn CurrentListColumn;
var int	MenuListPosX[32];
var int	MenuListPosY[32];

var int MenuListOffsetX;
var int MenuListOffsetY;
var int HelpSizeY;

//=============================================================================

simulated function PlaySelectSound()
{
	if( MenuSelectSoundName != "" )
	{
		PlayerOwner.PlaySound( Sound( DynamicLoadObject( MenuSelectSoundName, class'Sound' ) ) );
	}
}

//=============================================================================

simulated function PlayModifySound()
{
	if( MenuModifySoundName != "" )
	{
		PlayerOwner.PlaySound( Sound( DynamicLoadObject( MenuModifySoundName, class'Sound' ) ),,2.0 );
	}
}

//=============================================================================

simulated function PlayEnterSound() 
{
	if( MenuModifySoundName != "" )
	{
		PlayerOwner.PlaySound( Sound( DynamicLoadObject( MenuModifySoundName, class'Sound' ) ),,2.0 );
	}
}

//=============================================================================

function SetListColumn( EListColumn NewListColumn )
{
	CurrentListColumn = NewListColumn;
}

//=============================================================================
// Determines the amount of vertical spacing to use between menu list items 
// based on how much vertical space is available (depends on the resolution and
// whether or not there is a title, help panel and offsets for these). Also
// determines the X and Y offsets for the menu list.
//
// rot: This could probably be set up to be called once, the first time the
// menu list is drawn, but currently this isn't supported with changes to the
// resoltution. could have a per-menuWOT flag which is set when this function
// is called and have this cleared for all wotMenu's whenever the resolution
// is changed. Would also have to handle selection changing and affecting the
// size of the help text (if any).

function DetermineMenuListLayout( Canvas C )
{
	local float XL, XLMax, YL;
	local int MenuListSpaceY;
	local int MenuListSizeY;
	local int i;
	local float IdealMenuListSpaceY;
	
	// nothing will actually get rendered here
	C.Style = ERenderStyle.STY_None;

	if( MenuLength <= 1 )
	{
		MenuListSpacingY = 0;
	}
	else
	{
		// determine available vertical space for menu list items after title, help area etc. removed
		MenuListSpaceY = C.SizeY;

		if( MenuTitle != "" )
		{
			// figure out vertical size of title
			YL = C.CurY;
			DrawTitle( C );
			MenuListSpaceY -= (C.CurY - YL);
		}	

		if( bMenuHelp )
		{
			// figure out vertical size of help area
			DrawHelpPanel( C );
			MenuListSpaceY -= HelpSizeY;
		}

		// determine vertical size of 1 menu list item
		SetMenuListFont( C );
		C.StrLen( "X", XL, YL );

		// will N of these menu items fit with no spacing?
		if( MenuLength*YL <= MenuListSpaceY )
		{
			if( C.SizeY < 384 )
			{
				IdealMenuListSpaceY = MenuLength*YL + (MenuLength-1)*YL*SpaceYRatioLoRes;
			}
			else
			{
				IdealMenuListSpaceY = MenuLength*YL + (MenuLength-1)*YL*SpaceYRatioHiRes;
			}
			
			// yes: -- can we use the requested size?
			if( MenuLength*YL <= IdealMenuListSpaceY )
			{
				// yes: use it
				MenuListSpaceY = IdealMenuListSpaceY;
			}
			else
			{
				// no: use exact size ==> no spacing
				MenuListSpaceY = MenuLength*YL;
			}			
		}
		else
		{
			// no: -- spacing will be negative so list items will overlap somewhat
		}
		
		// determine spacing to use between rows	
		MenuListSpacingY = (MenuListSpaceY - MenuLength*YL)/(MenuLength-1);
	}

	// determine length of longest menu list item
	XLMax = 0;
	for( i=1; i<=MenuLength; i++ )
	{
		C.StrLen( MenuList[i], XL, YL );
		if( XL > XLMax )
		{
			XLMax = XL;
		}
	}
	
	CenterMenuListOffsetX 	= (C.SizeX - XLMax)/2;
	LeftMenuListOffsetX 	= C.SizeX/2 - LegendCanvas(C).ScaleValX(LeftColumnOffsetX);
	RightMenuListOffsetX 	= C.SizeX/2 + LegendCanvas(C).ScaleValX(RightColumnOffsetX);

	MenuListSizeY			= (MenuLength*YL) + ((MenuLength-1)*MenuListSpacingY);
	
	if( MenuListSizeY > C.SizeY )
	{
		warn( Self $ ": menu list doesn't fit!" );
		MenuListOffsetY		= 0;
	}
	else
	{
		MenuListOffsetY		= (C.SizeY - MenuListSizeY) / 2 - MenuListCenterOffsetY;
		
		if( MenuListSizeY < 0 )
		{
			warn( Self $ ": MenuListCenterOffsetY makes menu list start off-screen!" );
			MenuListOffsetY	= 0;
		}
	}
	
	// re-enable rendering
	C.Style = ERenderStyle.STY_Normal;
}

//=============================================================================

function DrawTitle( Canvas C )
{
	if( MenuTitle != "" )
	{
		C.SetFont( Font'WOT.F_WOTReg30' );
		SetFontBrightness( C, false );
		C.bCenter = true;
		C.SetPos( 0, LegendCanvas(C).ScaleValY(MenuTitleOffsetY) );
		C.DrawText( MenuTitle, false );
		C.bCenter = false;
	}
}

//=============================================================================

function SetMenuListFont( Canvas C )
{
	if( bLargeFont )
	{
		C.SetFont( Font'WOT.F_WOTReg30' );
	}
	else
	{
		C.SetFont( Font'WOT.F_WOTReg14' );
	}
}

//=============================================================================

function SetMenuListOffsetX( EListColumn Column )
{
	switch( Column )
	{
		case LC_None:
		case LC_Center:
			MenuListOffsetX = CenterMenuListOffsetX;	
			break;
				
		case LC_Left:
			MenuListOffsetX = LeftMenuListOffsetX;	
			break;
			
		case LC_Right:
			MenuListOffsetX = RightMenuListOffsetX;	
			break;

		default:
			warn( Self $ ": invalid situation in SetMenuListOffSetX" );
	}
}
	
//=============================================================================
// Draw contents of MenuList.

function DrawList( Canvas C, optional EListColumn Column )
{
	local int i;
	
	DetermineMenuListLayout( C );

	DrawTitle( C );

	SetMenuListOffsetX( Column );
	
	SetMenuListFont( C );

	C.SetPos( MenuListOffsetX, MenuListOffsetY );
		
	for( i=1; i<=MenuLength; i++ )
	{
		// used for some custom drawing (sliders, crosshair)
		MenuListPosX[i] = C.CurX;
		MenuListPosY[i] = C.CurY;
		
		SetFontBrightness( C, i == Selection );
		C.DrawText( MenuList[i], false );
		C.SetPos( MenuListOffsetX, C.CurY + MenuListSpacingY );
	}
	C.DrawColor = C.Default.DrawColor;
	SetFontBrightness( C, false );
}

//=============================================================================

function DrawMenuEntry( Canvas C, int PosX, int PosY, string MenuText, int Index, optional bool bDisabled )
{
	SetMenuListFont( C );

	if( !bDisabled)
	{
		SetFontBrightness( C, Index == Selection );
	}
	
	C.SetPos( PosX, PosY );
	C.DrawText( MenuText, false );

	if( !bDisabled)
	{
		SetFontBrightness( C, false );
	}
}

//=============================================================================

function DrawSlider( Canvas C, int StartX, int StartY, int Value, int sMin, int StepSize, int Index )
{
	local bool bFoundValue;
	local int i;

	bFoundValue = false;

	// shift slider a bit so it lines up with text
	StartX -= 4;
	StartY -= 1;
	
	C.Style = ERenderStyle.STY_Masked;
	C.SetPos( StartX, StartY );
	
	SetFontBrightness( C, Index == Selection );
	C.DrawIcon( Texture'Slide1', 1.0 );
	for( i = 1; i <= 8; i++ )
	{
		if( !bFoundValue && ( StepSize * i + sMin > Value || i == 8 ) )
		{
			bFoundValue = true; 
			C.DrawIcon( Texture'Slide2', 1.0 );
		}
		else
		{
			C.DrawIcon( Texture'Slide4', 1.0 );
		}
	}
	C.DrawIcon( Texture'Slide3', 1.0 );
	
	SetFontBrightness( C, false );
	C.Style = ERenderStyle.STY_Normal;
}

//=============================================================================
// All long menus use this "help panel."  A small area at the bottom of the 
// menu describing the currently selected option.

function DrawHelpPanel( Canvas C )
{
	local int OldClipX, OldClipY;
	local int OldOrgX, OldOrgY;
	local float XL, YL, XL1, YL1;
	local int HelpStartX, HelpStartY;
	
	if( Selection < ArrayCount(HelpMessage) )
	{
		// save current window
		OldClipX = C.ClipX;
		OldClipY = C.ClipY;
		OldOrgX  = C.OrgX;
		OldOrgY  = C.OrgY;
		
		// X offset from left of screen
		HelpStartX = (C.SizeX - C.SizeX*MaxHelpPanelWidthRatio)/2;

		// set clip sizes, X origin to determine size correctly in StrLen
		C.bCenter = true;
		C.SetClip( C.SizeX*MaxHelpPanelWidthRatio, C.SizeY );
		C.SetOrigin( HelpStartX, C.OrgY );
		C.SetFont( Font'WOT.F_WOTReg14' );
		C.StrLen( HelpMessage[Selection], XL, YL );
		C.StrLen( "X", XL1, YL1 );

		// YL1 shifts help text up width of font from bottom
		HelpStartY = (C.SizeY - YL - YL1 - 1 - LegendCanvas(C).ScaleValY(HelpPanelOffsetFromBottom) );
		HelpSizeY = YL;

		// set real Y origin now that we know it
		C.SetOrigin( HelpStartX, HelpStartY );
		SetFontBrightness( C, true );
		C.SetPos( 0, 0 );
		
		// center text if only 1 line
		C.bCenter = ( YL <= YL1 );

		// track CurY so we can measure the 		
		C.DrawText( HelpMessage[Selection] );
		SetFontBrightness( C, false );
		C.bCenter = false;
			
		// restore old current window
		C.SetClip( OldClipX, OldClipY );
		C.SetOrigin( OldOrgX, OldOrgY );
	}
}

defaultproperties
{
     MenuTitleOffsetY=16
     SpaceYRatioLoRes=0.333333
     SpaceYRatioHiRes=0.333333
     bLargeFont=True
     DisabledLevel=25
     MenuModifySoundName="WOT.Select"
     MenuSelectSoundName="WOT.MoveSelector"
}
