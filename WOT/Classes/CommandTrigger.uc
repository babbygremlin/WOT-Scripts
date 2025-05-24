//=============================================================================
// CommandTrigger.uc
// $Author: Mfox $
// $Date: 1/06/00 2:42p $
// $Revision: 1 $
//=============================================================================
class CommandTrigger expands Trigger;

var() string CommandStr;

//=============================================================================

function Trigger( Actor Other, Pawn EventInstigator )
{
	if( PlayerPawn(EventInstigator) != None )
	{
		PlayerPawn(EventInstigator).ConsoleCommand( CommandStr );
	}
}

//=============================================================================

defaultproperties
{
     CommandStr="SHOWUBROWSER"
}
