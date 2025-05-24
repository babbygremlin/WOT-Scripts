//=============================================================================
// AngrealUser.
// $Author: Mfox $
// $Date: 1/10/00 1:53p $
// $Revision: 30 $
//=============================================================================

class AngrealUser expands Captain;

//gets copied over to AngrealWeaponAdater.MinOffensiveUsageInterval
var () config float MinOffensiveAngrealUsageInterval;
//gets copied over to AngrealWeaponAdater.MinDefensiveUsageInterval
var () config float MinDefensiveAngrealUsageInterval;

//these all have to have the same dimension:
var () config string AII_AngrealInventoryStr[ 15 ];

/*
the following are used to prime AngrealInventory.CurCharges when initially
spawned into the angreal users inventory. Also used in the same way during
the respawn process used primarily for single player missions.
See AngrealInventory.GoEmpty() for details.
*/
//gets copied over to AngrealInventory.MinInitialCharges
var () config int AII_MinInitialCharges[ 15 ];
//gets copied over to AngrealInventory.MaxInitialCharges
var () config int AII_MaxInitialCharges[ 15 ];

/*
the following are used to prime AngrealInventory when a new iventory of this
type is added to the angreal users inventory
*/
//gets copied over to AngrealInventory.Priority
var () config float AII_Priority[ 15 ];
//gets copied over to AngrealInventory.MinChargesInGroup
var () config int AII_MinChargesInGroup[ 15 ];
//gets copied over to AngrealInventory.MaxChargesInGroup
var () config int AII_MaxChargesInGroup[ 15 ];
//gets copied over to AngrealInventory.MinChargeGroupInterval
var () config float AII_MinChargeGroupInterval[ 15 ];
//gets copied over to AngrealInventory.MaxChargeUsedInterval
var () config float AII_MaxChargeUsedInterval[ 15 ];

/*
the following are only used when an angreal is initially spawned into the
angreal users inventory. Gets copied over to AngrealInventory.NPCRespawnTime.
Set this to 0 to disable the behavior of the latent give to leech used in
AngrealInventory.GoEmpty()
*/
//gets copied over to AngrealInventory.NPCRespawnTime
var () config float AII_NPCRespawnTime[ 15 ];

var LegendPawnNotification LastNotification;
var int LastNotificationInfoIndex;
var AngrealWeaponAdapter AngrealInterface; //only a member variable on convenience. it is in the inventory list also

const SentinalValueFloat = -1.0;
const SentinalValueInt = -1;

const HintName_UseAngreal = 'UseAngreal'; //select and use an angreal in the inventory
const HintName_UseSpecificAngreal = 'UseSpecificAngreal'; //use the specific angreal names in the post hint
const HintName_UseMeteor = 'UseMeteor';
const AttackRunAnimSlot = 'ATTACKRUN';



function SetValueWithSentinalFloat( out float OutVal, float InVal )
{
	if( !( InVal ~= SentinalValueFloat ) )
	{
		OutVal = InVal;
	}
}



function SetValueWithSentinalInt( out int OutVal, int InVal )
{
	if( InVal != SentinalValueInt )
	{
		OutVal = InVal;
	}
}



