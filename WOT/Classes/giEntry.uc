//=============================================================================
// giEntry.uc
//
//=============================================================================
class giEntry expands giWOT;

var bool bFirstTime;

// don't give the player anything in the entry level
function AddDefaultInventory( pawn PlayerPawn )
{
}

// make sure everybody in this level (the player) is looking at the menu
function Timer()
{
	local PlayerPawn P;

	Super.Timer();

	if( bFirstTime )
	{
		bFirstTime = false;

		foreach AllActors( class'PlayerPawn', P )
		{
			if( !P.bShowMenu )
				P.ShowMenu();
		}
	}
}

// end of giEntry.uc

defaultproperties
{
     bFirstTime=True
}
