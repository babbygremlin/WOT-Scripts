//=============================================================================
// WotRangeHandlerFoundRefuge.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class WotRangeHandlerFoundRefuge expands RangeHandlerFoundRefuge;

function bool HasFoundRefuge( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bHasFoundRefuge;

	//Log( RangeActor $ "::WotRangeHandlerFoundRefuge::HasFoundRefuge" );
	if( RangeActor.IsA( 'Captain' ) )
	{	
		bHasFoundRefuge = HasCaptainFoundRefuge( Captain( RangeActor ) );
	}
	else if( RangeActor.IsA( 'Grunt' ) )
	{
		bHasFoundRefuge = HasGruntFoundRefuge( Grunt( RangeActor ) );
	}
	
	return bHasFoundRefuge;
}



static function bool HasGruntFoundRefuge( Grunt SearchingGrunt )
{
	local int NumGruntsSeen;
	local Pawn CurrentPawn;
    local WOTPlayer CurrentWotPlayer;
    local bool	bFoundRefuge;
	
	NumGruntsSeen = 0;
	foreach SearchingGrunt.VisibleActors( class'Pawn', CurrentPawn )
	{
        if( ( CurrentPawn != SearchingGrunt ) &&
        		SearchingGrunt.IsFriendly( CurrentPawn ) )
        {
            CurrentWotPlayer = WOTPlayer( CurrentPawn );
            if( CurrentWotPlayer != None && CurrentWotPlayer.LooksLikeAWOTPlayer() )
            {
				bFoundRefuge = true;
				break;
			}
           	else if( ( CurrentPawn.IsA( 'Captain' ) &&
           			Captain( CurrentPawn ).IsHealthy() ) ||
           			( CurrentWotPlayer != None &&
           			CurrentWotPlayer.LooksLikeA( class'Captain' ) ) )
            {
	            //Ordering is important here, since Captains
	            //will also have Grunt( WP ) != None...
       	        bFoundRefuge = true;
				break;
            }
            else if( ( CurrentPawn.IsA( 'Grunt' ) &&
           			Grunt( CurrentPawn ).IsHealthy() ) ||
            		( CurrentWotPlayer != None &&
            		CurrentWotPlayer.LooksLikeA( class'Grunt' ) ) )
   	        {
       	        if( ++NumGruntsSeen > 1 )
           	    {
               	    bFoundRefuge = true;
					break;
              	}
            }
        }
    }

	//Log( SearchingGrunt $ "::WotRangeHandlerFoundRefuge::HasGruntFoundRefuge returning " $ bFoundRefuge );
	return bFoundRefuge;
}



static function bool HasCaptainFoundRefuge( Captain SearchingCaptain ) // Grunt override.
{
    local Pawn CurrentPawn;
    local bool bFoundRefuge;

    foreach SearchingCaptain.VisibleActors( class'Pawn', CurrentPawn )
    {
        if( ( CurrentPawn != SearchingCaptain ) &&
        		SearchingCaptain.IsFriendly( CurrentPawn ) )
        {
        	//the current pawn is friendly
            if( CurrentPawn.IsA( 'WOTPlayer' ) )
            {
                bFoundRefuge =  true;
            }
            else if( CurrentPawn.IsA( 'Captain' ) &&
            		Captain( CurrentPawn ).IsHealthy() )
            {
                bFoundRefuge = true;
            }
        }
    }
    
	//Log( SearchingCaptain $ "::WotRangeHandlerFoundRefuge::HasCaptainFoundRefuge returning " $ bFoundRefuge );
    return bFoundRefuge;
}

defaultproperties
{
}