function AddDefaultInventoryItems()
{
	local class<AngrealInventory> NewAngrealInventoryClass;
	local AngrealInventory NewAngrealInventory;	
	local int i;
	
	class'Debug'.static.DebugLog( Self, "AddDefaultInventoryItems", 'AngrealUser' );
	for( i = 0; i < ArrayCount( DefaultInventoryTypes ); i++ )
	{
		if( ( DefaultInventoryTypes[ i ] != None ) &&
				DefaultInventoryTypes[ i ].IsA( 'AngrealInventory' ) )
		{
			Warn( "Angreal users can only have Angreal in the DefaultInventoryTypes array" );
			//xxxrlo assert( false );
		}
	}

	Super.AddDefaultInventoryItems();
	
	AngrealInterface = AngrealWeaponAdapter( class'Util'.static.GetInventoryWeapon( Self, class'AngrealWeaponAdapter' ) );
	if( AngrealInterface != None )
	{
		AngrealInterface.MinOffensiveUsageInterval = MinOffensiveAngrealUsageInterval;
		AngrealInterface.MinDefensiveUsageInterval = MinDefensiveAngrealUsageInterval;
	}

	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_NPCRespawnTime ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MinInitialCharges ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MaxInitialCharges ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_Priority ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MinChargesInGroup ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MaxChargesInGroup ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MinChargeGroupInterval ) );
	Assert( ArrayCount( AII_AngrealInventoryStr ) == ArrayCount( AII_MaxChargeUsedInterval ) );

	for( i = 0; i < ArrayCount( AII_AngrealInventoryStr );  i++ )
	{
		if( AII_AngrealInventoryStr[ i ] != "" )
		{
			NewAngrealInventoryClass = class<AngrealInventory>( DynamicLoadObject( AII_AngrealInventoryStr[ i ], class'Class', true ) );
			if( NewAngrealInventoryClass != None )
			{
				NewAngrealInventory = AngrealInventory( class'Util'.static.AddInventoryTypeToHolder( Self, NewAngrealInventoryClass ) );
				if( NewAngrealInventory != None )
				{
					//if the value on the RHS is different from the Sentinal value, override the angreal inventory default
					SetValueWithSentinalFloat( NewAngrealInventory.Priority, AII_Priority[ i ] );
					SetValueWithSentinalInt( NewAngrealInventory.MaxChargesInGroup, AII_MaxChargesInGroup[ i ] );
					SetValueWithSentinalInt( NewAngrealInventory.MinChargesInGroup, AII_MinChargesInGroup[ i ] );
					SetValueWithSentinalFloat( NewAngrealInventory.MaxChargeUsedInterval, AII_MaxChargeUsedInterval[ i ] );
					SetValueWithSentinalFloat( NewAngrealInventory.MinChargeGroupInterval, AII_MinChargeGroupInterval[ i ] );
					SetValueWithSentinalFloat( NewAngrealInventory.NPCRespawnTime, AII_NPCRespawnTime[ i ] );
					SetValueWithSentinalInt( NewAngrealInventory.MinInitialCharges, AII_MinInitialCharges[ i ] );
					SetValueWithSentinalInt( NewAngrealInventory.MaxInitialCharges, AII_MaxInitialCharges[ i ] );
					SetValueWithSentinalInt( NewAngrealInventory.CurCharges, RandRange( NewAngrealInventory.MinInitialCharges, NewAngrealInventory.MaxInitialCharges) );

//Log( Self $ "::Added " $ NewAngrealInventoryClass );
//Log( "NewAngrealInventory.Priority " $ NewAngrealInventory.Priority );
//Log( "NewAngrealInventory.MaxChargesInGroup " $ NewAngrealInventory.MaxChargesInGroup );
//Log( "NewAngrealInventory.MinChargesInGroup " $ NewAngrealInventory.MinChargesInGroup );
//Log( "NewAngrealInventory.MaxChargeUsedInterval " $ NewAngrealInventory.MaxChargeUsedInterval );
//Log( "NewAngrealInventory.MinChargeGroupInterval " $ NewAngrealInventory.MinChargeGroupInterval);
//Log( "NewAngrealInventory.NPCRespawnTime " $ NewAngrealInventory.NPCRespawnTime );
//Log( "NewAngrealInventory.MinInitialCharges " $ NewAngrealInventory.MinInitialCharges );
//Log( "NewAngrealInventory.MaxInitialCharges " $ NewAngrealInventory.MaxInitialCharges );
//Log( "NewAngrealInventory.CurCharges " $ NewAngrealInventory.CurCharges );

					OnAddedDefaultInventoryItem( NewAngrealInventory );
				}
			}
			else
			{
				Warn( Self $ ": AII_AngrealInventoryStr[ " $ i $ " ] is invalid: " $ AII_AngrealInventoryStr[ i ] );
			}
		}
	}
}



function HandleHint( Name Hint )
{
	class'Debug'.static.DebugLog( Self, "HandleHint Hint " $ Hint, 'AngrealUser' );
	switch( Hint )
	{
		case HintName_UseAngreal:
			break;
		case HintName_UseSpecificAngreal:
			UseSpecificAngreal( CurrentRangeIterator.GetCurrentHandler().Template.HT_PostHint );
			break;
		case HintName_UseMeteor:
			UseMeteor();
			break;
		default:
			Super.HandleHint( Hint );
			break;
	}
}



