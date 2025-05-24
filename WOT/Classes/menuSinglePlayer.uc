//=============================================================================
// menuSinglePlayer.uc
//=============================================================================
class menuSinglePlayer expands menuLong;

const TUTORIAL_MAP = "Tutorial.wot";

const MENU_StartTutorial	= 1; //
const MENU_StartMission		= 2; //
const MENU_LoadMission		= 3; //
const MENU_SaveMission		= 4; //

function bool ProcessSelection()
{
	local Menu ChildMenu;

	switch( Selection )
	{
	case MENU_StartTutorial:
		StartMap( TUTORIAL_MAP );
		break;
	case MENU_StartMission:
		ChildMenu = spawn( class'menuStartMission', Owner );
		break;
	case MENU_LoadMission:
		ChildMenu = spawn( class'menuLoad', Owner );
		break;
	case MENU_SaveMission:
		if( Level.NetMode == NM_Standalone )
		{
			ChildMenu = spawn( class'menuSave', Owner );
		}
		else
		{
			return false;
		}
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

function DrawMenu( Canvas C )
{
	// draw text
	DrawList( C );

	// Draw help panel
	DrawHelpPanel( C );
}

defaultproperties
{
     bMenuHelp=True
     MenuLength=4
}
