//=============================================================================
// GoalContext.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================

class GoalContext expands GoalContextInterf native;

var () private class<ContextSensitiveGoal> 	NavigationGoalType;
var () private class<GoalReachedHandler> 	ReachedHandlerClass;

var private Object							ContextObject;
var private GoalCacheInfo 					GoalCache;
var private GoalAbstracterInterf			NavigationGoal;
var private GoalReachedHandler 				ReachedHandler;

var private Rotator							AssociatedRotation;
var private bool							bUseAssociatedRotation;

const NavigableAvoidGoalRadius = 500.0;
const FindReachableRandomNavigationPointRadius = 800;
const bUseEnginePathing = true;



//=============================================================================
// public interface
//=============================================================================



function Destructed()
{
	GoalContextInit( None, None );
	if( NavigationGoal != None )
	{
		NavigationGoal.Delete();
		NavigationGoal = None;
	}
	if( GoalCache != None )
	{
		GoalCache.Delete();
		GoalCache = None;
	}
	if( ReachedHandler != None )
	{
		ReachedHandler.Delete();
		ReachedHandler = None;
	}
	Super.Destructed();
}



static event CreateGoalContext( out GoalContextInterf NewContextInterf,
		GoalAbstracterInterf ContextOf,
		Actor ContextActor )
{
	local GoalContext NewContext;
	class'Debug'.static.DebugLog( ContextActor, "CreateGoalContext", default.DebugCategoryName );
	NewContext = New( ContextOf )default.Class;
	NewContext.NavigationGoal = new( NewContext )default.NavigationGoalType;
	class'GoalCacheInfo'.static.CreateGoalCache( NewContext.GoalCache, NewContext, ContextOf, ContextActor );
	if( ( NewContext.ReachedHandlerClass != None ) )
	{
		NewContext.BindReachedHandler( new( NewContext )NewContext.ReachedHandlerClass );
	}
	NewContext.GoalContextInit( ContextOf, ContextActor );
	NewContextInterf = NewContext;
}



function BindReachedHandler( GoalReachedHandler NewReachedHandler )
{
	class'Debug'.static.DebugLog( ContextObject, "BindReachedHandler NewReachedHandler " $ NewReachedHandler, DebugCategoryName );
	ReachedHandler = NewReachedHandler;
}



event bool UltimateGoalReached()
{
	class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached Outer" $ Outer, DebugCategoryName );
	class'Debug'.static.DebugLog( ContextObject, "UltimateGoalReached ReachedHandler " $ ReachedHandler, DebugCategoryName );
	
	if( ReachedHandler != None )
	{
		ReachedHandler.OnUltimateGoalReachedBy( ContextObject, GoalAbstracterInterf( Outer ) );
	}
	return true;
}



event IntermediateGoalReached()
{
	local NavigationPoint CurrentNavigPoint, NextNavigPoint;
	local Actor NavigationGoalActor;
	local float NextTravelDistance, CurrentActorSpeed;

	class'Debug'.static.DebugLog( ContextObject, "IntermediateGoalReached Outer" $ Outer, DebugCategoryName );
	class'Debug'.static.DebugLog( ContextObject, "IntermediateGoalReached ReachedHandler " $ ReachedHandler, DebugCategoryName );
	
	if( ReachedHandler != None )
	{
		ReachedHandler.OnIntermediateGoalReachedBy( ContextObject, NavigationGoal );
	}
}



//=============================================================================
// path goal interface
//=============================================================================



//Pawn provides a FindRandomDest(), but my tests seem to show that it picks
//navigation points which the pawn cannot reach directly.  This fn also
//picks randomly, but makes sure that only reachable points are picked.
function bool FindFirstNavigablePathGoal( GoalAbstracterInterf PathGoal )
{
	local NavigationPoint CurrentNavigPt;
	local bool bFoundPathGoal;
	local Actor ContextActor;
	
	class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigablePathGoal", DebugCategoryName );
	ContextActor = Actor( ContextObject );
	if( ContextActor != None )
	{
		foreach ContextActor.RadiusActors( class'NavigationPoint', CurrentNavigPt,
				FindReachableRandomNavigationPointRadius )
		{
			class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigablePathGoal CurrentNavigPt: " $ CurrentNavigPt, DebugCategoryName );
			PathGoal.AssignObject( ContextObject, CurrentNavigPt );
			if( PathGoal.IsGoalNavigable( ContextObject ) && !PathGoal.IsGoalReached( ContextObject ) )
			{
		   	   	//the path goal is not too close to the searching pawn
				//the path goal is navigable by the searching pawn
				bFoundPathGoal = true;
				break;
			}
		}
	}
	
	class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigablePathGoal returning " $ bFoundPathGoal, DebugCategoryName );
    return bFoundPathGoal;
}



