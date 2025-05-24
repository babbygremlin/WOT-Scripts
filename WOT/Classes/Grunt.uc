//=============================================================================
// Grunt.
// $Author: Mfox $
// $Date: 1/09/00 4:49p $
// $Revision: 60 $
//=============================================================================

class Grunt expands WOTPawn abstract;

/*=============================================================================
  Design Goals for Weapon Selection

  Grunt and Grunt-derived classes may have a melee weapon and/or ranged weapon
  and any of these could be None (e.g. if the creature doesn't use a weapon for
  that attack). Set the MeleeWeaponType and/or RangedWeaponType (captains only)
  appropriately and the weapon selection code should handle the rest. Unlike
  some Unreal I Pawns, WOT creatures may peform a melee/ranged attack without 
  having an explicit melee/ranged weapon. For example, the Trolloc has his 
  melee weapon as part of his mesh while the Warder's was detached for some 
  reason, and needs to be correctly assigned by setting MeleeWeaponType to
  WarderSword. The BATrolloc uses his halberd for both melee and ranged attacks
  and the Archer has a melee weapon but his ranged weapon (bow) is part of his
  mesh. These examples are merely intended to illustrate the kinds of 
  situations which the weapon selection code must handle.

  If DefaultWeaponType is set to a valid weapon class (one of the melee or, 
  this weapon will be assigned to the creature when it is created (with no
  selection animations used).

  WOT NPCs may also optionally have an animation associated with the selection
  or de-selection of a weapon. This is still work in progress but it seems 
  likely that these will be specified through the Pawn's properties and will
  consist of 4 animations for putting away/taking out melee/ranged weapons.

  If an animation *is* used, it is expected that the weapon switch will be
  driven by a notification function, called at the time (0.00-1.00) at which
  the weapon should be switched. Add a line like

  #exec MESH NOTIFY MESH=Myrddraal SEQ=SwitchM TIME=0.8  FUNCTION=WeaponSwitchAnimNotification

  to the NPC's .uc file (in this case when the SwitchM animation is called, the
  function WeaponSwitchAnimNotification will be called 80% of the way through
  the animation. Getting the exact TIME right can take some trial and error.
  Also, obviously the name of the actual animation (i.e. it might not be
  SwitchM has to be used.

  WARNING: if TIME=0.95 or greater, it seems the notification may never be 
  sent. For now this doesn't seem to be a problem because TIME never needs
  to be this great.

  If there is no animation associated with putting down or taking out a
  weapon, the switch is done immediately after entering the state respondible
  for managing the weapon (e.g. the PrepareMeleeWeapon/PrepareProjectileWeapon
  states).

=============================================================================*/

var () int BrokenMoralePct;			//(0-100) When Health drops below this percentage of original value, Grunt runs away    
//rlofuture var() int RecoverMoralePct;			//(0-100) if broken morale, captain recovers when heals up to this much Health
var () float CowerRadius;			//Grunt will cower when Waiting + master is this close
var () int   WalkSpeedPct; 			//(0-100) the percentage of speed below which the grunt will play the walking animation instead of the running animation
var () float BaseWalkingSpeed;		//NPC's base walking speed for scaling his walk animation
var () float SeeEnemySoundOdds;		//odds that SeeEnemy sound will be played
var () Name InitThreatGoalEvent;
var () Name DefensivePerimiterCompromisedEvent;
var () float ProjectileAlertRadius;
var () float FaceActorSourceMoveDistance;
var () Name TakeDamageEvent;
var () bool bTakeDamageEventOnce;
var () float TakeDamageMoveDistance;
var () int MoveFromTakeDamageThreshold;	//Inflicted damage amount (on self) required to initiate movement from damage area
var () float MinTimeBetweenAcquiredSounds;
var () float MinTimeAfterInitialAcquisitionSound;
var (WOTWeapons) class<WotWeapon>   DefaultWeaponType;
var (WOTWeapons) class<WotWeapon>   MeleeWeaponType;	//class of melee weapon
var (WOTWeapons) class<WotWeapon>   RangedWeaponType;	//class of ranged weapon
var bool bCowering;
var float NextAcquiredSoundTime;
var float NextPlayAnimSoundTime;
var Name NextAnimation;

var () bool bPreferAcquiredVisibilityHandler;
var () float FlipPreferAcquiredVisibilityHandlerOdds;
var () bool bAutomaticWeaponSelection;
var bool bForceProjectileWeaponSelection;
var bool bForceMeleeWeaponSelection;

const FriendlyBumpMoveDistance = 160;
const HintName_SwitchProjectileWeapon = 'SwitchProjectile';
const HintName_SwitchMeleeWeapon = 'SwitchMelee';
const HintName_PreferProjectileWeapon = 'PreferProjectile';
const HintName_PreferMeleeWeapon = 'PreferMelee';

//grunt anims:
const ListenAnimSlot    			= 'Listen';
const MeleeAttackAnimSlot			= 'MeleeAttack';      
const MeleeWeaponAttackAnimSlot		= 'MeleeWeaponAttack';      
const ProjectileAttackAnimSlot		= 'ProjectileAttack';
const SearchAnimSlot				= 'Search';
const SeeEnemyAnimSlot				= 'SeeEnemy';
const ShowRespectAnimSlot			= 'ShowRespect';
const ShowRespectLoopAnimSlot		= 'ShowRespectLoop';
const WeaponPutAwayMeleeAnimSlot	= 'WeaponPutAwayMelee';
const WeaponPutAwayRangedAnimSlot	= 'WeaponPutAwayRanged';
const WeaponTakeOutMeleeAnimSlot	= 'WeaponTakeOutMelee';
const WeaponTakeOutRangedAnimSlot	= 'WeaponTakeOutRanged';
const DodgeLeftAnimSlot    			= 'DodgeLeft';
const DodgeRightAnimSlot    		= 'DodgeRight';

const ShowRespectAnim				= 'ReactP';
const ShowRespectLoopAnim			= 'ReactPLoop';


// jc: (Most) Grunts can swim
function PreSetMovement()
{
	Super.PresetMovement();
	
	if( buoyancy > 0 )
	{
		bCanSwim = true;
	}
}



/*=============================================================================
PlayAnimSound:

Some NPC animations use this function through a notification callback to play
a sound based on the currently playing animation. NPCs should implement a 
single notification function either using this function directly, or a derived
version which can call this function as needed.


This must be done for every animation which the NPC uses which needs to be 
handled here. Note that if you want sounds to be played right at the start of 
an animation, use TIME=0.01 -- TIME=0.00 doesn't seem to work. Also, state-
specific sounds should be implemented in state-specific notification functions 
rather than using GetStateName() to identify which state an animation is being 
used in.
=============================================================================*/

function PlayAnimSound()
{
	class'Debug'.static.DebugLog( Self, Class $ ":PlayAnimSound", class'Debug'.default.DC_Sound );

	if( Level.TimeSeconds >= NextPlayAnimSoundTime )
	{
		switch( AnimSequence )
		{
			case BreathAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.BreathSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
	
			case ListenAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.AcceptOrdersSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
	
			case LookAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.LookSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
	
			case SeeEnemyAnimSlot:
	   			MySoundTable.PlaySlotSound( Self, MySoundTable.SeeEnemySoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
	
			case ShowRespectAnim:
			case ShowRespectLoopAnim:
				MySoundTable.PlaySlotSound( Self, MySoundTable.ShowRespectSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
	
			default:
				class'Debug'.static.DebugWarn( Self, "PlayAnimSound no sound available for " $ Class $ ", " $ AnimSequence, class'Debug'.default.DC_Sound );
		}
	}
}



//=============================================================================
// begin - animation and sound functions
//=============================================================================



function LoopMovementAnim( float IntendedMovementSpeed )
{
	local float WalkSpeedThreshold;
	class'Debug'.static.DebugLog( Self, "LoopMovementAnim", DebugCategoryName );

	WalkSpeedThreshold = WalkSpeedPct/100.0*(default.GroundSpeed - default.BaseWalkingSpeed) + default.BaseWalkingSpeed;
	
	class'Debug'.static.DebugLog( Self, "LoopMovementAnim IntendedMovementSpeed " $ IntendedMovementSpeed, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "LoopMovementAnim WalkSpeedThreshold " $ WalkSpeedThreshold, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "LoopMovementAnim CurrentGoalIdx " $ CurrentGoalIdx, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "LoopMovementAnim GoalSuggestedSpeed " $ GetGoal( CurrentGoalIdx ).GetSuggestedSpeed( Self ), DebugCategoryName );
	
	if( IntendedMovementSpeed <= WalkSpeedThreshold )
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, WalkAnimSlot, IntendedMovementSpeed/default.BaseWalkingSpeed );
	}
	else
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, RunAnimSlot, IntendedMovementSpeed/default.GroundSpeed );
	}
}



function PerformDefensiveDodge( Vector DodgeDestination )
{
	local Vector DodgeDirection;
	DodgeDirection = Normal( DodgeDestination - Location ) >> Rotation;
	if( DodgeDirection.Y < 0 )
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, DodgeLeftAnimSlot );
	}
	else if( DodgeDirection.Y > 0 )
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, DodgeRightAnimSlot );
	}
	Super.PerformDefensiveDodge( DodgeDestination );
}

//=============================================================================
// end - animation and sound functions
//=============================================================================



function HandleHint( Name Hint )
{
	class'Debug'.static.DebugLog( Self, "HandleHint Hint " $ Hint, DebugCategoryName );
	switch( Hint )
	{
		case HintName_SwitchProjectileWeapon:
			bForceProjectileWeaponSelection = true;
			bForceMeleeWeaponSelection = false;
			SwitchToBestWeapon();
			break;
		case HintName_SwitchMeleeWeapon:
			bForceProjectileWeaponSelection = false;
			bForceMeleeWeaponSelection = true;
			SwitchToBestWeapon();
			break;
		case HintName_PreferProjectileWeapon:
			bPreferAcquiredVisibilityHandler = true;
			break;
		case HintName_PreferMeleeWeapon:
			bPreferAcquiredVisibilityHandler = false;
			break;
		default:
			Super.HandleHint( Hint );
			break;
	}
}



