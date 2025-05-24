//=============================================================================
// WaypointSelectorSniping.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class WaypointSelectorSniping expands WaypointSelector;


var () class<WotPathNode> SnipePositionCollectionClass;
var () float CollectionRadius;

// Find nearest Sniping Point
static function bool SelectWaypoint( GoalAbstracterInterf Waypoint,
		Actor MovingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local Actor GoalActor;
	local Actor FarthestNode;	
	local itemsorter SnipeDestinationSorter;
	local int i, ItemCount;
	local Actor ClosestSnipePoint;
	local Actor CurrentSnipePoint;

	class'Debug'.static.DebugLog( MovingActor, "SelectWaypoint", default.DebugCategoryName );

	if( Goal.GetGoalActor( MovingActor, GoalActor ) ) 
	{
		SnipeDestinationSorter = ItemSorter( class'Singleton'.static.GetInstance( MovingActor.XLevel, class'ItemSorter' ) );
		SnipeDestinationSorter.CollectRadiusItems( MovingActor, Default.SnipePositionCollectionClass, default.CollectionRadius );
		
		//SnipeDestinationSorter.SortReq.IR_Origin = MovingActor.Location;
		//var float IR_MaxDistance;
		//var ERequirement IR_MaxDistanceReq;
		//var float IR_MinDistance;
		//var ERequirement IR_MinDistanceReq;
		//SnipeDestinationSorter.SortReq.IR_TraceInfo = TRACE_Unobstruced;
		//SnipeDestinationSorter.SortReq.IR_TraceInfoReq = R_Require;
		//SnipeDestinationSorter.SortItems();
		
		if( SnipeDestinationSorter.GetItemCount( ItemCount ) )
		{
			for( i = 0; i < ItemCount; i++ )
			{
				CurrentSnipePoint = SnipeDestinationSorter.GetItem( i );
				if( CanSeeGoal( CurrentSnipePoint, GoalActor ) )
				{
					assert( CurrentSnipePoint.IsA( 'WOTPathNode' ) );
					if( WOTPathnode( CurrentSnipePoint ).GetSnipeFlag() )
					{
						if( ClosestSnipePoint == None )
						{
							ClosestSnipePoint = CurrentSnipePoint;
						}
						else if( VSize( CurrentSnipePoint.Location - MovingActor.Location ) < VSize( ClosestSnipePoint.Location - MovingActor.Location ) )
						{
							ClosestSnipePoint = CurrentSnipePoint;
						}
					}
				}
			}
		}
	}
	if( ClosestSnipePoint != none )
	{
		Waypoint.AssignObject( MovingActor, ClosestSnipePoint );
		return true;
	}
}



static function bool CanSeeGoal( Actor StartActor, Actor EndActor )
{
	local Actor HitActor;
	local Vector HitNormal, HitLocation;
	local Actor GoalActor;
	HitActor = StartActor.Trace( HitNormal, HitLocation, EndActor.Location, StartActor.Location + vect( 0, 0, 60 ), true );
	return ( HitActor == EndActor );
}

defaultproperties
{
     SnipePositionCollectionClass=Class'WOT.WotPathNode'
     CollectionRadius=2250.000000
}