//The Unreal engine provides nifty functions for finding the best path 
//somewhere, but nothing for when we want to use paths to get *away* from
//something instead of towards it.  So, this function does that.
//RETURNS: Ultimate destination path.  ActorReachable(RetVal) is not
//necessarily true -- pawn might have to traverse intermediate path nodes first.
//find a reachable random path node not in the line of sight of the goal
function bool FindFirstNavigableAvoidGoalPathGoal( GoalAbstracterInterf PathGoal )
{
	local bool bFoundPathGoal;
	local int CurrentItemIdx;
	local Vector GoalLocation;
	local Actor ContextActor;
	local ItemSorter NavigPointSorter;
	
	class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigableAvoidGoalPathGoal", DebugCategoryName );

	ContextActor = Actor( ContextObject );
	if( ( ContextActor != None ) && GoalAbstracterInterf( Outer ).GetGoalLocation( ContextObject, GoalLocation ) )
    {
	    NavigPointSorter = ItemSorter( class'Singleton'.static.GetInstance( ContextActor.XLevel, class'ItemSorter' ) );
		NavigPointSorter.CollectRadiusItems( ContextActor, class'NavigationPoint', NavigableAvoidGoalRadius );

		NavigPointSorter.SortReq.IR_Origin = GoalLocation;
		NavigPointSorter.SortReq.IR_MaxDistance =  0;
		NavigPointSorter.SortReq.IR_MaxDistanceReq = R_Irrelevant;
		NavigPointSorter.SortReq.IR_MinDistance = 0;
		NavigPointSorter.SortReq.IR_MinDistanceReq = R_Irrelevant;
		NavigPointSorter.SortReq.IR_TraceInfo = TRACE_Unobstruced;
		NavigPointSorter.SortReq.IR_TraceInfoReq = R_Irrelevant;
		
		NavigPointSorter.SortItems();

		NavigPointSorter.DebugLog( ContextActor );
		
		//attempt to find an item that is far away and blocked by geometry
		if( NavigPointSorter.GetItemCount( CurrentItemIdx ) )
		{
			for( CurrentItemIdx = CurrentItemIdx - 1; CurrentItemIdx >= 0; CurrentItemIdx-- )
			{
				if( NavigPointSorter.GetItemTraceInfo( CurrentItemIdx ) == TRACE_GeometryObstruced )
				{
		        	PathGoal.AssignObject( ContextObject, NavigPointSorter.GetItem( CurrentItemIdx ) );
		        	if( PathGoal.IsGoalNavigable( ContextObject ) && !PathGoal.IsGoalReached( ContextObject ) )
	        		{
				    	//the path goal is not visible by the goal
		    	    	//the path goal is not too close to the ContextObject
				    	//the path goal is navigable by the ContextObject
						class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigableAvoidGoalPathGoal SelectedItem: " $ NavigPointSorter.GetItem( CurrentItemIdx ), DebugCategoryName );
						bFoundPathGoal = true;
						break;
		        	}
				}
			}
		}
		
		if( !bFoundPathGoal )
		{
			//attempt to find an item that is far away
			if( NavigPointSorter.GetItemCount( CurrentItemIdx ) )
			{
				for( CurrentItemIdx = CurrentItemIdx - 1; CurrentItemIdx >= 0; CurrentItemIdx-- )
				{
					if( ( NavigPointSorter.GetItemTraceInfo( CurrentItemIdx ) != TRACE_GeometryObstruced ) &&
						( NavigPointSorter.GetItemTraceInfo( CurrentItemIdx ) != TRACE_Untested ) )
					{
		        		PathGoal.AssignObject( ContextObject, NavigPointSorter.GetItem( CurrentItemIdx ) );
	    	    		if( PathGoal.IsGoalNavigable( ContextObject ) && !PathGoal.IsGoalReached( ContextObject ) )
	        			{
				    		//the path goal is not visible by the goal
		    	    		//the path goal is not too close to the ContextObject
				    		//the path goal is navigable by the ContextObject
							class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigableAvoidGoalPathGoal SelectedItem: " $ NavigPointSorter.GetItem( CurrentItemIdx ), DebugCategoryName );
							bFoundPathGoal = true;
							break;
		        		}
					}
				}
			}
		}
	}	

	class'Debug'.static.DebugLog( ContextObject, "FindFirstNavigableAvoidGoalPathGoal returning " $ bFoundPathGoal, DebugCategoryName );
   	return bFoundPathGoal;
}






