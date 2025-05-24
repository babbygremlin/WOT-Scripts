//=============================================================================
// LegendPawn.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 59 $
//=============================================================================

class LegendPawn expands Pawn abstract native;

enum ETriStateBool
{
	TSB_Unknown,
	TSB_True,
	TSB_False
};

enum EFactionType
{
	FT_Unknown,
	FT_Friendly,
	FT_Enemy
};

enum EGoalIndex
{
	GI_Threat,
	GI_ExternalDirective,
	GI_Refuge,
	GI_Guarding,
	GI_Colleague,
	GI_Intermediate,
	GI_Waiting,
	GI_CurrentWaypoint,
	GI_CurrentFocus,
	GI_None
};

enum ETransitionerIndex
{
	TI_Returning,
	TI_Tracking,
	TI_Retreating,
	TI_ExternalDirective,
	TI_Acquired,
	TI_Investigating,
	TI_Searching,
	TI_NavigatingToGoal,
	TI_SeekRefuge,
	TI_FindHelp,
	TI_NavigatingToSeal,
	TI_NavigatingToSealAltar,
	TI_SoundAlarm,
	TI_None
};

enum EDurationNotifierIndex
{
	DNI_Visibility,
	DNI_Rotation,
	DNI_Movement,
	DNI_Defensive,
	DNI_Offensive,
	DNI_Waiting,
	DNI_Misc0,
	DNI_Misc1,
	DNI_Misc2,
	DNI_None
};

struct TTransitionerInfo
{
	var () bool TI_bConstruct;
	var () Name TI_TransitionerName;
	var RangeTransitioner TI_Transitioner;
};

struct TGoalPriorityInfo
{
	var float GPI_GoalPriority;
	var EGoalIndex GPI_GoalIndex;
};

struct TGoalInfo
{
	var () Name GI_GoalName;
	var GoalAbstracterInterf GI_Goal;
};

var () const editconst Name DebugCategoryName;
var () bool bShowDebugMessage;

var () class<DrawScaleInfo>			DrawScaleInfoClass;
var () class<MovementManager> 		MovementManagerClass;
var () class<RangeTransitioner>		RangeTransitionerClass;
var () class<BehaviorConstrainer> 	ConstrainerClass;
var () class<GoalFactory> 			GoalFactoryClass;
var () class<RangeHandlerFactory>	HandlerFactoryClass;

var (GoalInfo) Name					GoalDescripterNames[ 9 ];
var (GoalInfo) float				GoalPriorities[ 9 ];
var (GoalInfo) float				GoalPriorityDistances[ 9 ];
var (GoalInfo) float				GoalPriorityDistanceUsages[ 9 ];
var (GoalInfo) float				GoalSuggestedSpeeds[ 9 ];
var (GoalInfo) private TGoalInfo	GoalInfos[ 9 ];
var TGoalPriorityInfo				GoalPriorityInfos[ 9 ];
var EGoalIndex						CurrentGoalIdx;

var bool 							bPreferCurrentHandler;
var () TTransitionerInfo			TransitionerInfos[ 13 ];
var DrawScaleInfo					CurrentDrawScaleInfo;
var RangeIterator					CurrentRangeIterator;
var MovementManagerInterf 			CurrentMovementManager;
var BehaviorConstrainer 			CurrentConstrainer;

var DurationNotifier 				DurationNotifiers[ 11 ];
var () class<DurationNotifier>		DurationNotifierClasses[ 11 ];
var () Name							DurationNotifierNotifications[ 11 ];
var () float						DurationNotifierDurations[ 11 ];

var () int 							PeerNotificationRadiiCount;	//used by NotifyPeersOfGoal
var () class<Inventory>				DefaultInventoryTypes[ 5 ];

var bool							bPerformedLatentOperation;

var bool							bNotifyAchievedRotation;
var bool							bNotifyReachedDestination;

var () float						MinTrackingDuration;
var float							LastTrackingTime;
var byte							NavigationNugget;

var () class<ActivityManager>		ActivityManagerClass;
var () Name 						ForceInactiveStateName;

var () float						DodgeVelocityFactor;
var () float						DodgeVelocityAlltitude;

var () private class<Pawn> 			NavigationProxyClass;
var private Pawn 					NavigationProxy;

//xxx remove?
var () class<PrimitiveMovementAnimater>	AnimaterClass;
var PrimitiveMovementAnimater	CurrentAnimater;
var PrimitiveActorMovement2     CurrentPrimitiveMovement;

const HintName_AttemptAttack = 'AttemptAttack';
const HintName_AttemptDodge = 'AttemptDodge';
const HintName_ForceStationary = 'ForceStationary';
const HintName_UnForceStationary = 'UnForceStationary';



static function EGoalIndex GoalIndex( EGoalIndex GoalIndex )
{
	return GoalIndex;
}



static function EDurationNotifierIndex DurationNotifierIndex( EDurationNotifierIndex DurationNotifierIndex )
{
	return DurationNotifierIndex;
}



native function GoalAbstracterInterf GetGoal( EGoalIndex GoalIndex );

native function GoalAbstracterInterf GetGoalByInt( int GoalIndex );



function DurationNotifier GetDurationNotifier( EDurationNotifierIndex DurationNotifierIndex )
{
	return DurationNotifiers[  DurationNotifierIndex ];
}



function ConstructAggregates()
{
	//DebugClass = class'LegendDebug';
	class'Debug'.static.DebugLog( Self, "ConstructAggregates", DebugCategoryName );
	
	ConstructNotifiers();
	CurrentGoalIdx = EGoalIndex.GI_Threat;
	ConstructGoals();
	
	CurrentAnimater = New( Self )AnimaterClass;
	CurrentDrawScaleInfo = New( Self )DrawScaleInfoClass;
	
	CurrentMovementManager = New( Self )MovementManagerClass;
	CurrentMovementManager.BindDestinationGoal( GetGoal( EGoalIndex.GI_CurrentWaypoint ) );
	CurrentMovementManager.BindFocusGoal( GetGoal( EGoalIndex.GI_CurrentFocus ) );
	
	ConstructTransitioners();
	
	CurrentConstrainer = New( Self )ConstrainerClass;
	CurrentRangeIterator = New( Self )class'RangeIterator';
	
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Tracking ].TI_Transitioner );
	CurrentPrimitiveMovement = New( Self )class'PrimitiveActorMovement2';

	if( NavigationProxyClass != None )
	{
		NavigationProxy = Spawn( NavigationProxyClass, Self );
	}
}



function ConstructNotifiers()
{
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "ConstructNotifiers", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( DurationNotifiers ); ArrayIter++ )
	{
		if( DurationNotifierClasses[ ArrayIter ] != None )
		{
			DurationNotifiers[ ArrayIter ] = DurationNotifier( DurationNotifierClasses[ ArrayIter ].static.CreateNotifier( Self, DurationNotifierNotifications[ ArrayIter ] ) );
			DurationNotifiers[ ArrayIter ].SetDuration( DurationNotifierDurations[ ArrayIter ] );
		}
	}
}



function ConstructGoals()
{
	local int ConstructedGoalIdx;
	class'Debug'.static.DebugLog( Self, "ConstructGoals", DebugCategoryName );
	for( ConstructedGoalIdx = 0; ConstructedGoalIdx < ArrayCount( GoalInfos ); ConstructedGoalIdx++ )
	{
		if( GoalFactoryClass.static.CreateGoal( GoalInfos[ ConstructedGoalIdx ].GI_Goal, Self, GoalDescripterNames[ ConstructedGoalIdx ] ) )
		{
			GoalFactoryClass.static.InitGoal( GetGoalByInt( ConstructedGoalIdx ), Self, GoalPriorities[ ConstructedGoalIdx ],
					GoalPriorityDistances[ ConstructedGoalIdx ], GoalPriorityDistanceUsages[ ConstructedGoalIdx ],
					GoalSuggestedSpeeds[ ConstructedGoalIdx ] );
		}
	}
}



function ConstructTransitioners()
{
	local int TransitionerIdx, HandlerIdx;
	local RangeHandler TransitionerHandler;
	class'Debug'.static.DebugLog( Self, "ConstructTransitioners", DebugCategoryName );
	for( TransitionerIdx = 0; TransitionerIdx < ArrayCount( TransitionerInfos ); TransitionerIdx++ )
	{
		if( TransitionerInfos[ TransitionerIdx ].TI_bConstruct )
		{
			class'Debug'.static.DebugLog( Self, "ConstructTransitioners TransitionerIdx " $ TransitionerIdx, DebugCategoryName );
			class'Debug'.static.DebugLog( Self, "ConstructTransitioners TI_TransitionerName " $ TransitionerInfos[ TransitionerIdx ].TI_TransitionerName, DebugCategoryName );

			TransitionerInfos[ TransitionerIdx ].TI_Transitioner = new( Self )RangeTransitionerClass;
			class'Debug'.static.DebugLog( Self, "ConstructTransitioners TransitionerInfos[ TransitionerIdx ].TI_Transitioner " $ TransitionerInfos[ TransitionerIdx ].TI_Transitioner, DebugCategoryName );
			for( HandlerIdx = 0; HandlerIdx < 5; HandlerIdx++ )
			{
				class'Debug'.static.DebugLog( Self, "ConstructTransitioners HandlerIdx " $ HandlerIdx , DebugCategoryName );
				if( HandlerFactoryClass.static.CreateHandler( TransitionerHandler, TransitionerInfos[ TransitionerIdx ].TI_Transitioner, TransitionerIdx, HandlerIdx ) )
				{
					class'Debug'.static.DebugLog( Self, "ConstructTransitioners HT_Name " $ TransitionerHandler.Template.HT_Name, DebugCategoryName );
					TransitionerInfos[ TransitionerIdx ].TI_Transitioner.BindIndexHandler( TransitionerHandler, HandlerIdx );
				}
				class'Debug'.static.DebugLog( Self, "ConstructTransitioners TransitionerHandler " $ TransitionerHandler, DebugCategoryName );
			}
		}
	}
}



