//=============================================================================
// WOTBrowserMainWindow - The main window
//=============================================================================
class WOTBrowserMainWindow extends UBrowserMainWindow;

function BeginPlay()
{
	Super.BeginPlay();

	WindowTitle = "Wheel of Time"@WindowTitleString;
	ClientClass = class'WOTBrowserMainClientWindow';
}

defaultproperties
{
}
