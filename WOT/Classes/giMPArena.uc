//=============================================================================
// giMPArena.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================
class giMPArena expands giMP;

function AddDefaultInventory( pawn PlayerPawn )
{
	// Start the player off with 25 charges of dart along with their normal default weapon.
	GivePawnAngreal( PlayerPawn, "Angreal.AngrealInvDart", 25 );
	Super.AddDefaultInventory( PlayerPawn );
}

//end of giMPArena.uc

defaultproperties
{
     FragLimit=20
     bChangeLevels=True
     Map="Arena_12.wot"
     ScoreBoardType=Class'WOT.ArenaScoreBoard'
     MapPrefix="Arena_"
}