function DestructAggregates()
{
	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentPrimitiveMovement " $ CurrentPrimitiveMovement, DebugCategoryName );
	if( CurrentPrimitiveMovement != None )
	{
		CurrentPrimitiveMovement.Delete();
		CurrentPrimitiveMovement = None;
	}

	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentRangeIterator " $ CurrentRangeIterator, DebugCategoryName );
	if( CurrentRangeIterator != None )
	{
		CurrentRangeIterator.Delete();
		CurrentRangeIterator = None;
	}
	
	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentConstrainer " $ CurrentConstrainer, DebugCategoryName );
	if( CurrentConstrainer != None )
	{
		CurrentConstrainer.Delete();
		CurrentConstrainer = None;
	}
	
	DestructTransitioners();

	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentMovementManager" $ CurrentMovementManager, DebugCategoryName );
	if( CurrentMovementManager != None )
	{
		CurrentMovementManager.Delete();
		CurrentMovementManager = None;
	}
	
	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentDrawScaleInfo " $ CurrentDrawScaleInfo, DebugCategoryName );
	if( CurrentDrawScaleInfo != None )
	{
		CurrentDrawScaleInfo.Delete();
		CurrentDrawScaleInfo = None;
	}
	
	class'Debug'.static.DebugLog( Self, "DestructAggregates CurrentAnimater " $ CurrentAnimater, DebugCategoryName );
	if( CurrentAnimater != None )
	{
		CurrentAnimater.Delete();
		CurrentAnimater = None;
	}

	DestructGoals();
	DestructNotifiers();
}



function DestructNotifiers()
{
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "DestructNotifiers", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( DurationNotifiers ); ArrayIter++ )
	{
		if( DurationNotifiers[ ArrayIter ] != None )
		{
			DurationNotifiers[ ArrayIter ].Delete();
			DurationNotifiers[ ArrayIter ] = None;
		}
	}
}



function DestructGoals()
{
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "DestructGoals", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( GoalInfos ); ArrayIter++ )
	{
		if( GetGoalByInt( ArrayIter ) != None )
		{
			if( GetGoalByInt( ArrayIter ).Outer == Self )
			{
				GetGoalByInt( ArrayIter ).Delete();
			}
			GoalInfos[ ArrayIter ].GI_Goal = None;
		}
	}
}



function DestructTransitioners()
{
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "DestructTransitioners", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( TransitionerInfos ); ArrayIter++ )
	{
		if( TransitionerInfos[ ArrayIter ].TI_Transitioner != None )
		{
			TransitionerInfos[ ArrayIter ].TI_Transitioner.Delete();
			TransitionerInfos[ ArrayIter ].TI_Transitioner = None;
		}
	}
}



function AddDefaultInventoryItems()
{
	local Inventory NewInventoryItem;
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "AddDefaultInventoryItems", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( DefaultInventoryTypes ); ArrayIter++ )
	{
		if( DefaultInventoryTypes[ ArrayIter ] != None )
		{
			NewInventoryItem = class'Util'.static.AddInventoryTypeToHolder( Self, DefaultInventoryTypes[ ArrayIter ] );
			if( NewInventoryItem != None )
			{
				OnAddedDefaultInventoryItem( NewInventoryItem );
			}
		}
	}
}



function OnAddedDefaultInventoryItem( Inventory AddedInventoryItem );



function DisableNotifiers()
{
	local int ArrayIter;
	class'Debug'.static.DebugLog( Self, "DisableNotifiers", DebugCategoryName );
	for( ArrayIter = 0; ArrayIter < ArrayCount( DurationNotifiers ); ArrayIter++ )
	{
		if( DurationNotifiers[ ArrayIter ] != None )
		{
			DurationNotifiers[ ArrayIter ].DisableNotifier();
		}
	}
}



function ActivityManagerRegister()
{
	local Actor CurrentActivityManager;
	local int ActivityManagerCount;
	local ActivityManager ActivityManagerIter, FoundActivityManager;
	
	foreach AllActors( class'ActivityManager', ActivityManagerIter )
	{
		ActivityManagerCount++;
	}

	if( ActivityManagerCount > 1 )
	{
		//Support for multiple activity managers is not functional!
		//Until multiple activity managers in a level are supported more than one can not exist in the level!
		Warn( Self $ "::ActivityManagerRegister found multiple activity managers" );
		Assert( false );
	}

	//If the pawn does not have an activity manager class then an activity manager will not manage it.
	if( ActivityManagerClass != None )
	{
		ActivityManagerCount = 0;
		foreach AllActors( ActivityManagerClass, CurrentActivityManager )
		{
			//register with all of the activity managers in the level
			if( FoundActivityManager == None )
			{
				FoundActivityManager = ActivityManager( CurrentActivityManager );
			}
			ActivityManagerCount++;
		}
		
		if( ActivityManagerCount == 0 )
		{
			//no activity manager is in the level so spawn one
			FoundActivityManager = Spawn( ActivityManagerClass, Level );
		}
		else if( ActivityManagerCount > 1 )
		{
			Warn( Self $ "::ActivityManagerRegister can not resolve activity managers" );
			Assert( false );
		}

		if( FoundActivityManager != None )
		{
			FoundActivityManager.Register( Self );
		}
	}
}



//=============================================================================
// begin - global state transition functions
//=============================================================================



function TransitionToNextState()
{
	class'Debug'.static.DebugLog( Self, "TransitionToNextState", DebugCategoryName );
	TransitionOnGoalPriority();
}



function TransitionOnGoalPriority( optional bool bEvaluateGoalPriorities )
{
	local int ArrayIter;
	local bool bTransitioned;
	local EGoalIndex PriorityGoalIndex;
	
	if( Health <= 0 )
	{
		GotoState( 'Dying' );
	}
	else
	{
		class'Debug'.static.DebugLog( Self, "TransitionOnGoalPriority bEvaluateGoalPriorities " $ bEvaluateGoalPriorities, DebugCategoryName );
		if( bEvaluateGoalPriorities )
		{
			GetPriorityGoalIndex( PriorityGoalIndex );
		}

		for( ArrayIter = 0; ( ( ArrayIter < ArrayCount( GoalPriorityInfos ) ) && !bTransitioned ); ArrayIter++ )
		{
			if( GoalPriorityInfos[ ArrayIter ].GPI_GoalPriority != -1 )
			{
				bTransitioned = GoalIndexTransition( GoalPriorityInfos[ ArrayIter ].GPI_GoalIndex );
			}
		}
	}
}



native function GetPriorityGoalIndex( out EGoalIndex PriorityGoalIndex );



function bool GoalIndexTransition( EGoalIndex GoalIndex )
{
	local bool bTransitioned;
	class'Debug'.static.DebugLog( Self, "GoalIndexTransition GoalIndex " $ GoalIndex, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "GoalIndexTransition Goal " $ GetGoal( GoalIndex ), DebugCategoryName );
	switch( GoalIndex )
	{
		case GI_Threat:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Threat", DebugCategoryName );
			bTransitioned = GoalIndexTransitionThreat();
			break;
		case GI_ExternalDirective:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_ExternalDirective", DebugCategoryName );
			bTransitioned = GoalIndexTransitionExternalDirective();
			break;
		case GI_Refuge:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Refuge", DebugCategoryName );
			bTransitioned = GoalIndexTransitionRefuge();
			break;
		case GI_Guarding:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Guarding", DebugCategoryName );
			bTransitioned = GoalIndexTransitionGuarding();
			break;
		case GI_Colleague:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Colleague", DebugCategoryName );
			bTransitioned = GoalIndexTransitionColleague();
			break;
		case GI_Intermediate:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Intermediate", DebugCategoryName );
			bTransitioned = GoalIndexTransitionIntermediate();
			break;
		case GI_Waiting:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_Waiting", DebugCategoryName );
			bTransitioned = GoalIndexTransitionWaiting();
			break;
		case GI_CurrentWaypoint:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_CurrentWaypoint", DebugCategoryName );
			bTransitioned = GoalIndexTransitionCurrentWaypoint();
			break;
		case GI_CurrentFocus:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_CurrentFocus", DebugCategoryName );
			bTransitioned = GoalIndexTransitionCurrentFocus();
			break;
		case GI_None:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition GI_None", DebugCategoryName );
			bTransitioned = GoalIndexTransitionNone();
			break;
		default:
			class'Debug'.static.DebugLog( Self, "GoalIndexTransition Unhandled", DebugCategoryName );
			bTransitioned = GoalIndexTransitionUnhandled();
			break;
	}
	class'Debug'.static.DebugLog( Self, "GoalIndexTransition returning " $ bTransitioned, DebugCategoryName );
	return bTransitioned;
}



function bool GoalIndexTransitionThreat()
{
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreat TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Tracking ].TI_TransitionerName, DebugCategoryName );
	CurrentGoalIdx = EGoalIndex.GI_Threat;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Tracking ].TI_Transitioner );
	CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
	return true;
}



function bool GoalIndexTransitionExternalDirective()
{
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionExternalDirective TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_ExternalDirective ].TI_TransitionerName, DebugCategoryName );
	CurrentGoalIdx = EGoalIndex.GI_ExternalDirective;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_ExternalDirective ].TI_Transitioner );
	CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
	return true;
}



function bool GoalIndexTransitionRefuge() { return false; }
function bool GoalIndexTransitionGuarding() { return false; }
function bool GoalIndexTransitionColleague() { return false; }
function bool GoalIndexTransitionIntermediate() { return false; }

function bool GoalIndexTransitionWaiting()
{
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionWaiting TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Returning ].TI_TransitionerName, DebugCategoryName );
	CurrentGoalIdx = EGoalIndex.GI_Waiting;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Returning ].TI_Transitioner );
	return CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
}



function bool GoalIndexTransitionCurrentWaypoint() { return false; }
function bool GoalIndexTransitionCurrentFocus() { return false; }
function bool GoalIndexTransitionNone() { return false; }
function bool GoalIndexTransitionUnhandled() { return true; }



//=============================================================================
// end - global state transition functions
//=============================================================================



//=============================================================================
// begin - notifications that result in goal initialization
//=============================================================================



function OnSeeEnemy( Pawn SeenPawn )
{
	class'Debug'.static.DebugLog( Self, "OnSeeEnemy", DebugCategoryName );
	InitGoalWithObject( EGoalIndex.GI_Threat, SeenPawn, ETriStateBool.TSB_True );
}



function OnSeeFriendlyPlayer( Pawn SeenPawn )
{
	class'Debug'.static.DebugLog( Self, "OnSeeFriendlyPlayer", DebugCategoryName );
	InitGoalWithObject( EGoalIndex.GI_Colleague, SeenPawn, ETriStateBool.TSB_True );
}



