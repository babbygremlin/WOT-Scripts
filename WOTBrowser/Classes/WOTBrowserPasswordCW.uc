class WOTBrowserPasswordCW expands UWindowDialogClientWindow;

var UWindowEditControl	PasswordEdit;
var localized string	PasswordText;

var string URL;

function Created()
{
	local float ControlOffset, CenterPos, CenterWidth;

	Super.Created();
	
	PasswordEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, 10, 220, 1));
	PasswordEdit.SetText(PasswordText);
	PasswordEdit.SetFont(F_Normal);
	PasswordEdit.SetNumericOnly(False);
	PasswordEdit.SetMaxLength(300);
	PasswordEdit.EditBoxWidth = 100;

	PasswordEdit.BringToFront();
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	PasswordEdit.WinWidth = WinWidth - 20;
	PasswordEdit.EditBoxWidth = WinWidth - 140;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	if( E == DE_EnterPressed || (C == WOTBrowserPasswordWindow(ParentWindow).OKButton && E == DE_Click) )
	{
		OKPressed();
	}
}

function OKPressed()
{
	if( URL != "" )
	{
		//WOTConsole(GetPlayerOwner().Player.Console).ConnectWithPassword( URL, PasswordEdit.GetValue() );
		WOTConsole(Root.Console).ConnectWithPassword( URL, PasswordEdit.GetValue() );
		URL = "";
	}
	else
	{
		WOTBrowserServerGrid(ParentWindow.OwnerWindow).ConnectToServer( /*LastRequestedServer*/, PasswordEdit.GetValue() );
	}
	ParentWindow.Close();
}

defaultproperties
{
     PasswordText="Password"
}
