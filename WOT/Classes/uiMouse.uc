//=============================================================================
// uiMouse.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class uiMouse expands uiComponent;

var uiCursor CurrentCursor;		// The current cursor we are using
var bool HasDrawn;
var int DeltaX;
var int DeltaY;

simulated function Destroyed()
{
	if( CurrentCursor != None )
		CurrentCursor.Destroy();
	CurrentCursor = None;
	Super.Destroyed();
}

simulated function SetCursor( class<uiCursor> CursorClass )
{
	if( CurrentCursor != None )
		CurrentCursor.Destroy();

	CurrentCursor = Spawn( CursorClass, Self );
}

simulated function Draw( canvas Canvas )
{
	assert( uiHUD(Owner) != None );

	// center the mouse if this is the first draw operation
	if( !HasDrawn )
	{
		CurrentX = Canvas.SizeX / 2;
		CurrentY = Canvas.SizeY / 2;
		HasDrawn = true;
	}

	if( CurrentCursor != None )
	{
		CurrentCursor.Draw( Canvas );
	}
}

simulated function Reset()
{
	assert( uiHUD(Owner) != None );
	CurrentX = uiHUD(Owner).SizeX / 2;
	CurrentY = uiHUD(Owner).SizeY / 2;
}

simulated function MoveX( float Delta )
{
	assert( uiHUD(Owner) != None );
	DeltaX = Delta;
	CurrentX += Delta;
	RestrainToX();
}

simulated function MoveY( float Delta )
{
	assert( uiHUD(Owner) != None );
	DeltaY = Delta;
	CurrentY += Delta;
	RestrainToY();
}

simulated function RestrainToX()
{
	assert( uiHUD(Owner) != None );
	CurrentX = Min( Max( 0, CurrentX ), uiHUD(Owner).SizeX );
}

simulated function RestrainToY()
{
	assert( uiHUD(Owner) != None );
	CurrentY = Min( Max( 0, CurrentY ), uiHUD(Owner).SizeY );
}

simulated function LeftMouseDown()
{
	uiHUD(Owner).LeftMouseDown();
}

simulated function LeftMouseUp()
{
	uiHUD(Owner).LeftMouseUp();
}

simulated function RightMouseDown()
{
	uiHUD(Owner).RightMouseDown();
}

simulated function RightMouseUp()
{
	uiHUD(Owner).RightMouseUp();
}

//end of uiMouse.uc

defaultproperties
{
}