function OnSeeFriendlyPawn( Pawn SeenPawn )
{
	class'Debug'.static.DebugLog( Self, "OnSeeFriendlyPawn", DebugCategoryName );
	InitGoalWithObject( EGoalIndex.GI_Colleague, SeenPawn, ETriStateBool.TSB_True );
}



function TransferThreatGoalsFrom( LegendPawn Other )
{
    class'Debug'.static.DebugLog( Self, "TransferThreatGoalsFrom", DebugCategoryName );
	if( ( Other.GetGoal( EGoalIndex.GI_Threat ) != None ) &&
			Other.GetGoal( EGoalIndex.GI_Threat ).IsValid( Other ) )
	{
		InitGoalWithObject( EGoalIndex.GI_Threat, Other.GetGoal( EGoalIndex.GI_Threat ) );
	}
}



function TransferThreatGoalsTo( LegendPawn Other )
{
    class'Debug'.static.DebugLog( Self, "TransferThreatGoalsTo", DebugCategoryName );
	Other.InitGoalWithObject( EGoalIndex.GI_Threat, GetGoal( EGoalIndex.GI_Threat ) );
}



function ExchangeThreatGoals( LegendPawn Other )
{
    if( GetGoal( EGoalIndex.GI_Threat ).IsValid( Self ) )
	{
	    TransferThreatGoalsTo( Other );
    }
    else
	{
    	TransferThreatGoalsFrom( Other );
	}
}



//=============================================================================
// end - notifications that result in goal initialization
//=============================================================================



//=============================================================================
// begin - unreal engine function overrides
//=============================================================================



function PostBeginPlay()
{
	class'Debug'.static.DebugLog( Self, "PostBeginPlay", DebugCategoryName );
	Super.PostBeginPlay();
	ConstructAggregates();
	if( Level.NetMode != NM_Client )
	{
		AddDefaultInventoryItems();
	}
	UpdateDrawScaleBasedProperties();
	ActivityManagerRegister();
}



// fix for our PawnFactories -- default to auto
// state if Pawn is being created after level loaded for now.
simulated event SetInitialState()
{
	class'Debug'.static.DebugLog( Self, "SetInitialState Waiting Location: " $ Location, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "SetInitialState Waiting Rotation: " $ Rotation.Yaw $ " " $ Rotation.Pitch $ " "  $ Rotation.Roll, DebugCategoryName );
	SetWaitingGoal( Location, Rotation );
	Super.SetInitialState();
}



function Destroyed()
{
	DestructAggregates();
	Super.Destroyed();
}



function Died( Pawn Killer, Name DamageType, vector HitLocation )
{
	DisableNotifiers();
	Super.Died( Killer, damageType, HitLocation );
}



function BeginState()
{
	class'Debug'.static.DebugLog( Self, "BeginState", class'Debug'.default.DC_StateTransition );
	//xxxdebugrlo DebugClass = class'LegendDebug';
	//xxxdebugrlo class'Debug'.static.DebugLog( Self, "BeginState Rotation " $ Rotation, class'Debug'.default.DC_StateTransition );
	//xxxdebugrlo DebugClass = None;
	Super.BeginState();
}



function EndState()
{
	class'Debug'.static.DebugLog( Self, "EndState", class'Debug'.default.DC_StateTransition );
	Super.EndState();
}



/*
//xxxdebugrlo
function Tick( float DeltaTime )
{
	//class'Debug'.static.DebugLog( Self, "Tick", class'Debug'.default.DC_EngineNotification );
	Super.Tick( DeltaTime );
}
*/



function Trigger( Actor Other, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "Trigger Other: " $ Other $ " EventInstigator: " $ EventInstigator, class'Debug'.default.DC_EngineNotification );
	if( bShowDebugMessage )
	{
		BroadcastMessage( Self $ "::Trigger Other " $ Other $ " EventInstigator " $ EventInstigator );
		Log( Self $ "::Trigger Other " $ Other $ " EventInstigator " $ EventInstigator );
	}
	if( Other.IsA( 'NotifierProxy' ) )
	{
		if( NotifierProxy( Other ).ActualNotifier.IsA( 'DurationNotifier' ) )
		{
			OnDurationNotification( DurationNotifier( NotifierProxy( Other ).ActualNotifier ) );
		}
		else
		{
			OnNotification( NotifierProxy( Other ).ActualNotifier );
		}
	}
	else if( Other.IsA( 'ObservableDirective' ) )
	{
		if( Other.IsA( 'ExternalDirective' ) )
		{
			OnExternalDirectiveNotification( ExternalDirective( Other ) );
		}
		else if( Other.IsA( 'ActivityManager' ) )
		{
			OnActivityManagerNotification( ActivityManager( Other ) );
		}
		else if( Other.IsA( 'LegendPawnNotification' ) )
		{
			switch( LegendPawnNotification( Other ).GetNotificationType() )
			{
				case LPNT_ForceStationary:
					ForceStationary();
					break;
				case LPNT_UnforceStationary:
					UnforceStationary();
					break;
				case LPNT_GoalModify:
					OnGoalModifyNotification( LegendPawnNotification( Other ) );
					break;
				case LPNT_HandleHint:
					HandleHint( LegendPawnNotification( Other ).GetHintName() );
					break;
				case LPNT_Use:
					OnUseNotification( LegendPawnNotification( Other ) );
					break;
				case LPNT_ForceDormant:
					ForceDormant();
					break;
				case LPNT_UnForceDormant:
					UnForceDormant();
					break;
				default:
					OnOtherLegendPawnNotification( LegendPawnNotification( Other ) );
					break;
			}
		}
		else
		{
			Super.Trigger( Other, EventInstigator );
		}
	}
	else
	{
		Super.Trigger( Other, EventInstigator );
	}
}



//=============================================================================
// end - unreal engine function overrides
//=============================================================================



//=============================================================================
// begin - see pawn utility and callback functions
//=============================================================================



event SeePlayer( Actor SeenPlayer )
{
	class'Debug'.static.DebugLog( Self, "SeePlayer", class'Debug'.default.DC_EngineNotification );
	DispatchSeePlayerCallbacks( Pawn( SeenPlayer ) );
}



event SeePawn( Pawn SeenPawn )
{
	class'Debug'.static.DebugLog( Self, "SeePawn SeenPawn " $ SeenPawn, DebugCategoryName );
	DispatchSeePawnCallbacks( SeenPawn );
}



//UnrealI doesn't seem to worry about pawns that are friendly to one player
//but not another. Override the fns called below rather than this fn
//to react to SeePlayer and SeePawn events.
//Override See?Reachable?Player callbacks in subclass to handle such events appropriately.

function DispatchSeePawnCallbacks( Pawn SeenPawn ) // May NOT override in derived classes
{
	local EFactionType SeenPawnFaction;

    //Don't bother processing unless the player is alive (it seems bizarre that
    //this needs to be handled here, but the engine does indeed generate
    //SeePlayer() events for dead players...).

    if( ( SeenPawn != None ) && ( SeenPawn.Health > 0.0 ) )
	{
	    SeenPawnFaction = GetActorFaction( SeenPawn );
		switch( SeenPawnFaction )
		{
			case FT_Enemy:
				class'Debug'.static.DebugLog( Self, "DispatchSeePawnCallbacks SeeEnemyPawn", DebugCategoryName );
				SeeEnemyPawn( SeenPawn );
				break;
			case FT_Friendly:
				class'Debug'.static.DebugLog( Self, "DispatchSeePawnCallbacks SeeFriendlyPawn", DebugCategoryName );
				SeeFriendlyPawn( SeenPawn );
				break;
			default:
				class'Debug'.static.DebugLog( Self, "DispatchSeePawnCallbacks SeeUnknownPawn", DebugCategoryName );
				SeeUnknownPawn( SeenPawn );
				break;
		}
    }
}



function DispatchSeePlayerCallbacks( Pawn SeenPlayer ) // May NOT override in derived classes
{
	local EFactionType SeenPlayerFaction;

    //Don't bother processing unless the player is alive (it seems bizarre that
    //this needs to be handled here, but the engine does indeed generate
    //SeePlayer() events for dead players...).

    if( ( SeenPlayer != None ) && ( SeenPlayer.Health > 0 ) )
	{
	    SeenPlayerFaction = GetActorFaction( SeenPlayer );
		switch( SeenPlayerFaction )
		{
			case FT_Enemy:
				class'Debug'.static.DebugLog( Self, "DispatchSeePlayerCallbacks SeeEnemyPlayer", DebugCategoryName );
				SeeEnemyPlayer( SeenPlayer );
				break;
			case FT_Friendly:
				class'Debug'.static.DebugLog( Self, "DispatchSeePlayerCallbacks SeeFriendlyPlayer", DebugCategoryName );
				SeeFriendlyPlayer( SeenPlayer );
				break;
			default:
				class'Debug'.static.DebugLog( Self, "DispatchSeePlayerCallbacks SeeUnknownPlayer", DebugCategoryName );
				SeeUnknownPlayer( SeenPlayer );
				break;
		}
    }
}



//All player types are unknown in the base class
//Override this function in subclass to determine if a player is friendly and enemy or unknown.
function EFactionType GetActorFaction( Actor OtherActor )
{
	return FT_Unknown;
}



function SeeEnemyPawn( Pawn SeenPawn )
{
	OnSeeEnemy( SeenPawn );
}



function SeeEnemyPlayer( Pawn SeenPlayer )
{
	OnSeeEnemy( SeenPlayer );
}



function SeeFriendlyPawn( Pawn SeenPawn );

function SeeFriendlyPlayer( Pawn SeenPlayer )
{
	OnSeeFriendlyPlayer( SeenPlayer );
}
	


function SeeUnknownPawn( Pawn SeenPawn );
function SeeUnknownPlayer( Pawn SeenPlayer );



function InvalidateGoal( EGoalIndex GoalIdx )
{
	GetGoal( GoalIdx ).Invalidate( Self );
}



function InitGoalWithVector( EGoalIndex GoalIdx, Vector InitWith,
		optional ETriStateBool IsVisible, optional ETriStateBool IsReachable,
		optional ETriStateBool IsPathable )
{
	local ContextSensitiveGoal Goal;
	GetGoal( GoalIdx ).AssignVector( Self, InitWith );
	Goal = ContextSensitiveGoal( GetGoal( GoalIdx ) );
	if( Goal != None )
	{
		InitGoalContext( Goal, IsVisible, IsReachable, IsPathable );
	}
	GoalInitialized( GoalIdx );
}