//=============================================================================
// public static interface from goal contextinterf
//=============================================================================



/*
static function bool IsGoalReachedByObject( Object ContextObject, GoalAbstracterInterf Goal )
{
	local float GoalDistance;
	return ( Goal.IsValid( ContextObject ) &&
			Goal.GetGoalDistance( ContextObject, GoalDistance, ContextObject ) &&
			IsCloseEnough( GoalDistance ) );
}
*/


/*
static function bool IsGoalVisibleByObject( Object ContextObject, GoalAbstracterInterf Goal )
{
	local Pawn ContextPawn;
	local Actor CurrentGoalActor, TraceHitActor;
	local Vector CurrentGoalLocation, TraceHitLocation, TraceHitNormal;
	local bool bGoalIsVisible;
	
	class'Debug'.static.DebugLog( ContextObject, "IsGoalVisibleByObject", default.DebugCategoryName );
	
	ContextPawn = Pawn( ContextObject );
	if( ContextPawn != None )
	{
		if( Goal.GetGoalActor( ContextPawn, CurrentGoalActor ) )
		{
//xxxrlo	bGoalIsVisible = ContextPawn.CanSee( CurrentGoalActor );
			bGoalIsVisible = ContextPawn.LineOfSightTo( CurrentGoalActor );
		}
		else if( Goal.GetGoalLocation( ContextPawn, CurrentGoalLocation ) )
		{
			TraceHitActor = ContextPawn.Trace( TraceHitLocation, TraceHitNormal, CurrentGoalLocation );
			bGoalIsVisible = ( TraceHitActor == None );
		}
	}
	
	class'Debug'.static.DebugLog( ContextObject, "IsGoalVisibleByObject CurrentGoalActor " $ CurrentGoalActor, default.DebugCategoryName );
	class'Debug'.static.DebugLog( ContextObject, "IsGoalVisibleByObject returning " $ bGoalIsVisible , default.DebugCategoryName );
	return bGoalIsVisible;
}
*/


/*
static function bool IsGoalReachableByObject( Object ContextObject, GoalAbstracterInterf Goal )
{
	local Pawn ContextPawn;
	local Actor CurrentGoalActor;
	local Vector CurrentGoalLocation, TraceHitNormal;
	local bool bGoalIsReachable, bRestoreFallingPhysics;
	
	class'Debug'.static.DebugLog( ContextObject, "IsGoalReachableByObject", default.DebugCategoryName );
	ContextPawn = Pawn( ContextObject );
	if( ContextPawn != None )
	{

//xxxrlo hack!
		if( ContextPawn.Physics == PHYS_Falling )
		{
			bRestoreFallingPhysics = true;
			ContextPawn.SetPhysics( PHYS_Walking );
		}
//xxxrlo hack!

		if( Goal.GetGoalActor( ContextPawn, CurrentGoalActor ) )
		{
			class'Debug'.static.DebugLog( ContextPawn, "IsGoalReachableByObject CurrentGoalActor " $ CurrentGoalActor, default.DebugCategoryName );
			if( CurrentGoalActor.Physics == PHYS_Falling )
			{
/*
//xxxrlo
the ramifications of this hack are significant!
the reachable successful cache is going to end up with the location of the goal in space
the navigation goal will just be initialized with the goal
as opposed to the goal's location on the floor 
*/
				class'Util'.static.TraceRecursive( ContextPawn, CurrentGoalLocation, TraceHitNormal, CurrentGoalActor.Location, false, CurrentGoalActor.CollisionHeight );
				CurrentGoalLocation.z += CurrentGoalActor.CollisionHeight;
				bGoalIsReachable = ContextPawn.PointReachable( CurrentGoalLocation );
		
				class'Debug'.static.DebugLog( ContextObject, "IsGoalReachableByObject CurrentGoalActor.Location " $ CurrentGoalActor.Location, default.DebugCategoryName );
				class'Debug'.static.DebugLog( ContextObject, "IsGoalReachableByObject CurrentGoalLocation " $ CurrentGoalLocation, default.DebugCategoryName );
			}
			else
			{
				bGoalIsReachable = ContextPawn.ActorReachable( CurrentGoalActor );
			}
		}
		else if( Goal.GetGoalLocation( ContextPawn, CurrentGoalLocation ) )
		{
			bGoalIsReachable = ContextPawn.PointReachable( CurrentGoalLocation );
		}

