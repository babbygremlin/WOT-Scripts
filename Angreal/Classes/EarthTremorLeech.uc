//------------------------------------------------------------------------------
// EarthTremorLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class EarthTremorLeech expands DecreaseHealthLeech;

var AngrealProjectile SourceProjectile;

function AffectHost( optional int Iterations )
{
	local ShakeViewEffect SVE;

	if( PlayerPawn(Owner) != None )
	{
		if( WOTPlayer(Owner) != None )
		{
			//SVE = Spawn( class'ShakeViewEffect' );
			SVE = ShakeViewEffect( class'Invokable'.static.GetInstance( Self, class'ShakeViewEffect' ) );
			SVE.InitializeWithLeech( Self );
			SVE.Initialize( AffectResolution, 2500, 0 );
			SVE.SetVictim( Pawn(Owner) );
			WOTPlayer(Owner).ProcessEffect( SVE );
		}
		else
		{
			PlayerPawn(Owner).ShakeView( AffectResolution, 2500, 0 );
		}
	}

	Super.AffectHost( Iterations );
}

defaultproperties
{
    bDisplayIcon=False
}
