//=============================================================================
// menuMultiPlayer.uc
//=============================================================================
class menuMultiPlayer expands menuLong;

const MENU_JoinGame				= 1;
const MENU_PlayerConfig			= 2;
const MENU_StartArenaServer		= 3;
const MENU_StartBattleServer	= 4;

function bool ProcessSelection()
{
	local Menu ChildMenu;

	switch( Selection )
	{
	case MENU_JoinGame:
		if( PlayerOwner.Player.Console.IsA('UBrowserConsole') )
		{
			ExitAllMenus();
			PlayerOwner.ConsoleCommand("SHOWUBROWSER");
			return false;
		}
		else
		{
			assert( false );
		}
		break;
	case MENU_PlayerConfig:
		ChildMenu = spawn( class'menuPlayer', Owner );
		break;
	case MENU_StartArenaServer:
		ChildMenu = Spawn( class'menuStartArenaServer', Owner );
		break;
	case MENU_StartBattleServer:
		ChildMenu = Spawn( class'menuStartBattleServer', Owner );
		break;
	default:
		ChildMenu = None;
		break;
	}
	if( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = Self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}

	return true;
}

function DrawMenu( Canvas C )
{
	DrawList( C );
	DrawHelpPanel( C );
}

defaultproperties
{
     bMenuHelp=True
     MenuLength=4
}
