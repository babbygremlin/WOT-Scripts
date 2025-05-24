//=============================================================================
// MovementPattern.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class MovementPattern expands AiComponent;

enum ERelationalRequirement
{
	RR_None,
	RR_Equal,
	RR_Less,
	RR_LessOrEqual,
	RR_GreaterOrEqual,
	RR_Greater
};

struct TElementFocusParams
{
	var () bool							FP_bSelectFocus;
	var () class<FocusSelectorInterf>	FP_AlternateSelectorFcs;
	//rlofuture var () Vector			FP_FocusLocation;
	//rlofuture var () Name				FP_FocusActorTag;
	//rlofuture var () Name				FP_FocusActorName;
};

struct TElementWaypointParams
{
	var () bool								WP_bSelectWaypoint;		//
	var () bool								WP_bApplyOffsetDirection;	//if true apply the pattern's direction otherwise use the direction of the selected waypoint
	var () Vector							WP_OffsetDirection;		//the direction in which to move if bApplayDirection is true
	var () bool								WP_bApplyOffsetDistance;		//if true apply the pattern's distance otherwise use the distance of the selected waypoint
	var () float							WP_OffsetDistance;		//how far to go in the given direction if bApplyOffsetDistance is true
	var () ERelationalRequirement			WP_ReqTravelDistanceRel;	
	var () float 							WP_ReqTravelDistance;
	var () ERelationalRequirement			WP_ReqGoalDistanceRel;	//the relational requirement of the distance to the goal from the resulting waypoint
	var () float 							WP_ReqGoalDistance;	//the distance to use based on the resultant requirement
	var () bool								WP_bRequireReachable;
	//rlofuture var () class<WaypointSelectorInterf>	WP_AlternateSelectorWpt;
	//rlofuture var () Vector							WP_WaypointLocation;
	//rlofuture var () Name								WP_WaypointActorTag;
	//rlofuture var () Name								WP_WaypointActorName;
};

struct TMovementPatternElement
{
	var () bool						MPE_bEnabled;					//
	var () ERelationalRequirement	MPE_ApplicationRel;				//the relational requirement of the distance to the goal from the current location
	var () float 					MPE_ApplicationGoalDistance;	//the distance to use based on the application requirement
	
	var () ERelationalRequirement	MPE_SelectionIntervalRel;
	var () float 					MPE_SelectionInterval;
	var    float 					MPE_LastSelectionTime;

	var () ERelationalRequirement	MPE_GoalVelocitySizeRel;
	var () float 					MPE_GoalVelocitySize;

	var () bool						MPE_bApplySpeed;				//if true apply the pattern's speed otherwise use use the suggested speed of the goal
	var () float 					MPE_Speed;						//how fast to go if bApplySpeed is true
//xxxrlofuture var () bool			MPE_bApplyPauseTime;			//if true apply the pattern's pause time otherwise the pause time is initialized to 0
//xxxrlofuture var () float			MPE_PauseTime;					//
	var () Name 					MPE_Name;
	var () Name 					MPE_PreHint;
	var () Name 					MPE_PostHint;
	
	var () TElementFocusParams		MPE_FocusParams;
	var () TElementWaypointParams	MPE_WaypointParams;
	
};

//what about the situation where none of the movement methods can give us a reachable destination?
var () Name 						PatternName;

//xxrlo make this external to the movement pattern
var () Class<IteratorInterf>		PatternElementIterClass;
var IteratorInterf 					PatternElementIter;

var () float 						GoalDistanceTolerance;			//the tolerance by which goal distance requirement is judged 
var () TMovementPatternElement		MovementPatternElements[ 16 ];

//xxxrlo var () ERelationalRequirement		PostReqDistanceRelation;	//the relational requirement of the distance to the goal from the selected waypoint
//xxxrlo var () float 						PostReqGoalDistance;		//the distance to use based on the resultant requirement
var () ERelationalRequirement		PreReqDistanceRelation;		//the relational requirement of the distance to the goal from the selected waypoint
var () float 						PreReqGoalDistance;			//the distance to use based on the resultant requirement