//xxxrlo hack!
		if( bRestoreFallingPhysics )
		{
			ContextPawn.SetPhysics( PHYS_Falling );
		}
//xxxrlo hack!

	}
	class'Debug'.static.DebugLog( ContextObject, "IsGoalReachableByObject returning " $ bGoalIsReachable, default.DebugCategoryName );
	return bGoalIsReachable;
}
*/


/*
static function bool IsGoalPathableByObject( Object ContextObject, GoalAbstracterInterf Goal )
{
	local NavigationPoint NavigPoint;
	local bool bNavigPtFound;
	local Actor ContextActor;
	
	class'Debug'.static.DebugLog( ContextObject, "IsGoalPathableByObject", default.DebugCategoryName );
	ContextActor = Actor( ContextObject );
	if( ContextActor != None )
	{
		bNavigPtFound = FindNavigationPointFromActor( NavigPoint, ContextActor, Goal );
	}
	class'Debug'.static.DebugLog( ContextObject, "IsGoalPathableByObject returning " $ bNavigPtFound, default.DebugCategoryName );
	return bNavigPtFound;
}
*/


/*
static function bool IsGoalNavigableByObject( Object ContextObject, GoalAbstracterInterf Goal )
{
	local Actor CurrentGoalActor;
	local bool bNavigable;
	
	class'Debug'.static.DebugLog( ContextObject, "IsGoalNavigableByObject", default.DebugCategoryName );
	bNavigable = IsGoalReachableByObject( ContextObject, Goal ) || IsGoalPathableByObject( ContextObject, Goal );
	class'Debug'.static.DebugLog( ContextObject, "IsGoalNavigableByObject returning " $ bNavigable, default.DebugCategoryName );
	return bNavigable;
}
*/


/*
static function bool GetActorNavigationGoal( Object InvokingObject, GoalAbstracterInterf NavigationGoal )
{
	//xxxrlo
	return false;
}
*/


/*
static function bool FindNavigationGoalFromActor( GoalAbstracterInterf NavigationGoal, Actor ContextObject, GoalAbstracterInterf Goal )
{
	local Vector GoalLocation;
	local NavigationPoint FoundNavigPoint;
	
	class'Debug'.static.DebugLog( ContextObject, "FindNavigationGoalFromActor", default.DebugCategoryName );
	if( IsGoalReachableByObject( ContextObject, Goal ) )
	{
		class'Debug'.static.DebugLog( ContextObject, "FindNavigationGoalFromActor the goal is reachable", default.DebugCategoryName );
		NavigationGoal.AssignObject( ContextObject, Goal );
	}
	else if( Goal.IsA( 'GoalAbstracterInterf' ) && FindNavigationPointFromActor( FoundNavigPoint, ContextObject, Goal ) )
	{
		class'Debug'.static.DebugLog( ContextObject, "FindNavigationGoalFromActor the goal is pathable", default.DebugCategoryName );
		NavigationGoal.AssignObject( ContextObject, FoundNavigPoint );
	}
	else
	{
		class'Debug'.static.DebugLog( ContextObject, "FindNavigationGoalFromActor the goal is not reachable or pathable", default.DebugCategoryName );
		NavigationGoal.Invalidate( ContextObject );
	}
	class'Debug'.static.DebugLog( ContextObject, "FindNavigationGoalFromActor returning " $ NavigationGoal.IsValid( ContextObject ), default.DebugCategoryName );
	return NavigationGoal.IsValid( ContextObject );
}
*/