function BeginStatePrepareNotifiers()
{
	Super.BeginStatePrepareNotifiers();
	if( !DurationNotifiers[ EDurationNotifierIndex.DNI_Misc1 ].bEnabled )
	{
		DurationNotifiers[ EDurationNotifierIndex.DNI_Misc1 ].EnableNotifier();
	}
}



//=============================================================================
// begin - global state transition functions
//=============================================================================



function bool GoalIndexTransitionThreat()
{
	local bool bTransitioned;
	if( IsHealthy() )
	{
		bTransitioned = GoalIndexTransitionThreatWhileHealthy();
	}
	else
	{
		bTransitioned = GoalIndexTransitionThreatWhileUnhealthy();
	}
	return bTransitioned;
}



function bool GoalIndexTransitionThreatWhileHealthy()
{
	local bool bTransitioned;
	local Actor GoalActor;

	if( GetGoal( EGoalIndex.GI_Threat ).GetGoalActor( Self, GoalActor ) )
	{
		if( IsFriendly( GoalActor ) )
		{
			//xxxrlo
			//threat is friendly
		}
		else
		{
			bTransitioned = GoalIndexTransitionThreatWhileHealthyUnFriendlyActor( GoalActor );
   		}
	}
   	else
   	{
		bTransitioned = GoalIndexTransitionThreatWhileHealthyLocation();
   	}
	return bTransitioned;
}



function bool GoalIndexTransitionThreatWhileHealthyUnFriendlyActor( Actor GoalActor )
{
	local RangeHandler SelectedHandler;
	local bool bTransitioned;

	if( GetGoal( EGoalIndex.GI_Threat ).IsGoalVisible( Self ) )
	{
		class'Debug'.static.DebugLog( Self,  "GoalIndexTransitionThreatWhileHealthyUnFriendlyActor TransitionToAcquired", DebugCategoryName );
		if( SelectAcquiredGoalHandler( SelectedHandler, GetGoal( EGoalIndex.GI_Threat ) ) )
		{
			CurrentGoalIdx = EGoalIndex.GI_Threat;
			CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Acquired ].TI_Transitioner );
			CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
			bTransitioned = true;
		}
  	}
   	else
	{
		class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyUnFriendlyActor TransitionToSearching", DebugCategoryName );
		if( TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner.SelectHandler( SelectedHandler, Self, GetGoal( EGoalIndex.GI_Threat ), CurrentConstrainer ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyUnFriendlyActor TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_TransitionerName, DebugCategoryName );
			CurrentGoalIdx = EGoalIndex.GI_Threat;
			CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner );
			CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
			bTransitioned = true;
		}
	}
	return bTransitioned;
}



function bool GoalIndexTransitionThreatWhileHealthyLocation()
{
	local RangeHandler SelectedHandler;
	local bool bTransitioned;

	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyLocation TransitionToInvestigating", DebugCategoryName );
	if( TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_Transitioner.SelectHandler( SelectedHandler, Self, GetGoal( EGoalIndex.GI_Threat ), CurrentConstrainer ) )
	{
		class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyLocation TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_TransitionerName, DebugCategoryName );
		CurrentGoalIdx = EGoalIndex.GI_Threat;
		CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_Transitioner );
		CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
		bTransitioned = true;
	}
	else
	{
		class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyLocation TransitionToInvestigating the current goal can not be investigated", DebugCategoryName );
		class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyLocation TransitionToInvestigating can't transition to investigating", DebugCategoryName );

		if( TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner.SelectHandler( SelectedHandler, Self, GetGoal( EGoalIndex.GI_Threat ), CurrentConstrainer ) )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileHealthyLocation TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_TransitionerName, DebugCategoryName );
			CurrentGoalIdx = EGoalIndex.GI_Threat;
			CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner );
			CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
			bTransitioned = true;
		}
	}
	return bTransitioned;
}



function bool GoalIndexTransitionThreatWhileUnhealthy()
{
	local bool bTransitioned;
	
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileUnhealthy", DebugCategoryName );
	if( GetGoal( EGoalIndex.GI_Threat ).IsVisibleByGoal( Self ) )
	{
		if( GoalPriorities[ EGoalIndex.GI_Refuge ] > GetGoal( EGoalIndex.GI_Threat ).GetGoalPriority( Self ) )
		{
			if(	FindBestGruntAvoidGoalPathGoal( GetGoal( EGoalIndex.GI_Refuge ), Self, GetGoal( EGoalIndex.GI_Threat ) ) )
			{
				if( GetGoal( EGoalIndex.GI_Refuge ).GetGoalPriority( Self ) > GetGoal( EGoalIndex.GI_Threat ).GetGoalPriority( Self ) )
				{
					bTransitioned = GoalIndexTransitionRefuge();
				}
			}
		}
		if( !bTransitioned )
		{
			class'Debug'.static.DebugLog( Self, "GoalIndexTransitionThreatWhileUnhealthy can't transition to SeekRefuge", DebugCategoryName );
			bTransitioned = GoalIndexTransitionThreatWhileHealthy();
		}
	}
	return bTransitioned;
}



function bool GoalIndexTransitionGuarding()
{
	local float GuardingToWaitingDistance;
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionGuarding TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_Returning ].TI_TransitionerName, DebugCategoryName );
	if( GetGoal( EGoalIndex.GI_Guarding ).GetGoalDistance( Self, GuardingToWaitingDistance, GetGoal( EGoalIndex.GI_Waiting ) ) )
	{
		if( GuardingToWaitingDistance > GoalPriorityDistances[ EGoalIndex.GI_Guarding ] )
		{
			//the distance between the guarding goal and the waiting goal is greater than the guarding goal priority distance
			InvalidateGoal( EGoalIndex.GI_Waiting );
		}
	}
	CurrentGoalIdx = EGoalIndex.GI_Guarding;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_Returning ].TI_Transitioner );
	return CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
}



function bool GoalIndexTransitionRefuge()
{
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionRefuge", DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionRefuge TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_SeekRefuge ].TI_TransitionerName, DebugCategoryName );
	CurrentGoalIdx = GI_Refuge;
	CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_SeekRefuge ].TI_Transitioner );
	return CurrentRangeIterator.TransitionToNextHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer );
}



function bool GoalIndexTransitionIntermediate()
{
	local RangeHandler SelectedHandler;
	local bool bTransitioned;
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate", DebugCategoryName );
	if( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToGoal ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
			GetGoal( EGoalIndex.GI_Intermediate ), CurrentConstrainer ) )
	{
		//the identified helper is rangable
		class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate TI_TransitionerName " $ TransitionerInfos[ ETransitionerIndex.TI_NavigatingToGoal ].TI_TransitionerName, DebugCategoryName );
		CurrentGoalIdx = EGoalIndex.GI_Intermediate;
		CurrentRangeIterator.BindRangeTransitioner( TransitionerInfos[ ETransitionerIndex.TI_NavigatingToGoal ].TI_Transitioner );
		CurrentRangeIterator.TransitionToHandler( Self, GetGoal( CurrentGoalIdx ), CurrentConstrainer, SelectedHandler );
		bTransitioned = true;
	}
	class'Debug'.static.DebugLog( Self, "GoalIndexTransitionIntermediate returning " $ bTransitioned, DebugCategoryName );
	return 	bTransitioned;
}



function bool SelectAcquiredGoalHandler( out RangeHandler SelectedHandler, GoalAbstracterInterf Goal )
{
	local bool bSelected;
	class'Debug'.static.DebugLog( Self, "SelectAcquiredGoalHandler bPreferAcquiredVisibilityHandler " $ bPreferAcquiredVisibilityHandler, DebugCategoryName );
	if( bPreferAcquiredVisibilityHandler &&
			TransitionerInfos[ ETransitionerIndex.TI_Acquired ].TI_Transitioner.GetGoalProximityHandler( SelectedHandler, GP_Visible, Self ) &&
			SelectedHandler.IsValidAsNextRange( Self, CurrentConstrainer, Goal ) )
	{
		class'Debug'.static.DebugLog( Self, "SelectAcquiredGoalHandler selected the visible handler from acquired", DebugCategoryName );
		bSelected = true;
	}
	else if( TransitionerInfos[ ETransitionerIndex.TI_Acquired ].TI_Transitioner.SelectHandler( SelectedHandler, Self, Goal, CurrentConstrainer ) )
	{
		class'Debug'.static.DebugLog( Self, "SelectAcquiredGoalHandler selected any acquired handler", DebugCategoryName );
		bSelected = true;
	}
	class'Debug'.static.DebugLog( Self, "SelectAcquiredGoalHandler returning " $ bSelected, DebugCategoryName );
	return bSelected;
}



/*
//xxxprio
function bool SelectSearchingGoalHandler( out RangeTransitioner SelectedTransitioner,
		out RangeHandler SelectedHandler,
		GoalAbstracterInterf Goal )
{
	local bool bSelected;
	class'Debug'.static.DebugLog( Self, "SelectSearchingGoalHandler", DebugCategoryName );
	if( CurrentRangeIterator.CurrentTransitioner == TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner )
	{
		class'Debug'.static.DebugLog( Self, "SelectSearchingGoalHandler in seaching", DebugCategoryName );
		SelectedTransitioner = CurrentRangeIterator.CurrentTransitioner;
		SelectedHandler = CurrentRangeIterator.CurrentHandler;
		bSelected = true;
	}
	else if( TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
			GetGoal( EGoalIndex.GI_Threat ), CurrentConstrainer ) )
	{
		class'Debug'.static.DebugLog( Self, "SelectSearchingGoalHandler selected seaching handler", DebugCategoryName );
		SelectedTransitioner = TransitionerInfos[ ETransitionerIndex.TI_Searching ].TI_Transitioner;
		bSelected = true;
	}
	class'Debug'.static.DebugLog( Self, "SelectSearchingGoalHandler returning " $ bSelected, DebugCategoryName );
	return bSelected;
}



function bool SelectInvestigatingGoalHandler( out RangeTransitioner SelectedTransitioner,
		out RangeHandler SelectedHandler,
		GoalAbstracterInterf Goal )
{
	local bool bSelected;
	if( CurrentRangeIterator.CurrentTransitioner == TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_Transitioner )
	{
		//the grunt is already investigating
		SelectedTransitioner = CurrentRangeIterator.CurrentTransitioner;
		SelectedHandler = CurrentRangeIterator.CurrentHandler;
		bSelected = true;
	}
	else if( TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_Transitioner.SelectHandler( SelectedHandler, Self,
			GetGoal( EGoalIndex.GI_Threat ), CurrentConstrainer ) )
	{
		//attempt to select any investigating handler
		SelectedTransitioner = TransitionerInfos[ ETransitionerIndex.TI_Investigating ].TI_Transitioner;
		bSelected = true;
	}
	return bSelected;
}
*/