function InitGoalWithObject( EGoalIndex GoalIdx, Object InitWith,
		optional ETriStateBool IsVisible, optional ETriStateBool IsReachable,
		optional ETriStateBool IsPathable )
{
	local ContextSensitiveGoal Goal;
	GetGoal( GoalIdx ).AssignObject( Self, InitWith );
	Goal = ContextSensitiveGoal( GetGoal( GoalIdx ) );
	if( Goal != None )
	{
		InitGoalContext( Goal, IsVisible, IsReachable, IsPathable );
	}
	GoalInitialized( GoalIdx );
}



function GoalInitialized( EGoalIndex GoalIdx );



function InitGoalContext( ContextSensitiveGoal Goal, optional ETriStateBool IsVisible,
		optional ETriStateBool IsReachable, optional ETriStateBool IsPathable )
{
	if( IsVisible == ETriStateBool.TSB_True )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_VisibleSuccessful );
 	}
	else if( IsVisible == ETriStateBool.TSB_False )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_VisibleUnsuccessful );
 	}

	if( IsReachable == ETriStateBool.TSB_True )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_ReachableSuccessful );
 	}
	else if( IsReachable == ETriStateBool.TSB_False )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_ReachableUnsuccessful );
 	}

	if( IsPathable == ETriStateBool.TSB_True )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_VisibleSuccessful );
 	}
	else if( IsPathable == ETriStateBool.TSB_False )
	{
//xxxrloperf	 	Goal.Context( Self ).SetCacheItem( GCCI_VisibleUnsuccessful );
 	}
}



function MoveAwayFromAreaRandom( float MoveDistance, optional bool bOverrideCurrent )
{
	local Vector MoveVector;
	local int DirIndex, Attempts;
	
	class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaRandom", DebugCategoryName );
	//make the npc move away from it's current location for a while
	if( bOverrideCurrent || !GetGoal( EGoalIndex.GI_Intermediate ).IsValid( Self ) )
	{
		class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaRandom", DebugCategoryName );
		DirIndex = int( RandRange( 0, 3 ) );
AttemptDirection:
		Attempts++;
		switch( DirIndex )
		{
			case 0:
				MoveVector = Vect( 1, 0, 0 );
				DirIndex++;
				break;
			case 1:
				DirIndex++;
				MoveVector = Normal( Vect( 1, -1, 0 ) );
				break;
			case 2:
				MoveVector = Vect( 0, -1, 0 );
				DirIndex++;
				break;
			case 3:
				MoveVector = Normal( Vect( -1, -1, 0 ) );
				DirIndex++;
				break;
			case 4:
				MoveVector = Vect( -1, 0, 0 );
				DirIndex++;
				break;
			case 5:
				MoveVector = Normal( Vect( -1, 1, 0 ) );
				DirIndex++;
				break;
			case 6:
				MoveVector = Vect( 0, 1, 0 );
				DirIndex++;
				break;
			case 7:
				MoveVector = Normal( Vect( 1, 1, 0 ) );
				DirIndex = 0;
				break;
		}

		InitGoalWithVector( GI_Intermediate, Location + ( MoveVector * MoveDistance ) );
		if( GetGoal( EGoalIndex.GI_Intermediate ).IsGoalNavigable( Self ) )
		{
			TransitionOnGoalPriority( true );
		}
		else if( Attempts < 8 )
		{
			goto AttemptDirection;
		}
		else
		{
			InValidateGoal( GI_Intermediate );
		}
	}
}



function MoveAwayFromAreaDirected( float MoveDistance, Rotator PreferredRotation, optional bool bOverrideCurrent )
{
	local int i;
	local Rotator AttempedRotation;
	local float DeltaYaw, YawInterval;
	local GoalAbstracterInterf Goal;

	class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaDirected", DebugCategoryName );
	//make the npc move away from it's current location for a while
	Goal = GetGoal( EGoalIndex.GI_Intermediate );
	if( bOverrideCurrent || !Goal.IsValid( Self ) )
	{
		class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaDirected current location " $ Location, DebugCategoryName );
		//DeltaYaw = 0;
		YawInterval = 32768 / 8;
		AttempedRotation = PreferredRotation;

		for( i = 0; i <= 8; i++ )
		{
			if( ( i % 8 ) == 0 )
			{
				DeltaYaw *= -1;
			}
			else
			{
				DeltaYaw += ( ( YawInterval / 2 ) + ( ( i - 1 ) / 2 * YawInterval ) );
			}
			
			AttempedRotation.Yaw = PreferredRotation.Yaw;
			AttempedRotation.Yaw += DeltaYaw;
			
			class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaDirected attempted location " $ Location + ( Vector( AttempedRotation ) * MoveDistance ), DebugCategoryName );
			Goal.AssignVector( Self, Location + ( Vector( AttempedRotation ) * MoveDistance ) );
			if( Goal.IsGoalNavigable( Self ) )
			{
				class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaDirected found navigable goal", DebugCategoryName );
				GoalInitialized( EGoalIndex.GI_Intermediate );
				break;
			}
			else
			{
				class'Debug'.static.DebugLog( Self, "MoveAwayFromAreaDirected did not find goal", DebugCategoryName );
				Goal.Invalidate( Self );
			}
		}
	}
}



//=============================================================================
// end - see pawn utility and callback functions
//=============================================================================



function BeginStatePrepareNotifiers();
function EndStatePrepareNotifiers();

event OnNotification( Notifier Notification )
{
	if( Notification.IsA( 'DurationNotifier' ) )
	{
		OnDurationNotification( DurationNotifier( Notification ) );
	}
}



event OnDurationNotification( DurationNotifier NotifingDuration )
{
	//class'Debug'.static.DebugLog( Self, "OnDurationNotification NotifingDuration " $ NotifingDuration, DebugCategoryName );
	//class'Debug'.static.DebugLog( Self, "OnDurationNotification Notification " $ NotifingDuration.Notification, DebugCategoryName );
	switch( NotifingDuration.Notification )
	{
		case NotifingDuration.DurationElapsedNotification:
			break;
		default:
			break;
	}
}



function OnExternalDirectiveNotification( ExternalDirective NotifingDirective )
{
	class'Debug'.static.DebugLog( Self, "OnExternalDirectiveNotification NotifingDirective " $ NotifingDirective, DebugCategoryName );
	if( ( GetGoal( EGoalIndex.GI_ExternalDirective ) == None ) ||
			( GetGoal( EGoalIndex.GI_ExternalDirective ).GetGoalPriority( Self ) <
			NotifingDirective.DirectiveGoal.GetGoalPriority( Self ) ) )
	{
		NotifingDirective.AcknowledgeNotification( Self, GoalInfos[ EGoalIndex.GI_ExternalDirective ].GI_Goal,
				NotifingDirective.NotificationAcknowledgment( NA_Accept ) );
	}
}

function bool IsInactive() { return false; }

function OnActivityManagerNotification( ActivityManager NotifingActivityManager )
{
	class'Debug'.static.DebugLog( Self, "OnActivityManagerNotification NotifingActivityManager " $ NotifingActivityManager, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "OnActivityManagerNotification Notification " $ NotifingActivityManager.Notification, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "OnActivityManagerNotification ForceInactiveStateName " $ ForceInactiveStateName, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "OnActivityManagerNotification CurrentState " $ GetStateName(), DebugCategoryName );
	switch( NotifingActivityManager.Notification )
	{
		case NotifingActivityManager.ForceActiveNotification:
			if( IsInactive() )
			{
				TransitionOnGoalPriority( true );
			}
			break;
		case NotifingActivityManager.ForceInactiveNotification:
			if( !IsInactive() )
			{
				StopMovement();
				GotoState( ForceInactiveStateName );
			}
			break;
		default:
			break;
	}
}



function OnGoalModifyNotification( LegendPawnNotification Notification )
{
	local Name GoalName;
	local GoalAbstracterInterf Goal;
	local int ArrayIter;
	
	class'Debug'.static.DebugLog( Self, "OnGoalModifyNotification Notification " $ Notification, DebugCategoryName );
	GoalName = Notification.GetGoalModifyName();
	for( ArrayIter = 0; ArrayIter < ArrayCount( GoalInfos ); ArrayIter++ )
	{
		if( GoalInfos[ ArrayIter ].GI_GoalName == GoalName )
		{
			Goal = GetGoalByInt( ArrayIter );
			break;
		}
	}

	if( Goal != None )
	{
		switch( Notification.GetGoaModifyType() )
		{
			case GMT_PrioritySet:
				Goal.SetGoalPriority( Self, Notification.GetGoaModifyPriority() );
				break;
			case GMT_PriorityIncrement:
				Goal.SetGoalPriority( Self, Goal.GetGoalPriority( Self ) + Notification.GetGoaModifyPriority() );
				break;
			case GMT_PriorityDecrement:
				Goal.SetGoalPriority( Self, Goal.GetGoalPriority( Self ) - Notification.GetGoaModifyPriority() );
				break;
		}
	}

	TransitionOnGoalPriority( true );
}



function OnUseNotification( LegendPawnNotification Notification );
function OnOtherLegendPawnNotification( LegendPawnNotification Notification );



function OnVisibilityNotification( Notifier Notification )
{
	LegendPawnShowSelf();
}



event OnAchievedRotation( Vector FocalPoint );
event OnReachedDestination( Vector Destination );



function OnRotationNotification( Notifier Notification );
function OnMovementNotification( Notifier Notification );



function OnDefensiveNotification( Notifier Notification )
{
	local DefensiveDetector DefensiveNotification;
	DefensiveNotification = DefensiveDetector( Notification );
	if( DefensiveNotification != None )
	{
		switch( DefensiveNotification.Notification )
		{
			case DefensiveNotification.OffendingNotification:
				DefensivePerimiterCompromised( DefensiveNotification );
				break;
			case DefensiveNotification.NoOffendingNotification:
				DefensivePerimiterUncompromised();
				break;
			default:
				break;
		}
	}
}



function DefensivePerimiterCompromised( DefensiveDetector DefensiveNotification )
{
	if( DefensiveNotification.GetOffenderRejectionInfo() == ORI_NotRejected )
	{
		DefensivePerimiterCompromisedByOffender( DefensiveNotification );
	}
	else
	{
		DefensivePerimiterCompromisedByRejectedOffender( DefensiveNotification );
	}
}