function OnUseNotification( LegendPawnNotification Notification )
{
    local int NotificationInfoIndex;
	if( Notification.GetNotificationInfoIndex( NotificationInfoIndex ) )
	{
		GetNextStateAndLabelForReturn( NextState, NextLabel );
		LastNotification = Notification;
		LastNotificationInfoIndex = NotificationInfoIndex;
		GotoState( 'PerformUse' );
	}
}



function UseMeteor()
{
	local Projectile Meteor;
	local vector HitLocation, SpawnLocation, HitNormal;
	class'Util'.static.TraceRecursive( Self, SpawnLocation , HitNormal, Location, false,, vect( 0, 0, 1 ) );
	class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, Location + vect( 0, 0, 1 ) * BaseEyeHeight, false,, Vector( ViewRotation ) );
	Meteor = Spawn( class<Projectile>( DynamicLoadObject( "Angreal.AngrealFireballProjectile", class'Class' ) ),,, SpawnLocation, Rotator( HitLocation - SpawnLocation ) );
	Meteor.Instigator = Self;
}



function UseSpecificAngreal( Name AngrealClassName )
{
	local Inventory InventoryIter;
	local AngrealInventory Angreal;
	for( InventoryIter = Inventory; InventoryIter != None; InventoryIter = InventoryIter.Inventory )
	{
		if( InventoryIter.IsA( AngrealClassName ) )
		{
			Angreal = AngrealInventory( InventoryIter );
		}
	}
	if( Angreal != None )
	{
		CeaseUsingAngreal();
		SelectedItem = Angreal;
		UseAngreal();
	}
}



function Actor GetDefensiveInstigator()
{
	return DefensiveDetector( DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ] ).GetOffender();
}



function DefensivePerimiterCompromised( DefensiveDetector DefensiveNotification )
{
	local SeekingProjectile Seeker;
	class'Debug'.static.DebugLog( Self, "DefensivePerimiterCompromised", 'AngrealUser' );
	Super.DefensivePerimiterCompromised( DefensiveNotification );
	Seeker = SeekingProjectile( GetDefensiveInstigator() );
	if( ( Seeker == None ) || ( Seeker.Destination == Self ) )
	{
	    GetNextStateAndLabelForReturn( NextState, NextLabel );
		GotoState( 'AttemptDefensiveAngrealUse' );
	}
}



state AttemptDefensiveAngrealUse expands AttemptAttack
{
	function bool GetAttackActor( out Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local bool bGetAttackActor;
		class'Debug'.static.DebugLog( Self, "GetAttackActor", 'AngrealUser' );
		AngrealInterface.DetermineDefensiveUsage( GetDefensiveInstigator() );
		if( AngrealInterface.GetWeaponUsage() != WU_None )
		{
			AttackActor = AngrealInterface;
			bGetAttackActor = true;
		}
		class'Debug'.static.DebugLog( Self, "GetAttackActor AttackActor " $ AttackActor $ " returning " $ bGetAttackActor, 'AngrealUser' );
		return bGetAttackActor;
	}
}



function LoopMovementAnim( float IntendedMovementSpeed )
{
	if( AngrealInterface.IsCasting() )
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, AttackRunAnimSlot );
	}
	else
	{
		Super.LoopMovementAnim( IntendedMovementSpeed );
	}
}



function PlayInactiveAnimation()
{ 
	if( AngrealInterface.IsCasting() )
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, AttackRunAnimSlot );
	}
	else
	{
		Super.PlayInactiveAnimation();
	}
}



//=============================================================================
// Notification for when a charge has been used.
//=============================================================================
function ChargeUsed( AngrealInventory Ang )
{
	AnimSequence = 'ATTACKRUN';
	AngrealInterface.ChargeUsed( Ang );
	Super.ChargeUsed( Ang );
}



//=============================================================================
// Called by angreal projectiles to notify the victim what just hit them.
//=============================================================================
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	if( HitProjectile.IsA( 'AngrealIceProjectile' ) )
	{
		//Interrupt the charge group
		CeaseUsingAngreal();
	}
	Super.NotifyHitByAngrealProjectile( HitProjectile );
}