//=============================================================================
// begin - notifications that result in goal initialization
//=============================================================================



function OnHearNoise( float Loudness, Actor NoiseMaker )
{
	class'Debug'.static.DebugLog( Self, "OnHearNoise NoiseMaker: " $ NoiseMaker, DebugCategoryName );
	if( !NoiseMaker.bHidden )
	{
		if( IsFriendly( NoiseMaker ) )
		{
			if( NoiseMaker.IsA( 'Grunt' ) )
			{
		 		TransferThreatGoalsFrom( Grunt( NoiseMaker ) );
			}
		}
		else if( NoiseMaker.IsA( 'Pawn' ) )
		{
			SeeEnemyPawn( Pawn( NoiseMaker ) );
		}
	}
}



//Called by alarm when sounded by a Captain.
function AlarmSounded( Alarm NotifyingAlarm )
{
	class'Debug'.static.DebugLog( Self, "AlarmSounded NotifyingAlarm: " $ NotifyingAlarm, DebugCategoryName );
	if( CanBeGivenNewOrders() )
	{
		InitGoalWithObject( EGoalIndex.GI_Intermediate, NotifyingAlarm );
	}
}



function AlertedByCaptain( Captain AlertingCaptain )
{
	class'Debug'.static.DebugLog( Self, "AlertedByCaptain AlertingCaptain: " $ AlertingCaptain, DebugCategoryName );
	if( CanBeGivenNewOrders() )
	{
		InitGoalWithObject( EGoalIndex.GI_Intermediate, AlertingCaptain );
	}
}



function GoalInitialized( EGoalIndex GoalIdx )
{
	local Actor CurrentActor;
	Super.GoalInitialized( GoalIdx );
	if( ( GoalIdx == GI_Threat ) && ( InitThreatGoalEvent != '' ) )
	{
		foreach AllActors( class'Actor', CurrentActor, InitThreatGoalEvent )
		{
			CurrentActor.Trigger( Self, Self );
		}
	}
}



function DefensivePerimiterCompromised( DefensiveDetector DefensiveNotification )
{
	local Actor CurrentActor;
	if( DefensivePerimiterCompromisedEvent != '' )
	{
		foreach AllActors( class'Actor', CurrentActor, DefensivePerimiterCompromisedEvent )
		{
			CurrentActor.Trigger( Self, Self );
		}
	}

	if( IcykHackTestsForDefensivePerimiterCompromised() )
	{
		if( ( Projectile( DefensiveNotification.GetOffender() ) != None ) &&
				( VSize( DefensiveNotification.GetOffender().Location - Location ) < ( CollisionRadius + ProjectileAlertRadius ) ) )
		{
			FaceActorSource( DefensiveNotification.GetOffender() );
		}
	}

	Super.DefensivePerimiterCompromised( DefensiveNotification );
}



function bool IcykHackTestsForDefensivePerimiterCompromised()
{
	local float GoalSuggestedSpeed;
	if( GetGoal( EGoalIndex.GI_Threat ).IsValid( Self ) )
	{
		return false;
	}
	else if( GetGoal( EGoalIndex.GI_Intermediate ) == None )
	{
		return false;
	}
	else if( GetGoal( EGoalIndex.GI_ExternalDirective ) == None )
	{
		return true;
	}
	else if( !GetGoal( EGoalIndex.GI_ExternalDirective ).IsValid( Self ) )
	{
		return true;
	}
	else
	{
		GoalSuggestedSpeed = GetGoal( EGoalIndex.GI_ExternalDirective ).GetSuggestedSpeed( Self );
		if( GoalSuggestedSpeed >= BaseWalkingSpeed )
		{
			//if the npc is running toward external directive goal it must be important?
			return false;
		}
		else
		{
			return true;
		}
	}
}


function DefensivePerimiterCompromisedByOffender( DefensiveDetector DefensiveNotification )
{
	local Actor Offender;
	Offender = DefensiveNotification.GetOffender();
	if( Offender.IsA( 'Projectile' ) )
	{
		if( ( Offender.Instigator != None ) && CanSee( Offender.Instigator ) )
		{
			if( Offender.Instigator.bIsPlayer )
			{
				SeePlayer( Offender.Instigator );
			}
			else
			{
				SeePawn( Offender.Instigator );
			}
		}
	}
	Super.DefensivePerimiterCompromisedByOffender( DefensiveNotification );
}



function FaceActorSource( Actor SourceActor )
{
	MoveAwayFromAreaDirected( FaceActorSourceMoveDistance, Rotator( SourceActor.Location - Location ) );
}



function Bump( Actor Other )
{
	local Pawn OtherPawn;
	local Rotator MoveRotation;
	local float MoveDistance, ThisSpeed;

	OtherPawn = Pawn( Other );
	class'Debug'.static.DebugLog( Self, "Bump", DebugCategoryName );
	if( OtherPawn != None )
	{
		if( IsFriendly( OtherPawn ) )
		{
			if( OtherPawn.bIsPlayer  )
			{
				if( VSize( OtherPawn.Velocity ) != 0 )
				{
					class'Debug'.static.DebugLog( Self, "Bumped by a friendly player", DebugCategoryName );
					MoveRotation = OtherPawn.Rotation;
					MoveDistance = FriendlyBumpMoveDistance;
				}
			}
			else
			{
				class'Debug'.static.DebugLog( Self, "Bumped by a friendly npc", DebugCategoryName );
				MoveRotation = Rotator( OtherPawn.Velocity );
				MoveDistance = CollisionRadius;
				ThisSpeed = VSize( Velocity );
				if( ThisSpeed == 0 )
				{
					//slower trafic goes to the right
					MoveRotation.Yaw += Rotation.Yaw - 65536 / 4;
				}
				if( ThisSpeed >= VSize( OtherPawn.Velocity ) )
				{
					//faster trafic goes to the left
					MoveRotation.Yaw -= Rotation.Yaw - 65536 / 8;
					return;
				}
				else
				{
					//slower trafic goes to the right
					MoveRotation.Yaw += Rotation.Yaw - 65536 / 8;
					return;
				}
			}
			if( MoveDistance != 0 )
			{
				MoveAwayFromAreaDirected( MoveDistance, MoveRotation );
			}
		}
	}
	Super.Bump( Other );
}



//Called by engine when grunt takes damage.
function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Name DamageType )
{
	local Actor CurrentActor;
	class'Debug'.static.DebugLog( Self, "TakeDamage begin", DebugCategoryName );
	if( TakeDamageEvent != '' )
	{
		foreach AllActors( class'Actor', CurrentActor, TakeDamageEvent )
		{
			CurrentActor.Trigger( Self, Self );
		}
		if( bTakeDamageEventOnce )
		{
			TakeDamageEvent = '';
		}
	}
	
	if( InstigatedBy != None )
	{
		if( InstigatedBy.bIsPlayer )
		{
			SeePlayer( InstigatedBy );
		}
		else
		{
			SeePawn( InstigatedBy );
		}
	}
	
	if( IsFriendly( InstigatedBy ) )
	{
		//took friendly fire
		MoveAwayFromAreaDirected( FriendlyBumpMoveDistance, Rotation );
	}
	else if( ( MoveFromTakeDamageThreshold != -1 ) && ( Damage >= MoveFromTakeDamageThreshold ) )
	{
		MoveAwayFromTakeDamageArea();
	}
    
	//this call might cause:
    //- state to detour through TakeHit (indirectly, via WOTPawn::PlayHit())
    //- physics to become PHYS_Falling
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	class'Debug'.static.DebugLog( Self, "TakeDamage end", DebugCategoryName );
}



function MoveAwayFromTakeDamageArea()
{
	MoveAwayFromAreaDirected( TakeDamageMoveDistance, Rotation );
}



function Trigger( Actor Other, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "Trigger Other " $ Other, class'Debug'.default.DC_EngineNotification );
	Super.Trigger( Other, EventInstigator );
	if( Other.IsA( 'Alarm' ) )
	{
		class'Debug'.static.DebugLog( Self, "Trigger Calling alarm sounded", class'Debug'.default.DC_EngineNotification );
		AlarmSounded( Alarm( Other ) );
	}
	else if( Other.IsA( 'WotWeapon' ) )
	{
		if( Other.Event == WotWeapon( Other ).DestroyedEvent )
		{
			OnWotWeaponDestroyed( WotWeapon( Other ) );
		}
	}
}



//=============================================================================
// end - notifications that result in goal initialization
//=============================================================================



function bool CanBeGivenNewOrders()
{
	local bool bIsOccupied;
    bIsOccupied = GetGoal( EGoalIndex.GI_Threat ).IsValid( Self ) || 
			GetGoal( EGoalIndex.GI_Guarding ).IsValid( Self ) ||
    		GetGoal( EGoalIndex.GI_Intermediate ).IsValid( Self ) ||
    		GetGoal( EGoalIndex.GI_Refuge ).IsValid( Self );
    class'Debug'.static.DebugLog( Self, "CanBeGivenNewOrders returning " $ !bIsOccupied, DebugCategoryName );
    return !bIsOccupied;
}


//=============================================================================
// begin - global state transition functions
//=============================================================================



function TransitionToFalling()
{
    class'Debug'.static.DebugLog( Self, "TransitionToFalling", DebugCategoryName );
    GetNextStateAndLabelForReturn( NextState, NextLabel );
    GotoState( 'FallingState' );
}



//=============================================================================
// begin - global state transition functions
//=============================================================================



