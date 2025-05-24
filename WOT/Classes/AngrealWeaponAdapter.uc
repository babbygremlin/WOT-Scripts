//=============================================================================
// AngrealWeaponAdapter.
// $Author: Mfox $
// $Date: 1/10/00 1:51p $
// $Revision: 17 $
//=============================================================================

class AngrealWeaponAdapter expands WotWeapon;

var AngrealInventory	AdaptedItem;
var AngrealInventory	SelectedOffensiveItem;
var AngrealInventory	SelectedDefensiveItem;
var DurationNotifier	ItemUsageMonitor; 		//this is effectively the release the button notification

//per (npc) angreal weapon adapter info
var () float MinOffensiveUsageInterval; //at least this amount of time must elapse between offensive item selctions
var () float MinDefensiveUsageInterval; //at least this amount of time must elapse between defensive item selctions

var private float LastOffensiveUsageTime;
var private float LastDefensiveUsageTime;



function Destroyed()
{
	if( ItemUsageMonitor != None )
	{
		ItemUsageMonitor.Delete();
		ItemUsageMonitor = None;
	}
	Super.Destroyed();
}



function PostBeginPlay()
{
	Super.PostBeginPlay();
	ConstructDurationNotifiers();
}



function ConstructDurationNotifiers()
{
	if( ItemUsageMonitor == None )
	{
		ItemUsageMonitor = DurationNotifier( class'DurationNotifier'.static.CreateNotifier( Self, 'OnItemUsageNotification' ) );
		ItemUsageMonitor.bRandomizeElapsedTime = false;
	}
}



function Tick( float DeltaTime )
{
	local Rotator AimDirection;
	class'Debug'.static.DebugLog( Owner, "Tick", class'Debug'.default.DC_EngineNotification );
	if( ItemUsageMonitor.bEnabled && ( AdaptedItem != None ) && ( GetSelector() != None ) &&
			( GetSelector().SelectedItem == AdaptedItem ) )
	{
		//xxxrlo AimDirection = GetGoalAimDirection( GetSelector(), AdaptedItem.GetVictim(), AdaptedItem.GetLeadSpeed(),
		//xxxrlo 		GetAimSource( GetSelector(), AdaptedItem.GetVictim().Location ), AdaptedItem.MissOdds );
		AimDirection = AdaptedItem.GetBestTrajectory();
		GetSelector().ViewRotation = AimDirection;
		GetSelector().DesiredRotation = AimDirection;
	}
	ItemUsageMonitor.OnReflectedTick( Self, DeltaTime );
	Super.Tick( DeltaTime );
}



function bool IsCasting()
{
	return ( ( AdaptedItem != None ) && ( AdaptedItem.MaxChargeUsedInterval == 0 ) && ItemUsageMonitor.bEnabled );
}



function ChargeUsed( AngrealInventory Item )
{
	local float CastDuration;
	class'Debug'.static.DebugLog( Owner, "ChargeUsed used a charge of " $ Item.Name $ " she has " $ Item.CurCharges $ " left.", DebugCategoryName );
	if( ( Item != None ) && ( Item == AdaptedItem ) )
	{
		if( AdaptedItem.bDefensive )
		{
			LastDefensiveUsageTime = Level.TimeSeconds;
		}
		else
		{
			LastOffensiveUsageTime = Level.TimeSeconds;
		}
		
		if( AdaptedItem.ShouldUncast() )
		{
			//release the button
			GetSelector().CeaseUsingAngreal();
			ItemUsageMonitor.DisableNotifier();
		}

		if( AdaptedItem.ShouldCast() )
		{
			if( AdaptedItem.GetCastDuration( CastDuration ) )
			{
				//callback when supposed to release the button or
				//callback when supposed to press the button again
				ItemUsageMonitor.SetDuration( CastDuration );
				ItemUsageMonitor.EnableNotifier();
			}
		}
		else
		{
			//the weapon can not be used anymore right now
			AdaptedItem = None;
			DeterminedWeaponUsage = WU_None;
		}
	}
}



function CeaseUsingAngreal()
{
	if( AdaptedItem != None )
	{
		AdaptedItem.Uncast();

		ItemUsageMonitor.DisableNotifier();
	}
}