//=============================================================================
// Call this function to stop using the currently selected angreal.
//=============================================================================
function CeaseUsingAngreal()
{
	if( AngrealInterface != None )
	{
		AngrealInterface.CeaseUsingAngreal();
	}
	Super.CeaseUsingAngreal();
}



//=============================================================================
//	AttemptAttack state
//=============================================================================



state AttemptAttack
{
	function BeginStatePrepareNotifiers()
	{
		Global.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].DisableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Global.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].EnableNotifier();
	}
}

//=============================================================================
//	PerformProjectileAttack state
//=============================================================================



state PerformProjectileAttack
{
	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].DisableNotifier();
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Defensive ].EnableNotifier();
	}
}




//=============================================================================
//	PerformUse state
//=============================================================================



state PerformUse expands PerformProjectileAttack
{
	function ShootRangedAmmo()
	{
		PerformUse( LastNotification );
	}
	
	function OnRotationNotification( Notifier Notification );
	
	function PerformUse( LegendPawnNotification Notification )
	{
		local Actor CurrentActor;
		local class WhatToUseClass;
		local Name WhatToUseItOn;
		local Projectile WhatToUse;
		local Vector SpawnLocation, HitNormal;
		local Rotator SpawnDirection;
		local WotWeapon WotProjectileWeapon;

		WotProjectileWeapon = WotWeapon( class'Util'.static.GetInventoryItem( Self, RangedWeaponType ) );
	 	LastNotification.SetNotificationInfoIndex( LastNotificationInfoIndex );
		WhatToUseItOn = Notification.GetWhatToUseItOn();
		if( WhatToUseItOn != '' )
		{
			WhatToUseClass = Notification.GetWhatToUseClass();
			if( ( WhatToUseClass != None ) && ( ClassIsChildOf( WhatToUseClass, class'Projectile' ) ) )
			{
				foreach AllActors( class'Actor', CurrentActor, WhatToUseItOn )
				{
/*
//xxxrlo differentiate from "death from above"
					if( ClassIsChildOf( WhatToUseClass, class'GenericProjectile' ) )
					{
						SpawnLocation = WotProjectileWeapon.GetAimSource( Self, CurrentActor.Location );
						SpawnDirection = class<GenericProjectile>( WhatToUseClass ).static.CalculateTrajectory( Self, CurrentActor );
					}
					else
					{
*/
						class'Util'.static.TraceRecursive( Self, SpawnLocation, HitNormal, Location, false,, Vect( 0, 0, 1 ) );
						SpawnDirection = Rotator( CurrentActor.Location - SpawnLocation );
//					}

					WhatToUse = Spawn( class<Projectile>( WhatToUseClass ), , , SpawnLocation, SpawnDirection );
					WhatToUse.Instigator = Self;
					
					if( WhatToUse.IsA( 'GenericProjectile' ) )
					{
						GenericProjectile( WhatToUse ).SetDestination( CurrentActor );
					}
					
					bRotateToDesired = true;
					DesiredRotation = Rotator( CurrentActor.Location - Location );
				}
			}
		}
	}
}