static final function bool FindBestGruntAvoidGoalPathGoal( GoalAbstracterInterf PathGoal,
		Grunt SearchingGrunt, GoalAbstracterInterf AvoidGoal )
{
	local bool bFoundPathGoal;
    local Actor GoalActor;
		
	class'Debug'.static.DebugLog( SearchingGrunt, "FindBestGruntAvoidGoalPathGoal", default.DebugCategoryName );
/*
//xxxrlo
    if( AvoidGoal.GetGoalActor( SearchingGrunt, GoalActor ) && SearchingGrunt.IsFriendly( GoalActor ) )
   	{
    	//If avoiding a friendly player just get out of there
		class'Debug'.static.DebugLog( SearchingGrunt, "FindBestGruntAvoidGoalPathGoalavoiding a friendly", default.DebugCategoryName );
		bFoundPathGoal = AvoidGoal.Context( SearchingGrunt ).FindFirstNavigablePathGoal( PathGoal );
    }
   	else
    {
		class'Debug'.static.DebugLog( SearchingGrunt, "FindBestGruntAvoidGoalPathGoal avoiding an unfriendly", default.DebugCategoryName );
		bFoundPathGoal = AvoidGoal.Context( SearchingGrunt ).FindFirstNavigableAvoidGoalPathGoal( PathGoal );
	}
*/	
	class'Debug'.static.DebugLog( SearchingGrunt, "FindBestGruntAvoidGoalPathGoal returning " $ bFoundPathGoal, default.DebugCategoryName );
	return bFoundPathGoal;
}



//=============================================================================
// end - global state transition functions
//=============================================================================



function bool IsHealthy()
{
	local float HealthThreshold;
	//xxxrlo
	return true;
	HealthThreshold = BrokenMoralePct * Default.Health / 100;
	class'Debug'.static.DebugLog( Self, "IsHealthy Health " $ Health, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "IsHealthy HealthThreshold " $ HealthThreshold, DebugCategoryName );
	return ( Health > HealthThreshold );
}



//=============================================================================
// begin - unreal engine function overrides
//=============================================================================



function PostBeginPlay()
{
	Super.PostBeginPlay();
    FindLeader();
}



function Falling()
{
    TransitionToFalling();
}



// jc: Added so Grunts can swim
function ZoneChange( ZoneInfo NewZone )
{
	local vector JumpDir;

	if( NewZone.bWaterZone )
	{
		if( Physics != PHYS_Swimming && bCanSwim )
		{
			if( Physics != PHYS_Falling )
			{
				PlayDive(); 
			}
			SetPhysics( PHYS_Swimming );
		}
		//Need a check for !bCanSwim to establish behavior for Grunts who can't swim?
	}
	else if( Physics == PHYS_Swimming )
	{
		SetPhysics( PHYS_Falling );
		if( bCanWalk && ( Abs( Acceleration.X ) + Abs( Acceleration.Y ) > 0 ) && CheckWaterJump( JumpDir ) )
		{
			JumpOutOfWater( JumpDir );
		}
	}
}



function JumpOutOfWater( vector JumpDir )
{
	Falling();
	Velocity = JumpDir * WaterSpeed;
	Acceleration = JumpDir * AccelRate;
	Velocity.Z = 380; //set here so physics uses this for remainder of tick
	PlayOutOfWater();
	bUpAndOut = true;
}



function PlayHit( float Damage, vector HitLocation, name damageType, float MomentumZ )
{
    GetNextStateAndLabelForReturn( NextState, NextLabel );
	Super.PlayHit( Damage, HitLocation, damageType, MomentumZ );
}



function bool GetPendingMeleeWeapon( out Weapon NewPendingWeapon )
{
	local bool bGetPendingWeapon;
	//if using automatic attacks the acquired reachable state always uses the melee weapon
	//xxxrlo need to make a distinction between melee weapon attacks and melee attacks (body attacks)
	class'Debug'.static.DebugLog( Self, "GetPendingMeleeWeapon, MeleeWeaponType: " $ MeleeWeaponType, DebugCategoryName );
	if( MeleeWeaponType == None )
	{
		if( MeleeRange > 0 )
		{
			//this is kind of a hack to suport npcs that have melee attacks without an actual weapon
			NewPendingWeapon = None;
			bGetPendingWeapon = true;
		}
	}
	else
	{
		NewPendingWeapon = class'Util'.static.GetInventoryWeapon( Self, MeleeWeaponType );
		bGetPendingWeapon = ( NewPendingWeapon != None ); 
	}
	class'Debug'.static.DebugLog( Self, "GetPendingMeleeWeapon returning " $ bGetPendingWeapon, DebugCategoryName );
	return bGetPendingWeapon;
}



function bool GetPendingWeapon( out Weapon NewPendingWeapon )
{
	local bool bGetPendingWeapon;
	class'Debug'.static.DebugLog( Self, "GetPendingWeapon", DebugCategoryName );
	if( bForceMeleeWeaponSelection )
	{
		bGetPendingWeapon = GetPendingMeleeWeapon( NewPendingWeapon );
	}
	else if( bForceProjectileWeaponSelection )
	{
		NewPendingWeapon = class'Util'.static.GetInventoryWeapon( Self, RangedWeaponType );
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon, RangedWeaponType: " $ RangedWeaponType, DebugCategoryName );
		bGetPendingWeapon = ( NewPendingWeapon != None ); 
	}
	if( !bGetPendingWeapon )
	{
		bGetPendingWeapon = Super.GetPendingWeapon( NewPendingWeapon );
	}
	class'Debug'.static.DebugLog( Self, "GetPendingWeapon NewPendingWeapon " $ NewPendingWeapon, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "GetPendingWeapon returning " $ bGetPendingWeapon, DebugCategoryName );
	return bGetPendingWeapon;
}



//=============================================================================
// end - unreal engine function overrides
//=============================================================================



function OnWotWeaponDestroyed( WotWeapon DestroyedWeapon );



function bool ShouldPrepareInventoryItem( Inventory InventoryItem )
{
	return ( Super.ShouldPrepareInventoryItem( InventoryItem ) &&
			( ( InventoryItem.class == MeleeWeaponType ) ||
			( InventoryItem.class == RangedWeaponType ) ) );
}



function bool PrepareInventoryItem( Inventory InventoryItem )
{
	local bool bItemPrepared;

	class'Debug'.static.DebugLog( Self, "PrepareInventory", DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "PrepareInventory InventoryItem type " $ InventoryItem.class, DebugCategoryName );
	
	if( ShouldPrepareInventoryItem( InventoryItem ) )
	{
		if( InventoryItem.class == MeleeWeaponType )
		{
		    GetNextStateAndLabelForReturn( NextState, NextLabel );
			GotoState( 'PrepareMeleeWeapon' );
			bItemPrepared = true;
		}
		else if( InventoryItem.class == RangedWeaponType )
		{
		    GetNextStateAndLabelForReturn( NextState, NextLabel );
			GotoState( 'PrepareProjectileWeapon' );
			bItemPrepared = true;
		}
	}
	
	return bItemPrepared;
}



function AddDefaultInventoryItems()
{
	local Inventory AddedInventoryItem;
	
	Super.AddDefaultInventoryItems();
	class'Debug'.static.DebugLog( Self, "AddDefaultInventoryItems MeleeWeaponType " $ MeleeWeaponType, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "AddDefaultInventoryItems RangedWeaponType " $ RangedWeaponType, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "AddDefaultInventoryItems DefaultWeaponType " $ DefaultWeaponType, DebugCategoryName );

	//Add the MeleeWeaponType, if any, to the inventory.
    if( MeleeWeaponType != None )
    {
    	AddedInventoryItem = class'Util'.static.AddInventoryTypeToHolder( Self, MeleeWeaponType );
    	if( AddedInventoryItem != None )
    	{
	    	OnAddedDefaultInventoryItem( AddedInventoryItem );
    	}
    }
	//Add the RangeWeaponType, if any, to the inventory.
    if( RangedWeaponType != None )
    {
    	AddedInventoryItem = class'Util'.static.AddInventoryTypeToHolder( Self, RangedWeaponType );
    	if( AddedInventoryItem != None )
    	{
	    	OnAddedDefaultInventoryItem( AddedInventoryItem );
    	}
	}
}



//Support for having Grunt and Grunt-derived classes start out with a specific
//weapon (e.g. melee or ranged or other) initially. No animations involved --
//this just gloms in the weapon.

function OnAddedDefaultInventoryItem( Inventory AddedInventoryItem )
{
	class'Debug'.static.DebugLog( Self, "OnAddedDefaultInventoryItem", DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "OnAddedDefaultInventoryItem AddedInventoryItem " $ AddedInventoryItem, DebugCategoryName );

    if( AddedInventoryItem.Class == DefaultWeaponType )
    {
   		Weapon( AddedInventoryItem ).WeaponSet( Self );
	}
/* -- Now allows items to run out.  The artifact will give itself back to the Grunt after its NPCRespawnTime expires.
	if( AddedInventoryItem.IsA( 'AngrealInventory' ) )
	{
		//never runs out
		AngrealInventory( AddedInventoryItem ).ChargeCost = 0;
	}
*/
	class'Debug'.static.DebugLog( Self, "OnAddedDefaultInventoryItem", DebugCategoryName );
}



function Actor CanBeRemoved() //WOT-specific Actor override.  TBD:DPT: Move up to WOTPawn?
{
	return self;
}



//Called when Captain wants Grunt to figure out whether he's following
//a captain's lead or not.
function bool FindLeader()
{
	local Captain Leader;
	local bool bFindLeader;
	
    if( GetGoal( EGoalIndex.GI_Guarding ) != None )
	{
		bFindLeader = class'WotUtil'.static.GetLeader( Self, Leader );
		if( bFindLeader )
		{
			//If there's a captain in range, mimic his guarding characteristics
			InitGoalWithObject( EGoalIndex.GI_Guarding, Leader.GetGoal( EGoalIndex.GI_Guarding ) );
		}
		else
		{
			InvalidateGoal( EGoalIndex.GI_Guarding );
		}
	}

   return bFindLeader;
}



