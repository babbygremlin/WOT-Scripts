//=============================================================================
// HitActorInfoSpammer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class HitActorInfoSpammer expands InfoSpammer;

const NumLinesToClear = 4;

var private bool bSpamHitActors;
var private int ClearCount;

function ShowSpam()
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	local string TeamStr;

	HitActor = class'util'.static.GetHitActor( PlayerPawn(Owner), !bSpamHitActors );

	if( HitActor != None && LevelInfo(HitActor) == None )
	{
		if( Pawn(HitActor) != None )
		{
			TeamStr = "X";
			if( Pawn(HitActor).PlayerReplicationInfo != None )
			{
				// !!! test
				TeamStr = Chr( Pawn(HitActor).PlayerReplicationInfo.Team );
			}
			ShowString( "Viewing "  $ HitActor.Name $
						"."			$ HitActor.GetStateName() $
						"("			$ HitActor.AnimSequence $ ")" $
						" Hlth="	$ Pawn(HitActor).Health $
						" Team="    $ TeamStr $
						" E/T="     $ HitActor.Event $ "/" $ HitActor.Tag $
						" Dist="    $ int(VSize( HitActor.Location - Owner.Location)) );
		}
		else
		{
			ShowString( "Viewing " $ HitActor.Name $ 
						"."		   $ HitActor.GetStateName() $
						"("			$ HitActor.AnimSequence $ ")" $
						" E/T="    $ HitActor.Event $ "/" $ HitActor.Tag $
						" Dist="   $ int(VSize( HitActor.Location - Owner.Location)) );
		}

		ClearCount=NumLinesToClear;
	}
	else if( ClearCount > 0 )
	{
		PlayerPawn(Owner).ClientMessage( " " );

		ClearCount--;
	}
}



function EnableSpamHitActors()
{
     bSpamHitActors=true;
}

defaultproperties
{
}