function WotPawn GetSelector()
{
	return WotPawn( Owner );
}



//=============================================================================
// If an angreal user calls UseAngreal but never calls CeaseUsingAngreal it is
// equivalent of a player pressing the fire button but never releasing it.
// The code below calls CeaseUsingAngreal after some time to "release" the
// firing key.
//=============================================================================

function OnItemUsageNotification( Notifier Notification )
{
	local Actor GoalActor;

	class'Debug'.static.DebugLog( Owner, "OnItemUsageNotification", DebugCategoryName );
	if( ( AdaptedItem != None ) && ( GetSelector() != None ) &&
			( GetSelector().SelectedItem == AdaptedItem ) &&
			AdaptedItem.ShouldCast() )
	{
		// xxxrlo:
		GoalActor = AdaptedItem.GetVictim();
		if( GoalActor != None && Pawn(Owner) != None && class'Util'.static.PawnCanSeeActor( Pawn(Owner), GoalActor ) )
		{
			UseCurrentAngreal();
		}
		else
		{
			// may have started a "volley" -- make sure we stop if target no longer visible
            // xxxrlo: add check for auto-target above so bots can use this
			CeaseUsingAngreal();
		}
	}
}



function UseProjectileWeapon( Actor Invoker, GoalAbstracterInterf TargetGoal )
{
	Assert( Invoker == GetSelector() );
	if( ( SelectedOffensiveItem != None ) && ( SelectedDefensiveItem != None ) )
	{
		assert( false );
	}
	else if( SelectedOffensiveItem != None )
	{
		AdaptedItem = SelectedOffensiveItem;
		SelectedOffensiveItem = None;
	}
	else if( SelectedDefensiveItem != None )
	{
		AdaptedItem = SelectedDefensiveItem;
		SelectedDefensiveItem = None;
	}

	if( AdaptedItem != None )
	{
		GetSelector().SelectedItem = AdaptedItem;
		Super.UseProjectileWeapon( Invoker, TargetGoal );
	}
}
	
	
	
function FireProjectile( Actor Invoker, Vector ProjectileSource, Rotator ProjectileDirection )
{
	class'Debug'.static.DebugLog( Owner, "FireProjectile", DebugCategoryName );
	if( AdaptedItem.ShouldCast() )
	{
		UseCurrentAngreal();
	}
}


function UseCurrentAngreal()
{
	class'Debug'.static.DebugLog( Owner, "UseCurrentAngreal", DebugCategoryName );
	Assert( AdaptedItem != None );
	if( AdaptedItem.ShouldCast() )
	{
		class'Debug'.static.DebugLog( Owner, "UseCurrentAngreal using", DebugCategoryName );
		GetSelector().UseAngreal();
	}
	else
	{
		class'Debug'.static.DebugLog( Owner, "UseCurrentAngreal failed", DebugCategoryName );
		AdaptedItem.Failed();
	}
}



function DetermineWeaponUsage( Actor Invoker, GoalAbstracterInterf AttackGoal )
{
	//preservation of old interface assumes weapons are only offensive
	DetermineOffensiveUsage( AttackGoal );
}



function DetermineOffensiveUsage( GoalAbstracterInterf AttackGoal )
{
	class'Debug'.static.DebugLog( Owner, "DetermineOffensiveUsage", DebugCategoryName );
	if( CanUseAngreal() && SelectOffensiveAngreal( AttackGoal, SelectedOffensiveItem ) )
	{
		//the weapon can be used
		DeterminedWeaponUsage = WU_Projectile;
		SelectedOffensiveItem.InitChargeGroup();
		SelectedDefensiveItem = None;
	}
	else if( SelectedDefensiveItem == None )
	{
		//the weapon can not be used
		DeterminedWeaponUsage = WU_None;
	}
	class'Debug'.static.DebugLog( Owner, "DetermineOffensiveUsage SelectedOffensiveItem " $ SelectedOffensiveItem, DebugCategoryName );
	class'Debug'.static.DebugLog( Owner, "DetermineOffensiveUsage DeterminedWeaponUsage " $ DeterminedWeaponUsage, DebugCategoryName );
}