//=============================================================================
// private static interface
//=============================================================================



/*
static function bool FindNavigationPointFromActor( out NavigationPoint FoundNavigPoint, Actor ContextObject, GoalAbstracterInterf Goal )
{
	local Pawn ContextPawn;
	local Vector CurrentGoalLocation, TraceHitNormal;
	local Actor CurrentGoalActor;
	local bool bNavigPointFound, bRestoreFallingPhysics;

	class'Debug'.static.DebugLog( ContextObject, "FindNavigationPointFromActor", default.DebugCategoryName );
	ContextPawn = Pawn( ContextObject );
	if( ContextPawn != None )
	{
//xxxrlo hack!
		if( ContextPawn.Physics == PHYS_Falling )
		{
			bRestoreFallingPhysics = true;
			ContextPawn.SetPhysics( PHYS_Walking );
		}
//xxxrlo hack!

		class'Debug'.static.DebugLog( ContextPawn, "FindNavigationPointFromActor attempting to use engine path node interface interface", default.DebugCategoryName );
		if( Goal.GetGoalActor( ContextPawn, CurrentGoalActor ) )
		{
			class'Debug'.static.DebugLog( ContextPawn, "FindNavigationPointFromActor CurrentGoalActor " $ CurrentGoalActor, default.DebugCategoryName );
			if( CurrentGoalActor.Physics == PHYS_Falling )
			{
/*
//xxxrlo
the ramifications of this hack are significant!
the reachable successful cache is going to end up with the location of the goal in space
the navigation goal will just be initialized with the goal
as opposed to the goal's location on the floor 
*/
				class'Util'.static.TraceRecursive( ContextPawn, CurrentGoalLocation, TraceHitNormal, CurrentGoalActor.Location, false, CurrentGoalActor.CollisionHeight );
				CurrentGoalLocation.z += CurrentGoalActor.CollisionHeight;
				FoundNavigPoint = NavigationPoint( ContextPawn.FindPathTo( CurrentGoalLocation ) );
				bNavigPointFound = ( FoundNavigPoint != None );

				class'Debug'.static.DebugLog( ContextObject, "FindNavigationPointFromActor CurrentGoalActor.Location " $ CurrentGoalActor.Location, default.DebugCategoryName );
				class'Debug'.static.DebugLog( ContextObject, "FindNavigationPointFromActor CurrentGoalLocation " $ CurrentGoalLocation, default.DebugCategoryName );
			}
			else
			{
				FoundNavigPoint = NavigationPoint( ContextPawn.FindPathToward( CurrentGoalActor ) );
				bNavigPointFound = ( FoundNavigPoint != None );
			}
		}
		else if( Goal.GetGoalLocation( ContextPawn, CurrentGoalLocation ) )
		{
			class'Debug'.static.DebugLog( ContextPawn, "FindNavigationPointFromActor CurrentGoalLocation " $ CurrentGoalLocation, default.DebugCategoryName );
			FoundNavigPoint = NavigationPoint( ContextPawn.FindPathTo( CurrentGoalLocation ) );
			bNavigPointFound = ( FoundNavigPoint != None );
		}

//xxxrlo hack!
		if( bRestoreFallingPhysics )
		{
			ContextPawn.SetPhysics( PHYS_Falling );
		}
//xxxrlo hack!
	}
	class'Debug'.static.DebugLog( ContextObject, "FindNavigationPointFromActor returning " $ bNavigPointFound, default.DebugCategoryName );
	return bNavigPointFound;
}
*/


/*
enum EGoalContextVisibility
{
	GCV_VisibilityUnknown,
	GCV_VisibilityVisible,
	GCV_VisibilityNotVisible
};
*/
//const ReachableRandomPathNoLineOfSightRadius = 1000.0;
//const FindAvoidGoalPathRadius = 800.0;

