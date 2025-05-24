//=============================================================================
// RangeHandler.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//=============================================================================

//A range is defined primarily by the distance an actor is from a given goal.
//It is possible for a goal to be bassed on one or more sub-goals but, an actor
//may be in only on range at a time. 

class RangeHandler expands AiComponent;

enum EObjectIntersectRequirement
{
	OIR_Irrelevant, //the object cylinder instersections are not used to determine validity
	OIR_Require,	//the object cylinders must intersect 
	OIR_Forbid, 	//the object cylinders must not intersect
};

struct THandlerTemplate
{
	var () Name								HT_Name;
	var () float							HT_Priority;
	var () Name								HT_PreHint;
	var () Name								HT_PostHint;
	var () Name 							HT_AssociatedState;
	var () Name 							HT_AssociatedLabel;
	var () class<WaypointSelectorInterf>	HT_SelectorClassWpt;
	var () class<FocusSelectorInterf>		HT_SelectorClassFcs;
	var () EObjectIntersectRequirement		HT_ObjIntersectReq;
	var () class<MovementPattern> 			HT_MovementPatternClass;
	var () bool								HT_bReentrant;				//the actor may reenter if it is already in it
	var () float 							HT_MinEntryInterval;		//the minimum amount of time that must pass between successful entry attempts
	var () bool 							HT_bDurationConstrained;	//should the amount of time in this range be constrained
	var () float							HT_MaxDuration;			//the maximum amount of time that may be spent in the range
	var () bool 							HT_bRequireValidGoal;	//is the goal required to be valid for the acotr to be in this range
};

var () THandlerTemplate		Template;
var	float 					EntryTime;			//the entrance time (set by calling ResetRangeEntryTime)
var Name 					PreviousStateName;	//the last UNIQUE state that the actor was in.
var MovementPattern 		MovementPattern;

const CloseEnoughToDistance = 16.0;



function Destructed()
{
	if( MovementPattern != None )
	{
		MovementPattern.Delete();
		MovementPattern = None;
	}
	Super.Destructed();
}



function BindHandler( RangeHandler NewHandler );



function RangeHandler GetHandler()
{
	return Self;
}



function SetSelectorClasses( class<WaypointSelectorInterf> RangeWptSelectorClass,
		class<FocusSelectorInterf> RangeFcsSelectorClass )
{
	if( RangeWptSelectorClass != None )
	{
		Template.HT_SelectorClassWpt = RangeWptSelectorClass;
	}
	else
	{
		Template.HT_SelectorClassWpt = default.Template.HT_SelectorClassWpt;
	}
	if( RangeFcsSelectorClass != None )
	{
		Template.HT_SelectorClassFcs = RangeFcsSelectorClass;
	}
	else
	{
		Template.HT_SelectorClassFcs = default.Template.HT_SelectorClassFcs;
	}
}



function SetEntryConstraints( bool bReentrantRange, float RangeMaxDuration, float RangeMinEntryInterval )
{
	Template.HT_bReentrant = bReentrantRange;
	Template.HT_MaxDuration = RangeMaxDuration;
	Template.HT_MinEntryInterval = RangeMinEntryInterval;
}



function SetAssociatedStateInfo( Name StateName, Name StateNameLabel )
{
	Template.HT_AssociatedState = StateName;
	Template.HT_AssociatedLabel = StateNameLabel;
}



function bool TransitionToAssociatedState( Actor TransitioningActor )
{
	local bool bActorTransitioned;
	local Name CurrentStateName;
	
	class'Debug'.static.DebugLog( TransitioningActor, "TransitionToAssociatedState HT_Name " $ Template.HT_Name, DebugCategoryName );
	if( CanActorEnterRange( TransitioningActor ) )
	{
		CurrentStateName = TransitioningActor.GetStateName();
		class'Debug'.static.DebugLog( TransitioningActor, "TransitionToAssociatedState: " $ Template.HT_AssociatedState $ " while in state " $ CurrentStateName, DebugCategoryName );
		if( CurrentStateName != Template.HT_AssociatedState )
		{
			PreviousStateName = CurrentStateName;
			ResetRangeEntryTime( TransitioningActor );
		}
		TransitioningActor.GotoState( Template.HT_AssociatedState, Template.HT_AssociatedLabel );	
		bActorTransitioned = true;
	}
	class'Debug'.static.DebugLog( TransitioningActor, "TransitionToAssociatedState returning " $ bActorTransitioned, DebugCategoryName );
	return bActorTransitioned;
}



