//=============================================================================
// Captain.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 18 $
//=============================================================================

class Captain expands Grunt abstract;

//See Design Goals for Weapon Selection in base class for information on how
//the weapon selection code works.

//TBD: This inheritance hierarchy makes it so that Captains are Grunts with
//some extra abilities.  Since learning more about the design, it seems closer
//to reality of the design that Grunts are really Captains that don't have
//ranged weapons, and can only have orders of KillIntruder, GuardSeal,
//or GuardRoom.  Maybe in the future it would be worth exploring the idea.
//It would at least make the classes less messy if the Captain's way of
//determining his orders (WorkingOrders) matched the Grunt's way (bIsGuarding).
//More irritations with the current scheme: if you override 
//See[Un]ReachableEnemyPlayer() in a Grunt state, you also need
//to override it in a Captain state so that orders are followed.

enum EOrdersType
{
	OT_Guard,           //guard current location
	OT_KillIntruder,	//essentially acts as Grunt (except heals)
	OT_GuardSeal,       //guard nearest seal
	OT_SoundAlarm,      //usually sounds alarm when activated
	OT_GetHelp,        	//when alerted, find help
	OT_Automatic      	//start with sound alarm then get help then kill intruder
};

var() float AlarmSearchRadius;			//max distance Capt will go for alarm
var() float AlertVisibleWotPawnsRadius;	//I can alert folks when I'm this far away
var() float FindHelpRadius;				//max distance to find help within
var() float LeadershipRadius;			//Guarding captains will affect grunts up to this far away

//This var is initialized in WaitingIdle state to shadow the captain's
//Orders.  Subsequent state changes may change this field (e.g. once an
//alarm is sounded, a captain with OT_SoundAlarm orders gets OT_KillIntruder
//orders).  So, AI should pay attention to WorkingOrders (and not AssignedOrders)
//and the user GUI should set Orders (and not WorkingOrders), via ChangeOrders().
var EOrdersType		WorkingOrders;
var() EOrdersType	AssignedOrders;		//Set via ChangeOrders( NewOrders );

var private ItemSorter ReinforcementsSorter;

//captain anims:
const GiveOrdersAnimSlot = 'GiveOrders';
const GongAnimSlot = 'Gong';
const ReportAnimSlot = 'Report';



function ConstructAggregates()
{
	class'Debug'.static.DebugLog( Self, "ConstructAggregates", 'Captain' );
	Super.ConstructAggregates();
	ReinforcementsSorter = new( Self )class'ItemSorter';
}



function DestructAggregates()
{
	if( ReinforcementsSorter != None )
	{
		ReinforcementsSorter.Delete();
		ReinforcementsSorter = None;
	}
	Super.DestructAggregates();
}



//=============================================================================
// begin - unreal engine function overrides
//=============================================================================



simulated event SetInitialState()
{
    //initialize command system
	//xxxrlo hack-o-rama
	if( Level.NetMode != NM_Standalone )
    {
        AssignedOrders = OT_Automatic;
    }
   	ChangeOrders( AssignedOrders );
    class'WotUtil'.static.InvokeWotPawnFindLeader( Self );
	Super.SetInitialState();
}



function Destroyed()
{
    // Release any Grunts that Captain might have been leading
    AssignedOrders = OT_KillIntruder;  // make sure the Grunts don't think the Captain's guarding
    class'WotUtil'.static.InvokeWotPawnFindLeader( Self );
    Super.Destroyed();
}



function Trigger( Actor Other, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "Trigger Other " $ Other, class'Debug'.default.DC_EngineNotification );
	Super.Trigger( Other, EventInstigator );
	if( ( Other != None ) && Other.IsA( 'Seal' ) )
	{
		if( AssignedOrders == OT_GuardSeal )
		{
			OnGuardSeal();
		}
	}
}



//=============================================================================
// end - unreal engine function overrides
//=============================================================================



//=============================================================================
// begin - order functions
//=============================================================================



final function PlayOrdersSound( EOrdersType Orders )
{
	// alternatively could set sounds in SoundTable to not be played in SP games
	if( Level.Game.IsA( 'giCombatBase' ) )
	{
		MySoundTable.PlaySlotSound( Self, GetOrdersSlot( Orders ), VolumeMultiplier, RadiusMultiplier, PitchMultiplier );
	}
}