function Constructed()
{
	Super.Constructed();
	PatternElementIter = new( Self )PatternElementIterClass;
	PatternElementIter.BindCollection( , ArrayCount( MovementPatternElements ) );
}



function Destructed()
{
	PatternElementIter.Delete();
	PatternElementIter = None;
	Super.Destructed();
}



function TMovementPatternElement GetMovmentPatternElement( IteratorInterf PatternElementIter )
{
	local int CurrentElementIndex;
	PatternElementIter.GetCurrentIndex( CurrentElementIndex );
	return MovementPatternElements[ CurrentElementIndex ];
}



function bool SelectPatternElement( Actor MovingActor, GoalAbstracterInterf Goal, IteratorInterf PatternElementIter )
{
	local float GoalDistance, DistanceDifference, TimeDifference, VelocityDifference;
	local int CurrentElementIndex, ElementCount, TestedElementCount;
	local bool bSuccess;
	
	class'Debug'.static.DebugLog( MovingActor, "SelectPatternElement", DebugCategoryName );
	if( PatternElementIter.GetItemCount( ElementCount ) &&
			( PatternElementIter.GetCurrentIndex( CurrentElementIndex ) ||
			PatternElementIter.GetFirstIndex( CurrentElementIndex ) ) )
	{
		class'Debug'.static.DebugLog( MovingActor, "SelectPatternElement ElementCount " $ ElementCount, DebugCategoryName );

		Goal.GetGoalDistance( MovingActor, GoalDistance, MovingActor );
		for( TestedElementCount = 1; TestedElementCount <= ElementCount; TestedElementCount++ )
		{
			class'Debug'.static.DebugLog( MovingActor, "SelectPatternElement CurrentElementIndex " $ CurrentElementIndex, DebugCategoryName );
			if( MovementPatternElements[ CurrentElementIndex ].MPE_bEnabled )
			{
				DistanceDifference = GoalDistance - MovementPatternElements[ CurrentElementIndex ].MPE_ApplicationGoalDistance;
				if( EvaluateRequisiteGoalDistance( DistanceDifference, MovementPatternElements[ CurrentElementIndex ].MPE_ApplicationRel ) )
				{
					TimeDifference = MovingActor.Level.TimeSeconds - MovementPatternElements[ CurrentElementIndex ].MPE_LastSelectionTime;
					if( EvaluateRequisiteValue( TimeDifference, MovementPatternElements[ CurrentElementIndex ].MPE_SelectionIntervalRel,
						 	MovementPatternElements[ CurrentElementIndex ].MPE_SelectionInterval ) )
					{
						VelocityDifference = VSize( MovingActor.Velocity ) - MovementPatternElements[ CurrentElementIndex ].MPE_GoalVelocitySize;
						if( EvaluateRequisiteValue( VelocityDifference, MovementPatternElements[ CurrentElementIndex ].MPE_GoalVelocitySizeRel,
						 	MovementPatternElements[ CurrentElementIndex ].MPE_GoalVelocitySize ) )
						{
							MovementPatternElements[ CurrentElementIndex ].MPE_LastSelectionTime = MovingActor.Level.TimeSeconds;
							bSuccess = true;
							break;
						}
					}
				}
			}
			PatternElementIter.GetNextIndex( CurrentElementIndex );
		}
	}
	class'Debug'.static.DebugLog( MovingActor, "SelectPatternElement returning " $ bSuccess, DebugCategoryName );
	return bSuccess;
}



function SelectGoalsFromPatternElement( GoalAbstracterInterf MovementGoal,
		GoalAbstracterInterf FocusGoal,
		Actor MovingActor,
		class<WaypointSelectorInterf> WptSelectorClass,
		class<FocusSelectorInterf> FcsSelectorClass,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal,
		IteratorInterf PatternElementIter )
{
	SelectWaypointFromPatternElement( MovementGoal, MovingActor, WptSelectorClass, Constrainer, Goal, PatternElementIter );
	SelectFocusFromPatternElement( FocusGoal, MovingActor, FcsSelectorClass, Constrainer, Goal, PatternElementIter );
}