function DefensivePerimiterCompromisedByOffender( DefensiveDetector DefensiveNotification )
{
	local Actor TraceHitActor;
	local Vector TraceHitNormal, TraceHitLocation, TraceExtents, TraceEnd;
	local Actor Offender;
	
	Offender = DefensiveNotification.GetOffender();
	class'Debug'.static.DebugLog( Self, "DefensivePerimiterCompromisedByOffender Offender " $ Offender, DebugCategoryName );
	TraceExtents.X = Offender.CollisionRadius;
	TraceExtents.Y = Offender.CollisionRadius;
	TraceExtents.Z = Offender.CollisionHeight;
	TraceEnd = Offender.Location + Normal( Offender.Velocity ) * VSize( Location - Offender.Location );
	foreach Offender.TraceActors( default.class, TraceHitActor, TraceHitLocation, TraceHitNormal, TraceEnd, Offender.Location, TraceExtents )
	{
		if( TraceHitActor == Self )
		{
			PendingOffenderCollision( DefensiveNotification, TraceHitLocation );
	  	}
	}
}



function DefensivePerimiterCompromisedByRejectedOffender( DefensiveDetector DefensiveNotification );



function PendingOffenderCollision( DefensiveDetector DefensiveNotification, Vector PendingHitLocation )
{
	CurrentMovementManager.DefensiveDodge( Self, PendingHitLocation );
	bAnimFinished = true;
	InterruptMovement();
	DefensiveNotification.RespondedToActor( DefensiveNotification.GetOffender(), true );
}



function DefensivePerimiterUncompromised();

function OnOffensiveNotification( Notifier Notification );
function OnWaitingNotification( Notifier Notification );



function MatchGoalRotation( GoalAbstracterInterf Goal )
{
	local Actor GoalActor;
	local Vector DeltaLocation;
	//xxxrlo local Rotator OptimalRotationDelta;
	if( Goal.GetGoalActor( Self, GoalActor ) )
	{
		bRotateToDesired = true;
		DeltaLocation = GoalActor.Location - Location;
		//xxxrlo OptimalRotationDelta = Normalize( Rotator( DeltaLocation ) - Rotation );
		//xxxrlo OptimalRotationDelta.Yaw = OptimalRotationDelta.Yaw / FMax( 96 / VSize( DeltaLocation ), 1 );
		//xxxrlo DesiredRotation = Rotation + Rotator( DeltaLocation );
		DesiredRotation = Rotator( DeltaLocation );
	}
}



function MatchGoalAcceleration( GoalAbstracterInterf Goal )
{
	local Actor GoalActor;
	if( Goal.GetGoalActor( Self, GoalActor ) )
	{
		Acceleration = AccelRate * Normal( GoalActor.Location - Location );
	}
}



native function LegendPawnShowSelf();



function NotifyPeersOfGoal()
{
	local LegendPawn Peer;
	class'Debug'.static.DebugLog( Self, "NotifyPeersOfGoal", DebugCategoryName );
	foreach RadiusActors( class'LegendPawn', Peer, Default.CollisionRadius * PeerNotificationRadiiCount )
	{
		if( Peer != Self )
		{
			class'Debug'.static.DebugLog( Self, "NotifyPeersOfGoal Peer: " $ Peer, DebugCategoryName );
			class'Debug'.static.DebugLog( Self, "NotifyPeersOfGoal GetGoal( CurrentGoalIdx ): " $ GetGoal( CurrentGoalIdx ), DebugCategoryName );
			class'Debug'.static.DebugLog( Self, "NotifyPeersOfGoal Peer.GetGoal( CurrentGoalIdx ): " $ Peer.GetGoal( CurrentGoalIdx ), DebugCategoryName );
			if( GetGoal( CurrentGoalIdx ).IsValid( Self ) && !Peer.GetGoal( CurrentGoalIdx ).IsValid( Self ) )
			{
				//since my goal actor is valid notify the peer of the actor
				TransferThreatGoalsTo( Peer );
			}
			else
			{
				//tbi get the goal information from the peer?
				break;
			}
		}
	}
}



function SetWaitingGoal( Vector WaitingLocation, Rotator WaitingRotation )
{
	InitGoalWithVector( EGoalIndex.GI_Waiting, WaitingLocation );
	WaitingRotation.Pitch = 0;
	GetGoal( EGoalIndex.GI_Waiting ).SetAssociatedRotation( Self, WaitingRotation );
}



function StopMovement()
{
	class'Debug'.static.DebugLog( Self, "StopMovement", DebugCategoryName );
	//Based on empirical evidence Acceleration is the one crucial member that must be
	//set to stop the latent movement.
	Acceleration = vect( 0, 0, 0 );
	Velocity = vect( 0, 0, 0 );
	bNotifyAchievedRotation = false;
	bNotifyAchievedRotation = false;
}



function InterruptMovement()
{
	class'Debug'.static.DebugLog( Self, "StopMovement", DebugCategoryName );
	StopMovement();
}



function DisableMovement()
{
	InterruptMovement();
	DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
	DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
}



function UpdateDrawScaleBasedProperties()
{
/*
//xxxrlo
	CurrentDrawScaleInfo.Init( Self );

	MaxDesiredSpeed = Default.MaxDesiredSpeed / CurrentDrawScaleInfo.GetDrawScaleFactor();
	RotationRate = Default.RotationRate / CurrentDrawScaleInfo.GetDrawScaleFactor();
	
	MaxStepHeight = Default.MaxStepHeight * CurrentDrawScaleInfo.GetDrawScaleRatio();

	Mass = Default.Mass * CurrentDrawScaleInfo.GetDrawScaleRatio();
	SetCollisionSize( Default.CollisionRadius * CurrentDrawScaleInfo.GetDrawScaleRatio(),
			Default.CollisionHeight * CurrentDrawScaleInfo.GetDrawScaleRatio() );
*/
}



function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel )
{
    ReturnState = GetStateName();
    ReturnLabel= 'Begin';
}



function LoopMovementAnim( float IntendedMovementSpeed );
function PlayInactiveAnimation();
function PlayInactiveSound();



function HandlePreHint( Name PreHint )
{
	HandleHint( PreHint );
}



function HandlePostHint( Name PostHint )
{
	HandleHint( PostHint );
}



function HandleHint( Name Hint )
{
	class'Debug'.static.DebugLog( Self, "HandleHint Hint " $ Hint, DebugCategoryName );
	switch( Hint )
	{
		case HintName_AttemptAttack:
			DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].Notify();
			break;
		case HintName_ForceStationary:
			ForceStationary();
			break;
		case HintName_UnforceStationary:
			UnforceStationary();
			break;
		default:
			break;
	}
}



function ForceStationary()
{
	CurrentMovementManager.SetForcedStationary( true );
}



function UnForceStationary()
{
	CurrentMovementManager.SetForcedStationary( false );
}



function ForceDormant()
{
	GotoState( 'Dormant' );
}



function UnForceDormant();



function PerformDefensiveDodge( Vector DodgeDestination );



function bool WithinMaxMeleeDistance( GoalAbstracterInterf Goal )
{
	local float GoalDistance;
	local bool bWithinMaxMeleeDistance;
	if( ( MeleeRange != 0 ) && Goal.GetGoalDistance( Self, GoalDistance, Self ) )
	{
		class'Debug'.static.DebugLog( Self, "WithinMaxMeleeDistance GoalDistance " $ GoalDistance, DebugCategoryName );
		bWithinMaxMeleeDistance = GoalDistance <= MeleeRange;
	}
	class'Debug'.static.DebugLog( Self, "WithinMaxMeleeDistance MeleeRange " $ MeleeRange, DebugCategoryName );
	return bWithinMaxMeleeDistance;
}



//=============================================================================
//	StartUp state
//=============================================================================



auto state () StartUp
{
	function BeginState()
	{
		Global.BeginState();
		TransitionOnGoalPriority( true );
	}
}



state Animating
{
	function PlayStateAnimation();
	Begin:
		PlayStateAnimation();
		FinishAnim();
	FinishedAnimating:
		GotoState( NextState, NextLabel );
}



state AnimatingEndOnTakeDamage expands Animating
{
	function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation,  Vector Momentum, Name DamageType)
	{
		bAnimFinished = true;
		Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
		GotoState( GetStateName(), 'FinishedAnimating' );
	}
}



//=============================================================================
//	AttemptAttack state
//=============================================================================



state AttemptAttack
{
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel );
	
	function BeginState()
	{
		local Actor AttackActor;
		local float	CurrentGoalDistance;

		BeginStatePrepareNotifiers();
		Global.BeginState();
		if( GetGoal( CurrentGoalIdx ).IsValid( Self ) && GetAttackActor( AttackActor, GetGoal( CurrentGoalIdx ) ) )
		{
			PerformAttack( AttackActor, GetGoal( CurrentGoalIdx ) );
		}
		else
		{
			FinishedAttackAttempt();
		}
	}
	
	function EndState()
	{
		EndStatePrepareNotifiers();
		Global.EndState();
	}

	function BeginStatePrepareNotifiers()
	{
		Global.BeginStatePrepareNotifiers();
		//xxxrlo DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].DisableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].DisableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Global.EndStatePrepareNotifiers();
		//xxxrlo DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].EnableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].DisableNotifier();
	}

	function bool GetAttackActor( out Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local bool bGetAttackActor;
		class'Debug'.static.DebugLog( Self, "GetAttackActor", DebugCategoryName );
		if( Weapon != None )
		{
			//just some kind of weapon
			AttackActor = Weapon;
			bGetAttackActor = true;
		}
		else if( WithinMaxMeleeDistance( Goal ) )
		{
			//no current weapon
			//in melee range
			AttackActor = Self;
			bGetAttackActor = true;
		}
		class'Debug'.static.DebugLog( Self, "GetAttackActor AttackActor " $ AttackActor $ " returning " $ bGetAttackActor, DebugCategoryName );
		return bGetAttackActor;
	}
	
	function FinishedAttackAttempt()
	{
		class'Debug'.static.DebugLog( Self, "FinishedAttackAttempt", DebugCategoryName );
		GotoState( NextState, NextLabel );
	}

	function PerformAttack( Actor AttackActor, GoalAbstracterInterf Goal )
	{
		class'Debug'.static.DebugLog( Self, "PerformAttack", DebugCategoryName );
		if( AttackActor == Self )
		{
			GotoState( 'PerformMeleeAttack' );
		}
		else
		{
			//just some weapon in the iventory
			GotoState( 'PerformAttack' );
		}
	}

	function PrePerformingAttack()
	{
		class'Debug'.static.DebugLog( Self, "PrePerformingAttack:", DebugCategoryName );
		GotoState( GetStateName(), 'PerformingAttack' );
	}
	
	function PerformingAttack()
	{
		class'Debug'.static.DebugLog( Self, "PerformingAttack:", DebugCategoryName );
		GotoState( GetStateName(), 'PostPerformingAttack' );
	}
	
	function PostPerformingAttack()
	{
		class'Debug'.static.DebugLog( Self, "PostPerformingAttack:", DebugCategoryName );
		FinishedAttackAttempt();
	}