final function Name GetOrdersSlot( EOrdersType Orders )
{
	switch( Orders )
	{
		case OT_Guard:
			return MySoundTable.OrderGuardSoundSlot;
			break;						  
		case OT_KillIntruder:
			return MySoundTable.OrderKillIntruderSoundSlot;
			break;
		case OT_GuardSeal:
			return MySoundTable.OrderGuardSealSoundSlot;
			break;
		case OT_SoundAlarm:
			return MySoundTable.OrderSoundAlarmSoundSlot;
			break;
		case OT_GetHelp:
			return MySoundTable.OrderGetHelpSoundSlot;
			break;
		case OT_Automatic:
			return '';
			break;
		default:
			assert( false );
			break;
	}
}



function EOrdersType MapOrders( name OrdersName )
{
	local EOrdersType NewOrders;
	switch( OrdersName )
	{
	    case 'Guard':
			NewOrders = OT_Guard;
			break;
	    case 'KillIntruder':
		    NewOrders = OT_KillIntruder;
	    	break;
		case 'GuardSeal':
		    NewOrders = OT_GuardSeal;
	    	break;
		case 'SoundAlarm':
		    NewOrders = OT_SoundAlarm;
	    	break;
		case 'GetHelp':
		    NewOrders = OT_GetHelp;
	    	break;
		case 'Automatic':
		    NewOrders = OT_Automatic;
	    	break;
		default:
			warn( "MapOrders() Invalid Order" $ OrdersName );
			break;
	}
	return NewOrders;
}



function ResetOrders()
{
	class'Debug'.static.DebugLog( Self, "ResetOrders AssignedOrders: " $ AssignedOrders $ " WorkingOrders: " $ WorkingOrders, 'Captain' );
	WorkingOrders = AssignedOrders;
}



//=============================================================================
//When a Captain gets its orders changed, it needs to ping all of the 
//WOTPawns in its LeadershipRange so that they can decide who to follow.
//Captains have to let the Pawns make the decision, rather than making it
//for them, to avoid problem like the following:
//    1. Place Grunt
//    2. Place nearby Captain with Guard orders, who now leads Grunt
//    3. Place another nearby Captain with Guard orders, who now leads Grunt
//    4. Change the just-placed-Captain's orders to something besides Guard.
//If the captains were in control, the Grunt would go out of Guard mode, too.
//With this algorithm, the Grunt will pick up on the orders of the Captain
//placed in Step 2.
//=============================================================================

function ChangeOrders( EOrdersType NewOrders, optional bool bPlaySound )
{
	class'Debug'.static.DebugLog( Self, "ChangeOrders WorkingOrders " $ WorkingOrders $ " ChangeOrders NewOrders " $ NewOrders, 'Captain' );

	//xxxrlo guard seal and guard location do not exist
	if( ( NewOrders == OT_Guard ) || ( NewOrders == OT_GuardSeal ) )
	{
		NewOrders = OT_KillIntruder;
	}
	
	//Handle the given orders.
	DispatchOrders( NewOrders );
    WorkingOrders = NewOrders;
    if( AssignedOrders != NewOrders )
    {
	    //If orders changed, alert grunts.
	    AssignedOrders = NewOrders;
        class'WotUtil'.static.InvokeWotPawnFindLeader( Self );
    }

	if( bPlaySound )
	{
		PlayOrdersSound( AssignedOrders );
	}

	class'Debug'.static.DebugLog( Self, "ChangeOrders AssignedOrders " $ AssignedOrders $ " ChangeOrders WorkingOrders " $ WorkingOrders, 'Captain' );
}



