//=============================================================================
// WOTBrowserRootWindow - the root window.
//=============================================================================
class WOTBrowserRootWindow extends UBrowserRootWindow;
//class WOTBrowserRootWindow extends UWindowRootWindow;

function Created()
{
	Super(UWindowRootWindow).Created();

	MainWindow = UBrowserMainWindow(CreateWindow(class'WOTBrowserMainWindow', 50, 30, 550, 360));
	MainWindow.bStandaloneBrowser = True;
	MainWindow.WindowTitle = "Wheel of Time Browser";
	Resized();
}

defaultproperties
{
}
