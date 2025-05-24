//=============================================================================
// menuOptions.uc
//=============================================================================
class menuOptions expands menuLong;

const MENU_CustomizeControls	= 1;
const MENU_InvertMouse			= 2;
const MENU_MouseSensitivity		= 3;
const MENU_AlwaysMouseLook		= 4;
const MENU_AutoSlopeLook		= 5;
const MENU_LookSpring			= 6;
const MENU_Crosshair			= 7;
const MENU_ViewBob				= 8;
const MENU_JoystickEnabled		= 9;
const MENU_GoreDetailLevel		= 10;	// [ 0: Very Low, 1:Low, 2: Medium: 3:High ]
const MENU_PlayerID				= 11;

var bool bJoystick;
var byte GoreDetailLevel;
var config bool bEnableMenuOption; // support for German localization -- disable Gore Menu setting if false (default)

function PreBeginPlay()
{
	if( !bEnableMenuOption )
	{
		MenuLength = 9;
	}
}

function bool ProcessLeft()
{
	switch( Selection )
	{
	case MENU_MouseSensitivity:
		PlayerOwner.UpdateSensitivity( FMax( 1, PlayerOwner.MouseSensitivity - 1 ) );
		break;
	case MENU_InvertMouse:
	case MENU_AlwaysMouseLook:
	case MENU_AutoSlopeLook:
	case MENU_LookSpring:
	case MENU_JoystickEnabled:
	case MENU_PlayerID:
		ProcessSelection();
		break;
	case MENU_Crosshair:
		PlayerOwner.myHUD.ChangeCrossHair( -1 );
		break;
	case MENU_ViewBob:
		PlayerOwner.UpdateBob( PlayerOwner.Bob - 0.004 );
		break;
	case MENU_GoreDetailLevel:
		if( bEnableMenuOption )
		{
			GoreDetailLevel = Max( 0, GoreDetailLevel - 1 );
			ProcessSelection();
		}
		break;
	default:
		return false;
	}

	return true;
}

function bool ProcessRight()
{
	switch( Selection )
	{
	case MENU_MouseSensitivity:
		PlayerOwner.UpdateSensitivity( FMin( 32, PlayerOwner.MouseSensitivity + 1 ) );
		break;
	case MENU_InvertMouse:
	case MENU_AlwaysMouseLook:
	case MENU_AutoSlopeLook:
	case MENU_LookSpring:
	case MENU_JoystickEnabled:
	case MENU_PlayerID:
		ProcessSelection();
		break;
	case MENU_Crosshair:
		PlayerOwner.MyHUD.ChangeCrossHair( 1 );
		break;
	case MENU_ViewBob:
		PlayerOwner.UpdateBob( PlayerOwner.Bob + 0.004 );
		break;
	case MENU_GoreDetailLevel:
		if( bEnableMenuOption )
		{
			GoreDetailLevel = Min( 3, GoreDetailLevel + 1 );
			ProcessSelection();
		}
		break;
	default:
		return false;
	}

	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	switch( Selection )
	{
	case MENU_CustomizeControls:
		ChildMenu = Spawn( class'menuKeyboard', Owner );
		break;
	case MENU_InvertMouse:
		PlayerOwner.bInvertMouse = !PlayerOwner.bInvertMouse;
		break;
	case MENU_AlwaysMouseLook:
		PlayerOwner.ChangeAlwaysMouseLook( !PlayerOwner.bAlwaysMouseLook );
		break;
	case MENU_AutoSlopeLook:
		PlayerOwner.ChangeStairLook( !PlayerOwner.bLookUpStairs );
		break;
	case MENU_LookSpring:
		PlayerOwner.ChangeSnapView( !PlayerOwner.bSnapToLevel );
		break;
	case MENU_Crosshair:
		PlayerOwner.ChangeCrossHair();
		break;
	case MENU_JoystickEnabled:
		bJoystick = !bJoystick;
		PlayerOwner.ConsoleCommand( "set windrv.windowsclient usejoystick "$int(bJoystick) );
		break;
	case MENU_GoreDetailLevel:
		if( bEnableMenuOption )
		{
			PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager GoreDetailLevel "$GoreDetailLevel );
		}
		break;
	case MENU_PLAYERID:
		BaseHUD(PlayerOwner.MyHUD).bPlayerIDEnabled = !BaseHUD(PlayerOwner.MyHUD).bPlayerIDEnabled;
		break;

	default:
		return false;
	}

	if( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}

	return true;
}

function SaveConfigs()
{
	PlayerOwner.myHUD.SaveConfig();
	PlayerOwner.SaveConfig();
}

function DrawOptions( Canvas C )
{
	local int i;

	for( i=1; i<=MenuLength; i++ )
	{
		MenuList[i] = Default.MenuList[i];
	}

	DrawList( C, LC_Left );
}

function string GetGoreDetailStr()
{
	GoreDetailLevel = byte( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager GoreDetailLevel" ) );
	switch( GoreDetailLevel )
	{
		case 0:	return VeryLowText;
		case 1:	return LowText;
		case 2:	return MediumText;
		case 3:	return HighText;
		default: assert( false );
	}
}

function DrawValues( Canvas C )
{	
	MenuList[MENU_CustomizeControls] 	= " ";
	MenuList[MENU_InvertMouse] 			= string( PlayerOwner.bInvertMouse );
	MenuList[MENU_MouseSensitivity] 	= string( int(PlayerOwner.MouseSensitivity) );
	MenuList[MENU_AlwaysMouseLook] 		= string( PlayerOwner.bAlwaysMouseLook );
	MenuList[MENU_AutoSlopeLook] 		= string( PlayerOwner.bLookUpStairs );
	MenuList[MENU_LookSpring] 			= string( PlayerOwner.bSnapToLevel );
	MenuList[MENU_Crosshair] 			= " ";
	MenuList[MENU_ViewBob] 				= " ";
	MenuList[MENU_JoystickEnabled] 		= string( bool( PlayerOwner.ConsoleCommand( "get windrv.windowsclient usejoystick" ) ) );
	MenuList[MENU_GoreDetailLevel] 		= GetGoreDetailStr();
	MenuList[MENU_PlayerID] 			= string( BaseHUD(PlayerOwner.MyHUD).bPlayerIDEnabled );
	
	DrawList( C, LC_Right );
}

function DrawCrossHair( Canvas C )
{
	local int OffsetY;
	
	OffsetY = MenuListPosY[7];
	
	// hack to get crosshair to fit in various resolutions:
	if( C.SizeY < 384 )
	{
		OffsetY = MenuListPosY[7] - 5;
	}
	else
	{
		OffsetY = MenuListPosY[7] - 2;
	}
	
	PlayerOwner.MyHUD.DrawCrossHair( C, RightMenuListOffsetX-1, OffsetY );
}

function DrawMenu( Canvas C )
{
	DrawOptions( C );

	DrawValues( C );
	
	// Crosshair
	DrawCrossHair( C );

	// View Bob
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[8], 1000 * PlayerOwner.Bob, 0, 4, 8 );

	DrawHelpPanel( C );
}

defaultproperties
{
     bEnableMenuOption=True
     SpaceYRatioLoRes=1.000000
     bMenuHelp=True
     bLargeFont=False
     MenuLength=11
}