function EvaluateOrders()
{
	local GoalAbstracterInterf Goal;
	class'Debug'.static.DebugLog( Self, "EvaluateOrders WorkingOrders " $ WorkingOrders, 'Captain' );
	Goal = GetGoal( EGoalIndex.GI_Intermediate );
/*
//xxxrlo old order interface
	switch( WorkingOrders )

	{
		case OT_Guard:
    	case OT_KillIntruder:
       	case OT_GuardSeal:
			//fall through all the same
	    	InvalidateGoal( EGoalIndex.GI_Intermediate );
	    	break;
	   	case OT_SoundAlarm:
			if( !class'WotUtil'.static.GetClosestAlarm( GetGoal( EGoalIndex.GI_Intermediate ), Self, AlarmSearchRadius ) )
			{
		    	InvalidateGoal( EGoalIndex.GI_Intermediate );
			}
			break;
		case OT_GetHelp:
			if( class'WotUtil'.static.CollectAvailableWotPawns( Self, ReinforcementsSorter, FindHelpRadius ) )
			{
				class'WotUtil'.static.GetNextAvailableWotPawn( Self, GetGoal( EGoalIndex.GI_Intermediate ), ReinforcementsSorter );
			}
			else
			{
		    	InvalidateGoal( EGoalIndex.GI_Intermediate );
			}
			break;
   		default:
	    	InvalidateGoal( EGoalIndex.GI_Intermediate );
   			class'Debug'.static.DebugWarn( Self, "EvaluateOrders did not handle orders " $ WorkingOrders, 'Captain' );
   			break;
	}
*/
	if( WorkingOrders == OT_KillIntruder )
	{
		//if she is set to kill she will kill
		Goal.Invalidate( Self );
	}
	else if( class'WotUtil'.static.GetClosestAlarm( Goal, Self, AlarmSearchRadius ) )
	{
		//if there is an alarm she will ring it
		WorkingOrders = OT_SoundAlarm;
	}
	else if( class'WotUtil'.static.CollectAvailableWotPawns( Self, ReinforcementsSorter, FindHelpRadius ) )
	{
		//if there is help available she will get it
		class'WotUtil'.static.GetNextAvailableWotPawn( Self, Goal, ReinforcementsSorter );
		WorkingOrders = OT_GetHelp;
	}
	else
	{
		//otherwise she will kill
		WorkingOrders = OT_KillIntruder;
		Goal.Invalidate( Self );
	}
	PlayOrdersSound( WorkingOrders );
	GoalInitialized( EGoalIndex.GI_Intermediate );;
}



//=============================================================================
// Dispatches Order types to appropriate order handling function.
//=============================================================================



final function DispatchOrders( EOrdersType Orders )
{
	switch( Orders )
	{
		case OT_Guard:
			OnGuardLocation();
			break;
		case OT_KillIntruder:
			OnKillIntruder();
			break;
		case OT_GuardSeal:
			OnGuardSeal();
			break;
		case OT_SoundAlarm:
			OnSoundAlarm();
			break;
		case OT_GetHelp:
			OnGetHelp();
			break;
		case OT_Automatic:
			OnAutomaticOrders();
			break;
		default:
			OnInvalidOrder();
			break;
	}
}



//=============================================================================
// begin Order handling functions
//=============================================================================



function OnGuardLocation()
{
	InitGoalWithVector( EGoalIndex.GI_Guarding, Location );
}



function OnKillIntruder()
{
	InvalidateGoal( EGoalIndex.GI_Guarding );
}



function OnGuardSeal()
{
	if( !class'WotUtil'.static.GetClosestUnownedSeal( GetGoal( EGoalIndex.GI_Guarding ), Self ) )
	{
		InvalidateGoal( EGoalIndex.GI_Guarding );
	}
}



function OnSoundAlarm()
{
	InvalidateGoal( EGoalIndex.GI_Guarding );
}



function OnGetHelp()
{
	InvalidateGoal( EGoalIndex.GI_Guarding );
}



function OnAutomaticOrders()
{
	InvalidateGoal( EGoalIndex.GI_Guarding );
}


			
function OnInvalidOrder()
{
	InvalidateGoal( EGoalIndex.GI_Guarding );
	warn( "Invalid OrderType." );
}
	


//=============================================================================
// end Order handling functions
//=============================================================================



//=============================================================================
// end - order functions
//=============================================================================



function bool IsLeader()
{
	return ( ( GetGoal( EGoalIndex.GI_Guarding ) != None ) && GetGoal( EGoalIndex.GI_Guarding ).IsValid( Self ) );
}



function bool FindLeader()
{
	//Captains don't bother doing anything
	return false;
}