function EFactionType GetActorFaction( Actor OtherActor )
{
    local EFactionType OtherActorFaction;

    if( OtherActor != None )
	{
        if( IsFriendly( OtherActor ) )
		{
			OtherActorFaction = FT_Friendly;
		}
		else
		{
			OtherActorFaction = FT_Enemy;
		}
    }
	else
	{
		OtherActorFaction = FT_Unknown;
	}

	return OtherActorFaction;
}



/*=============================================================================
  WeaponSwitchAnimNotification:

  When a Grunt or Grunt-derived Pawn changes weapons, there may be an animation
  associated with this (either to put the current weapon away, if any, or to 
  take out the new weapon, if any). In most cases, the actual changing of the
  weapon (i.e. so this can be seen) occurs at some point during this animation,
  usually not at the beginning or end. For example, when putting a sword away,
  the sword might actually "disappear" (i.e. weapon=none) 80% of the way 
  through the "sheath sword" animation. To support this, the pending weapon is
  set (possibly to none), this notification function is associated with the 
  animation and the actual weapon changing logic is handled here.

  In some cases, there may be *no* animation associated with changing weapons,
  usually when the pendingweapon is none (e.g. the archer has a melee weapon,
  but no ranged weapon for his ranged attack because his bow is part of his
  mesh). In these cases, we can't use a notification function and 
  
=============================================================================*/

function WeaponSwitchAnimNotification()
{
	class'Debug'.static.DebugLog( Self, "WeaponSwitchAnimNotification", DebugCategoryName );
	if( ( Weapon != None ) && Weapon.IsA( 'WotWeapon' ) &&
			( Weapon.GetStateName() == 'WaitForDownWeaponOwnerAnimation' ) )
	{
		Weapon.GotoState( 'DownWeapon', 'OwnerAnimationFinished' );
	}
	else if( ( PendingWeapon != None ) && PendingWeapon.IsA( 'WotWeapon' ) &&
			( PendingWeapon.GetStateName() == 'WaitForBringUpWeaponOwnerAnimation' ) )
	{
		PendingWeapon.GotoState( 'Active', 'OwnerAnimationFinished' );
	}
}



function PlayInactiveAnimation()
{
	AnimationTableClass.static.TweenLoopSlotAnim( Self, WaitAnimSlot );
	StopMovement();
}



function OnBoardNotification( Notifier Notification )
{
	class'Debug'.static.DebugLog( Self, "OnBoardNotification", DebugCategoryName );
}
	


function MaybeFlipPreferAcquiredVisibilityHandler( Notifier Notification )
{
	if( Frand() <= FlipPreferAcquiredVisibilityHandlerOdds )
	{
		bPreferCurrentHandler = false;
		bPreferAcquiredVisibilityHandler = !bPreferAcquiredVisibilityHandler;
		bForceProjectileWeaponSelection = bPreferAcquiredVisibilityHandler;
		bForceMeleeWeaponSelection = !bForceProjectileWeaponSelection;
	}
}



//=============================================================================
//	PrepareMeleeWeapon state
//=============================================================================



state PrepareMeleeWeapon
{
	//no functions that result in a animation change can be called
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel );
	function TransitionToTakeHitState( float Damage, vector HitLocation, name DamageType, float MomentumZ );
	function OnDefensiveNotification( Notifier Notification );
	function OnOffensiveNotification( Notifier Notification );
	
	function OnRotationNotification( Notifier Notification )
	{
		class'Debug'.static.DebugLog( Self, "OnRotationNotification", DebugCategoryName );
		MatchGoalRotation( GetGoal( EGoalIndex.GI_Threat ) );
	}

Begin:
	StopMovement();
   	class'Debug'.static.DebugLog( Self, "PrepareMeleeWeapon: begin Self.Weapon " $ Weapon, class'Debug'.default.DC_StateCode );

PrepareMeleeWeapon:
	AnimationTableClass.static.TweenPlaySlotAnim( Self, WeaponTakeOutMeleeAnimSlot );
	FinishAnim();
    Goto( 'FinishPreparation' );

FinishPreparation:
   	class'Debug'.static.DebugLog( Self, "PrepareMeleeWeapon: returning to " $ NextState $ ", " $ NextLabel, class'Debug'.default.DC_StateCode );
    GotoState( NextState, NextLabel );
}



//=============================================================================
//	PrepareProjectileWeapon state
//=============================================================================



//When switching to *melee* state, this state is actually used to put *away*
//the projectile weapon (if any). We pbly need to have separate "putawayrangedweapon",
//"takeoutrangedweapon, "putawaymeleeweapon" and "takeoutmeleeweapon" states? so
//we can support the takeout vs putaway sounds (either that or we generalize the
//existing states/code to handle either case). The code below (and above) doesn't
//currently support playing a sound after the "putaway" versions because the call
//to FinishAnim "never returns" -- the notification function for handling the
//actual removal of the weapon calls ChangedWeapon and this (presumably -- I haven't
//traced that far yet) switches us to another state.

state PrepareProjectileWeapon expands PrepareMeleeWeapon
{
Begin:
	StopMovement();
   	class'Debug'.static.DebugLog( Self, "PrepareProjectileWeapon: Self.Weapon " $ Weapon, class'Debug'.default.DC_StateCode );

PrepareProjectileWeapon:
	AnimationTableClass.static.TweenPlaySlotAnim( Self, WeaponTakeOutRangedAnimSlot );
	FinishAnim();
    Goto( 'FinishPreparation' );
}



//=============================================================================
//	AttemptAttack state
//=============================================================================



state AttemptAttack
{
	function TransitionToTakeHitState( float Damage, vector HitLocation, Name DamageType, float MomentumZ );

	function bool GetAttackActor( out Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local bool bGetAttackActor;
		local WotWeapon AttackWotWeapon;
		class'Debug'.static.DebugLog( Self, "GetAttackActor", DebugCategoryName );
		if( Super.GetAttackActor( AttackActor, Goal ) )
		{
		 	if( AttackActor.IsA( 'WotWeapon' ) )
		 	{
				AttackWotWeapon = WotWeapon( AttackActor );
				AttackWotWeapon.DetermineWeaponUsage( Self, Goal );
				bGetAttackActor = ( AttackWotWeapon.GetWeaponUsage() != WU_None );
			}
			else
			{
				bGetAttackActor = true;
			}
		}
		class'Debug'.static.DebugLog( Self, "GetAttackActor AttackActor " $ AttackActor $ " returning " $ bGetAttackActor, DebugCategoryName );
		return bGetAttackActor;
	}
	
	function PerformAttack( Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local WotWeapon AttackWotWeapon;
		class'Debug'.static.DebugLog( Self, "PerformAttack", DebugCategoryName );
		if( AttackActor.IsA( 'WotWeapon' ) )
		{
			AttackWotWeapon = WotWeapon( AttackActor );
			class'Debug'.static.DebugLog( Self, "PerformAttack AttackWotWeapon: " $ AttackWotWeapon, DebugCategoryName );
			if( AttackWotWeapon.GetWeaponUsage() == WU_Melee )
			{
				//the weapon should be used in Melee
				GotoState( 'PerformMeleeWeaponAttack' );
			}
			else if( AttackWotWeapon.GetWeaponUsage() == WU_Projectile )
			{
				//the weapon should be used as a ranged weapon
				GotoState( 'PerformProjectileAttack' );
			}
			else
			{
				//the weapon can not be used
				assert( false );
			}
		}
		else
		{
			Super.PerformAttack( AttackActor, Goal );
		}
	}
}



//=============================================================================
//	PerformMeleeAttack state
//=============================================================================



//The current goal is reachable. Derived classes must use a mesh
//notification in their melee attack anim sequences to actually
//inflict damage on the current goal.
state PerformMeleeAttack
{
	//all sounds have the same weight for now -- assumes no sounds skipped
	//notification function for melee attack sounds (e.g. sword swish)
	function PlaySlashSound()
	{
		MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeAttackSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}
	
	function PlayMeleeHitSound()
	{
		MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeHitEnemySoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}
	
	function bool AttackDamageTarget( float Damage, float Height, name DamageType )
	{
		local bool bAttackDamageTarget;
		if( MeleeDamageGoal( Damage, Height, DamageType ) )
		{
			//sound of weapon hitting enemy
			PlayMeleeHitSound();
			bAttackDamageTarget = true;
		}
		return bAttackDamageTarget;
	}

	/*
	Liberally hooked from ScriptedPawn.
	Called internally to inflict given damage type on Grunt's current goal.
	HitLocationModifier gives the vertical offset of the hit location
	as a percentage of the character's CollisionHeight.  So, 0.5 means
	halfway between the origin and the top of the collision cylinder (3/4ths
	of the character's height) and -0.5 means halfway between the origin and
	the bottom of the collision cylinder (1/4 of the character's height).
	
	Returns `true' if actually hit the current goal, or `false' if goal moved away
	by the time the Grunt was able to swing his weapon.
	*/
	final function bool MeleeDamageGoal( float Damage, float HitLocationModifier, name DamageType )
	{
		local Actor HitActor, GoalActor;
		local vector HitLocation, HitNormal, DamagePoint;
		local vector TraceStart, GoalLocation;
		local float GoalHalfHeight, GoalRadius;
		local bool bInflictedDamage;
		
		class'Debug'.static.DebugLog( Self, "MeleeDamageGoal CurrentGoalIdx: " $ CurrentGoalIdx, DebugCategoryName );
		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Actor' ) && WithinMaxMeleeDistance( GetGoal( CurrentGoalIdx ) ) )
		{
			//still in melee range
			GetGoal( CurrentGoalIdx ).GetGoalParams( Self, GoalLocation, GoalRadius, GoalHalfHeight );
			GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor );
			
			TraceStart = Location;
			TraceStart.z += CollisionHeight * HitLocationModifier;
			
			DamagePoint = GoalLocation;
			DamagePoint.z += CollisionHeight * HitLocationModifier;
			DamagePoint.z = FMin( DamagePoint.z, GoalLocation.z + GoalHalfHeight );
			DamagePoint.z = FMax( DamagePoint.z, GoalLocation.z - GoalHalfHeight );
			
			HitActor = Trace( HitLocation, HitNormal, DamagePoint, TraceStart, true );
			
			class'Debug'.static.DebugLog( Self, "MeleeDamageGoal HitActor " $ HitActor, DebugCategoryName );
			if( HitActor == GoalActor )
			{
				GoalActor.TakeDamage( Damage, self, HitLocation, vect( 0, 0, 0 ), DamageType );
				if( Pawn( GoalActor ) != None && Pawn( GoalActor ).Health <= 0 )
				{
					//play killed enemy sound
					MySoundTable.PlaySlotSound( Self, MySoundTable.MeleeKilledEnemyTauntSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				}
				else
				{
					//randomly taunt enemy because we hit him
			  		MySoundTable.PlaySlotSound( Self, MySoundTable.MeleeHitEnemyTauntSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				}

        		bInflictedDamage = true;
				class'Debug'.static.DebugLog( Self, "MeleeDamageGoal HitActor.Health " $ Pawn( HitActor ).Health, DebugCategoryName );
				class'Debug'.static.DebugLog( Self, "MeleeDamageGoal HitActor.State " $ Pawn( HitActor ).GetStateName(), DebugCategoryName );
			}
		}
		class'Debug'.static.DebugLog( Self, "MeleeDamageGoal returning " $ bInflictedDamage, DebugCategoryName );
		return bInflictedDamage;
	}

	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, MeleeAttackAnimSlot );
	}

