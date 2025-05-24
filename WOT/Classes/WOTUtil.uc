//=============================================================================
// WOTUtil
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 10 $
//=============================================================================

class WOTUtil expands LegendObjectComponent	abstract;



//------------------------------------------------------------------------------
// Use to remove ALL reflectors from the given Pawn.
// Note: This should only be used for cleaning out default reflectors on dead
// Pawns.  Manually removing !bRemovable Reflectors is generally dangerous.
//------------------------------------------------------------------------------
static final function RemoveAllReflectorsFrom( Pawn Other )
{
	local ReflectorIterator IterR;
	local Reflector R;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Other );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		R.UnInstall();
		R.Destroy();
	}
	IterR.Reset();
	IterR = None;
}



//------------------------------------------------------------------------------
// Use to find out if a leech of the given type is attached to the given Pawn.
//------------------------------------------------------------------------------
static final function bool HasLeechOfType( Pawn Other, name LeechType, optional bool bIgnoreSubclasses )
{
	local bool bHasLeech;

	local LeechIterator IterL;
	local Leech L;

	IterL = class'LeechIterator'.static.GetIteratorFor( Other );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( bIgnoreSubclasses )
		{
			if( L.Class.Name == LeechType )
			{
				bHasLeech = true;
				break;
			}
		}
		else
		{
			if( L.IsA( LeechType ) )
			{
				bHasLeech = true;
				break;
			}
		}
	}
	IterL.Reset();
	IterL = None;

	return bHasLeech;
}



//------------------------------------------------------------------------------
// Use to find out if a reflector of the given type is installed in the given Pawn.
//------------------------------------------------------------------------------
static final function bool HasReflectorOfType( Pawn Other, name ReflectorType, optional bool bIgnoreSubclasses )
{
	local bool bHasReflector;

	local ReflectorIterator IterR;
	local Reflector R;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Other );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( bIgnoreSubclasses )
		{
			if( R.Class.Name == ReflectorType )
			{
				bHasReflector = true;
				break;
			}
		}
		else
		{
			if( R.IsA( ReflectorType ) )
			{
				bHasReflector = true;
				break;
			}
		}
	}
	IterR.Reset();
	IterR = None;

	return bHasReflector;
}



//------------------------------------------------------------------------------
// Shift out of all bad, removable, non-projectile leeches and reflectors.
//------------------------------------------------------------------------------
static final function ShiftOutOfLeechesAndReflectors( Pawn Other )
{
	ShiftOutOfLeeches( Other );
	ShiftOutOfReflector( Other );
}



//------------------------------------------------------------------------------
// Shift out of all bad, removable, non-projectile leeches.
//------------------------------------------------------------------------------
static final function ShiftOutOfLeeches( Pawn Other )
{
	local LeechIterator IterL;
	local Leech L;

	IterL = class'LeechIterator'.static.GetIteratorFor( Other );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.bRemovable && L.bDeleterious && !L.bFromProjectile )
		{
			L.UnAttach();
			L.Destroy();
		}
	}
	IterL.Reset();
	IterL = None;
}



//------------------------------------------------------------------------------
// Shift out of all bad, removable, non-projectile reflectors.
//------------------------------------------------------------------------------
static final function ShiftOutOfReflector( Pawn Other )
{
	local ReflectorIterator IterR;
	local Reflector R;

	IterR = class'ReflectorIterator'.static.GetIteratorFor( Other );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.bRemovable && R.bDeleterious && !R.bFromProjectile )
		{
			R.UnInstall();
			R.Destroy();
		}
	}
	IterR.Reset();
	IterR = None;
}



static final function InvokeWotPawnFindLeader( Captain InvokingCaptain )
{
    local WOTPawn CurrentWotPawn;
    //Could just look for Grunts, but you'd pick up the Captains
    //anyway (since Captain derives from Grunt).
    foreach InvokingCaptain.RadiusActors( class'WOTPawn', CurrentWotPawn, InvokingCaptain.LeadershipRadius )
    {
    	if( CurrentWotPawn != InvokingCaptain )
    	{
    		//class'Debug'.static.DebugLog( InvokingCaptain, "InvokeWotPawnFindLeader notifing " $ CurrentWotPawn, DebugCategoryName );
	        CurrentWotPawn.FindLeader();
        }
    }
}