function bool SelectWaypointFromPatternElement( GoalAbstracterInterf RawMovementGoal,
		Actor MovingActor,
		class<WaypointSelectorInterf> WptSelectorClass,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal,
		IteratorInterf PatternElementIter )
{
	local Vector GoalLocation, InitialWaypointLocation, WaypointLocation, WaypointOffsetDirection, WaypointOffset;
	local float WaypointOffsetDistance, WaypointDistanceToGoal;
	local bool bSuccess;
	local int PatternElementIdx;
	
	if( PatternElementIter.GetCurrentIndex( PatternElementIdx ) )
	{
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement PatternElementIdx " $ PatternElementIdx, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement PatternElementName " $ MovementPatternElements[ PatternElementIdx ].MPE_Name, DebugCategoryName );
		
		if( MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bSelectWaypoint &&
				WptSelectorClass.static.SelectWaypoint( RawMovementGoal, MovingActor, Constrainer, Goal ) )
		{
			RawMovementGoal.GetGoalLocation( MovingActor, InitialWaypointLocation );
		}
		else
		{
			InitialWaypointLocation = MovingActor.Location;
		}
		
		if( MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bApplyOffsetDirection )
		{
			WaypointOffsetDirection = Normal( MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_OffsetDirection ) >> MovingActor.Rotation;
		}
		else
		{
			WaypointOffsetDirection = Normal( InitialWaypointLocation - MovingActor.Location );
		}
		
		if( VSize( WaypointOffsetDirection ) ~= 0 )
		{
			//this is handling something that it really an error condition?
			WaypointOffsetDirection = Vector( MovingActor.Rotation );
		}
		
		if( MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bApplyOffsetDistance )
		{
			WaypointOffsetDistance = MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_OffsetDistance + MovingActor.CollisionRadius;
		}

/*
		else
		{
			//get as close to the goal as possible
			RawMovementGoal.GetGoalDistance( MovingActor, WaypointOffsetDistance, MovingActor );
		}
*/
		
		if( MovementPatternElements[ PatternElementIdx ].MPE_bApplySpeed )
		{
			//set the speed based on the speed of the pattern
			RawMovementGoal.SetSuggestedSpeed( MovingActor, MovementPatternElements[ PatternElementIdx ].MPE_Speed );
		}
		else
		{
			//set the speed based on the suggested speed of the goal
			RawMovementGoal.SetSuggestedSpeed( MovingActor, Goal.GetSuggestedSpeed( MovingActor ) );
		}
/*
//xxxrlofuture
		if( MovementPatternElements[ PatternElementIdx ].MPE_bApplyPauseTime )
		{
			//set the pause time in the behavior constrainer
		}
		else
		{
			//clear the pause time in the behavior constrainer
		}
*/		
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WP_bApplyOffsetDirection" $ MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bApplyOffsetDirection, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointOffsetDirection " $ WaypointOffsetDirection, DebugCategoryName );
		
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WP_bApplyOffsetDistance " $ MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bApplyOffsetDistance, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointOffsetDistance " $ WaypointOffsetDistance, DebugCategoryName );
		
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WP_bSelectWaypoint " $ MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bSelectWaypoint, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement InitialWaypointLocation " $ InitialWaypointLocation, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement InitialWaypoint distance " $ VSize( InitialWaypointLocation - MovingActor.Location ), DebugCategoryName );
		
		WaypointOffset = WaypointOffsetDirection * WaypointOffsetDistance;
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointOffset " $ WaypointOffset, DebugCategoryName );
		
		WaypointLocation = InitialWaypointLocation + WaypointOffset;
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointLocation (using waypoint offset) " $ WaypointLocation, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement Waypoint distance " $ VSize( WaypointLocation - MovingActor.Location ), DebugCategoryName );
		
		//adjust the waypoint location based on the distance between the selected waypoint location and the location of the moving actor
		AdjustWaypointLocation( WaypointLocation, MovingActor, WaypointLocation, ( VSize( WaypointLocation - MovingActor.Location ) - MovingActor.CollisionRadius ),
				MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_ReqTravelDistance + MovingActor.CollisionRadius,
				MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_ReqTravelDistanceRel );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointLocation (enforce distance from moving actor) " $ WaypointLocation, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement Waypoint distance " $ VSize( WaypointLocation - MovingActor.Location ), DebugCategoryName );
		
		//get the distance that the actor will be away from the goal if it was at the selected waypoint
		Goal.GetGoalDistanceToCylinder( MovingActor, WaypointDistanceToGoal, WaypointLocation, MovingActor.CollisionRadius, MovingActor.CollisionHeight );
		Goal.GetGoalLocation( MovingActor, GoalLocation );
		
		//adjust the waypoint location based on the distance between the selected waypoint location and the location of the goal
		AdjustWaypointLocation( WaypointLocation, MovingActor, GoalLocation, WaypointDistanceToGoal,
				MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_ReqGoalDistance,
				MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_ReqGoalDistanceRel );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement WaypointLocation (enforce distance from goal) " $ WaypointLocation, DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement Waypoint distance " $ VSize( WaypointLocation - MovingActor.Location ), DebugCategoryName );
		
		RawMovementGoal.AssignVector( MovingActor, WaypointLocation );
		
		//PatternElementIter.GetNextIndex();
		bSuccess = ( !MovementPatternElements[ PatternElementIdx ].MPE_WaypointParams.WP_bRequireReachable ||
				RawMovementGoal.IsGoalReachable( MovingActor ) );
	}
	class'Debug'.static.DebugLog( MovingActor, "SelectWaypointFromPatternElement returning " $ bSuccess, DebugCategoryName );
	return bSuccess;
}



