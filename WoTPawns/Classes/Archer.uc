//=============================================================================
// Archer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 19 $
//=============================================================================

// The captain for the Whitcloak

class Archer expands ArcherAssets;

#exec MESH NOTIFY MESH=Archer SEQ=AttackRunSwipe   TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Archer SEQ=AttackRunSwipe   TIME=0.45 FUNCTION=SwipeDamageTarget

#exec MESH NOTIFY MESH=Archer SEQ=AttackRunSkewer  TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Archer SEQ=AttackRunSkewer  TIME=0.40 FUNCTION=SkewerDamageTarget

#exec MESH NOTIFY MESH=Archer SEQ=DrawSwrd         TIME=0.50 FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Archer SEQ=DrawSwrd         TIME=0.55 FUNCTION=PlayDrawSwordSound

#exec MESH NOTIFY MESH=Archer SEQ=SheathSwrd       TIME=0.50 FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Archer SEQ=SheathSwrd	   TIME=0.55 FUNCTION=PlaySheathSwordSound

#exec MESH NOTIFY MESH=Archer SEQ=Look             TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Archer SEQ=GiveOrders       TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Archer SEQ=ReactP  	       TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Archer SEQ=ReactPLoop       TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Archer  SEQ=Walk            TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Archer  SEQ=Walk            TIME=0.75 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Archer  SEQ=Run             TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Archer  SEQ=Run             TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Archer  SEQ=DeathB			TIME=0.80 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Archer  SEQ=DeathF			TIME=0.70 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Archer  SEQ=DeathKneel		TIME=0.55  FUNCTION=TransitionToCarcassNotification

var () float SwipeDamage;        //Total damage this attack sequence does
var () float SkewerDamage;       //Total damage this attack sequence does
var () float BowDrawnTimerDuration;
var () float BowDrawnSleepDuration;
var () float SwitchToMeleeDistance;
var () float RickyPauseTime;

var float ProjectileAttackingStateEntryTime;

const MinProjectileAttackingStateExitInterval = 5.0; //how long before the projectile attacking state should be exited

const HitKneelAnimSlot				= 'HitKneel';
const HitHardKneelAnimSlot			= 'HitHardKneel';
const KneelAnimSlot					= 'Kneel';
const DeathKneelAnimSlot			= 'DeathKneel';
const DrawAnimSlot					= 'Draw';
const ReleaseAnimSlot				= 'Release';
const GetupAnimSlot					= 'GetUp';



function PlaySheathSwordSound()
{
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeSheathSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
}



function PlayDrawSwordSound()
{
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeDrawSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
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
	}
	if( bGetPendingWeapon )
	{
		bPreferAcquiredVisibilityHandler = true;
	}
	else
	{
		bGetPendingWeapon = Super.GetPendingWeapon( NewPendingWeapon );
	}
	class'Debug'.static.DebugLog( Self, "GetPendingWeapon NewPendingWeapon " $ NewPendingWeapon, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "GetPendingWeapon returning " $ bGetPendingWeapon, DebugCategoryName );
	return bGetPendingWeapon;
}



state PerformMeleeWeaponAttack
{
	function SwipeDamageTarget()
	{
		AttackDamageTarget( SwipeDamage, 0.0, 'Sliced' );
	}

	function SkewerDamageTarget()
	{
		AttackDamageTarget( SkewerDamage, 0.0, 'Skewered' );
	}
}



//=============================================================================
//	PerformProjectileAttack state
//=============================================================================