function OnWaitingNotification( Notifier Notification )
{
	if( !IsHealthy() )
    {
		class'Debug'.static.DebugLog( Self, "OnWaitingNotification current health " $ Health, 'Captain' );
        Health++;
		class'Debug'.static.DebugLog( Self, "OnWaitingNotification new health " $ Health, 'Captain' );
   	}
   	//do not call super
}



function InitGoalWithVector( EGoalIndex GoalIdx, Vector InitWith,
		optional ETriStateBool IsVisible, optional ETriStateBool IsReachable,
		optional ETriStateBool IsPathable )
{
	if( ( GoalIdx == EGoalIndex.GI_Threat ) && !GetGoal( GoalIdx ).IsValid( Self ) )
	{
		EvaluateOrders();
	}
	Super.InitGoalWithVector( GoalIdx, InitWith, IsVisible, IsReachable, IsPathable );
}



function InitGoalWithObject( EGoalIndex GoalIdx, Object InitWith,
		optional ETriStateBool IsVisible, optional ETriStateBool IsReachable,
		optional ETriStateBool IsPathable )
{
	if( ( GoalIdx == EGoalIndex.GI_Threat ) && !GetGoal( GoalIdx ).IsValid( Self ) )
	{
		EvaluateOrders();
	}
	Super.InitGoalWithObject( GoalIdx, InitWith, IsVisible, IsReachable, IsPathable );
}



function bool GoalIndexTransitionIntermediate()
{
	local RangeHandler SelectedHandler;
	local bool bTransitioned;
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate", 'Captain' );
	if( GetGoal( EGoalIndex.GI_Intermediate ).IsGoalA( Self, 'Actor' ) )
	{
/*
		//the current goal is a valid actor
		if( GetGoal( EGoalIndex.GI_Intermediate ).IsGoalA( Self, 'Seal' ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate goal is a valid Seal", 'Captain' );
			if( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSeal ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
					GetGoal( EGoalIndex.GI_Intermediate ), CurrentConstrainer ) )
			{
				//the goal is rangable
				class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSeal ].TI_TransitionerName, 'Captain' );
				CurrentGoalIdx = EGoalIndex.GI_Intermediate;
				CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSeal ].TI_Transitioner );
				CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
				bTransitioned = true;
			}

		   	if( bTransitioned )
		   	{
		   		class'WotUtil'.static.InvokeWotPawnFindLeader( Self ); //reliquish control of local grunts
		   		InitGoalWithObject( EGoalIndex.GI_Guarding, GetGoal( EGoalIndex.GI_Intermediate ) );
	   		}
		}
		else if( GetGoal( EGoalIndex.GI_Intermediate ).IsGoalA( Self, 'SealAltar' ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate goal is a valid SealAltar", 'Captain' );
			if( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSealAltar ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
					GetGoal( EGoalIndex.GI_Intermediate ), CurrentConstrainer ) )
			{
				//the goal is rangable
				class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSealAltar ].TI_TransitionerName, 'Captain' );
				CurrentGoalIdx = EGoalIndex.GI_Intermediate;
				CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToSealAltar ].TI_Transitioner );
				CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
				bTransitioned = true;
			}

		   	if( bTransitioned )
   			{
	   			class'WotUtil'.static.InvokeWotPawnFindLeader( Self ); //reliquish control of local grunts
			}
		}
	
		else
*/
		if( ( WorkingOrders == OT_SoundAlarm ) && GetGoal( EGoalIndex.GI_Intermediate ).IsGoalA( Self, 'Alarm' ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate goal is a valid Alarm", 'Captain' );
			//a alarm has been identified
			if( TransitionerInfos[ ETransitionerIndex.TI_SoundAlarm ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
					GetGoal( EGoalIndex.GI_Intermediate ), CurrentConstrainer ) )
			{
				//the identified alarm is rangable
				class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_SoundAlarm ].TI_TransitionerName, 'Captain' );
				CurrentGoalIdx = EGoalIndex.GI_Intermediate;
				CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_SoundAlarm ].TI_Transitioner );
				CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
				bTransitioned = true;
			}
		}
		else if( ( WorkingOrders == OT_GetHelp ) && GetGoal( EGoalIndex.GI_Intermediate ).IsGoalA( Self, 'WotPawn' ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate goal is a WotPawn", 'Captain' );
			//a helper has been identified
			if( TransitionerInfos[ ETransitionerIndex.TI_FindHelp ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
					GetGoal( EGoalIndex.GI_Intermediate ), CurrentConstrainer ) )
			{
				//the identified helper is rangable
				class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_FindHelp ].TI_TransitionerName, 'Captain' );
				CurrentGoalIdx = EGoalIndex.GI_Intermediate;
				CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_FindHelp ].TI_Transitioner );
				CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
				bTransitioned = true;
			}
		}
		else
		{
			bTransitioned = Super.GoalIndexTransitionIntermediate();
		}
	}
	else
	{
		bTransitioned = Super.GoalIndexTransitionIntermediate();
	}
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate returning " $ bTransitioned, 'Captain' );
	return 	bTransitioned;
}