function DetermineDefensiveUsage( Actor InvokationInstigator )
{
	class'Debug'.static.DebugLog( Owner, "DetermineDefensiveUsage", DebugCategoryName );
	if( CanUseAngreal() && SelectDefensiveAngreal( InvokationInstigator, SelectedDefensiveItem ) )
	{
		//the weapon can be used
		DeterminedWeaponUsage = WU_Projectile;
		SelectedDefensiveItem.InitChargeGroup();
		SelectedOffensiveItem = None;
	}
	else if( SelectedOffensiveItem == None )
	{
		//the weapon can not be used
		DeterminedWeaponUsage = WU_None;
	}
	class'Debug'.static.DebugLog( Owner, "DetermineDefensiveUsage SelectedDefensiveItem " $ SelectedDefensiveItem, DebugCategoryName );
	class'Debug'.static.DebugLog( Owner, "DetermineDefensiveUsage DeterminedWeaponUsage " $ DeterminedWeaponUsage, DebugCategoryName );
}



//designed to only be called by DetermineDefensiveUsage
function bool SelectDefensiveAngreal( Actor DefendAgainst, out AngrealInventory SelectedAngrealInventory )
{
	local Inventory CurrentInventoryItem;
	local float CurrentPriority, HighestPriority;
	local AngrealInventory CurrentAngrealInventoryItem;
	local bool bSelected;

	class'Debug'.static.DebugLog( Owner, "SelectDefensiveAngreal DefendAgainst " $ DefendAgainst, DebugCategoryName );
	if( Level.TimeSeconds > ( LastDefensiveUsageTime + MinDefensiveUsageInterval ) )
	{
		for( CurrentInventoryItem = GetSelector().Inventory;
			( CurrentInventoryItem != None );
			CurrentInventoryItem = CurrentInventoryItem.Inventory )
		{
			CurrentAngrealInventoryItem = AngrealInventory( CurrentInventoryItem );
			if( ( CurrentAngrealInventoryItem != None ) &&
					( CurrentAngrealInventoryItem != AdaptedItem ) &&
					CurrentAngrealInventoryItem.bDefensive )
			{
				CurrentAngrealInventoryItem.SetVictim( DefendAgainst );
				if( CurrentAngrealInventoryItem.GetEffectivePriority( CurrentPriority ) &&
						( !bSelected || ( CurrentPriority > HighestPriority ) ) )
				{
					HighestPriority = CurrentPriority;
					SelectedAngrealInventory = CurrentAngrealInventoryItem;
					bSelected = true;
				}
			}
		}
	}
	class'Debug'.static.DebugLog( Owner, "SelectDefensiveAngreal returning " $ bSelected, DebugCategoryName );
	return bSelected;
}



//designed to only be called by DetermineOffensiveUsage
function bool SelectOffensiveAngreal( GoalAbstracterInterf OffensiveGoal, out AngrealInventory SelectedAngrealInventory )
{
	local Actor OffensiveGoalActor;
	local Inventory CurrentInventoryItem;
	local float CurrentPriority, HighestPriority;
	local AngrealInventory CurrentAngrealInventoryItem;
	local bool bSelected;

	class'Debug'.static.DebugLog( Owner, "SelectOffensiveAngreal", DebugCategoryName );
	if( OffensiveGoal.GetGoalActor( GetSelector(), OffensiveGoalActor ) &&
			( Level.TimeSeconds > ( LastOffensiveUsageTime + MinOffensiveUsageInterval ) ) )
	{
		for( CurrentInventoryItem = GetSelector().Inventory;
			( CurrentInventoryItem != None );
			CurrentInventoryItem = CurrentInventoryItem.Inventory )
		{
			CurrentAngrealInventoryItem = AngrealInventory( CurrentInventoryItem );
			class'Debug'.static.DebugLog( Owner, "SelectOffensiveAngreal CurrentAngrealInventoryItem " $ CurrentAngrealInventoryItem, DebugCategoryName );
			if( ( CurrentAngrealInventoryItem != None ) &&
					( CurrentAngrealInventoryItem != AdaptedItem ) &&
					CurrentAngrealInventoryItem.bOffensive &&
					( !bRequireTargetVisibility || OffensiveGoal.IsGoalVisible( GetSelector() ) ) )
			{
				CurrentAngrealInventoryItem.SetVictim( OffensiveGoalActor );
				if( CurrentAngrealInventoryItem.GetEffectivePriority( CurrentPriority ) &&
						( !bSelected || ( CurrentPriority > HighestPriority ) ) )
				{
					HighestPriority = CurrentPriority;
					SelectedAngrealInventory = CurrentAngrealInventoryItem;
					bSelected = true;
				}
			}
		}
	}
	class'Debug'.static.DebugLog( Owner, "SelectOffensiveAngreal returning " $ bSelected, DebugCategoryName );
	return bSelected;
}




