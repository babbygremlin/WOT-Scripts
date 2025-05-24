//=============================================================================
// uiComponent.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class uiComponent expands uiObject abstract;

var int SizeX, SizeY;                   // Size of the object
var int CurrentX, CurrentY;             // Current location on the canvas

// event interface, override as needed
simulated function LeftMouseDown();
simulated function LeftMouseUp();
simulated function RightMouseDown();
simulated function RightMouseUp();

// Generic draw for all objects, override as needed
simulated function Draw( canvas C );

// end of uiComponent.uc

defaultproperties
{
}