//=============================================================================
//	Returning states
//=============================================================================



state () WaitingIdle
{
	function InitiateTrackingOperation()
	{
		ResetOrders();
		Super.InitiateTrackingOperation();
	}
}



//=============================================================================
//	NavigatingToGoal states
//=============================================================================



state SuccessfullyNavigatedToGoal
{
	function BeginState()
	{
   		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Seal' ) )
   		{
   			SuccessfullyNavigatedToSeal();
   		}
   		else if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'SealAltar' ) )
   		{
    		SuccessfullyNavigatedToSealAltar();
   		}
   		else
   		{
	    	Super.BeginState();
   		}
	}
	function SuccessfullyNavigatedToSeal() { GotoState( 'SealReached' ); }
	function SuccessfullyNavigatedToSealAltar() { GotoState( 'SealAltarReached' ); }
}



state SuccessfullyNavigatedToCaptain
{
	function PlayAnimSound()
	{
		switch( AnimSequence )
		{
			case ReportAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.AcceptOrdersSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
			default:
				Global.PlayAnimSound();
				break;
		}
	}

PrePerformTurn:
	class'Debug'.static.DebugLog( Self, "PrePerformTurn:", 'Captain' );
	AnimationTableClass.static.TweenPlaySlotAnim( Self, ReportAnimSlot );
	Goto( 'PerformTurn' );
}



//=============================================================================
//	SoundAlarm states
//=============================================================================



state SoundAlarm expands NavigatingToGoal
{
	function ThreatGoalInitialized();
}

state AlarmPathable expands SoundAlarm {}
state AlarmReachable expands SoundAlarm  {}

state SuccessfullyNavigatedToAlarmToSound expands SuccessfullyNavigatedToGoal
{
	function BeginState()
	{
		StopMovement();
		Super.BeginState();
	}

	function SuccessfullyNavigatedToAlarm()
	{
		class'Debug'.static.DebugLog( Self, "SuccessfullyNavigatedToAlarm", 'Captain' );
	}

	function SoundAlarm()
	{
		local Alarm AlarmToSound;
		local Actor GoalActor;
		local bool bSoundAlarm;
		
		class'Debug'.static.DebugLog( Self, "SoundAlarm", 'Captain' );
		if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && GoalActor.IsA( 'Alarm' ) )
		{
			AlarmToSound = Alarm( GoalActor );
			/*
			if( !GetGoal( EGoalIndex.GI_Threat ).GetLastVisibleLocation( Self, AlarmToSound.ThreatLocation ) )
			{
				AlarmToSound.ThreatActor = None;
				bSoundAlarm = true;
			}
			else
			*/
			if( GetGoal( EGoalIndex.GI_Threat ).GetGoalActor( Self, AlarmToSound.ThreatActor ) )
			{
				AlarmToSound.ThreatLocation = Vect( 0, 0, 0 );;
				bSoundAlarm = true;
			}
			else if( GetGoal( EGoalIndex.GI_Threat ).GetGoalLocation( Self, AlarmToSound.ThreatLocation ) )
			{
				AlarmToSound.ThreatActor = None;
				bSoundAlarm = true;
			}

			if( bSoundAlarm )
		    {
			    //Prep the alarm
    		    AlarmToSound.ActivateAlarm( Self );
			}
		}
	}

	function AlarmSounded( Alarm NotifyingAlarm )
	{
		class'Debug'.static.DebugLog( Self, "AlarmSounded NotifyingAlarm: " $ NotifyingAlarm, 'Captain' );
	    InvalidateGoal( CurrentGoalIdx );
		WorkingOrders = OT_KillIntruder;
	}
	