PerformingAttack:
	class'Debug'.static.DebugLog( Self, "PerformingAttack begin", class'Debug'.default.DC_StateCode );
	PlayStateAnimation();
	FinishAnim();
	LoopMovementAnim( GetGoal( CurrentGoalIdx ).GetSuggestedSpeed( Self ) );
	class'Debug'.static.DebugLog( Self, "PerformingAttack end", class'Debug'.default.DC_StateCode );
	PerformingAttack();
}



//=============================================================================
//	PerformMeleeWeaponAttack state
//=============================================================================



state PerformMeleeWeaponAttack expands PerformMeleeAttack 
{
	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, MeleeWeaponAttackAnimSlot );
	}
}



//=============================================================================
//	PerformProjectileAttack state
//=============================================================================



state PerformProjectileAttack expands PerformAttack
{
	function ShootRangedAmmo()
	{
		local WotWeapon WotProjectileWeapon;
		class'Debug'.static.DebugLog( Self, "ShootRangedAmmo" );
		WotProjectileWeapon = WotWeapon( class'Util'.static.GetInventoryItem( Self, RangedWeaponType ) );
		WotProjectileWeapon.UseProjectileWeapon( Self, GetGoal( CurrentGoalIdx ) );
	}
	
	/*
	Returns true if the selected anim is too short (1 frame for now)
	to use a notification function to shoot the associated "ammo".
	*/
	function bool ProjectileAttackTooFewFrames()
	{
		local Name SelectedAnim;
		local int NumFrames;

		//currently only 1 attack anim used, but this could change so don't assume this...
		SelectedAnim = AnimationTableClass.static.PickSlotAnim( Self, ProjectileAttackAnimSlot );
		NumFrames = GetAnimFrames( SelectedAnim );

		if( NumFrames == 1 )
		{
			AnimationTableClass.static.TweenSlotAnim( Self, SelectedAnim,,true );
			return true;
		}
		else
		{
			AnimationTableClass.static.TweenPlaySlotAnim( Self, SelectedAnim,,,true );
			return false;
		}
	}
	
PerformingAttack:
	class'Debug'.static.DebugLog( Self, "PerformingAttack begin", class'Debug'.default.DC_StateCode );
	StopMovement();
	if( ProjectileAttackTooFewFrames() )
	{
	    FinishAnim();
		ShootRangedAmmo();
	}
	else
	{
	    FinishAnim();
	}
	class'Debug'.static.DebugLog( Self, "PerformingAttack end", class'Debug'.default.DC_StateCode );
	PerformingAttack();
}



//=============================================================================
//	Tracking state
//=============================================================================



state Tracking
{
	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Misc0 ].EnableNotifier();
	}
	
	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Misc0 ].DisableNotifier();
	}
	
	function HearNoise( float Loudness, Actor NoiseMaker )
	{
		class'Debug'.static.DebugLog( Self, "HearNoise", class'Debug'.default.DC_EngineNotification );
		OnHearNoise( Loudness, NoiseMaker );
	}
}



//=============================================================================
//	Acquired states
//=============================================================================



state AcquiredBase expands Tracking
{
	function HearNoise( float Loudness, Actor NoiseMaker );
	function OnBoardNotification( Notifier Notification );
	function SeeEnemyPawn( Pawn SeenPawn );
	function SeeEnemyPlayer( Pawn SeenPlayer );

	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		if( bAutomaticWeaponSelection )
		{
			//if the npc is intended to use automatic attacks the offensive notifier must be enabled
			//otherwise the npc must explicitly invoke attacks (probably though movement pattern elements and hints)
			DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].EnableNotifier();
		}
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].DisableNotifier();
	}

	function OnRotationNotification( Notifier Notification )
	{
		class'Debug'.static.DebugLog( Self, "OnRotationNotification", DebugCategoryName );
		GotoState( GetStateName(), 'PerformTurnNoAnim' );
	}

	function OnMovementNotification( Notifier Notification )
	{
		class'Debug'.static.DebugLog( Self, "OnMovementNotification", DebugCategoryName );
		GotoState( GetStateName(), 'PerformMoveNoAnim' );
	}

	function PlayAcquiredSound()
	{
		if( NextAcquiredSoundTime == 0.0 )
		{
			//make sure any SeeEnemy sound finished
			NextAcquiredSoundTime = Level.TimeSeconds + MinTimeBetweenAcquiredSounds;
		}
		if( Level.TimeSeconds >= NextAcquiredSoundTime )
		{
			//don't call PlaySlotSound too frequently
			NextAcquiredSoundTime = Level.TimeSeconds + MinTimeBetweenAcquiredSounds;
			MySoundTable.PlaySlotSound( Self, MySoundTable.AcquiredSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
	}

PostPerformInactivity:
	if( Level.TimeSeconds >= NextPlayAnimSoundTime )
	{
		MySoundTable.PlaySlotSound( Self, MySoundTable.WaitingRandomSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}
	goto 'PostExecuteLabel';
}



state Acquired expands AcquiredBase
{
	function BeginState()
	{
		if( bAutomaticWeaponSelection )
		{
			SwitchToBestWeapon();
		}
		PlayAcquiredSound();
		Super.BeginState();
	}

	function bool GetPendingWeapon( out Weapon NewPendingWeapon )
	{
		return Global.GetPendingWeapon( NewPendingWeapon );
	}

	function Name GetPerforminactivityLabel() { return 'PerformingSleepInactivity'; }

PerformInactivity:
	class'Debug'.static.DebugLog( Self, "PerformInactivity:", class'Debug'.default.DC_StateCode );
	if( PerformInactivity() )
	{
		Goto( GetPerforminactivityLabel() );
PostPerformingInactivity:
	}
	Goto( 'PostPerformInactivity' );

PerformingSleepInactivity:
	Sleep( MinTrackingDuration - ( Level.TimeSeconds - LastTrackingTime ) );
	Goto( 'PostPerformingInactivity' );

PerformingAnimInactivity:
	PlayInactiveAnimation();
	FinishAnim( false );
	PlayInactiveSound();
	if( PerformInactivity() )
	{
		Sleep( MinTrackingDuration - ( Level.TimeSeconds - LastTrackingTime ) );
	}
	Goto( 'PostPerformingInactivity' );
}



state AcquiredReachable expands Acquired
{
	function bool GetPendingWeapon( out Weapon NewPendingWeapon )
	{
		local bool bGetPendingWeapon;
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon", DebugCategoryName );
		if( bAutomaticWeaponSelection )
		{
			if( GetPendingMeleeWeapon( NewPendingWeapon ) )
			{
				if( NewPendingWeapon == None )
				{
					bGetPendingWeapon = WithinMaxMeleeDistance( GetGoal( CurrentGoalIdx ) );
				}
				else
				{
					bGetPendingWeapon = true;
				}
			}
		}
		if( !bGetPendingWeapon )
		{
			bGetPendingWeapon = Super.GetPendingWeapon( NewPendingWeapon );
		}
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon NewPendingWeapon " $ NewPendingWeapon, DebugCategoryName );
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon returning " $ bGetPendingWeapon, DebugCategoryName );
		return bGetPendingWeapon;
	}
}



state AcquiredVisible expands Acquired
{
	function BeginState()
	{
		bPreferCurrentHandler = bPreferAcquiredVisibilityHandler;
		Super.BeginState();	
	}

	function bool GetPendingWeapon( out Weapon NewPendingWeapon )
	{
		local bool bGetPendingWeapon;
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon", DebugCategoryName );
		if( bAutomaticWeaponSelection )
		{
			//if using automatic attacks the acquired visible state always uses the projectile weapon
			NewPendingWeapon = class'Util'.static.GetInventoryWeapon( Self, RangedWeaponType );
			class'Debug'.static.DebugLog( Self, "GetPendingWeapon, RangedWeaponType: " $ RangedWeaponType, DebugCategoryName );
			bGetPendingWeapon = ( NewPendingWeapon != None );
		}
		if( !bGetPendingWeapon )
		{
			bGetPendingWeapon = Super.GetPendingWeapon( NewPendingWeapon );
		}
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon NewPendingWeapon " $ NewPendingWeapon, DebugCategoryName );
		class'Debug'.static.DebugLog( Self, "GetPendingWeapon returning " $ bGetPendingWeapon, DebugCategoryName );
		return bGetPendingWeapon;
	}
}



state AcquiredPathable expands AcquiredBase {}
state AcquiredUnNavigable expands AcquiredBase
{
	function Name GetPerforminactivityLabel() { return 'PerformingAnimInactivity'; }
}



//Design spec says Grunt is angry only if he sees player unexpectedly
state InitialAcquisition expands AcquiredBase
{
	function BeginState()
	{
		Super.BeginState();
		StopMovement();
	}
	
	function BeginStatePrepareNotifiers()
	{
		//the npc needs to make sure that the offensive notifier is disabled
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].DisableNotifier();
	}
	
	function PlayInitialAcquisition()
	{
		if( FRand() <= SeeEnemySoundOdds )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.SeeEnemySoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );

			//block certain sounds (mostly idle) from spamming SeeEnemy sound
			NextPlayAnimSoundTime = Level.TimeSeconds + MinTimeAfterInitialAcquisitionSound;
		}

		/* xxxrlo: OBE'd code? (also zap SeeEnemyAnimRadius and SeeEnemyAnimOdds?)
		var () float SeeEnemyAnimRadius=480.000000;	//If freshly acquired goal is in this radius -- no SeeEnemy anim.
		var () float SeeEnemyAnimOdds=0.500000;		//odds that SeeEnemy anim will be played when in SeeEnemyAnimRadius
		local float CurrentGoalDistance;
		GetGoal( CurrentGoalIdx ).GetGoalDistance( Self, CurrentGoalDistance, Self );
		if( ( CurrentGoalDistance > SeeEnemyAnimRadius ) && ( FRand() <= SeeEnemyAnimOdds ) )
		{
			//TBD: make odds of SeeEnemy anim increase with distance to goal?
			AnimationTableClass.static.TweenPlaySlotAnim( Self, SeeEnemyAnimSlot );
		}
		else
		{
			//might want to have a "SeeEnemy" sound with no animation, if there is an animation, 
			//the sound (if any) will be played through the notification function PlayAnimSound
			MySoundTable.PlaySlotSound( Self, MySoundTable.SeeEnemySoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
		*/
	}

	function bool PerformInactivity() { return false; }
	