/*
//bot code rip off
static function bool PickLocalInventory( Pawn Invoker, float MaxDist, float MinDistraction )
{
	local Inventory Inv, BestInv, KnowPath;
	local float NewWeight, DroppedDist, BestWeight;
	local bool bCanReach;
	local bool bPickLocalInventory;
	
	local Inventory EnemyDropped;
	local Actor MoveTarget;
	
	if( ( EnemyDropped != None ) && !EnemyDropped.bDeleteMe && ( EnemyDropped.Owner == None ) )
	{
		DroppedDist = VSize( EnemyDropped.Location - Invoker.Location );
		NewWeight = EnemyDropped.BotDesireability( Invoker );
		if( ( DroppedDist < MaxDist )
			&& ( ( NewWeight > MinDistraction ) || ( DroppedDist < 0.5 * MaxDist ) )
			&& Invoker.ActorReachable( EnemyDropped ) )
		{
			BestWeight = NewWeight;
			if( BestWeight > 0.4 )
			{
				MoveTarget = EnemyDropped;
				EnemyDropped = None;
				return true; 
			}
			BestInv = EnemyDropped;
			BestWeight = BestWeight / DroppedDist;
			KnowPath = BestInv;
		}
	}

	EnemyDropped = None;

	//first look at nearby inventory < MaxDist
	foreach Invoker.VisibleCollidingActors( class'Inventory', Inv, MaxDist, , true )
	{
		if( Inv.IsInState( 'PickUp' ) && ( Inv.MaxDesireability / 60 > BestWeight ) &&
				( Inv.Location.Z < ( Invoker.Location.Z + Invoker.MaxStepHeight + Invoker.CollisionHeight ) ) )
		{
			NewWeight = inv.BotDesireability( Invoker );
			if( ( NewWeight > MinDistraction ) ||
					( Inv.bHeldItem && Inv.IsA( 'Weapon' ) &&
					( VSize( Inv.Location - Invoker.Location ) < 0.6 * MaxDist ) ) )
			{
				NewWeight = NewWeight / VSize( Inv.Location - Invoker.Location );
				if( NewWeight > BestWeight )
				{
					BestWeight = NewWeight;
					BestInv = Inv;
				}
			}
		}
	}
	
	if( BestInv != None )
	{
		Invoker.bCanJump = ( BestInv.Location.Z > Invoker.Location.Z - Invoker.CollisionHeight - Invoker.MaxStepHeight );
		bCanReach = Invoker.ActorReachable( BestInv );
		if( bCanReach )
		{
			MoveTarget = BestInv;
			bPickLocalInventory = true;
//xxxrlo	return true;
		}
	}
	else
	{
		bCanReach = false;
	}

	Invoker.bCanJump = true;

	if( !bCanReach && ( KnowPath != None ) )
	{
		MoveTarget = KnowPath;
		bPickLocalInventory = true;
//xxxrlo		return true;
	}
	return false;
}


function bool FindAvailableInventory( out Inventory FoundInventory )
{
   	local int ItemCount, i;
    local Actor PotentialInventory;
    local ItemSorter InventorySorter;
    local bool bFindAvailableInventory;
    local Actor InventoryPath;
	local Actor ClosestInventory;
	
	class'Debug'.static.DebugLog( Self, "FindAvailableInventory", 'AngrealUser' );

	InventorySorter = ItemSorter( class'Singleton'.static.GetInstance( Self.XLevel, class'ItemSorter' ) );
	InventorySorter.CollectAllItems( Self, class'AngrealSpawnPool' );
	if( InventorySorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			class'Debug'.static.DebugLog( Self, "FindAvailableInventory InventorySorter.GetItem( i ) " $ InventorySorter.GetItem( i ), 'AngrealUser' );
			if( !InventorySorter.GetItem( i ).IsInState( 'Active' ) )
      		{
	      		InventorySorter.RejectItem( i );
    	    }
		}
	}
	
//xxxrloxxx	InventorySorter.InitSorter();
//xxxrloxxx	InventorySorter.SortReq.IR_Origin = Self.Location;
	InventorySorter.SortItems();
	
	if( InventorySorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			if( InventorySorter.IsItemAccepted( 0 ) )
			{
				PotentialInventory = InventorySorter.GetItem( i );
				class'Debug'.static.DebugLog( Self, "FindAvailableInventory PotentialInventory  " $ PotentialInventory , 'AngrealUser' );
				if( ClosestInventory == None )
				{
					ClosestInventory = PotentialInventory;
				}
				else
				{
					if( VSize( PotentialInventory.Location - Location ) < VSize( ClosestInventory .Location - Location ) )
					{
						ClosestInventory = PotentialInventory;
					}
				}
				if( ( ClosestInventory != None ) &&
						( ActorReachable( ClosestInventory ) ||
						( FindPathToward( ClosestInventory ) != None ) ) )
      			{
					bFindAvailableInventory = true;
					FoundInventory = Inventory( InventorySorter.GetItem( i ) );
					break;
    	   	 	}
    	    }
		}
	}
	class'Debug'.static.DebugLog( Self, "FindAvailableInventory ItemCount " $ ItemCount, 'AngrealUser' );
	class'Debug'.static.DebugLog( Self, "FindAvailableInventory returning " $ bFindAvailableInventory, 'AngrealUser' );
	return bFindAvailableInventory;
}



function bool RejectInventory( Inventory PotentialInventory )
{
	return !PotentialInventory.IsInState( 'PickUp' );
}



state SuccessfullyNavigatedToGoal
{
	function BeginState()
	{
		Super.BeginState();
   		if( GetGoal( CurrentGoalIdx ).IsGoalA( Self, class'AngrealSpawnPool'.Name ) )
   		{
			SuccessfullyNavigatedToAngrealSpawnPool();
   		}
	}
	
	function SuccessfullyNavigatedToAngrealSpawnPool()
	{
		local Inventory InventoryToGet;
		if( FindAvailableInventory( InventoryToGet ) )
		{
			InitGoalWithObject( EGoalIndex.GI_Intermediate, InventoryToGet );
		}
		else
		{
			InvalidateGoal( CurrentGoalIdx );
		}
		PostTrackGoal();
	}
}



state () WaitingIdle
{
	function OnWaitingNotification( Notifier Notification )
	{
		local Inventory InventoryToGet;
		bIsPlayer = true;
		if( FindAvailableInventory( InventoryToGet ) )
		{
			InitGoalWithObject( EGoalIndex.GI_Intermediate, InventoryToGet );
		}
		else
		{
			Super.OnWaitingNotification( Notification );
		}
	}
}
*/