/*
//The Unreal engine provides nifty functions for finding the best path 
//somewhere, but nothing for when we want to use paths to get *away* from
//something instead of towards it.  So, this function does that.
//RETURNS: Ultimate destination path.  ActorReachable(RetVal) is not
//necessarily true -- pawn might have to traverse intermediate path nodes first.
function bool FindFirstAvoidGoalPathGoal( GoalAbstracterInterf PathGoal )
{
	return FindFirstNoLineOfSightPathGoal( PathGoal );
}
*/


/*
//Pawn provides a FindRandomDest(), but my tests seem to show that it picks
//navigation points which the pawn cannot reach directly.  This fn also
//picks randomly, but makes sure that only reachable points are picked.
static final function EPathGoalInfo FindRandomPathGoal(
	GoalAbstracterInterf PathGoal,
	Pawn SearchingPawn )
{
	local NavigationPoint CurrentNavigPt, PathGoalNavigPt;
	local float NumNavigPtsSeen, PathGoalNavigPtDistance, CurrentPathGoalDistance;
	local GoalContext PathGoalContext;
    local EPathGoalInfo CurrentPathGoalNavigPtInfo, PathGoalNavigPtInfo;
	
	if( PathGoal.GetGoalContext( PathGoalContext, PathGoalContext ) )
	{
	}

	//Log( SearchingPawn $ "::FindRandomPathGoal" );
	foreach SearchingPawn.RadiusActors( class'NavigationPoint',
			CurrentNavigPt, FindReachableRandomNavigationPointRadius )
	{
		PathGoal.AssignObject( CurrentNavigPt );
		CurrentPathGoalDistance = PathGoal.GetDistanceBetween( SearchingPawn );

		//Log( SearchingPawn $ "::FindRandomPathGoal CurrentNavigPt: " $ CurrentNavigPt );
		//Log( SearchingPawn $ "::FindRandomPathGoal CurrentNavigPtDistance: " $ CurrentNavigPtDistance );
		
		if( ( CurrentPathGoalDistance > TooCloseToLocation ) &&
				( CurrentPathGoalDistance > PathGoalNavigPtDistance ) )
		{
			PathGoalContext.IsGoalNavigable();

   		    if( PathGoal.IsReachableByActor( SearchingPawn ) )
   		    {
	   		   	CurrentPathGoalNavigPtInfo = PGI_Reachable;
   		    }
   		    else if( PathGoal.IsPathableByActor( SearchingPawn ) )
   		    {
	   		   	CurrentPathGoalNavigPtInfo = PGI_Pathable;
   		    }
   		    else
   		    {
	   		   	CurrentPathGoalNavigPtInfo = PGI_Invalid;
   		    }
   		    
	   		if( PathGoalContext.GetReachableInfo() || PathGoalContext.GetPathableInfo() CurrentPathGoalNavigPtInfo != PGI_Invalid )
	   		{
	   	    	//the path goal is not too close to the searching pawn
		    	//the current path goal is further away than the last path goal found
    			//the path goal is rechable or pathable by the searching pawn
				NumNavigPtsSeen += 1.0;
				if( FRand() < 1.0 / NumNavigPtsSeen )
				{
					//choose with equal probability
					PathGoalNavigPtInfo = CurrentPathGoalNavigPtInfo;
					PathGoalNavigPt = CurrentNavigPt;
					PathGoalNavigPtDistance = CurrentPathGoalDistance;
				}
			}
		}
	}
	
   	if( PathGoalNavigPtInfo != PGI_Invalid )
   	{
		//Log( SearchingPawn $ "::FindRandomPathGoal PathGoalNavigPt: " $ PathGoalNavigPt );
		//Log( SearchingPawn $ "::FindRandomPathGoal PathGoalNavigPt.Group: " $ PathGoalNavigPt.Group );
		//Log( SearchingPawn $ "::FindRandomPathGoal PathGoalNavigPtDistance: " $ PathGoalNavigPtDistance );
		//Log( SearchingPawn $ "::FindRandomPathGoal ActorReachable(): " $ SearchingPawn.ActorReachable( PathGoalNavigPt ) );
   		PathGoal.AssignObject( PathGoalNavigPt );
   	}
   	
	//Log( SearchingPawn $ "::FindRandomPathGoal returning " $ PathGoalNavigPtInfo  );
    return PathGoalNavigPtInfo;
}



static function bool EnsurePathGoalReachable( GoalAbstracterInterf PathGoal,
		EPathGoalInfo PathGoalInfo,
		Pawn SearchingPawn )
{
    local bool bPathGoalReachable;

	if( PathGoalInfo != PGI_Invalid )
	{
		if( PathGoalInfo == PGI_Pathable )
		{
			bPathGoalReachable = PathGoal.FindNavigationGoalFromActor( PathGoal, SearchingPawn );
		}
		else
		{
			bPathGoalReachable = true;
		}
	}

	return bPathGoalReachable;
}



//find a reachable random path node not in the line of sight of the goal
static function EPathGoalInfo FindRandomNoLineOfSightPathGoal(
		GoalAbstracterInterf PathGoal,
		Pawn SearchingPawn,
		GoalAbstracterInterf UltimateGoal )
{
	local NavigationPoint CurrentNavigPt, PathGoaldNavigPt;
    local float NumNavigPtsSeen, CurrentGoalToActorDist;
    local EPathGoalInfo CurrentPathGoalNavigPtInfo, PathGoalNavigPtInfo;
	
	if( UltimateGoal.IsValid() )
    {
       	CurrentGoalToActorDist = UltimateGoal.GetDistanceBetween( SearchingPawn );
    	foreach SearchingPawn.RadiusActors( class'NavigationPoint',
    			CurrentNavigPt, ReachableRandomPathNoLineOfSightRadius )
        {
        	PathGoal.AssignObject( CurrentNavigPt );
    		if( ( PathGoal.GetDistanceBetween( SearchingPawn ) > TooCloseToLocation ) &&
    				!PathGoal.IsVisibleByGoal( UltimateGoal ) )
    	    {
   		    	if( PathGoal.IsReachableByActor( SearchingPawn ) )
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Reachable;
   		    	}
   		    	else if( PathGoal.IsPathableByActor( SearchingPawn ) )
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Pathable;
   		    	}
   		    	else
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Invalid;
   		    	}
   		    
	   			if( CurrentPathGoalNavigPtInfo != PGI_Invalid )
	   			{
	    	    	//the path goal is not too close to the searching pawn
   			    	//the path goal is not in the line of sight of the goal
   			    	//the path goal is rechable or pathable by the searching pawn
           			if( UltimateGoal.GetDistanceBetween( PathGoal ) > CurrentGoalToActorDist )
           			{
                		NumNavigPtsSeen += 1.0;
	   	             	if( FRand() < 1.0 / NumNavigPtsSeen )
    	   	            {
        	   	        	//choose with equal probability
							PathGoalNavigPtInfo = CurrentPathGoalNavigPtInfo;
                	   		PathGoaldNavigPt = CurrentNavigPt;
        	    		}
	   	        	}
   	        	}
        	}
		}
	}
	
   	if( PathGoalNavigPtInfo != PGI_Invalid )
   	{
   		PathGoal.AssignObject( PathGoaldNavigPt );
   	}
   	
	//Log( SearchingPawn $ "::FindRandomNoLineOfSightPathGoal returning " $ PathGoalNavigPtInfo );
    return PathGoalNavigPtInfo;
}



//The Unreal engine provides nifty functions for finding the best path 
//somewhere, but nothing for when we want to use paths to get *away* from
//something instead of towards it.  So, this function does that.
//RETURNS: Ultimate destination path.  ActorReachable(RetVal) is not
//necessarily true -- pawn might have to traverse intermediate path nodes first.
static final function EPathGoalInfo FindAvoidGoalPathGoal( GoalAbstracterInterf PathGoal,
		Pawn SearchingPawn,
		GoalAbstracterInterf UltimateGoal )
{
	local bool bFoundNonLineOfSightNavigPt;
    local NavigationPoint CurrentNavigPt, PathGoalNavigPt;
    local float CurrentGoalToPathGoalDist, PathGoalNavigPtDistance;
    local EPathGoalInfo CurrentPathGoalNavigPtInfo, PathGoalNavigPtInfo;
    
    if( UltimateGoal.IsValid() )
    {
		if( SearchingPawn.Physics == PHYS_Falling )
		{
			//xxxxxx hack-o-rama
			SearchingPawn.SetPhysics( SearchingPawn.default.Physics );
		}
		
	    foreach SearchingPawn.RadiusActors( class'NavigationPoint',
    			CurrentNavigPt, FindAvoidGoalPathRadius )
	   	{
	   		PathGoal.AssignObject( CurrentNavigPt );
	        if( ( PathGoal.GetDistanceBetween( SearchingPawn ) > TooCloseToLocation ) )
   		    {
   		    	if( PathGoal.IsReachableByActor( SearchingPawn ) )
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Reachable;
   		    	}
   		    	else if( PathGoal.IsPathableByActor( SearchingPawn ) )
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Pathable;
   		    	}
   		    	else
   		    	{
	   		    	CurrentPathGoalNavigPtInfo = PGI_Invalid;
   		    	}
   		    
	   			if( CurrentPathGoalNavigPtInfo != PGI_Invalid )
	   			{
		   			//Log( SearchingPawn $ "::FindAvoidGoalPathGoal CurrentNavigPt: " $ CurrentNavigPt );
		   		    //the current path goal is reachable or pathable by the searching pawn
   				    //the searching paw is not too close to the current path goal
	   			    CurrentGoalToPathGoalDist = UltimateGoal.GetDistanceBetween( PathGoal );
       				if( !PathGoal.IsVisibleByGoal( UltimateGoal ) )
	    	   	    {
		      	    	//the current navigation point is out of the goal's line of sight
			        	if( !bFoundNonLineOfSightNavigPt )
	    			    {
						    //this is the first navigation point that is out of the goal's line of sight
						    bFoundNonLineOfSightNavigPt = true;
							PathGoalNavigPtInfo = CurrentPathGoalNavigPtInfo;
		   	            	PathGoalNavigPt = CurrentNavigPt;
			           	    PathGoalNavigPtDistance = CurrentGoalToPathGoalDist;
    		        	}
	    			   	else if( CurrentGoalToPathGoalDist > PathGoalNavigPtDistance )
		    		    {
		   	        		//choose node out of the goal's line of sight that's farthest from the goal
							PathGoalNavigPtInfo = CurrentPathGoalNavigPtInfo;
							PathGoalNavigPt = CurrentNavigPt;
    	           		    PathGoalNavigPtDistance = CurrentGoalToPathGoalDist;
	    	    	  	}
        		    }
  		       		else if( !bFoundNonLineOfSightNavigPt && ( CurrentGoalToPathGoalDist > PathGoalNavigPtDistance ) )
		  	       	{
    	       			//if a navigation point that is not in the line of sight of the goal has not been found
        	   			//choose the node farthest away from the the goal
						PathGoalNavigPtInfo = CurrentPathGoalNavigPtInfo;
       	        		PathGoalNavigPt = CurrentNavigPt;
           	    		PathGoalNavigPtDistance = CurrentGoalToPathGoalDist;
	        	   	}
        	   	}
	   	    }
	   	}
   	}
   	
   	if( PathGoalNavigPtInfo != PGI_Invalid )
   	{
		//Log( SearchingPawn $ "::FindAvoidGoalPathGoal PathGoalNavigPt: " $ PathGoalNavigPt );
		//Log( SearchingPawn $ "::FindAvoidGoalPathGoal PathGoalNavigPt.Group: " $ PathGoalNavigPt.Group );
		//Log( SearchingPawn $ "::FindAvoidGoalPathGoal PathGoalNavigPtDistance: " $ PathGoalNavigPtDistance );
   		PathGoal.AssignObject( PathGoalNavigPt );
   	}

	//Log( SearchingPawn $ "::FindAvoidGoalPathGoal returning " $ PathGoalNavigPtInfo );
    return PathGoalNavigPtInfo;
}
*/

defaultproperties
{
     NavigationGoalType=Class'Legend.ContextSensitiveGoal'
     ReachedHandlerClass=Class'Legend.ReachedHandlerStop'
     DebugCategoryName=GoalContext
}