PerformInactivity:
	AnimationTableClass.static.TweenPlaySlotAnim( Self, GongAnimSlot );
    FinishAnim();
	SoundAlarm();
	goto 'PostPerformInactivity';
}

state AlarmUnNavigable expands SuccessfullyNavigatedToAlarmToSound
{
	function InitiateTrackingOperation() { PostTrackGoal(); }
}



//=============================================================================
//	NavigatingToHelp states
//=============================================================================

state NavigatingToHelp expands NavigatingToGoal
{
	function ThreatGoalInitialized();
}

state HelpPathable expands NavigatingToHelp {}
state HelpReachable expands NavigatingToHelp {}

state HelpReached expands NavigatingToHelp
{
	function GetPriorityGoalIndex( out EGoalIndex PriorityGoalIndex )
	{
		if( !class'WotUtil'.static.GetNextAvailableWotPawn( Self, GetGoal( EGoalIndex.GI_Intermediate ), ReinforcementsSorter ) )
		{
        	WorkingOrders = OT_KillIntruder;
		}
		Super.GetPriorityGoalIndex( PriorityGoalIndex );
	}

	//see comments for Global version
	function PlayAnimSound()
	{
		switch( AnimSequence )
		{
			case GiveOrdersAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.GiveOrdersSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
			default:
				Global.PlayAnimSound();
				break;
		}
	}
	
	//Alert all alertable WotPawns within the given radius
	function AlertVisibleWotPawns()
	{
    	local WOTPawn CurrentWotPawn;
    	foreach RadiusActors( class'WOTPawn', CurrentWotPawn, CollisionRadius + AlertVisibleWotPawnsRadius )
	    {
    	    if( ( CurrentWotPawn != Self ) && CurrentWotPawn.CanBeGivenNewOrders() && LineOfSightTo( CurrentWotPawn ) )
        	{
	            CurrentWotPawn.AlertedByCaptain( Self );
        	}
	    }
	}

PerformInactivity:
	AlertVisibleWotPawns();
	AnimationTableClass.static.TweenPlaySlotAnim( Self, GiveOrdersAnimSlot );
    FinishAnim();
	goto 'PostPerformInactivity';
}



//=============================================================================
//	NavigatingToSeal states
//=============================================================================

state NavigatingToSeal expands NavigatingToGoal
{
	function AlarmSounded( Alarm NotifyingAlarm );
    function AlertedByCaptain( Captain AlertingCaptain );
}

state SealReachable expands NavigatingToSeal {}
state SealPathable expands NavigatingToSeal {}

state SealReached expands NavigatingToSeal
{
	function InitiateTrackingOperation()
	{
	    class'WotUtil'.static.InvokeWotPawnFindLeader( Self );
		Super.InitiateTrackingOperation();
	}
}

state SealUnNavigable expands SealReached
{
	function InitiateTrackingOperation()
	{
	   	ChangeOrders( OT_KillIntruder );
		PostTrackGoal();
    }
}


/*
//=============================================================================
//	NavigatingToSealAltar states
//=============================================================================

state NavigatingToSealAltar expands NavigatingToGoal
{
	function AlarmSounded( Alarm NotifyingAlarm );
    function AlertedByCaptain( Captain AlertingCaptain );
}

state SealAltarPathable expands NavigatingToSealAltar {}
state SealAltarReachable expands NavigatingToSealAltar {}
state SealAltarReached expands SealAltarReachable {}
state SealAltarUnNavigable expands SealAltarReached {}
*/

defaultproperties
{
     AlarmSearchRadius=400.000000
     AlertVisibleWotPawnsRadius=160.000000
     FindHelpRadius=320.000000
     LeadershipRadius=240.000000
     AssignedOrders=OT_KillIntruder
     DebugCategoryName=Captain
     HandlerFactoryClass=Class'WOT.RangeHandlerFactoryCaptain'
     TransitionerInfos(9)=(TI_bConstruct=True)
     TransitionerInfos(10)=(TI_bConstruct=True)
     TransitionerInfos(11)=(TI_bConstruct=True)
     TransitionerInfos(12)=(TI_bConstruct=True)
}