// xxxrlo:
function Killed( pawn Killer, pawn Other, name DamageType )
{
	local Actor GoalActor;

	if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) )
	{
		if( GoalActor == Other )
		{
			// may have started a "volley" -- make sure we stop if target died
			CeaseUsingAngreal();
		}
	}

	Super.Killed( Killer, Other, DamageType );
}

defaultproperties
{
     AII_MinInitialCharges(0)=-1
     AII_MinInitialCharges(1)=-1
     AII_MinInitialCharges(2)=-1
     AII_MinInitialCharges(3)=-1
     AII_MinInitialCharges(4)=-1
     AII_MinInitialCharges(5)=-1
     AII_MinInitialCharges(6)=-1
     AII_MinInitialCharges(7)=-1
     AII_MinInitialCharges(8)=-1
     AII_MinInitialCharges(9)=-1
     AII_MinInitialCharges(10)=-1
     AII_MinInitialCharges(11)=-1
     AII_MinInitialCharges(12)=-1
     AII_MinInitialCharges(13)=-1
     AII_MinInitialCharges(14)=-1
     AII_MaxInitialCharges(0)=-1
     AII_MaxInitialCharges(1)=-1
     AII_MaxInitialCharges(2)=-1
     AII_MaxInitialCharges(3)=-1
     AII_MaxInitialCharges(4)=-1
     AII_MaxInitialCharges(5)=-1
     AII_MaxInitialCharges(6)=-1
     AII_MaxInitialCharges(7)=-1
     AII_MaxInitialCharges(8)=-1
     AII_MaxInitialCharges(9)=-1
     AII_MaxInitialCharges(10)=-1
     AII_MaxInitialCharges(11)=-1
     AII_MaxInitialCharges(12)=-1
     AII_MaxInitialCharges(13)=-1
     AII_MaxInitialCharges(14)=-1
     AII_Priority(0)=-1.000000
     AII_Priority(1)=-1.000000
     AII_Priority(2)=-1.000000
     AII_Priority(3)=-1.000000
     AII_Priority(4)=-1.000000
     AII_Priority(5)=-1.000000
     AII_Priority(6)=-1.000000
     AII_Priority(7)=-1.000000
     AII_Priority(8)=-1.000000
     AII_Priority(9)=-1.000000
     AII_Priority(10)=-1.000000
     AII_Priority(11)=-1.000000
     AII_Priority(12)=-1.000000
     AII_Priority(13)=-1.000000
     AII_Priority(14)=-1.000000
     AII_MinChargesInGroup(0)=-1
     AII_MinChargesInGroup(1)=-1
     AII_MinChargesInGroup(2)=-1
     AII_MinChargesInGroup(3)=-1
     AII_MinChargesInGroup(4)=-1
     AII_MinChargesInGroup(5)=-1
     AII_MinChargesInGroup(6)=-1
     AII_MinChargesInGroup(7)=-1
     AII_MinChargesInGroup(8)=-1
     AII_MinChargesInGroup(9)=-1
     AII_MinChargesInGroup(10)=-1
     AII_MinChargesInGroup(11)=-1
     AII_MinChargesInGroup(12)=-1
     AII_MinChargesInGroup(13)=-1
     AII_MinChargesInGroup(14)=-1
     AII_MaxChargesInGroup(0)=-1
     AII_MaxChargesInGroup(1)=-1
     AII_MaxChargesInGroup(2)=-1
     AII_MaxChargesInGroup(3)=-1
     AII_MaxChargesInGroup(4)=-1
     AII_MaxChargesInGroup(5)=-1
     AII_MaxChargesInGroup(6)=-1
     AII_MaxChargesInGroup(7)=-1
     AII_MaxChargesInGroup(8)=-1
     AII_MaxChargesInGroup(9)=-1
     AII_MaxChargesInGroup(10)=-1
     AII_MaxChargesInGroup(11)=-1
     AII_MaxChargesInGroup(12)=-1
     AII_MaxChargesInGroup(13)=-1
     AII_MaxChargesInGroup(14)=-1
     AII_MinChargeGroupInterval(0)=-1.000000
     AII_MinChargeGroupInterval(1)=-1.000000
     AII_MinChargeGroupInterval(2)=-1.000000
     AII_MinChargeGroupInterval(3)=-1.000000
     AII_MinChargeGroupInterval(4)=-1.000000
     AII_MinChargeGroupInterval(5)=-1.000000
     AII_MinChargeGroupInterval(6)=-1.000000
     AII_MinChargeGroupInterval(7)=-1.000000
     AII_MinChargeGroupInterval(8)=-1.000000
     AII_MinChargeGroupInterval(9)=-1.000000
     AII_MinChargeGroupInterval(10)=-1.000000
     AII_MinChargeGroupInterval(11)=-1.000000
     AII_MinChargeGroupInterval(12)=-1.000000
     AII_MinChargeGroupInterval(13)=-1.000000
     AII_MinChargeGroupInterval(14)=-1.000000
     AII_MaxChargeUsedInterval(0)=-1.000000
     AII_MaxChargeUsedInterval(1)=-1.000000
     AII_MaxChargeUsedInterval(2)=-1.000000
     AII_MaxChargeUsedInterval(3)=-1.000000
     AII_MaxChargeUsedInterval(4)=-1.000000
     AII_MaxChargeUsedInterval(5)=-1.000000
     AII_MaxChargeUsedInterval(6)=-1.000000
     AII_MaxChargeUsedInterval(7)=-1.000000
     AII_MaxChargeUsedInterval(8)=-1.000000
     AII_MaxChargeUsedInterval(9)=-1.000000
     AII_MaxChargeUsedInterval(10)=-1.000000
     AII_MaxChargeUsedInterval(11)=-1.000000
     AII_MaxChargeUsedInterval(12)=-1.000000
     AII_MaxChargeUsedInterval(13)=-1.000000
     AII_MaxChargeUsedInterval(14)=-1.000000
     AII_NPCRespawnTime(0)=-1.000000
     AII_NPCRespawnTime(1)=-1.000000
     AII_NPCRespawnTime(2)=-1.000000
     AII_NPCRespawnTime(3)=-1.000000
     AII_NPCRespawnTime(4)=-1.000000
     AII_NPCRespawnTime(5)=-1.000000
     AII_NPCRespawnTime(6)=-1.000000
     AII_NPCRespawnTime(7)=-1.000000
     AII_NPCRespawnTime(8)=-1.000000
     AII_NPCRespawnTime(9)=-1.000000
     AII_NPCRespawnTime(10)=-1.000000
     AII_NPCRespawnTime(11)=-1.000000
     AII_NPCRespawnTime(12)=-1.000000
     AII_NPCRespawnTime(13)=-1.000000
     AII_NPCRespawnTime(14)=-1.000000
     DefaultWeaponType=Class'WOT.AngrealWeaponAdapter'
     RangedWeaponType=Class'WOT.AngrealWeaponAdapter'
     DebugCategoryName=AngrealUser
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryAngrealUser'
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorAngrealUser'
     MeleeRange=0.000000
}