function bool IsInRange( Actor RangeActor, BehaviorConstrainer Constrainer , GoalAbstracterInterf Goal )
{
	local bool bInRange;
	local bool bPassedTimeAndEntryConstraints;
	local bool bPassedIntersectionConstraints;
	

	if( RangeActor == None )
	{
		Log( "IsInRange RangeActor " $ RangeActor );
		Log( "IsInRange Constrainer " $ Constrainer );
		Log( "IsInRange Goal " $ Goal );
	}
	else if( Constrainer == None )
	{
		Log( "IsInRange RangeActor " $ RangeActor );
		Log( "IsInRange Constrainer " $ Constrainer );
		Log( "IsInRange Goal " $ Goal );
	}
	else if( Goal == None )
	{
		Log( "IsInRange RangeActor " $ RangeActor );
		Log( "IsInRange Constrainer " $ Constrainer );
		Log( "IsInRange Goal " $ Goal );
	}

	
	class'Debug'.static.DebugLog( RangeActor, "IsInRange HT_Name " $ Template.HT_Name, DebugCategoryName );
	if( !Template.HT_bRequireValidGoal || Goal.IsValid( RangeActor ) )
	{
		class'Debug'.static.DebugLog( RangeActor, "IsInRange 0", DebugCategoryName );
		//the goal is never in a range if it (the goal) is not valid
		if( Template.HT_bDurationConstrained && ( RangeActor.GetStateName() == Template.HT_AssociatedState ) )
		{
			class'Debug'.static.DebugLog( RangeActor, "IsInRange 1", DebugCategoryName );
			class'Debug'.static.DebugLog( RangeActor, "IsInRange Template.HT_AssociatedState " $ Template.HT_AssociatedState, DebugCategoryName );
			class'Debug'.static.DebugLog( RangeActor, "IsInRange Template.HT_MaxDuration " $ Template.HT_MaxDuration, DebugCategoryName );
			class'Debug'.static.DebugLog( RangeActor, "IsInRange EntryTime " $ EntryTime, DebugCategoryName );
			class'Debug'.static.DebugLog( RangeActor, "IsInRange RangeActor.Level.TimeSeconds " $ RangeActor.Level.TimeSeconds, DebugCategoryName );

			//the actor is in the associated state of this range
			//the goal is in range if the range has not been occupied for to long
			bPassedTimeAndEntryConstraints = ( RangeActor.Level.bStartUp ||
					( ( RangeActor.Level.TimeSeconds - EntryTime ) <= Template.HT_MaxDuration ) );
		}
		else
		{
			class'Debug'.static.DebugLog( RangeActor, "IsInRange 2", DebugCategoryName );
			//the actor is not in the associated state of this range
			//the goal is in range if the actor can enter the range
			bPassedTimeAndEntryConstraints = CanActorEnterRange( RangeActor );
		}

		if( bPassedTimeAndEntryConstraints )
		{
			if( Template.HT_ObjIntersectReq != OIR_Irrelevant )
			{
				//this range is based on object cylinder intersections
				if( DoActorAndGoalCylindersTouch( RangeActor, Goal, Constrainer ) )
				{
					class'Debug'.static.DebugLog( RangeActor, "IsInRange 3", DebugCategoryName );
					//the object cylinders intersect
					bPassedIntersectionConstraints = ( Template.HT_ObjIntersectReq == OIR_Require );
				}
				else
				{
					class'Debug'.static.DebugLog( RangeActor, "IsInRange 4", DebugCategoryName );
					//the object cylinders do not intersect
					bPassedIntersectionConstraints = ( Template.HT_ObjIntersectReq == OIR_Forbid );
				}
			}
			else
			{
				class'Debug'.static.DebugLog( RangeActor, "IsInRange 5", DebugCategoryName );
				//this range is not based on object cylinder intersections
				bPassedIntersectionConstraints = true;
			}
		}
		bInRange = bPassedTimeAndEntryConstraints && bPassedIntersectionConstraints;
	}

	class'Debug'.static.DebugLog( RangeActor, "IsInRange bPassedTimeAndEntryConstraints  " $ bPassedTimeAndEntryConstraints, DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "IsInRange bPassedIntersectionConstraints " $ bPassedIntersectionConstraints, DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "IsInRange returning " $ bInRange, DebugCategoryName );
	return bInRange;
}