PrePerformTurn:
	class'Debug'.static.DebugLog( Self, "PrePerformTurn:", DebugCategoryName );
	PlayInitialAcquisition();
	Goto( 'PerformTurn' );

PostPerformTurn:
	class'Debug'.static.DebugLog( Self, "PostPerformTurn:", DebugCategoryName );
	//need to make sure theat the initial acquisition animation finishes
	//this might be an issue if the npc has to wait for the normal movement animation loop to finish
	if( !IsAnimating() )
	{
		FinishAnim();
	}
	goto 'PostExecuteLabel';
}



//=============================================================================
//	NavigatingToGoal state
//=============================================================================



state NavigatingToGoal expands Tracking
{
	function OnBoardNotification( Notifier Notification );

	function GoalInitialized( EGoalIndex GoalIdx )
	{
		local Actor CurrentActor;
		if( GoalIdx == GI_Threat )
		{
			ThreatGoalInitialized();
		}
		Super.GoalInitialized( GoalIdx );
	}

	function ThreatGoalInitialized()
	{
		local Actor CurrentActor;
   		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Alarm' ) &&
				GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Captain' ) )
		{
   			InvalidateGoal( CurrentGoalIdx );
	   	}
	}
	
	function OnMovementNotification( Notifier Notification )
	{
		class'Debug'.static.DebugLog( Self, "OnMovementNotification", DebugCategoryName );
		if( GetGoal( CurrentGoalIdx ).IsGoalReached( Self ) )
		{
			//xxxrlo bNotifyReachedDestination = false;
			OnReachedDestination( Location );
		}
		else
		{
			Super.OnMovementNotification( Notification );
		}
	}
}



//=============================================================================
//	SuccessfullyNavigatedToGoal state
//=============================================================================



state SuccessfullyNavigatedToGoal expands NavigatingToGoal
{
	function GetPriorityGoalIndex( out EGoalIndex PriorityGoalIndex )
	{
		//call update goal right before all of the priorities are evaluated
		UpdateGoals();
		Super.GetPriorityGoalIndex( PriorityGoalIndex );
	}
	
	function UpdateGoals();
	
	function BeginState()
	{
		Super.BeginState();
   		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Alarm' ) )
   		{
   			SuccessfullyNavigatedToAlarm();
   		}
   		else if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, 'Captain' ) )
   		{
    		SuccessfullyNavigatedToCaptain();
   		}
   		else if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, GetGoal( CurrentGoalIdx ).LocationGoalName ) )
   		{
			SuccessfullyNavigatedToLocation();
   		}
	}
	
	function SuccessfullyNavigatedToAlarm() { GotoState( 'SuccessfullyNavigatedToAlarm' ); }
	function SuccessfullyNavigatedToCaptain() { GotoState( 'SuccessfullyNavigatedToCaptain' ); }
	function SuccessfullyNavigatedToLocation()
	{
		InvalidateGoal( CurrentGoalIdx );
		PostTrackGoal();
	}
}



state SuccessfullyNavigatedToAlarm expands SuccessfullyNavigatedToGoal
{
	function UpdateGoals()
	{
		local Actor GoalActor;
		class'Debug'.static.DebugLog( Self, "UpdateGoals", DebugCategoryName );
		GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor );
		InvalidateGoal( CurrentGoalIdx );
		if( ( GoalActor != None ) && GoalActor.IsA( 'Alarm' ) && ( Alarm( GoalActor ).Target != None ) )
		{
			InitGoalWithObject( EGoalIndex.GI_Threat, Alarm( GoalActor ).Target );
			if( !GetGoal( EGoalIndex.GI_Threat ).IsGoalNavigable( Self ) )
			{
				InvalidateGoal( EGoalIndex.GI_Threat );
			}
		}
	}
}



state SuccessfullyNavigatedToCaptain expands SuccessfullyNavigatedToGoal
{
	function UpdateGoals()
	{
		local Actor GoalActor;
		class'Debug'.static.DebugLog( Self, "UpdateGoals", DebugCategoryName );
		GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor );
		InvalidateGoal( CurrentGoalIdx );
		if( ( GoalActor != None ) && GoalActor.IsA( 'LegendPawn' ) )
		{
			InitGoalWithObject( EGoalIndex.GI_Threat, LegendPawn( GoalActor ).GetGoal( EGoalIndex.GI_Threat ) );
			if( !GetGoal( EGoalIndex.GI_Threat ).IsGoalNavigable( Self ) )
			{
				InvalidateGoal( EGoalIndex.GI_Threat );
			}
		}
	}

PrePerformTurn:
	class'Debug'.static.DebugLog( Self, "PrePerformTurn:", DebugCategoryName );
	MySoundTable.PlaySlotSound( Self, MySoundTable.AwaitingOrdersSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	AnimationTableClass.static.TweenPlaySlotAnim( Self, ListenAnimSlot );
	Goto( 'PerformTurn' );

PerformTurnPlayAnim:
	class'Debug'.static.DebugLog( Self, "PerformTurnPlayAnim:", DebugCategoryName );
	Goto( 'PerformTurnNoAnim' );

PostPerformTurn:
	class'Debug'.static.DebugLog( Self, "PostPerformTurn:", DebugCategoryName );
	FinishAnim();
	goto 'PostExecuteLabel';
}



//=============================================================================
//	Investigating state
//=============================================================================



state Investigating expands Tracking
{
	function SeeEnemyPawn( Pawn SeenPawn );
	function SeeEnemyPlayer( Pawn SeenPlayer );
	function HearNoise( float Loudness, Actor NoiseMaker );
}



state GoalInvestigated expands Investigating
{
	function InitiateTrackingOperation()
	{
		//at investigation point, haven't seen anything (if we had we would not be in this state. would we now)
 		InvalidateGoal( EGoalIndex.GI_Threat );
        PostTrackGoal();
	}
}



//=============================================================================
//	SearchingState states
//=============================================================================



state SearchingState expands Tracking
{
/*
//xxxrlo
    function PlayAnimSound()
    {
     	switch( AnimSequence )
        {
        	case LookAnimSlot:
				MySoundTable.PlaySlotSound( Self, MySoundTable.SearchingSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
				break;
            default:
            	Global.PlayAnimSound();
        }
    }

	function InitiateTrackingOperation()
	{
		class'Debug'.static.DebugLog( Self, "InitiateTrackingOperation", DebugCategoryName );
		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, GetGoal( CurrentGoalIdx ).ocationGoal ) )
        {
			Super.InitiateTrackingOperation();
        }
        else
        {
            GotoState( GetStateName(), 'PrePerfomTracking' );
        }
	}

PrePerfomTracking:
	AnimationTableClass.static.TweenPlaySlotAnim( Self, SearchAnimSlot );
    FinishAnim();
	Super.InitiateTrackingOperation();
	Stop;
*/
}



state SearchingVisible expands SearchingState { function InitiateTrackingOperation() { PostTrackGoal(); } }
state SearchingPathable expands SearchingState {}
state SearchingUnNavigable expands SearchingState {}



//=============================================================================
// NavigatingToRefuge states
// Grunts travel until he feels safe or there are no paths that
// get out of the goal's visibility.
//=============================================================================



state NavigatingToRefuge expands Tracking
{
	function AlarmSounded( Alarm NotifyingAlarm );
    function AlertedByCaptain( Captain AlertingCaptain );
    function HearNoise( float Loudness, Actor NoiseMaker );
	function OnBoardNotification( Notifier Notification );

	function SeeFriendlyPlayer( Pawn SeenPlayer )
	{
		class'Debug'.static.DebugLog( Self, "SeeFriendlyPlayer", DebugCategoryName );
		Super.SeeFriendlyPlayer( SeenPlayer );
		InitGoalWithVector( CurrentGoalIdx, Location );
    }
}

state Antagonized expands NavigatingToRefuge {}
state RefugeReached expands NavigatingToRefuge {}
state RefugeUnNavigable expands RefugeReached {}



//=============================================================================
//	TakeHitState state
//=============================================================================



state TakeHitState
{
	//need this or if/when a grunt is hit while in the TakeHitState, we end up
	//locked since NextState becomes TakeHitState.
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel );
	function TransitionToTakeHitState( float Damage, vector HitLocation, name DamageType, float MomentumZ );
	function AlarmSounded( Alarm NotifyingAlarm );
    function AlertedByCaptain( Captain AlertingCaptain );
    function HearNoise( float Loudness, Actor NoiseMaker );

