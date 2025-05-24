//=============================================================================
// giMP.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 11 $
//=============================================================================
class giMP expands giCombatBase;

function string GetRules()
{
	local string ResultSet;

	// MutatorInfo.
	//ResultSet = Super.GetRules();

	// Fraglimit.
	if( FragLimit > 0 )
	{
		ResultSet = ResultSet$"\\fraglimit\\"$FragLimit;
	}

	// Timelimit.
	if( TimeLimit > 0 )
	{
		ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
		ResultSet = ResultSet$"\\remainingtime\\"$class'Util'.static.SecondsToTime( Max( GameReplicationInfo.RemainingTime, 0 ) );
	}
	else
	{
		ResultSet = ResultSet$"\\elapsedtime\\"$class'Util'.static.SecondsToTime( GameReplicationInfo.ElapsedTime );
	}
		
	// Change levels.
	ResultSet = ResultSet$"\\changelevels\\"$bChangeLevels;

	// Public Access.
	ResultSet = ResultSet$"\\publicaccess\\"$(GamePassword == "");

	return ResultSet;
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	return WOTPlayer(Viewer) != None && WOTPlayer(Viewer).PlayerReplicationInfo.Team == 255;
}

function GivePawnAngreal( Pawn P, String AngrealName, optional int Charges )
{
	local class<AngrealInventory> AngrealType;
	local AngrealInventory A;

	if( P.bIsPlayer )
	{
		AngrealType = class<AngrealInventory>(DynamicLoadObject( AngrealName, class'Class' ));
		if( AngrealType != None && P.FindInventoryType( AngrealType ) == None )
		{
			A = Spawn( AngrealType );
			if( A != None )
			{
				if( Charges == 0 )
				{
					A.CurCharges = RandRange( A.MinInitialCharges, A.MaxInitialCharges );
				}
				else
				{
					A.CurCharges = Charges;
				}
				if( Level.Game.PickupQuery( P, A ) )
				{
					A.GiveTo( P );
				}
				else
				{
					A.Destroy();
				}
			}
		}
	}
}

// end of giMP.uc

defaultproperties
{
     bPauseable=False
}