static function bool CollectAvailableWotPawns( Pawn SearchingPawn, ItemCollector Collector, float HelpRadius )
{
    local WOTPawn CurrentWotPawn;
    local int i, ItemCount, RejectedCount;
    
   	class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns HelpRadius " $ HelpRadius, default.DebugCategoryName );
	Collector.CollectRadiusItems( SearchingPawn, class'WotPawn', HelpRadius + 500 ); //xxxrlo
	if( Collector.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			CurrentWotPawn = WotPawn( Collector.GetItem( i ) );
	    	class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns considering CurrentWotPawn: " $ CurrentWotPawn, default.DebugCategoryName );
			if( ( CurrentWotPawn == None ) || !CurrentWotPawn.CanBeGivenNewOrders() )
      		{
	      		Collector.RejectItem( i );
		      	RejectedCount++;
    	    }
		}
	}
	
   	class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns ItemCount: " $ ItemCount, default.DebugCategoryName );
   	class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns RejectedCount: " $ RejectedCount, default.DebugCategoryName );
	
	return ( ( ItemCount - RejectedCount ) > 0 );
}



static function bool GetNextAvailableWotPawn( Pawn SearchingPawn, GoalAbstracterInterf Goal, ItemSorter Sorter )
{
    local WOTPawn CurrentWotPawn;
    local bool bFoundWotPawn;
    local int i, ItemCount;
    
	Sorter.InitSorter();
	Sorter.SortReq.IR_Origin = SearchingPawn.Location;
	Sorter.SortItems();
	
	Sorter.DebugLog( SearchingPawn );
	
	if( Sorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			if( Sorter.IsItemAccepted( i ) )
			{
    			class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns considering CurrentWotPawn: " $ CurrentWotPawn, default.DebugCategoryName );
				CurrentWotPawn = WotPawn( Sorter.GetItem( i ) );
				if( CurrentWotPawn != None )
		      	{
		      		if( CurrentWotPawn.CanBeGivenNewOrders() )
	    	  		{
				    	Goal.AssignObject( SearchingPawn, CurrentWotPawn );
    				    if( Goal.IsGoalNavigable( SearchingPawn ) )
	        			{
    	   	    	    	bFoundWotPawn = true;
				    	  	Sorter.RejectItem( i );
    	   		        	break;
	        			}
	        		}
    	    		else
        			{
		   		      	Sorter.RejectItem( i );
        			}
		        }
    	    }
   		}
	}
	
	if( !bFoundWotPawn )
	{
		class'Debug'.static.DebugLog( SearchingPawn, "GetClosestAvailableWotPawn none available", default.DebugCategoryName );
		Goal.Invalidate( SearchingPawn );
	}
	
	class'Debug'.static.DebugLog( SearchingPawn, "GetClosestAvailableWotPawn returning " $ bFoundWotPawn, default.DebugCategoryName );
	return bFoundWotPawn;
}



