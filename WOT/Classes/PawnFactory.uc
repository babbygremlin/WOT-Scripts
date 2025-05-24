//=============================================================================
// PawnFactory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class PawnFactory expands ActorFactory;

var() byte Team;				// team to set spawned pawns to



function PreBeginPlay()
{
	if( Level.Game.bNoMonsters )
	{
		Destroy();
	}
	else
	{
		Super.PreBeginPlay();
	}
}

defaultproperties
{
     Team=255
     capacity=1
     bCovert=True
}