PrePerformingAttack:
	PrePerformingAttack();

PerformingAttack:
	PerformingAttack();

PostPerformingAttack:
	PostPerformingAttack();
}



//=============================================================================
//	PerformAttack state
//=============================================================================



state PerformAttack expands AttemptAttack
{
	function BeginState()
	{
		BeginStatePrepareNotifiers();
		Global.BeginState();
	}
	
	function EndState()
	{
		EndStatePrepareNotifiers();
		Global.EndState();
	}

	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].EnableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
	}

	function OnRotationNotification( Notifier Notification )
	{
		MatchGoalRotation( GetGoal( CurrentGoalIdx ) );
	}

Begin:
	class'Debug'.static.DebugLog( Self, "Begin:", class'Debug'.default.DC_StateCode );
	GotoState( GetStateName(), 'PrePerformingAttack' );
}



//=============================================================================
//	PerformMeleeAttack state
//=============================================================================



state PerformMeleeAttack expands PerformAttack
{
	function EndState()
	{
		StopMovement();
		Super.EndState();
	}

	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].EnableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
	}

	function OnMovementNotification( Notifier Notification )
	{
		MatchGoalAcceleration( GetGoal( CurrentGoalIdx ) );
	}
}



//=============================================================================
// TrackingBase state
//=============================================================================



state TrackingBase
{
	function BeginState()
	{
		bNotifyAchievedRotation = false;
		bNotifyReachedDestination = false;
		BeginStatePrepareNotifiers();
		Global.BeginState();
	}
	
	function EndState()
	{
		bNotifyAchievedRotation = false;
		bNotifyReachedDestination = false;
		bPreferCurrentHandler = false;
		EndStatePrepareNotifiers();
		Global.EndState();
	}

	function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
	}

    function HitWall( vector HitNormal, Actor Wall )
    {
        if( Physics != PHYS_Falling )
		{
            //Set this so PickWallAdjust() will work
            Destination = CurrentMovementManager.ReturnDestinationLocation( Self );
            if( PickWallAdjust() )
			{
				//then Destination and/or Physics changed
                if( Physics != PHYS_Falling )
				{
                    CurrentMovementManager.ReturnDestination().AssignVector( Self, Destination );
				}
            }
        }
    }

	function BeginStatePrepareNotifiers()
	{
		Global.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Visibility ].EnableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].EnableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Global.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
	}

	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel )
	{
	    ReturnState = GetStateName();
   	    ReturnLabel = 'PostTrackGoal';
	}

	function GoalInitialized( EGoalIndex GoalIdx )
	{
		class'Debug'.static.DebugLog( Self, "GoalInitialized", DebugCategoryName );
		Global.GoalInitialized( GoalIdx );
		if( HasRangeTransitioned() )
		{
			OnRangeTransition();
		}
	}
	
	function LostGoal()
	{
		class'Debug'.static.DebugLog( Self, "LostGoal", DebugCategoryName );
		InvalidateGoal( CurrentGoalIdx );
	}
	
	function GetPriorityGoalIndex( out EGoalIndex PriorityGoalIndex )
	{
		Global.GetPriorityGoalIndex( PriorityGoalIndex );
		class'Debug'.static.DebugLog( Self, "GetPriorityGoalIndex PriorityGoalIndex " $ PriorityGoalIndex, DebugCategoryName );
	}

	function bool HasRangeTransitioned()
	{
		local EGoalIndex PriorityGoalIndex;
		local bool bTransitioned;

		class'Debug'.static.DebugLog( Self, "HasRangeTransitioned", DebugCategoryName );
		GetPriorityGoalIndex( PriorityGoalIndex );
		if( PriorityGoalIndex != CurrentGoalIdx )
		{
			//another goal has a higher priority
			bTransitioned = true;
		}
		else if( bPreferCurrentHandler && CurrentRangeIterator.GetCurrentHandler().IsInRange(
				Self, CurrentConstrainer, GetGoal( CurrentGoalIdx ) ) )
		{
			//the current handler is prefered and
			//the current handler is valid
			//bTransitioned = false; //dont need to assign just here for clarity
		}
		else if( CurrentRangeIterator.SelectNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer ) )
		{
			//the current handler is not prefered or
			//the current handler is not valid
			bTransitioned = ( CurrentRangeIterator.GetSelectedHandler() != CurrentRangeIterator.GetCurrentHandler() );
		}
		else
		{
			//xxxrlo CurrentRangeIterator.GetCurrentHandler().IsInRange( Self, CurrentConstrainer, GetGoal( CurrentGoalIdx ) );
			//xxxrlo CurrentRangeIterator.SelectNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
			//xxxrlo assert( false );
			bTransitioned = true;
		}
		class'Debug'.static.DebugLog( Self, "HasRangeTransitioned returning " $ bTransitioned, DebugCategoryName );
		return bTransitioned;
	}

	//called after it has been determined that the a range transition has occured.
	//determines (based on the next selected range handler) if the current range
	//transitioner should still remain in charge. override this function with a
	//state transition to unconditionally divert control to another range itterator.
	function OnRangeTransition()
	{
		class'Debug'.static.DebugLog( Self, "OnRangeTransition", DebugCategoryName );
		bAnimFinished = true;
		TransitionToNextState();
	}

	//called after the current tracking iteration has been completed
	//over ride this function to provide special state behavior in between tracking
	//iterations. in order to proceed with normal goal tracking behavior make sure
	//to call the base class implementation after the derived behavior has been executed.
	function PostTrackGoal()
	{
		class'Debug'.static.DebugLog( Self, "PostTrackGoal CurrentGoalIdx " $ CurrentGoalIdx, DebugCategoryName );
		//xxxrlo GetGoal( CurrentGoalIdx ).IsGoalReached( Self ); in range transitioner?
		if( HasRangeTransitioned() )
		{
			OnRangeTransition();
		}
		else
		{
			DoTrackGoalPolling();
		}
		class'Debug'.static.DebugLog( Self, "PostTrackGoal end", DebugCategoryName );
	}
	
	//determines if another iteration of the tracking operation should be invoked.
	function DoTrackGoalPolling()
	{
		class'Debug'.static.DebugLog( Self, "DoTrackGoalPolling  HT_Name "  $ CurrentRangeIterator.GetCurrentHandler().Template.HT_Name, DebugCategoryName );
		//xxxrlo NotifyPeersOfGoal();
		InitiateTrackingOperation();
	}
	
	function InitiateTrackingOperation()
	{
		class'Debug'.static.DebugLog( Self, "InitiateTrackingOperation", DebugCategoryName );
		GotoState( GetStateName(), 'TrackGoal' );
	}

	function ExecuteLabel( name LabelToExecute, name ReturnLabel )
	{
		NextLabel = ReturnLabel;
		GotoState( GetStateName(), LabelToExecute );
	}
	
	function bool VerifyRangeHandler( Actor RangeActor,	BehaviorConstrainer Constrainer,
			GoalAbstracterInterf Goal )
	{
		local RangeHandler CurrentRangeHandler;
		local bool bVerifyRangeHandler;
		class'Debug'.static.DebugLog( Self, "VerifyRangeHandler", DebugCategoryName );
		if( Goal != None )
		{
			CurrentRangeHandler = CurrentRangeIterator.GetCurrentHandler();
			if( CurrentRangeHandler != None )
			{
				bVerifyRangeHandler = CurrentRangeHandler.IsInRange( RangeActor, Constrainer, Goal );
			}
		}
		return bVerifyRangeHandler; 
	}

	event OnDurationNotification( DurationNotifier NotifingDuration )
	{
		Global.OnDurationNotification( NotifingDuration );
	}

	function OnOffensiveNotification( Notifier Notification )
	{
		class'Debug'.static.DebugLog( Self, "OnOffensiveNotification", DebugCategoryName );
		Global.OnOffensiveNotification( Notification );
	    GetNextStateAndLabelForReturn( NextState, NextLabel );
		GotoState( 'AttemptAttack' );
	}
	
	event OnAchievedRotation( Vector FocalPoint )
	{
		class'Debug'.static.DebugLog( Self, "OnAchievedRotation", DebugCategoryName );
		GotoState( GetStateName(), 'FinsidedTurnTo' );
	}

	event OnReachedDestination( Vector Destination )
	{
		class'Debug'.static.DebugLog( Self, "OnReachedDestination", DebugCategoryName );
		GotoState( GetStateName(), 'FinsidedMoveTo' );
	}

	function InterruptMovement()
	{
		Global.InterruptMovement();
		if( bNotifyAchievedRotation )
		{
			NextLabel = 'PostTrackGoal';
			bNotifyAchievedRotation = false;
			OnAchievedRotation( Location );
		}
		else if( bNotifyReachedDestination )
		{
			NextLabel = 'PostTrackGoal';
			bNotifyReachedDestination = false;
			OnReachedDestination( Location );
		}
		else
		{
			GotoState( GetStateName(), 'PostTrackGoal' );
		}
	}

	function HandlePreHint( Name PreHint )
	{
		class'Debug'.static.DebugLog( Self, "HandlePreHint PreHint " $ PreHint, DebugCategoryName );
		Global.HandlePreHint( PreHint );
		switch( PreHint )
		{
			case HintName_AttemptDodge:
				ExecuteLabel( 'PerformDodge' , 'PostTrackGoal' );
				break;
			default:
				break;
		}
	}

	function HandlePostHint( Name PostHint )
	{
		Global.HandlePostHint( PostHint );
		/*
		switch( PostHint )
		{
			default:
				break;
		}
		*/
	}

	function PlayInactiveAnimation()
	{ 
		Global.PlayInactiveAnimation();
	}

	function PlayInactiveSound()
	{ 
		Global.PlayInactiveSound();
	}

	function bool PerformInactivity()
	{
		//local bool bPerformInactivity;
		//class'Debug'.static.DebugLog( Self, "PerformInactivity Level.TimeSeconds" $ Level.TimeSeconds, DebugCategoryName );
		//class'Debug'.static.DebugLog( Self, "PerformInactivity LastTrackingTime" $ LastTrackingTime, DebugCategoryName );
		//class'Debug'.static.DebugLog( Self, "PerformInactivity MinTrackingDuration" $ MinTrackingDuration, DebugCategoryName );
		return ( ( Level.TimeSeconds - LastTrackingTime ) < MinTrackingDuration );
	}

	function PerformDefensiveDodge( Vector DodgeDestination )
	{
		//xxxrlo this is a hack this should not need to be here
		//the state code is waiting for landing
		if( Physics != PHYS_Falling )
		{
			Velocity = Normal( DodgeDestination - Location ) * DodgeVelocityFactor;
			Velocity.Z = DodgeVelocityAlltitude;
			SetPhysics( PHYS_Falling );
			Global.PerformDefensiveDodge( DodgeDestination );
		}
	}
}



