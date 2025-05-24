//=============================================================================
// MenuHUD.uc
//=============================================================================
class MenuHUD expands uiHUD;

//=============================================================================
simulated function Setup( canvas C )
{
	// Setup the way we want to draw all HUD elements
	C.Reset();
	C.SpaceX    = 0;
	C.bNoSmooth = true;
	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;	
	C.SetFont( Font'WOT.F_WOTReg30' );

	// reset to clip coordinates set in UCanvas::Update()
	C.SetClip( C.SizeX, C.SizeY );
}

//=============================================================================
simulated function CreateMenu()
{
	// if special menu has been requested, and doesn't exist, create it
	if( PlayerPawn(Owner).bSpecialMenu && PlayerPawn(Owner).SpecialMenu != None )
	{
		MainMenu = Spawn( PlayerPawn(Owner).SpecialMenu, self );
		PlayerPawn(Owner).bSpecialMenu = false;
	}

	// if menu doesn't exist, create it
	if( MainMenu == None )
	{
		MainMenu = Spawn( MainMenuType, self );
	}
	
	// if menu exists, then initialize (otherwise, abort gracefully)
	if( MainMenu != None )
	{
		MainMenu.PlayerOwner = PlayerPawn(Owner);
		MainMenu.PlayEnterSound();

		menuMain(MainMenu).PostCreateMenu();
	}
	else
	{
		PlayerPawn(Owner).bShowMenu = false;
		Level.bPlayersOnly = false;
	}
}

//=============================================================================
simulated function PostRender( Canvas C )
{
    Super.PostRender( C );

	Setup( C );

	if( PlayerPawn(Owner).bShowMenu )
	{
		// if menu doesn't exist, create it
		if( MainMenu == None )
		{
			CreateMenu();
		}

		// if menu exists, then draw it
		if( MainMenu != None )
		{
			MainMenu.DrawMenu( C );
		}
	}
	else if( uiHUD(PlayerPawn(Owner).myHUD).IsWindowActive() )
	{
		// if any window is active, don't draw either scoreboard
	}
	else if( PlayerPawn(Owner).bShowScores )
	{
		// if scoreboard doesn't exist, create it
		if( PlayerPawn(Owner).Scoring == None && PlayerPawn(Owner).ScoringType != None )
		{
			PlayerPawn(Owner).Scoring = Spawn( PlayerPawn(Owner).ScoringType, Owner );
		}

		// if scoreboard exists, then draw it
		if( PlayerPawn(Owner).Scoring != None )
		{ 
			PlayerPawn(Owner).Scoring.ShowScores( C );
		}
	}
	else if( WOTPlayer(Owner) != None && WOTPlayer(Owner).bShowOverview )
	{
		// if overview doesn't exist, create it
		if( WOTPlayer(Owner).Overview == None && WOTPlayer(Owner).OverviewType != None )
		{
			WOTPlayer(Owner).Overview = Spawn( WOTPlayer(Owner).OverviewType, Owner );
		}
		
		// if overview exists, then draw it
		if( WOTPlayer(Owner).Overview != None )
		{ 
			WOTPlayer(Owner).Overview.ShowScores( C );
		}
	}
}

// end if MenuHUD.uc

defaultproperties
{
     MainMenuType=Class'WOT.menuMain'
}