function bool IsValidAsNextRange( Actor RangeActor, BehaviorConstrainer Constrainer, GoalAbstracterInterf Goal )
{
	local bool bValidAsNextRange;
	
	class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange HT_Name " $ Template.HT_Name, DebugCategoryName );
	if( IsInRange( RangeActor, Constrainer, Goal ) )
	{
		bValidAsNextRange = CanActorEnterRange( RangeActor );
	}
	
	class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange returning " $ bValidAsNextRange, DebugCategoryName );
	return bValidAsNextRange;
}



//=============================================================================
// private interface
//=============================================================================



//Dynamic cylinder extensions are computed dynamically whenever
//GetDynamicCylinderExtensions is called. The return values are
//based entirely on the implementation of the derived range
//handler class.
function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	RadiusExtension = 0;
	HeightExtension	= 0;
}



function bool CanActorEnterRange( Actor EnteringActor )
{
	local bool bCanEnterRange;
	local float CurrentDuration;
	
	class'Debug'.static.DebugLog( EnteringActor, "CanActorEnterRange HT_Name " $ Template.HT_Name, DebugCategoryName );
	if( !EnteringActor.Level.bStartUp )
	{
		CurrentDuration = EnteringActor.Level.TimeSeconds - EntryTime;
	}
	
	if( EntryTime == 0 )
	{
		//the range has never been entered before
		bCanEnterRange = true;
	}
	else if( CurrentDuration < Template.HT_MinEntryInterval )
	{
		//this range has been entered before
		//but, it is to early to enter the range again
		class'Debug'.static.DebugLog( EnteringActor, "	HT_MinEntryInterval: " $ Template.HT_MinEntryInterval, DebugCategoryName );
		class'Debug'.static.DebugLog( EnteringActor, "	CurrentDuration: " $ CurrentDuration, DebugCategoryName );
		class'Debug'.static.DebugLog( EnteringActor, "	EntryTime: " $ EntryTime, DebugCategoryName );
		class'Debug'.static.DebugLog( EnteringActor, "	EnteringActor.Level.TimeSeconds: " $ EnteringActor.Level.TimeSeconds, DebugCategoryName );
		bCanEnterRange = false;
	}
	else if( EnteringActor.GetStateName() != Template.HT_AssociatedState )
	{
		//this range has been entered before
		//it is not to early to enter the range again
		//the actor is not in the associated state of this range
		bCanEnterRange = true;
	}
	else if( !Template.HT_bReentrant )
	{
		//this range has been entered before
		//it is not to early to enter the range again
		//the actor is in the associated state of this range
		//but, the range is not designated as reentrant
		class'Debug'.static.DebugLog( EnteringActor, "	attempting to reenter into non reentrant range", DebugCategoryName );
		bCanEnterRange = false;
	}
	else if( Template.HT_bDurationConstrained && ( CurrentDuration > Template.HT_MaxDuration ) )
	{
		//this range has been entered before
		//it is not to early to enter the range again
		//the actor is in the associated state of this range
		//the range is designated as reentrant
		//but, this range has been occupied for to long
		class'Debug'.static.DebugLog( EnteringActor, "	HT_MaxDuration: " $ Template.HT_MaxDuration, DebugCategoryName );
		bCanEnterRange = false;
	}
	else
	{
		//this range has been entered before
		//it is not to early to enter the range again
		//the actor is in the associated state of this range
		//the range is designated as reentrant
		//and, this range has not been occupied for to long
		bCanEnterRange = true;
	}

	class'Debug'.static.DebugLog( EnteringActor, "CanActorEnterRange returning " $ bCanEnterRange, DebugCategoryName );
	return bCanEnterRange;
}