static final function bool GetTeamSealAltar( GoalAbstracterInterf SealAltarGoal,
		Pawn SearchingPawn )
{
    local SealAltar CurrentSealAltar, ReturnedSealAltar;
    local bool bFoundSealAltar;
    
    foreach SearchingPawn.AllActors( class'SealAltar', CurrentSealAltar )
    {
    	class'Debug'.static.DebugLog( SearchingPawn, "GetTeamSealAltar considering CurrentSealAltar: " $ CurrentSealAltar, default.DebugCategoryName );
    	class'Debug'.static.DebugLog( SearchingPawn, "GetTeamSealAltar considering CurrentSealAltar.Team: " $ CurrentSealAltar.Team, default.DebugCategoryName );
    	if( CurrentSealAltar.Team == SearchingPawn.PlayerReplicationInfo.Team )
    	{
	    	SealAltarGoal.AssignObject( SearchingPawn, CurrentSealAltar );
        	if( SealAltarGoal.IsGoalNavigable( SearchingPawn ) )
	        {
	        	//the current seal altar is directly reachable or pathable
	        	ReturnedSealAltar = CurrentSealAltar;
				bFoundSealAltar = true;
				break;
    	    }
        }
    }
	
	if( !bFoundSealAltar )
	{
		class'Debug'.static.DebugLog( SearchingPawn, "GetTeamSealAltar none available ", default.DebugCategoryName );
		SealAltarGoal.Invalidate( SearchingPawn );
	}


	class'Debug'.static.DebugLog( SearchingPawn, "GetTeamSealAltar returning " $ bFoundSealAltar, default.DebugCategoryName );
    return bFoundSealAltar;
}


static final function bool GetClosestUnownedSeal( GoalAbstracterInterf SealGoal, Pawn SearchingPawn )
{
	return GetClosestGoal( SealGoal, class'Seal', SearchingPawn, true );
}



static final function bool GetClosestTeamSeal( GoalAbstracterInterf SealGoal, Pawn SearchingPawn )
{
	return GetClosestGoal( SealGoal, class'Seal', SearchingPawn, false, true );
}



static function bool GetClosestAlarm( GoalAbstracterInterf AlarmGoal,
		Pawn SearchingPawn, float AlarmRadius )
{
	//the alarm needs to be on the same team as the captain?
	return GetClosestGoal( AlarmGoal, class'Alarm', SearchingPawn, true );
}



// <sarcasm>Let's hear it for polymorphism!</sarcasm> -- where's a good Interface when you need one?
static final function byte GetActorTeam( Actor Other )
{
	// NOTE[aleiby]: Make sure we aren't pulling in too many assets (memory-wise) by doing this.

	local byte Team;

	Team = 255;	// Use something else for failure? (-1)

	if( Other == None )
	{
		warn( Other $ " doesn't have a Team variable." );
		assert( false );
	}
	if( Other.IsA( 'Pawn' ) && Pawn(Other).PlayerReplicationInfo != None )
	{
		Team = Pawn(Other).PlayerReplicationInfo.Team;
	}
	else if( Other.IsA( 'Seal' ) )
	{
		Team = Seal(Other).Team;
	}
	else if( Other.IsA( 'SealAltar' ) )
	{
		Team = SealAltar(Other).Team;
	}
	else if( Other.IsA( 'AngrealIllusionProjectile' ) )
	{
		Team = AngrealIllusionProjectile(Other).Team;
	}
/*
	else if( Other.IsA( 'MashadarGuide' ) )
	{
		Team = MashadarGuide(Other).Team;
	}
	else if( Other.IsA( 'MashadarManager' ) )
	{
		Team = MashadarManager(Other).Team;
	}
*/
	else if( Other.IsA( 'WOTZoneInfo' ) )
	{
		Team = WOTZoneInfo(Other).Team;
	}
	else if( Other.IsA( 'BudgetInfo' ) )
	{
		Team = BudgetInfo(Other).Team;
	}
	else if( Other.IsA( 'Inventory' ) && Inventory(Other).Owner != None )
	{
		//!! hmmm... what if there is a cyclical chain of Inventory items each with the next as its Owner?
		Team = GetActorTeam( Inventory(Other).Owner );
	}
	else
	{
		warn( Other $ " doesn't have a Team variable." );
		assert( false );
	}

	return Team;
}