//=============================================================================
// Tracking state
//=============================================================================



state Tracking expands TrackingBase
{
Begin:
	DoTrackGoalPolling(); //code after this point will never be called
	Stop;

TrackGoal:
	class'Debug'.static.DebugLog( Self, "TrackGoal:", class'Debug'.default.DC_StateCode );
	
	LastTrackingTime = Level.TimeSeconds;

	//xxxrlo UpdateDrawScaleBasedProperties();
	CurrentMovementManager.InitMovement( Self, CurrentRangeIterator.GetCurrentHandler(),
			CurrentConstrainer, GetGoal( CurrentGoalIdx ) );

	HandlePreHint( CurrentRangeIterator.GetCurrentHandler().Template.HT_PreHint );
	ExecuteLabel( 'PrePerformTurn', 'Tracking_PostPerformTurn' );
	Tracking_PostPerformTurn:
	
	ExecuteLabel( 'PrePerformMove', 'Tracking_PostPerformMove' );
	Tracking_PostPerformMove:
	
	HandlePostHint( CurrentRangeIterator.GetCurrentHandler().Template.HT_PostHint );
	ExecuteLabel( 'PerformInactivity', 'Tracking_PostPerformInactivity' );
	Tracking_PostPerformInactivity:
	Goto( 'PostTrackGoal' );

PostTrackGoal:
	PostTrackGoal(); //code after this point will never be called
	Stop;
	
PrePerformTurn:
	class'Debug'.static.DebugLog( Self, "PrePerformTurn:", class'Debug'.default.DC_StateCode );
	Goto( 'PerformTurn' );
PerformTurn:
	class'Debug'.static.DebugLog( Self, "PerformTurn:", class'Debug'.default.DC_StateCode );
	if( CurrentMovementManager.ShouldTurnTo( Self ) )
	{
		Goto( 'PerformTurnPlayAnim' );
PerformTurnPlayAnim:
		class'Debug'.static.DebugLog( Self, "PerformTurnPlayAnim:", class'Debug'.default.DC_StateCode );
		LoopMovementAnim( GetGoal( CurrentGoalIdx ).GetSuggestedSpeed( Self ) );
		Goto( 'PerformTurnNoAnim' );
PerformTurnNoAnim:
		class'Debug'.static.DebugLog( Self, "PerformTurnNoAnim:", class'Debug'.default.DC_StateCode );
		bNotifyAchievedRotation = true;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].EnableNotifier();
		if( CurrentMovementManager.ReturnFocus().IsValid( Self ) )
		{
			Focus = CurrentMovementManager.ReturnFocusLocation( Self );
			ViewRotation = Rotator( Focus - Location );
			if( CurrentMovementManager.ReturnFocus().IsGoalA( Self, 'Actor' ) )
			{
				TurnToward( CurrentMovementManager.ReturnFocusActor( Self ) );
			}
			else
			{
				TurnTo( CurrentMovementManager.ReturnFocusLocation( Self ) );
			}		
			class'Debug'.static.DebugLog( Self, "PerformTurnNoAnim: latent turning", class'Debug'.default.DC_StateCode );
		}
		Goto( 'PostPerformTurnNoAnim' );
PostPerformTurnNoAnim:
		class'Debug'.static.DebugLog( Self, "PostPerformTurnNoAnim:", class'Debug'.default.DC_StateCode );
		Stop;
FinsidedTurnTo:
		class'Debug'.static.DebugLog( Self, "FinsidedTurnTo:", class'Debug'.default.DC_StateCode );
		bNotifyAchievedRotation = false;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
	}
	Goto( 'PostPerformTurn' );
PostPerformTurn:
	class'Debug'.static.DebugLog( Self, "PostPerformTurn:", class'Debug'.default.DC_StateCode );
	goto 'PostExecuteLabel';

PrePerformMove:
	class'Debug'.static.DebugLog( Self, "PrePerformMove:", class'Debug'.default.DC_StateCode );
	Goto( 'PerformMove' );
PerformMove:
	class'Debug'.static.DebugLog( Self, "PerformMove:", class'Debug'.default.DC_StateCode );
	if( CurrentMovementManager.ShouldMoveTo( Self ) )
	{
		Goto( 'PerformMovePlayAnim' );
PerformMovePlayAnim:
		class'Debug'.static.DebugLog( Self, "PerformMovePlayAnim: ", class'Debug'.default.DC_StateCode );
		LoopMovementAnim( GetGoal( CurrentGoalIdx ).GetSuggestedSpeed( Self ) );
		Goto( 'PerformMoveNoAnim' );
PerformMoveNoAnim:
		class'Debug'.static.DebugLog( Self, "PerformMoveNoAnim: ", class'Debug'.default.DC_StateCode );
		bNotifyReachedDestination = true;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].EnableNotifier();
		if( CurrentMovementManager.ReturnDestination().IsValid( Self ) )
		{
			class'Debug'.static.DebugLog( Self, "PerformMove: latent moving", class'Debug'.default.DC_StateCode );
			GroundSpeed = CurrentMovementManager.ReturnDestination().GetSuggestedSpeed( Self );
			StrafeTo( CurrentMovementManager.ReturnDestinationLocation( Self ),
					CurrentMovementManager.ReturnFocusLocation( Self ) );
		}
		Goto( 'PostPerformMoveNoAnim' );
PostPerformMoveNoAnim:
		class'Debug'.static.DebugLog( Self, "PostPerformMoveNoAnim: ", class'Debug'.default.DC_StateCode );
		Stop;
FinsidedMoveTo:
		class'Debug'.static.DebugLog( Self, "FinsidedMoveTo: ", class'Debug'.default.DC_StateCode );
		bNotifyReachedDestination = false;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
	}
	else if( !CurrentMovementManager.ReturnDestination().IsGoalA( Self, 'Actor' ) )
	{
		StopMovement();
	}
	Goto( 'PostPerformMove' );
PostPerformMove:
	class'Debug'.static.DebugLog( Self, "PostPerformMove:", class'Debug'.default.DC_StateCode );
	goto 'PostExecuteLabel';

PerformInactivity:
	class'Debug'.static.DebugLog( Self, "PerformInactivity:", class'Debug'.default.DC_StateCode );
	if( PerformInactivity() )
	{
		PlayInactiveAnimation();
		FinishAnim( false );
		PlayInactiveSound();
		if( PerformInactivity() )
		{
			Sleep( MinTrackingDuration - ( Level.TimeSeconds - LastTrackingTime ) );
		}
	}
	goto 'PostPerformInactivity';

PostPerformInactivity:
	goto 'PostExecuteLabel';

PerformDodge:
	DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].DisableNotifier();
	PerformDefensiveDodge( CurrentMovementManager.ReturnDestinationLocation( Self ) );
	WaitForLanding();
	Velocity.Z = 0.0;
	DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].EnableNotifier();
	goto 'PostExecuteLabel';

PostExecuteLabel:
	goto NextLabel;
}



//=============================================================================
// Retreating state
//=============================================================================



/*
function TransitionToRetreating()
{
	class'Debug'.static.DebugLog( Self, "TransitionToRetreating", DebugCategoryName );
	CurrentGoalIdx = EGoalIndex.GI_Threat;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Retreating ].TI_Transitioner );
	CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
}



function HandleRetreatSituation( RetreatInstigator Instigator )
{
	local Vector RetreatOrigin, RetreatExtents, Difference;
	local float CurrentDistance;
	
	class'Debug'.static.DebugLog( Self, "HandleRetreatSituation", DebugCategoryName );
	if( Instigator != none )
	{
		Instigator.GetRetreatInstigatorParams( Self, RetreatOrigin, RetreatExtents );
		RetreatExtents *= Instigator.GetThreatInfluence( Self );
		class'Debug'.static.DebugLog( Self, "RetreatExtents.x: " $ RetreatExtents.x, DebugCategoryName );
		Difference = RetreatOrigin - Location;
		Difference.Z = 0;

		CurrentDistance = VSize( Difference );
		class'Debug'.static.DebugLog( Self, "CurrentDistance: " $ CurrentDistance, DebugCategoryName );
		
		if( CurrentDistance < RetreatExtents.x )
		{
			TransitionToRetreating();
		}
	}
}



state Retreating expands Tracking
{
	function TransitionToRetreating()
	{
		class'Debug'.static.DebugLog( Self, "TransitionToRetreating", DebugCategoryName );
		CurrentRangeIterator.GetCurrentHandler().ResetRangeEntryTime( Self );
	}
}
*/



//=============================================================================
//	NavigatingToExternalDirective states
//=============================================================================



state NavigatingToExternalDirective expands Tracking {}
state ExternalDirectivePathable expands NavigatingToExternalDirective {}
state ExternalDirectiveVisible expands NavigatingToExternalDirective {}
state ExternalDirectiveReachable expands ExternalDirectiveVisible {}

state ExternalDirectiveReached expands ExternalDirectiveReachable
{
	function InitiateTrackingOperation()
	{
		class'Debug'.static.DebugLog( Self, "InitiateTrackingOperation", DebugCategoryName );
		class'ExternalDirective'.static.RelinquishDirective( Self, GoalInfos[ CurrentGoalIdx ].GI_Goal );
		Super.PostTrackGoal();
	}
}

state ExternalDirectiveUnNavigable expands ExternalDirectiveReached {}



//=============================================================================
//	Returning states
//=============================================================================



