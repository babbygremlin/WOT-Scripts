//=============================================================================
// GoalCacheInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class GoalCacheInfo expands GoalBase native;

enum EGoalCacheInfoItem
{
	GCII_ReachableSuccessful,
	GCII_ReachableUnsuccessful,
	GCII_VisibleSuccessful,
	GCII_VisibleUnsuccessful,
	GCII_PathableSuccessful,
	GCII_PathableUnsuccessful
};

struct TGoalCacheInfoItem
{
	var byte	GCII_Valid;			//is this item valid
	var Vector 	GCII_GoalLocation;	//the location of the goal when it was cached
	var Vector	GCII_ObjectLocation; //the location of the context actor when it was cached
};

var private Object CacheObject;
var private GoalAbstracterInterf CacheGoal;
var private TGoalCacheInfoItem GoalInfoCache[ 6 ];
var private PathNodeIterator NavigPathIter;
var () private class<PathNodeIterator> 	PathNodeIteratorType;

const Query_GCII_GoalLocation = 1;
const Query_GCII_ObjectLocation = 2;
const CacheItemCurrentThreshold = 32;
const bUseEnginePathing = true;



native function bool CacheInfoInit( GoalAbstracterInterf NewCacheGoal, Object NewCacheObject );

static function CreateGoalCache( out GoalCacheInfo NewGoalCache,
		Object GoalCacheOuter,
		GoalAbstracterInterf CacheGoal,
		Object CacheObject )
{
	class'Debug'.static.DebugLog( CacheObject, "CreateGoalCache", default.DebugCategoryName );
	NewGoalCache = new( GoalCacheOuter )default.class;
	if( !bUseEnginePathing && ( NewGoalCache.PathNodeIteratorType != None ) && CacheObject.IsA( 'Actor' )  )
	{
		NewGoalCache.NavigPathIter = Actor( CacheObject ).Level.Spawn( NewGoalCache.PathNodeIteratorType );
	}
	NewGoalCache.CacheInfoInit( CacheGoal, CacheObject );
}

defaultproperties
{
     PathNodeIteratorType=Class'Legend.PawnPathNodeIterator'
     DebugCategoryName=GoalCacheInfo
}