static final function bool GetClosestGoal( GoalAbstracterInterf Goal, class<actor> GoalClass, Pawn SearchingPawn, 
		optional bool bOnlyUnownedGoals, optional bool bOnlySameTeam )
{
    local Actor CurrentActor;
    local bool bFoundNavigableGoal;
    local int i, ItemCount;
    local ItemSorter GoalSorter;
	
	GoalSorter = ItemSorter( class'Singleton'.static.GetInstance( SearchingPawn.XLevel, class'ItemSorter' ) );
	GoalSorter.CollectAllItems( SearchingPawn, GoalClass );
	GoalSorter.InitSorter();
	GoalSorter.SortReq.IR_Origin = SearchingPawn.Location;
	GoalSorter.SortItems();
	if( GoalSorter.GetItemCount( ItemCount ) )
	{
		class'Debug'.static.DebugLog( SearchingPawn, "GetClosestGoal GoalClass " $ GoalClass, default.DebugCategoryName );
		class'Debug'.static.DebugLog( SearchingPawn, "GetClosestGoal ItemCount " $ ItemCount, default.DebugCategoryName );
		for( i = 0; i < ItemCount; i++ )
		{
			CurrentActor = GoalSorter.GetItem( i );
			class'Debug'.static.DebugLog( SearchingPawn, "GetClosestGoal CurrentActor " $ CurrentActor, default.DebugCategoryName );
			if(	!bOnlyUnownedGoals || ( CurrentActor.Owner == None ) && !bOnlySameTeam ||
					( GetActorTeam( CurrentActor ) == GetActorTeam( SearchingPawn ) ) )
    		{
    			//goal ownership is irrelevent or the goal is unowned
	    		Goal.AssignObject( SearchingPawn, CurrentActor );
	    	    if( Goal.IsGoalNavigable( SearchingPawn ) )
    	    	{
					//the goal is navigable
					bFoundNavigableGoal = true;
					break;
		        }
			}
		}
	}
	
 	if( !bFoundNavigableGoal )
	{
		Goal.Invalidate( SearchingPawn );
		class'Debug'.static.DebugLog( SearchingPawn, "GetClosestGoal no goal", default.DebugCategoryName );
	}
	else
	{
		class'Debug'.static.DebugLog( SearchingPawn, "GetClosestGoal CurrentActor " $ CurrentActor, default.DebugCategoryName );
	}
	
    return bFoundNavigableGoal;
}



static function bool GetLeader( Pawn SearchingPawn, out Captain Leader )
{
    local Captain CurrentCaptain;
    local ItemSorter GoalSorter;
    local int i, ItemCount;
    local bool bFoundLeader;
    
	GoalSorter = ItemSorter( class'Singleton'.static.GetInstance( SearchingPawn.XLevel, class'ItemSorter' ) );
	GoalSorter.CollectAllItems( SearchingPawn, class'Captain' );
	GoalSorter.InitSorter();
	GoalSorter.SortReq.IR_Origin = SearchingPawn.Location;
	GoalSorter.SortItems();

	if( GoalSorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			if( GoalSorter.IsItemAccepted( i ) )
			{
				CurrentCaptain = Captain( GoalSorter.GetItem( i ) );
   				class'Debug'.static.DebugLog( SearchingPawn, "CollectAvailableWotPawns considering CurrentCaptain: " $ CurrentCaptain, default.DebugCategoryName );
   				bFoundLeader = ( ( CurrentCaptain != None ) && CurrentCaptain.IsLeader() && ( GoalSorter.GetSortScore( i ) < CurrentCaptain.LeadershipRadius ) );
				if( bFoundLeader )
    		  	{
					Leader = CurrentCaptain;
					break;
		        }
		        else
	    	    {
		    		GoalSorter.RejectItem( i );
		        }
		 	}
		}
	}
    return bFoundLeader;
}



//===========================================================================
// Control when WOTPawns/WOTPlayers will gib.
//===========================================================================

static function bool WOTGibbed( Pawn DeadPawn, Name DamageType, float GibForSureFinalHealth, float GibSometimesFinalHealth, float GibSometimesOdds )
{
	if( DeadPawn.Tag == 'balefired' )
	{
		return false;
	}

	if ( (DeadPawn.Health < GibForSureFinalHealth) || 
		 ((DeadPawn.Health < GibSometimesFinalHealth) && (FRand() < GibSometimesOdds)) )
	{
		return true;
	}

	return false;
}

defaultproperties
{
     DebugCategoryName=WOTUtil
}