Begin:
	class'Debug'.static.DebugLog( Self, Name $ " entering state TakeHitState", DebugCategoryName );

	if( NextAnimSlot == HitAnimSlot )
	{
		AnimationTableClass.static.TweenSlotAnim( Self, NextAnimSlot );
	}
	else
	{
		// playing hit anim -- need to stop?
		StopMovement();
		//setup done in wotpawn, played here
		AnimationTableClass.static.TweenPlaySlotAnim( Self, NextAnimSlot );
	}
    FinishAnim();

	class'Debug'.static.DebugLog( Self, Name $ " reentering state " $ NextState, DebugCategoryName );
	GotoState( NextState, NextLabel );
}



//=============================================================================
//	FallingState state
//=============================================================================



//A holding state where nothing much happens. 
//I wanted to always change to this state when the grunt's physics
//became PHYS_Falling, since it would make the AI easier.  Specifically,
//ActorReachable() [and related fns] always returns `false' when
//Physics == PHYS_Falling.  It would have been nice if the various
//states' Timer() routines could always check if their target was
//reachable without having to worry about the current physics.
//However, doing so means entering this state every time the grunts
//take damage (since as of v117 [I think]) TakeDamage() *always*
//sets Physics = PHYS_Falling).  So you could effectively immobilize
//a grunt just by a constantly hitting it.  That's not what we want.
//So now this state is only entered when the grunt falls `honestly'
//(i.e. Falling() is called by the engine).
//This means that all other states *must* take into account that the
//pawn's physics might not be PHYS_Walking!

state FallingState
{
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel );
	function AlarmSounded( Alarm NotifyingAlarm );
    function AlertedByCaptain( Captain AlertingCaptain );
	function SeeEnemyPawn( Pawn SeenPawn );
	function SeeEnemyPlayer( Pawn SeenPlayer );
    function HearNoise( float Loudness, Actor NoiseMaker );
    function bool CanBeGivenNewOrders() { return false; }

	function AdjustJump()
	{
		local float CurrentVelocityZ;
		local Vector AnticipatedGroundVelocity;

		CurrentVelocityZ = Velocity.z;
		AnticipatedGroundVelocity = Normal( Velocity ) * GroundSpeed;
		
		if( Location.z > ( Destination.z + CollisionHeight + 2 * MaxStepHeight ) )
		{
			Velocity = AnticipatedGroundVelocity;
			Velocity.z = CurrentVelocityZ;
			Velocity = EAdjustJump();
			Velocity.z = 0;
			if( VSize( Velocity ) < 0.9 * GroundSpeed )
			{
				Velocity.z = CurrentVelocityZ;
				return;
			}
		}
		
		Velocity = AnticipatedGroundVelocity;
		Velocity.z = CurrentVelocityZ + JumpZ;
		Velocity = EAdjustJump();
	}
	
	function Landed( vector HitNormal )
    {
    	Super.Landed( HitNormal );
    	class'Debug'.static.DebugLog( Self, "Landed Health: " $ Health, DebugCategoryName );
    	if( Health > 0 )
		{
			//fall might have killed him
	        GotoState( 'FallingState', 'Landed' ); //same state, different label
		}
    }

    function ZoneChange( ZoneInfo newZone )
	{
		Global.ZoneChange( NewZone );
		if( NewZone.bWaterZone && bCanSwim )
		{
			GotoState( GetStateName(), 'Splash' );
		}
	}

Landed:
	if( Velocity.Z <= -SpeedPlayAnimAfterLanding )
	{
		//play all of animation
		AnimationTableClass.static.TweenPlaySlotAnim( Self, LandAnimSlot );
	}
	else
	{
		//tween to first frame
		AnimationTableClass.static.TweenSlotAnim( Self, LandAnimSlot );
	}
	if( Base == Level )
	{
		StopMovement();
	}
    FinishAnim();
    class'Debug'.static.DebugLog( Self, Name $ " returning to state: " $ NextState $ " label: " $ NextLabel $ " because landed", DebugCategoryName );
    GotoState( NextState, NextLabel );

Splash:
	bUpAndOut = false;
	FinishAnim();
	GotoState( NextState, NextLabel );

Begin:
	if( !bUpAndOut ) //not water jump
	{	
		if( !bJumpOffPawn && ( VSize( Velocity ) != 0 ) )
		{
			AdjustJump();
		}
		else
		{
			bJumpOffPawn = false;
		}
	}
	AnimationTableClass.static.TweenSlotAnim( Self, FallAnimSlot );
	Focus = Location + Vector( Rotation ) * 10000;
	FinishAnim();
    Stop;
}



//=============================================================================
//	Returning states
//=============================================================================



state () WaitingIdle expands Waiting
{
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel )
	{
		ReturnState = GetStateName();
		ReturnLabel = 'Begin';
	}

	function FaceActorSource( Actor SourceActor )
	{
		SetWaitingGoal( Location, Rotator( SourceActor.Location - Location ) );
		Global.FaceActorSource( SourceActor );
	}

	function HearNoise( float Loudness, Actor NoiseMaker )
	{
		class'Debug'.static.DebugLog( Self, "HearNoise NoiseMaker: " $ NoiseMaker, class'Debug'.default.DC_EngineNotification );
	    Global.OnHearNoise( Loudness, NoiseMaker );
	}

	function bool GoalIndexTransitionColleague() { return true; }

	function Name GetWaitingLabel()
	{
		local Actor GoalActor;
		local float ColleagueDistance;
		local Name WaitingLabel;
		
		if( ( GetGoal( EGoalIndex.GI_Colleague ).GetGoalActor( Self, GoalActor ) &&
				GoalActor.IsA( 'Pawn' ) && Pawn( GoalActor ).bIsPlayer &&
				GetGoal( EGoalIndex.GI_Colleague ).GetGoalDistance( Self, ColleagueDistance, Self ) &&
				( ColleagueDistance < ( CowerRadius ) ) ) )
		{
			//there is an associated colleague
			//the colleague is a player
			//the colleague is within this grunts cower radius
		    WaitingLabel = 'WaitingCower';
		}
		else
		{
			//Idle because no friendly guy near
   		    WaitingLabel = 'WaitingIdle';
		}
		class'Debug'.static.DebugLog( Self, "GetWaitingLabel returning " $ WaitingLabel, DebugCategoryName );
		return WaitingLabel;
	}

	function ContinueWaiting()
	{
		NextLabel = GetWaitingLabel();
		class'Debug'.static.DebugLog( Self, "ContinueWaiting NextLabel " $ NextLabel, DebugCategoryName );
		class'Debug'.static.DebugLog( Self, "ContinueWaiting bCowering " $ bCowering, DebugCategoryName );
		if( bCowering )
		{
			if( NextLabel != 'WaitingCower' )
			{
				GotoState( GetStateName(), NextLabel );
			}
		}
		else
		{
			if( NextLabel == 'WaitingCower' )
			{
				GotoState( GetStateName(), NextLabel );
			}
		}
	}
	
	function PlayInactiveSound()
	{
		//Play some idle chat/sound every now and then (if the NPC has these in his SoundTable).
		if( Level.TimeSeconds >= NextPlayAnimSoundTime )
		{
			MySoundTable.PlaySlotSound( Self, MySoundTable.WaitingRandomSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
	}

PostTrackGoal:

WaitingIdle:
	bCowering = false;
	LastTrackingTime = Level.TimeSeconds;
	ExecuteLabel( 'PerformInactivity', 'WaitingIdle_PostPerformInactivity' );

WaitingIdle_PostPerformInactivity:
	Goto( 'WaitingIdle' );
	Stop;

WaitingCower:
	bCowering = true;
	AnimationTableClass.static.TweenPlaySlotAnim( Self, ShowRespectAnimSlot );
	FinishAnim();
	AnimationTableClass.static.TweenLoopSlotAnim( Self, ShowRespectLoopAnimSlot );
	//sit in loop until hell freezes over (or state changes...)
	Stop;
}



state () InactiveIdle expands WaitingIdle
{
	function bool IsInactive() { return true; }
	function BeginStatePrepareNotifiers() { DisableNotifiers(); }
}



state Dormant
{
	function Landed( vector HitNormal ); 
}


// xxxrlo:
function Killed( pawn Killer, pawn Other, name DamageType )
{
	local Actor GoalActor;

	// make sure we lose the dead player as a goal until (if) we see him again in multiplayer
	if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) )
	{
		if( GoalActor == Other )
		{
			InvalidateGoal( EGoalIndex.GI_Threat );
		}
	}

	Super.Killed( Killer, Other, DamageType );
}

defaultproperties
{
     BrokenMoralePct=25
     CowerRadius=256.000000
     WalkSpeedPct=50
     BaseWalkingSpeed=162.500000
     SeeEnemySoundOdds=1.000000
     ProjectileAlertRadius=160.000000
     TakeDamageMoveDistance=160.000000
     MoveFromTakeDamageThreshold=20
     MinTimeBetweenAcquiredSounds=5.000000
     MinTimeAfterInitialAcquisitionSound=5.000000
     bPreferAcquiredVisibilityHandler=True
     FlipPreferAcquiredVisibilityHandlerOdds=0.333333
     bAutomaticWeaponSelection=True
     DebugCategoryName=Grunt
     HandlerFactoryClass=Class'WOT.RangeHandlerFactoryGrunt'
     TransitionerInfos(4)=(TI_bConstruct=True)
     TransitionerInfos(5)=(TI_bConstruct=True)
     TransitionerInfos(6)=(TI_bConstruct=True)
     TransitionerInfos(7)=(TI_bConstruct=True)
     TransitionerInfos(8)=(TI_bConstruct=True)
     DurationNotifierClasses(6)=Class'Legend.DurationNotifier'
     DurationNotifierClasses(7)=Class'Legend.DurationNotifier'
     DurationNotifierNotifications(6)=OnBoardNotification
     DurationNotifierNotifications(7)=MaybeFlipPreferAcquiredVisibilityHandler
     DurationNotifierDurations(6)=-1.000000
     DurationNotifierDurations(7)=-1.000000
     MeleeRange=25.000000
     InitialState=InactiveIdle
     Buoyancy=150.000000
}
