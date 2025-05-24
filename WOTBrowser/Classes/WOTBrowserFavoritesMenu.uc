class WOTBrowserFavoritesMenu expands UBrowserFavoritesMenu;

// NOTE[aleiby]: Make sure this is synced with WOTBrowserRightClickMenu

var UWindowPulldownMenuItem JoinPassword;

var localized string JoinPasswordName;

function Created()
{
	Super.Created();

	AddMenuItem("-", None);
	JoinPassword = AddMenuItem(JoinPasswordName, None);
}

function ExecuteItem(UWindowPulldownMenuItem I) 
{
	switch(I)
	{
	case JoinPassword:
		WOTBrowserServerGrid(Grid).RequestPassword(List);
		break;
	}

	Super.ExecuteItem(I);
}

function ShowWindow()
{
	JoinPassword.bDisabled = List == None || List.GamePort == 0;
	Super.ShowWindow();
}

defaultproperties
{
     JoinPasswordName="Join Game with &Password"
}
