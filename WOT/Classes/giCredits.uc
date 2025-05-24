//=============================================================================
// giCredits.uc
//
//=============================================================================
class giCredits expands giWOT;

var WOTPlayer Player;

function Timer()
{
	local WOTPlayer P;

	if( Player == None )
	{
		foreach AllActors( class'WOTPlayer', P )
			Player = P;

		Player.ShowCredits( true );
	}
}

// end of giCredits.uc

defaultproperties
{
     HUDType=Class'WOT.MenuHUD'
}