function bool SelectFocusFromPatternElement( GoalAbstracterInterf FocusGoal,
		Actor MovingActor,
		class<FocusSelectorInterf> FcsSelectorClass,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal,
		IteratorInterf PatternElementIter )
{
//xxxrlofuture
	return false;
}



//returns true if the pre-requisite goal distance was satisfied 
//returns false if the pre-requisite goal distance was not satisfied
//if false is returned the raw movement goal was adjusted to meet the goal distance requirement
static function bool EvaluatePrerequisiteGoalDistance( GoalAbstracterInterf RawMovementGoal, Actor MovingActor, GoalAbstracterInterf Goal )
{
	local float GoalDistance;
	Goal.GetGoalDistance( MovingActor, GoalDistance, MovingActor );
	class'Debug'.static.DebugLog( MovingActor, "EvaluatePrerequisiteGoalDistance MovingActor.Location " $ MovingActor.Location, default.DebugCategoryName );
	return !AdjustWaypoint( RawMovementGoal, MovingActor, Goal, MovingActor.Location, GoalDistance, default.PreReqGoalDistance, default.PreReqDistanceRelation );
}



/*
//returns true if the post-requisite goal distance was satisfied 
//returns false if the post-requisite goal distance was not satisfied
//if false is returned the raw movement goal was adjusted to meet the goal distance requirement
static function bool EvaluatePostrequisiteGoalDistance( GoalAbstracterInterf RawMovementGoal, Actor MovingActor, GoalAbstracterInterf Goal )
{
	local Vector WaypointLocation;
	local float GoalDistance;
	Goal.GetGoalDistance( MovingActor, GoalDistance, RawMovementGoal );
	if( !RawMovementGoal.GetGoalLocation( MovingActor, WaypointLocation ) )
	{
		WaypointLocation = MovingActor.Location;
	}

	class'Debug'.static.DebugLog( MovingActor, "EvaluatePostrequisiteGoalDistance WaypointLocation " $ WaypointLocation, default.DebugCategoryName );
	//xxxrlo !AdjustWaypoint( RawMovementGoal, MovingActor, Goal, WaypointLocation, GoalDistance, default.PostReqGoalDistance, default.PostReqDistanceRelation );
}
*/


//returns true if the raw waypoint goal was adjusted
static function bool AdjustWaypoint( GoalAbstracterInterf RawMovementGoal,
		Actor MovingActor,
		GoalAbstracterInterf Goal,
		Vector DesiredWaypointLocation,
		float GoalDistance,
		float RequiredGoalDistanceToWaypoint,
		ERelationalRequirement RelationalReq )
{
	local bool bPassedPrerequisiteGoalDistance;
	local Vector GoalLocation;
	
	Goal.GetGoalLocation( MovingActor, GoalLocation );
	bPassedPrerequisiteGoalDistance = AdjustWaypointLocation( DesiredWaypointLocation, MovingActor, GoalLocation, GoalDistance, RequiredGoalDistanceToWaypoint, RelationalReq );
	if( bPassedPrerequisiteGoalDistance )
	{
		RawMovementGoal.AssignVector( MovingActor, DesiredWaypointLocation );
	}
	return bPassedPrerequisiteGoalDistance;
}