function bool CanUseAngreal()
{
	local bool bCantCast;
	local ReflectorIterator ReflectorIter;

	if( !ItemUsageMonitor.bEnabled && GetSelector() != None )
	{
		//xxxrlo I don't like this being in here but it works
		ReflectorIter = class'ReflectorIterator'.static.GetIteratorFor( GetSelector() );
		for( ReflectorIter.First(); !ReflectorIter.IsDone(); ReflectorIter.Next() )
		{
			if( ReflectorIter.GetCurrent().IsA( 'NoCastReflector' ) )
			{
				bCantCast = true;
				break;
			}
		}
		ReflectorIter.Reset();
		ReflectorIter = None;
	}
	else
	{
		bCantCast = true;
	}
	class'Debug'.static.DebugLog( Owner, "CanUseAngreal returning " $ !bCantCast, DebugCategoryName );
	return !bCantCast;
}



//=============================================================================
// Aim support
//=============================================================================



function bool IsLeadable()
{
	return AdaptedItem.IsLeadable();
}



function Vector GetAimSource( Actor Invoker, Vector TargetLocation )
{
	return AdaptedItem.GetTrajectorySource();
}



function GetLeadAim( out Rotator AimDirection, Actor Invoker, Vector AimSource, GoalAbstracterInterf TargetGoal )
{
	AimDirection = AdaptedItem.GetBestTrajectory();
}



/*
// one shot angreal which shouldn't be hard to use:
     "Angreal.AngrealInvFireball"
     "Angreal.AngrealInvSeeker"
     "Angreal.AngrealInvDecay"
     "Angreal.AngrealInvEarthTremor"
     "Angreal.AngrealInvShift"
     "Angreal.AngrealInvTaint"
     "Angreal.AngrealInvSoulBarb"
     "Angreal.AngrealInvSwapPlaces"

// continuous fire angreal -- have to do CeaseUsingAngreal
     "Angreal.AngrealInvDart"
     "Angreal.AngrealInvLightning"
     "Angreal.AngrealInvBalefire"

// defensive etc.
     "Angreal.AngrealInvHeal"
     "Angreal.AngrealInvReflect"
     "Angreal.AngrealInvAbsorb"
     "Angreal.AngrealInvAirShield"
     "Angreal.AngrealInvEarthShield"
     "Angreal.AngrealInvFireShield"
     "Angreal.AngrealInvSpiritShield"
     "Angreal.AngrealInvWaterShield"
     "Angreal.AngrealInvShield"
     "Angreal.AngrealInvAMA"
     "Angreal.AngrealInvRemoveCurse"

// TBD:
     "Angreal.AngrealInvDisguise"
     "Angreal.AngrealInvIllusion"
     "Angreal.AngrealInvDistantEye"
     "Angreal.AngrealInvTrapDetect"
     "Angreal.AngrealInvLevitate"
     "Angreal.AngrealInvWhirlwind"
     "Angreal.AngrealInvStasis"

// minion's, guardians, champions
     "Angreal.AngrealInvGuardian"
     "Angreal.AngrealInvMinion"
     "Angreal.AngrealInvChampion"

// not sure
     "Angreal.AngrealInvTarget"
     "Angreal.AngrealInvFork"
     "Angreal.AngrealInvTracer"
     "Angreal.AngrealInvWallOfAir"
     "Angreal.AngrealInvExpWard"
*/

defaultproperties
{
     DebugCategoryName=AngrealWeaponAdapter
     MaxProjectileRange=10000.000000
     ProjectileEffectiveness=1.000000
}
