//=============================================================================
// menuMain.uc
//=============================================================================
class menuMain expands menuLong;

const MENU_SinglePlayer		= 1;
const MENU_Multiplayer		= 2;
const MENU_Options			= 3;
const MENU_Configuration	= 4;
const MENU_PlayIntro		= 5;
const MENU_Credits			= 6;
const MENU_Quit				= 7;

//=============================================================================

function PostCreateMenu()
{
	// automatically transition into single player menus while SP game is in progress
	if( Level.Game != None && Level.Game.IsA( 'giMission' ) )
	{
		Selection = 1;
		ProcessSelection();
	}
	else
	{
		Super.PlayEnterSound();
	}
}

//=============================================================================

function Quit()
{
	PlayerOwner.SaveConfig();
	if( Level.Game != None )
	{
		Level.Game.SaveConfig();
		Level.Game.GameReplicationInfo.SaveConfig();
	}
	PlayerOwner.ConsoleCommand( "Exit" );
}

//=============================================================================

function bool ProcessSelection()
{
	local Menu ChildMenu;

	switch( Selection )
	{
	case MENU_SinglePlayer:
		ChildMenu = spawn( class'menuSinglePlayer', owner );
		break;
	case MENU_MultiPlayer:
		ChildMenu = spawn( class'menuMultiPlayer', owner );
		break;
	case MENU_Options:
		ChildMenu = spawn( class'menuOptions', owner );
		break;
	case MENU_Configuration:
		ChildMenu = spawn( class'menuConfiguration', owner );
		break;
	case MENU_PlayIntro:
		PlayerOwner.ConsoleCommand( "MP3 STOP" );
		PlayerOwner.ConsoleCommand( "PlayMovie Intro.mov" );
		break;
	case MENU_Credits:
		PlayerOwner.ConsoleCommand( "ShowCredits" );
		break;
	case MENU_Quit:
		Quit();
		break;
	}

	if( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

//=============================================================================

function DrawMenu( Canvas C )
{
	C.Style = ERenderStyle.STY_Normal;
	LegendCanvas(C).DrawTextAt( 2, C.SizeY - 16, class'Version'.static.GetVersionStr(), font'WOT.F_WOTReg14', false, true );

//	DrawTitle( C );
	
	// draw text
	DrawList( C );
}

defaultproperties
{
     MenuLength=7
}