//returns true if the waypoint location was adjusted
static function bool AdjustWaypointLocation( out Vector WaypointLocation,
		Actor MovingActor,
		Vector GoalLocation,
		float GoalDistance,
		float RequiredGoalDistanceToWaypoint,
		ERelationalRequirement RelationalReq )
{
	local float DistanceDifference;
	local Vector WaypointDirection;
	local bool bPassedGoalDistanceReq;
	
	DistanceDifference = GoalDistance - RequiredGoalDistanceToWaypoint;
	bPassedGoalDistanceReq = EvaluateRequisiteGoalDistance( DistanceDifference, RelationalReq );
	
	class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation RelationalReq " $ RelationalReq, default.DebugCategoryName );
	class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation bPassedGoalDistanceReq " $ bPassedGoalDistanceReq, default.DebugCategoryName );
	class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation GoalDistance " $ GoalDistance, default.DebugCategoryName );
	class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation RequiredGoalDistanceToWaypoint " $ RequiredGoalDistanceToWaypoint, default.DebugCategoryName );
	class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation DistanceDifference " $ DistanceDifference, default.DebugCategoryName );

	if( !bPassedGoalDistanceReq )
	{
		if( GoalLocation == WaypointLocation )
		{
			WaypointDirection = MovingActor.Location - WaypointLocation;
		}
		else
		{
			WaypointDirection = GoalLocation - WaypointLocation;
		}
		WaypointDirection.Z = 0;
		WaypointDirection = Normal( WaypointDirection );
		
		
		class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation GoalLocation " $ GoalLocation, default.DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation WaypointDirection " $ WaypointDirection, default.DebugCategoryName );
		class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation WaypointLocation " $ WaypointLocation, default.DebugCategoryName );
		WaypointLocation += WaypointDirection * DistanceDifference;
		class'Debug'.static.DebugLog( MovingActor, "AdjustWaypointLocation WaypointLocation " $ WaypointLocation, default.DebugCategoryName );
	}
	return !bPassedGoalDistanceReq;
}



static function bool EvaluateRequisiteGoalDistance( float DistanceDifference, ERelationalRequirement RelationalReq )
{
	return EvaluateRequisiteValue( DistanceDifference, RelationalReq, default.GoalDistanceTolerance );
}



static function bool EvaluateRequisiteValue( float RequisiteValue, ERelationalRequirement RelationalReq, optional float Tolerance )
{
	local bool bPassedRequisite;
	switch( RelationalReq )
	{
		case RR_Equal:
			bPassedRequisite = ( RequisiteValue ~= Tolerance );
			break;
		case RR_Less:
			bPassedRequisite = ( RequisiteValue < Tolerance );
			break;
		case RR_LessOrEqual:
			bPassedRequisite = ( ( RequisiteValue < Tolerance ) ||
					( RequisiteValue ~= Tolerance ) );
			break;
		case RR_GreaterOrEqual:
			bPassedRequisite = ( ( RequisiteValue > Tolerance ) ||
					( RequisiteValue ~= Tolerance ) );
			break;
		case RR_Greater:
			bPassedRequisite = ( RequisiteValue > Tolerance );
			break;
		case RR_None:
			bPassedRequisite = true;
		default:
			break;
	}
	return bPassedRequisite;
}

defaultproperties
{
     PatternElementIterClass=Class'Legend.IteratorCircular'
     GoalDistanceTolerance=10.000000
     MovementPatternElements(0)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(1)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(2)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(3)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(4)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(5)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(6)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(7)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(8)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(9)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(10)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(11)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(12)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(13)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(14)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     MovementPatternElements(15)=(MPE_WaypointParams=(WP_bRequireReachable=True))
     DebugCategoryName=MovementPattern
}