state PerformProjectileAttack
{
	function BeginState()
	{
		ProjectileAttackingStateEntryTime = Level.TimeSeconds;
		Super.BeginState();
	}
	
	function bool GetPendingWeapon( out Weapon NewPendingWeapon )
	{
		NewPendingWeapon = class'Util'.static.GetInventoryWeapon( Self, MeleeWeaponType );
		return ( NewPendingWeapon != None );
	}

	function ReleaseBow()
	{
		Super.ShootRangedAmmo();
	}

	function PlayDeathHit( float Damage, vector HitLocation, name DamageType )
	{
		AnimationTableClass.static.PlaySlotAnim( Self, DeathKneelAnimSlot );   
	}

	function Timer()
	{
	    if( GetGoal( CurrentGoalIdx ).IsGoalVisible( Self ) )
    	{
			StopWaiting();
    		GotoState( GetStateName(), 'ReleaseBow' );
    	}
	}
	
	function HandleHint( Name Hint )
	{
		class'Debug'.static.DebugLog( Self, "HandleHint Hint " $ Hint, DebugCategoryName );
		Super.HandleHint( Hint );
		switch( Hint )
		{
			case HintName_SwitchMeleeWeapon:
			case HintName_PreferMeleeWeapon:
				GotoState( GetStateName(), 'PostPerformingAttack' );
				break;
			default:
				break;
		}
	}

	function bool CheckForMeleeSwitch()
	{
		local float GoalDistance;
		local bool bSwitchToMelee;
		if( ( Level.TimeSeconds - ProjectileAttackingStateEntryTime ) > MinProjectileAttackingStateExitInterval )
		{
			GetGoal( CurrentGoalIdx ).GetGoalDistance( Self, GoalDistance, Self );
			if( GoalDistance < SwitchToMeleeDistance )
			{
	    		bSwitchToMelee = true;
			}
		}
		return bSwitchToMelee;
	}

	//=============================================================================
	// Archer has special hit animations when he is kneeling.
	//=============================================================================
	
	function name GetHitAnimSeqName( vector HitLoc, int Damage )
	{
		if( IsHardHit( Damage ) )
		{
			return HitHardKneelAnimSlot;
		}
		else
		{
			return HitKneelAnimSlot;
		}
	}

PrePerformingAttack:
//the archer kneels down
	class'Debug'.static.DebugLog( Self, "PrePerformingAttack:", class'Debug'.default.DC_StateCode );
	StopMovement();
	AnimationTableClass.static.TweenPlaySlotAnim( Self, KneelAnimSlot );   
	FinishAnim();
	PrePerformingAttack();

PerformingAttack:
//the archer draws his bow
	AnimationTableClass.static.TweenPlaySlotAnim( Self, DrawAnimSlot );   
   	FinishAnim();
    if( GetGoal( CurrentGoalIdx ).IsGoalVisible( Self ) )
   	{

PreReleaseBow:
	Goto( 'PostReleaseBow' );
	
ReleaseBow:
	Sleep( RickyPauseTime );
	
PostReleaseBow:
	   	TimerRate = 0;
		ReleaseBow();
		AnimationTableClass.static.TweenPlaySlotAnim( Self, ReleaseAnimSlot );   
    	FinishAnim();
    	if( CheckForMeleeSwitch() )
    	{
			SwitchToBestWeapon();
   			Goto( 'PostPerformingAttack' );
    	}
    	else
    	{
	   		Goto( 'PerformingAttack' );
	   	}
	}
	SetTimer( BowDrawnTimerDuration, true );
	Sleep( BowDrawnSleepDuration );
   	TimerRate = 0;
	PerformingAttack();

PostPerformingAttack:
//the archer gets up
	AnimationTableClass.static.TweenPlaySlotAnim( Self, GetUpAnimSlot );   
	FinishAnim();
	PostPerformingAttack();
}

defaultproperties
{
     SwipeDamage=30.000000
     SkewerDamage=30.000000
     BowDrawnTimerDuration=0.150000
     BowDrawnSleepDuration=5.000000
     SwitchToMeleeDistance=320.000000
     RickyPauseTime=0.150000
     BaseWalkingSpeed=187.500000
     DefaultWeaponType=Class'WOTPawns.ArcherBowProxy'
     MeleeWeaponType=Class'WOTPawns.ArcherSword'
     RangedWeaponType=Class'WOTPawns.ArcherBowProxy'
     MinTimeBetweenWeaponSwitch=5.000000
     GroundSpeedMin=750.000000
     GroundSpeedMax=750.000000
     HealthMPMin=350.000000
     HealthMPMax=350.000000
     HealthSPMin=350.000000
     HealthSPMax=350.000000
     ChanceOfHitAnim=0.050000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableArcher'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListArcher'
     AnimationTableClass=Class'WOTPawns.AnimationTableArcher'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     HitSoftHealthRatio=0.000000
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryArcher'
     GoalSuggestedSpeeds(0)=750.000000
     GoalSuggestedSpeeds(2)=750.000000
     GoalSuggestedSpeeds(3)=750.000000
     GoalSuggestedSpeeds(4)=750.000000
     GoalSuggestedSpeeds(5)=750.000000
     GoalSuggestedSpeeds(6)=187.500000
     MeleeRange=50.000000
     GroundSpeed=750.000000
     CollisionRadius=30.000000
     Mass=200.000000
}