//ResetRangeEntryTime is called by TransitionToAssociatedState if the
//state being transitioned to is different than the state that the actor
//is currently in
function ResetRangeEntryTime( Actor TransitioningActor )
{
	class'Debug'.static.DebugLog( TransitioningActor, "ResetRangeEntryTime", DebugCategoryName );
	if( !TransitioningActor.Level.bStartUp )
	{
		EntryTime = TransitioningActor.Level.TimeSeconds;
	}
	else
	{
		EntryTime = 0;
	}
}



function bool DoActorAndGoalCylindersTouch( Actor TouchingActor,
		GoalAbstracterInterf Goal,
		BehaviorConstrainer Constrainer )
{
	local bool bTouching;
	local float DynamicRadiusExtension, DynamicHeightExtension;
	local float TestHeight, TestRadius, DistanceBetween;
	
	GetDynamicCylinderExtension( DynamicRadiusExtension, DynamicHeightExtension, TouchingActor, Constrainer, Goal );
	//class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch DynamicRadiusExtension " $ DynamicRadiusExtension , DebugCategoryName );
	//class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch DynamicHeightExtension " $ DynamicHeightExtension , DebugCategoryName );

	//class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch CollisionRadius " $ TouchingActor.CollisionRadius , DebugCategoryName );
	//class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch CollisionHeight " $ TouchingActor.CollisionHeight , DebugCategoryName );

	TestRadius = TouchingActor.CollisionRadius + DynamicRadiusExtension;
	TestHeight = TouchingActor.CollisionHeight + DynamicHeightExtension;

	if( Goal.IsGoalReached( TouchingActor ) /*&& ( TestRadius >= 0 ) && ( TestHeight >= 0 )*/ )
	{
		bTouching = true;
	}
/*
	else if( Goal.GetGoalDistanceToCylinder( TouchingActor, DistanceBetween,
			TouchingActor.Location, /*the origin of the second cylinder*/
			TestRadius, /*the radius of the second cylinder*/
			TestHeight /*the (half) height of the second cylinder*/ ) )
	{
		bTouching = ( DistanceBetween <= CloseEnoughToDistance );
	}
*/
	class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch TouchingActor " $ TouchingActor , DebugCategoryName );
	class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch DistanceBetween  " $ DistanceBetween , DebugCategoryName );
	class'Debug'.static.DebugLog( TouchingActor, "DoActorAndGoalCylindersTouch returning " $ bTouching, DebugCategoryName );
	return bTouching;
}



function DebugLog( Object Invoker )
{
	class'Debug'.static.DebugLog( Invoker, "DebugLog", DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_AssociatedState: " $ Template.HT_AssociatedState, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_AssociatedLabel: " $ Template.HT_AssociatedLabel, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_SelectorClassWpt: " $ Template.HT_SelectorClassWpt, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_SelectorClassFcs: " $ Template.HT_SelectorClassFcs, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_ObjIntersectReq: " $ Template.HT_ObjIntersectReq, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_MovementPatternClass: " $ Template.HT_MovementPatternClass, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_bReentrant: " $ Template.HT_bReentrant, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_MinEntryInterval: " $ Template.HT_MinEntryInterval, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_MaxDuration: " $ Template.HT_MaxDuration, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	HT_bRequireValidGoal: " $ Template.HT_bRequireValidGoal, DebugCategoryName );

	class'Debug'.static.DebugLog( Invoker, "	MovementPattern: " $ MovementPattern, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	EntryTime: " $ EntryTime, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "	PreviousStateName: " $ PreviousStateName, DebugCategoryName );
}

defaultproperties
{
     DebugCategoryName=RangeHandler
}