state Returning expands Tracking {}
state ReturningReachable expands Returning {}
state ReturningPathable expands Returning {}
state FinishedReturning expands Returning {}



state UnableToReturn expands FinishedReturning
{
	function InitiateTrackingOperation()
	{
		class'Debug'.static.DebugLog( Self, "InitiateTrackingOperation", DebugCategoryName );
		SetWaitingGoal( Location, Rotation );
		Super.InitiateTrackingOperation();
	}
}



//=============================================================================
// Waiting state
//=============================================================================



state () Waiting expands FinishedReturning
{
	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Waiting ].EnableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Waiting ].DisableNotifier();
	}

	function OnWaitingNotification( Notifier Notification )
	{
		local EGoalIndex PriorityGoalIndex;
		Global.OnWaitingNotification( Notification );
		GetPriorityGoalIndex( PriorityGoalIndex );
		class'Debug'.static.DebugLog( Self, "OnWaitingNotification PriorityGoalIndex " $ PriorityGoalIndex, DebugCategoryName );
 		if( ShouldContinueWaiting( PriorityGoalIndex ) )
 		{
			//keep on waiting until something is found
			ContinueWaiting();
 		}
		else
		{
			OnRangeTransition();
		}
	}

	function bool ShouldContinueWaiting( EGoalIndex PriorityGoalIndex )
	{
		return ( PriorityGoalIndex == GI_Waiting ) || ( PriorityGoalIndex == GI_Colleague );
	}

	function ContinueWaiting();

	function SetWaitingGoal( Vector WaitingLocation, Rotator WaitingRotation )
	{
		Super.SetWaitingGoal( WaitingLocation, WaitingRotation );
		//need to restart the state since waiting does not pole the goal continuously
		GoalIndexTransitionWaiting();
	}

PostTrackGoal:
	Stop;
}



//=============================================================================
// Inactive state
//=============================================================================



state() Inactive expands Waiting
{
	function bool IsInactive() { return true; }
	function BeginStatePrepareNotifiers() { DisableNotifiers(); }
Begin:
	FinishAnim();
	Stop;
}



//=============================================================================
// Dormant state
//=============================================================================



state () Dormant expands Waiting
{
	function BeginState()
	{
		Super.BeginState();
		bStasis = true;
		bForceStasis = true;
	}

	function EndState()
	{
		bStasis = false;
		bForceStasis = false;
		Super.EndState();
	}

	function BeginStatePrepareNotifiers() { DisableNotifiers(); }
	function OnActivityManagerNotification( ActivityManager NotifingActivityManager );
	function bool HasRangeTransitioned() { return false; }
	function MoveAwayFromAreaDirected( float MoveDistance, Rotator PreferredRotation, optional bool bOverrideCurrent );
	function ForceDormant();

	function UnForceDormant()
	{
		bStasis = false;
		bForceStasis = false;
		TransitionOnGoalPriority( true );
	}

	simulated event SetInitialState()
	{
		SetWaitingGoal( Location, Rotation );
	}

	function SetWaitingGoal( Vector WaitingLocation, Rotator WaitingRotation )
	{
		Global.SetWaitingGoal( WaitingLocation, WaitingRotation );
		//need to restart the state since waiting does not pole the goal continuously
		SetLocation( WaitingLocation );
		SetRotation( WaitingRotation );
	}

Begin:
	FinishAnim();
	Stop;
}



//=============================================================================
// Dying state
//=============================================================================



state Dying
{
	function Trigger( Actor Other, Pawn EventInstigator );
	function OnActivityManagerNotification( ActivityManager NotifingActivityManager );
	function TransitionOnGoalPriority( optional bool bEvaluateGoalPriorities );
	function OnVisibilityNotification( Notifier Notification );
    function OnRotationNotification( Notifier Notification );
    function OnMovementNotification( Notifier Notification );
    function OnDefensiveNotification( Notifier Notification );
    function OnOffensiveNotification( Notifier Notification );
    function OnWaitingNotification( Notifier Notification );
	function OnSeeEnemy( Pawn SeenPawn );
	function OnSeeFriendlyPlayer( Pawn SeenPawn );
	function OnSeeFriendlyPawn( Pawn SeenPawn );
}

defaultproperties
{
     DebugCategoryName=LegendPawn
     DrawScaleInfoClass=Class'Legend.DrawScaleInfo'
     MovementManagerClass=Class'Legend.MovementManager'
     RangeTransitionerClass=Class'Legend.RangeTransitioner'
     ConstrainerClass=Class'Legend.BehaviorConstrainer'
     GoalFactoryClass=Class'Legend.GoalFactory'
     HandlerFactoryClass=Class'Legend.RangeHandlerFactoryLegendPawn'
     GoalDescripterNames(0)=GoalDescriptorName_Pawn
     GoalDescripterNames(1)=GoalDescriptorName_None
     GoalDescripterNames(2)=GoalDescriptorName_Location
     GoalDescripterNames(3)=GoalDescriptorName_Location
     GoalDescripterNames(4)=GoalDescriptorName_Pawn
     GoalDescripterNames(5)=GoalDescriptorName_Location
     GoalDescripterNames(6)=GoalDescriptorName_Generic
     GoalDescripterNames(7)=GoalDescriptorName_Generic
     GoalDescripterNames(8)=GoalDescriptorName_Generic
     GoalPriorities(0)=80.000000
     GoalPriorities(1)=-1.000000
     GoalPriorities(2)=100.000000
     GoalPriorities(3)=90.000000
     GoalPriorities(4)=40.000000
     GoalPriorities(5)=85.000000
     GoalPriorities(6)=50.000000
     GoalPriorities(7)=-1.000000
     GoalPriorities(8)=-1.000000
     GoalPriorityDistances(0)=8000.000000
     GoalPriorityDistances(1)=-1.000000
     GoalPriorityDistances(2)=8000.000000
     GoalPriorityDistances(3)=480.000000
     GoalPriorityDistances(4)=8000.000000
     GoalPriorityDistances(5)=8000.000000
     GoalPriorityDistances(6)=8000.000000
     GoalPriorityDistances(7)=-1.000000
     GoalPriorityDistances(8)=-1.000000
     GoalPriorityDistanceUsages(0)=-2.000000
     GoalPriorityDistanceUsages(1)=-1.000000
     GoalPriorityDistanceUsages(2)=-2.000000
     GoalPriorityDistanceUsages(3)=-3.000000
     GoalPriorityDistanceUsages(4)=-2.000000
     GoalPriorityDistanceUsages(5)=-2.000000
     GoalPriorityDistanceUsages(6)=-2.000000
     GoalPriorityDistanceUsages(7)=-1.000000
     GoalPriorityDistanceUsages(8)=-1.000000
     GoalSuggestedSpeeds(0)=320.000000
     GoalSuggestedSpeeds(1)=-1.000000
     GoalSuggestedSpeeds(2)=320.000000
     GoalSuggestedSpeeds(3)=320.000000
     GoalSuggestedSpeeds(4)=320.000000
     GoalSuggestedSpeeds(5)=320.000000
     GoalSuggestedSpeeds(6)=160.000000
     GoalSuggestedSpeeds(7)=-1.000000
     GoalSuggestedSpeeds(8)=-1.000000
     GoalInfos(0)=(GI_GoalName=Threat)
     GoalInfos(1)=(GI_GoalName=ExternalDirective)
     GoalInfos(2)=(GI_GoalName=Refuge)
     GoalInfos(3)=(GI_GoalName=Guarding)
     GoalInfos(4)=(GI_GoalName=Colleague)
     GoalInfos(5)=(GI_GoalName=Intermediate)
     GoalInfos(6)=(GI_GoalName=Waiting)
     GoalInfos(7)=(GI_GoalName=CurrentWaypoint)
     GoalInfos(8)=(GI_GoalName=CurrentFocus)
     TransitionerInfos(0)=(TI_bConstruct=True,TI_TransitionerName=Returning)
     TransitionerInfos(1)=(TI_bConstruct=True,TI_TransitionerName=Tracking)
     TransitionerInfos(2)=(TI_bConstruct=True,TI_TransitionerName=Retreating)
     TransitionerInfos(3)=(TI_bConstruct=True,TI_TransitionerName=ExternalDirective)
     TransitionerInfos(4)=(TI_TransitionerName=Acquired)
     TransitionerInfos(5)=(TI_TransitionerName=Investigating)
     TransitionerInfos(6)=(TI_TransitionerName=Searching)
     TransitionerInfos(7)=(TI_TransitionerName=NavigationgToGoal)
     TransitionerInfos(8)=(TI_TransitionerName=SeekRefuge)
     TransitionerInfos(9)=(TI_TransitionerName=FindHelp)
     TransitionerInfos(10)=(TI_TransitionerName=NavigatingToSeal)
     TransitionerInfos(11)=(TI_TransitionerName=NavigatingToSealAltar)
     TransitionerInfos(12)=(TI_TransitionerName=SoundAlarm)
     DurationNotifierClasses(0)=Class'Legend.DurationNotifier'
     DurationNotifierClasses(1)=Class'Legend.DurationNotifier'
     DurationNotifierClasses(2)=Class'Legend.DurationNotifier'
     DurationNotifierClasses(3)=Class'Legend.DefensiveDetector'
     DurationNotifierClasses(4)=Class'Legend.DurationNotifier'
     DurationNotifierClasses(5)=Class'Legend.DurationNotifier'
     DurationNotifierNotifications(0)=OnVisibilityNotification
     DurationNotifierNotifications(1)=OnRotationNotification
     DurationNotifierNotifications(2)=OnMovementNotification
     DurationNotifierNotifications(3)=OnDefensiveNotification
     DurationNotifierNotifications(4)=OnOffensiveNotification
     DurationNotifierNotifications(5)=OnWaitingNotification
     DurationNotifierDurations(0)=2.000000
     DurationNotifierDurations(3)=0.050000
     DurationNotifierDurations(4)=0.500000
     DurationNotifierDurations(5)=0.250000
     PeerNotificationRadiiCount=5
     MinTrackingDuration=0.010000
     ActivityManagerClass=Class'Legend.ActivityManager'
     ForceInactiveStateName=Inactive
     DodgeVelocityFactor=400.000000
     DodgeVelocityAlltitude=160.000000
     AnimaterClass=Class'Legend.PrimitiveMovementAnimater'
     Physics=PHYS_Walking
     InitialState=Dormant
     CollisionRadius=16.000000
     CollisionHeight=44.000000
}
