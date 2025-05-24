//=============================================================================
// WotWeapon.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 9 $
//=============================================================================

class WotWeapon expands Weapon;

enum EWeaponUsage
{
	WU_None,
	WU_Melee,
	WU_Projectile
};

var () const editconst Name DebugCategoryName;
var EWeaponUsage DeterminedWeaponUsage;
var () class<Actor> TypeCapableOfPreparation;

var () float MinMeleeRange;				//min distance for determining melee usage
var () float MaxMeleeRange;				//max distance for determining melee usage
var () float MeleeEffectiveness;		//used to determine weapon usege in the event that both melee and projectile useage apply

var () float MinProjectileRange;		//min distance for determining projectile usage
var () float MaxProjectileRange;		//max distance for determining projectile usage
var () float ProjectileEffectiveness;	//used to determine weapon usege in the event that both melee and projectile useage apply
var () class<WotProjectile> WotWeaponProjectileType;
var () bool bRequireTargetVisibility;

var () int Health;
var() Texture DamageSkin0;
var() Texture DamageSkin1;
var() Texture DamageSkin2;

var() string TossedDecorationTypeString;	//type of decoration to spawn when weapon tossed
var() float SPTossedLifeSpan;					//LifeSpan of tossed weapons (bounceable decorations) in SP
var() float MPTossedLifeSpan;					//LifeSpan of tossed weapons (bounceable decorations) in MP

var() float MissOdds;
var() string DestroyedSoundString;
var Sound DestroyedSound;

var () const editconst Name RemovedFromOwnerInventoryEvent;
var () const editconst Name DestroyedEvent;



//=============================================================================
// begin - unreal engine function overrides
//=============================================================================



function PreBeginPlay()
{
	Super.PreBeginPlay();

	if( DestroyedSoundString != "" )
	{
		DestroyedSound = Sound( DynamicLoadObject( DestroyedSoundString, class'Sound' ) );
	}
}



//keep items spawned in PreBeginPlay from going into Initial state
simulated event SetInitialState()
{
	class'Debug'.static.DebugLog( Self, "SetInitialState", DebugCategoryName );
	if( !bHeldItem )
	{
		Super.SetInitialState();
	}
	class'Debug'.static.DebugLog( Self, "SetInitialState bHeldItem: " $ bHeldItem, DebugCategoryName );
}



function Destroyed()
{
	//use a trigger to tell our owner that
	class'Util'.static.TriggerActor( Self, Owner, None, DestroyedEvent );
	Super.Destroyed();
}



function Trigger( Actor Other, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "Trigger Other " $ Other, class'Debug'.default.DC_Notification );
	Super.Trigger( Other, EventInstigator );
	if( Other.IsA( 'WotProjectile' ) )
	{
		OnTriggeredByWotProjectile( WotProjectile( Other ) );
	}
}



function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Name DamageType )
{
    Health -= Damage;
	if( Health <= 0 )
	{
		OnWeaponTakeFatalDamage();
	}
	else
	{
		OnWeaponTakeNonFatalDamage();
	}
}



//don't want the base class implementation called because it
//refers to anims that don't eist
function PlaySelect() {}
function TweenDown() {}
function TweenSelect() {}



function SpawnTossedWeapon( Vector StartLocation )
{
    local BounceableDecoration BounceableWeaponDecoration;
	local class<BounceableDecoration> BounceableDecorationClass;
	
	if( TossedDecorationTypeString != "" )
	{
		BounceableDecorationClass = class<BounceableDecoration>( DynamicLoadObject( TossedDecorationTypeString, class'Class' ) );
	    BounceableWeaponDecoration = Spawn( BounceableDecorationClass );
	    if( ( BounceableWeaponDecoration != None ) && BounceableWeaponDecoration.SetLocation( StartLocation ) )
	    {
		    BounceableWeaponDecoration.InitFor( Self );
			if( Level.Netmode == NM_Standalone )
			{
			    BounceableWeaponDecoration.LifeSpan = SPTossedLifeSpan;
			}
			else
			{
			    BounceableWeaponDecoration.LifeSpan = MPTossedLifeSpan;
			}
		}
	}
}



//Toss this weapon out
function DropFrom( Vector StartLocation )
{
	//We want NPCs to throw their weapon when they die but we do not want
	//these to become pickup items and they should fade away after a while.
	SpawnTossedWeapon( StartLocation );
	Destroy();	
}



//Finish a firing sequence
function Finish()
{
	//Log( "Finish" );
	if( bChangeWeapon )
	{
		//Log( "Finish 0" );
		GotoState( 'DownWeapon' );
	}
	else if( Owner.IsA( 'PlayerPawn' ) )
	{
		//Log( "Finish 1" );
		//the owner is a player pawn
		if( ( ( AmmoType != None ) && ( AmmoType.AmmoAmount <= 0 ) ) ||
				( Pawn( Owner ).Weapon != self ) )
		{
			GotoState( 'Idle' );
		}
		else if( Pawn( Owner ).bFire !=0 )
		{
			Global.Fire( 0 );
		}
		else if( Pawn( Owner ).bAltFire != 0 )
		{
			Global.AltFire( 0 );
		}
		else
		{ 
			GotoState( 'Idle' );
		}
	}
	else if( Owner.IsA( 'Pawn' ) )
	{
		//Log( "Finish 2" );
		//the owner is not a player pawn
		//the owner is a pawn
		if( ( AmmoType != None ) && ( AmmoType.AmmoAmount <= 0 ) )
		{
			//Log( "Finish 3" );
			Pawn( Owner ).StopFiring();
			Pawn( Owner) .SwitchToBestWeapon();
		}
		else if( ( Pawn( Owner ).bFire != 0) && ( FRand() < RefireRate ) )
		{
			Global.Fire( 0 );
		}
		else if( ( Pawn( Owner ).bAltFire != 0 ) && ( FRand() < AltRefireRate ) )
		{
			Global.AltFire( 0 );
		}
		else
		{
			Pawn( Owner ).StopFiring();
			GotoState( 'Idle' );
		}
	}
}



//=============================================================================
// end - unreal engine function overrides
//=============================================================================



function OnTriggeredByWotProjectile( WotProjectile TriggeringWotProjectile )
{
	switch( TriggeringWotProjectile.Event )
	{
		case TriggeringWotProjectile.DestroyedEvent:
			OnWotProjectileDestroyed( TriggeringWotProjectile );
			break;
	}
}



function OnWotProjectileDestroyed( WotProjectile DestroyedWotProjectile )
{
}



function OnWeaponTakeFatalDamage()
{
	if( DestroyedSound != None )
	{
		Owner.PlaySound( DestroyedSound, SLOT_Interact );
	}
	
	Destroy(); //the base class implementation calls delete inventory on the pawn 
}



function OnWeaponTakeNonFatalDamage()
{
	// swap in weapon damage skins if applicable
	if( ( Health < default.Health / 3 ) && ( DamageSkin2 != None ) )
	{
		if( Skin != DamageSkin2 )
		{
			Skin = DamageSkin2;
		}
	}
	else if( ( Health < 2 * default.Health / 3 ) && ( DamageSkin1 != None ) )
	{
		if( Skin != DamageSkin1 )
		{
			Skin = DamageSkin1;
		}
	}
	else if( ( Health < default.Health ) && ( DamageSkin0 != None ) )
	{
		if( Skin != DamageSkin0 )
		{
			Skin = DamageSkin0;
		}
	}
}



function DetermineWeaponUsage( Actor Invoker, GoalAbstracterInterf AttackGoal )
{
	local float AttackGoalDistance;
	local bool bMeleeWeapon, bProjectileWeapon;

	AttackGoal.GetGoalDistance( Invoker, AttackGoalDistance, Invoker );
	
	if( !bRequireTargetVisibility || AttackGoal.IsGoalVisible( Invoker ) )
	{
		bMeleeWeapon = CanUseAsMeleeWeapon( Invoker, AttackGoal, AttackGoalDistance );
		bProjectileWeapon = CanUseAsProjectileWeapon( Invoker, AttackGoal, AttackGoalDistance );;
	
		if( bMeleeWeapon && bProjectileWeapon )
		{
			//the weapon could be used for both melee and projectile attacking
			if( MeleeEffectiveness > ProjectileEffectiveness )
			{
				//the weapon is more effective as a melee weapon
				DeterminedWeaponUsage = WU_Melee;
			}
			else
			{
				//the weapon is more effective as a projectile weapon
				DeterminedWeaponUsage = WU_Projectile;
			}
		}
		else if( bMeleeWeapon )
		{
			//the weapon can only be used in melee
			DeterminedWeaponUsage = WU_Melee;
		}
		else if( bProjectileWeapon )
		{
			//the weapon can only be used as a projectile weapon
			DeterminedWeaponUsage = WU_Projectile;
		}
		else
		{
			//the weapon can not be used
			DeterminedWeaponUsage = WU_None;
		}
	}
	else
	{
		//the weapon can not be used
		DeterminedWeaponUsage = WU_None;
	}

	class'Debug'.static.DebugLog( Self, "DetermineWeaponUsage bMeleeWeapon: " $ bMeleeWeapon, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "DetermineWeaponUsage bProjectileWeapon: " $ bProjectileWeapon, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "DetermineWeaponUsage AttackGoalDistance: " $ AttackGoalDistance, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "DetermineWeaponUsage DeterminedWeaponUsage: " $ DeterminedWeaponUsage, DebugCategoryName );
}



function EWeaponUsage GetWeaponUsage()
{
	return DeterminedWeaponUsage;
}



function bool CanUseAsMeleeWeapon( Actor Invoker, GoalAbstracterInterf AttackGoal, float AttackGoalDistance )
{
	class'Debug'.static.DebugLog( Self, "CanUseAsMeleeWeapon MinMeleeRange:" $ MinMeleeRange, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "CanUseAsMeleeWeapon MaxMeleeRange: " $ MaxMeleeRange, DebugCategoryName );
	return ( ( AttackGoalDistance >= MinMeleeRange ) &&
			( AttackGoalDistance <= MaxMeleeRange ) );
}



function bool CanUseAsProjectileWeapon( Actor Invoker, GoalAbstracterInterf AttackGoal, float AttackGoalDistance )
{
	class'Debug'.static.DebugLog( Self, "CanUseAsProjectileWeapon MinProjectileRange: " $ MinProjectileRange, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "CanUseAsProjectileWeapon MaxProjectileRange: " $ MaxProjectileRange, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "CanUseAsProjectileWeapon WotWeaponProjectileType: " $ WotWeaponProjectileType, DebugCategoryName );
	return ( ( AttackGoalDistance >= MinProjectileRange ) &&
			( AttackGoalDistance <= MaxProjectileRange ) &&
			( WotWeaponProjectileType != None ) );
}



function UseMeleeWeapon( Actor Invoker, GoalAbstracterInterf TargetGoal )
{
}



function UseProjectileWeapon( Actor Invoker, GoalAbstracterInterf TargetGoal )
{
   	local Rotator AimDirection;
   	local Vector AimSource;
	
	class'Debug'.static.DebugAssert( Self, TargetGoal.IsValid( Invoker ), "ShootRangedAmmo bogus target" );
	GetAimParams( AimSource, AimDirection, Invoker, TargetGoal );
	RandomizeAimParams( AimSource, AimDirection, Invoker, TargetGoal );

	if( Invoker.IsA( 'Pawn' ) )
	{
		//xxxrlo this is not right
		Pawn( Invoker ).ViewRotation = AimDirection;
	}

	FireProjectile( Invoker, AimSource, AimDirection );
}



function FireProjectile( Actor Invoker, Vector ProjectileSource, Rotator ProjectileDirection )
{
    Spawn( WotWeaponProjectileType, Self, /*tag*/, ProjectileSource, ProjectileDirection );
}



/*
function Projectile ProjectileFireOnGoal( class<WotWeaponProjectile> ProjectileType, float ProjectileSpeed, bool bWarn )
{
	local Vector Start, X, Y, Z;

	Owner.MakeNoise( Pawn( Owner ).SoundDampening );
	GetAxes( Pawn( Owner ).ViewRotation, X, Y, Z );
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = Pawn( Owner ).AdjustAim( ProjectileSpeed, Start, AimError, True, bWarn );
	return Spawn( ProjectileClass, , , Start, AdjustedAim );
}



function Projectile ProjectileFire( class<projectile> ProjectileType, float ProjectileSpeed, bool bWarn )
{
	local Vector Start, X, Y, Z;

	Owner.MakeNoise( Pawn( Owner ).SoundDampening );
	GetAxes( Pawn( Owner ).ViewRotation, X, Y, Z );
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = Pawn( Owner ).AdjustAim( ProjectileSpeed, Start, AimError, True, bWarn );
	return Spawn( ProjectileClass, , , Start, AdjustedAim );
}
*/



function bool ShouldBePreparedBy( Actor PreparingActor )
{
	local bool bShouldPrepare;
	if( ( PreparingActor != None ) && ( TypeCapableOfPreparation != None ) )
	{
		bShouldPrepare = PreparingActor.IsA( TypeCapableOfPreparation.Name );
	}
	return bShouldPrepare;
}



//=============================================================================
// Aim support.
//=============================================================================



function GetAimParams( out Vector AimSource,
		out Rotator AimDirection,
		Actor Invoker,
		GoalAbstracterInterf TargetGoal )
{
   	local Vector TargetLocation;
	if( TargetGoal.GetGoalLocation( Invoker, TargetLocation ) )
	{
  		//xxx use the current rotation?
	   	AimSource = GetAimSource( Invoker, TargetLocation );
		if( IsLeadable() && ShouldLeadTarget( Invoker, TargetGoal ) )
		{
			GetLeadAim( AimDirection, Pawn( Invoker ), AimSource, TargetGoal );
		}
		else
		{
			AimDirection = Rotator( TargetLocation - Invoker.Location );
		}
	}
}


function RandomizeAimParams( out Vector AimSource,
		out Rotator AimDirection,
		Actor Invoker,
		GoalAbstracterInterf TargetGoal )
{
	local Vector GoalLocation, TempVector;
	local float GoalRadius, GoalHeight;
	local Actor GoalActor;
	if( FRand() < MissOdds )
	{
		//the aim direction is potentially perfect
		//need to mess it up a bit

		/*
		if( TargetGoal.GetGoalParams( Invoker, GoalLocation, GoalRadius, GoalHeight ) )
		{
		}

		if( TargetGoal.GetGoalParams( Invoker, GoalActor ) )
		{
			GoalHeight = GoalActor.Velocity;
		}
		*/

		//class'Util'.static.RandomizeRotator( AimDirection, 32768 * RandomizePercentRoll,
		//			32768 * RandomizePercentYaw, 32768 * RandomizePercentPitch );
		//used to be the following
		//class'Util'.static.PerturbFloatPercent( AimDirection.Roll, RandomizePercentRoll );
		//class'Util'.static.PerturbFloatPercent( AimDirection.Yaw, RandomizePercentYaw );
		//class'Util'.static.PerturbFloatPercent( AimDirection.Pitch, RandomizePercentPitch );
	}
}



function Vector GetAimSource( Actor Invoker, Vector TargetLocation )
{
   	local Rotator CurrentRotationToTarget;
   	local Vector X, Y, Z;

	CurrentRotationToTarget = Rotator( TargetLocation - Invoker.Location );
	GetAxes( CurrentRotationToTarget, X, Y, Z );
   	return Invoker.Location + ( ( Invoker.CollisionRadius + 4.0 ) * x ) +
			( vect( 0, 0, 1 ) * ( Invoker.CollisionHeight / 2 ) );
}



function bool IsLeadable()
{
	return true;
}



function bool ShouldLeadTarget( Actor Invoker, GoalAbstracterInterf TargetGoal )
{
    local Actor GoalActor;
	//the shooting actor is a pawn
	//the target goal is an actor
	//the target goal is not stationary
	return ( Invoker.IsA( 'Pawn' ) &&
			TargetGoal.GetGoalActor( Invoker, GoalActor ) &&
			!( VSize( GoalActor.Velocity ) ~= 0.0 ) );
}



function GetLeadAim( out Rotator AimDirection,
		Actor Invoker,
		Vector AimSource,
		GoalAbstracterInterf TargetGoal )
{
	AimDirection = AdjustProjectileWeapondAim( Pawn( Invoker ), TargetGoal,
			GetLeadSpeed(), AimSource, MissOdds );
}



function float GetLeadSpeed()
{
	return WotWeaponProjectileType.default.Speed;
}



//========================================================================
// xxxrlo: strip out aimerror stuff, following 2 comments...
// support aimerror?
// allow target leading to be optional?
// support for "rocket jumping" aiming etc. (future)?
// 
// Should be called when we are about to spawn a projectile (including 
// projectile and seeker angreal) to determine the direction in which the
// projectile should be aimed.
//========================================================================

static function Rotator AdjustProjectileWeapondAim( Pawn Invoker,
		GoalAbstracterInterf TargetGoal,
		float ProjectileSpeed,
		Vector ProjectileStart,
		int AimError )
{
	local Rotator AimDirection;
	local Vector ProjectileDest;
	local Actor TraceHitActor;
	local Vector TraceHitLocation, TraceHitNormal;
	local Actor TargetGoalActor;

	if( TargetGoal.GetGoalLocation( Invoker, ProjectileDest ) )
	{
		if( TargetGoal.GetGoalActor( Invoker, TargetGoalActor ) )
		{
			AimError = AimError * ( 1 - 10 * ( ( Normal( TargetGoalActor.Location - Invoker.Location ) Dot
					Normal( ( TargetGoalActor.Location + 0.5 * TargetGoalActor.Velocity ) -
					( Invoker.Location + 0.5 * Invoker.Velocity ) ) ) - 1 ) );
			
			AimError = AimError * ( 2.4 - 0.5 * ( Invoker.Skill + FRand() ) );
			
			if( ProjectileSpeed > 0 )
			{
				ProjectileDest += FMin( 1, 0.7 + 0.6 * FRand() ) *
						( TargetGoalActor.Velocity * VSize( TargetGoalActor.Location - ProjectileStart ) /
						ProjectileSpeed );
				TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest, ProjectileStart, false );
				if( TraceHitActor != None )
				{
					ProjectileDest = 0.5 * ( ProjectileDest + TargetGoalActor.Location );
				}
			}
			
			TraceHitActor = Invoker; //so will fail first check unless shooting at feet
			if( Invoker.bIsPlayer &&
					( Invoker.Location.Z + 19 >= TargetGoalActor.Location.Z ) &&
					TargetGoalActor.IsA( 'Pawn' ) &&
					( Invoker.Weapon != None ) &&
					Invoker.Weapon.bSplashDamage &&
					( 0.5 * ( Invoker .skill - 1 ) > FRand() ) )
			{
				//try to aim at feet
				TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest - vect( 0, 0, 80 ), ProjectileDest, false );
	
				if( TraceHitActor != None )
				{
					ProjectileDest = TraceHitLocation + vect( 0, 0, 3 );
					TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest, ProjectileStart, false );
				}
				else
				{
					TraceHitActor = Invoker;
				}
			}

			if( TraceHitActor != None )
			{
				//trace to the target's abdomen
				ProjectileDest.Z = TargetGoalActor.Location.Z;
 				TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest, ProjectileStart, false );
			}

			if( TraceHitActor != None ) 
			{
				//trace to the target's head
	 			ProjectileDest.Z = TargetGoalActor.Location.Z + 0.9 * TargetGoalActor.CollisionHeight;
 				TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest, ProjectileStart, false );
			}

			if( ( TraceHitActor != None ) &&
					TargetGoal.IsA( 'ContextSensitiveGoal' ) &&
					TargetGoal.GetLastVisibleLocation( Invoker, ProjectileDest ) )
			{	
				if( Invoker.Location.Z >= ProjectileDest.Z )
				{
					ProjectileDest.Z -= 0.5 * TargetGoalActor.CollisionHeight;
				}
				if( Invoker.Weapon != None )
				{
			 		TraceHitActor = Invoker.Trace( TraceHitLocation, TraceHitNormal, ProjectileDest, ProjectileStart, false );
					if( TraceHitActor != None )
					{
						Invoker.bFire = 0;
						Invoker.bAltFire = 0;
					}
				}
			}
		}
	
		AimDirection = Rotator( ProjectileDest - ProjectileStart );
		//AimError TBD:	AimDirection.Yaw = AimDirection.Yaw + 0.5 * ( Rand( 2 * AimError ) - AimError );
		AimDirection.Yaw = AimDirection.Yaw + 0.5;
		AimDirection.Yaw = AimDirection.Yaw & 65535;
	
		if( ( Abs( AimDirection.Yaw - ( Invoker.Rotation.Yaw & 65535 ) ) > 8192 ) &&
				( Abs( AimDirection.Yaw - ( Invoker.Rotation.Yaw & 65535 ) ) < 57343 ) )
		{
			if( ( AimDirection.Yaw > Invoker.Rotation.Yaw + 32768 ) ||
					( ( AimDirection.Yaw < Invoker.Rotation.Yaw ) &&
					( AimDirection.Yaw > Invoker.Rotation.Yaw - 32768 ) ) )
			{
				AimDirection.Yaw = Invoker.Rotation.Yaw - 8192;
			}
			else
			{
				AimDirection.Yaw = Invoker.Rotation.Yaw + 8192;
			}
		}
	}
	else
	{
		AimDirection = Invoker.ViewRotation;
	}

	return AimDirection;
}



/*
static function Rotator AdjustProjectileWeapondAim( Pawn Invoker,
		GoalAbstracterInterf Goal,
		float ProjectileSpeed,
		Vector ProjectileStart,
		float MissOdds )
{
	local Actor GoalActor;
	local Rotator AimDirection;
	if( Goal.GetGoalActor( Invoker, GoalActor ) )
	{
		AimDirection = GetGoalAimDirection( Invoker, GoalActor, ProjectileSpeed, ProjectileStart, MissOdds );
	}
	return AimDirection;
}



static function Rotator GetGoalAimDirection( Pawn Invoker,
		Actor GoalActor,
		float ProjectileSpeed,
		Vector ProjectileStart,
		float MissOdds )
{
	local Vector DeltaGoalLocation, PredictedGoalLocation, Trajectory;
	// Time it takes for the projectile to reach the destination.
	// Distance between the source and destination.
	if( ( ProjectileSpeed != 0 ) && ( ProjectileSpeed != -1 ) )
	{
		DeltaGoalLocation = ( GoalActor.Velocity * VSize( GoalActor.Location - ProjectileStart ) / ProjectileSpeed );
	}
	if( FRand() < MissOdds )
	{
		DeltaGoalLocation -= Normal( GoalActor.Velocity ) * GoalActor.CollisionRadius * 1.75;
	}
	// Location of the destination after time T (from above).
	PredictedGoalLocation = GoalActor.Location + DeltaGoalLocation;
	// Vector from the source to the predicted destination's location after time T.
	Trajectory = PredictedGoalLocation - ProjectileStart;
	return Rotator( Trajectory );
}
*/



//=============================================================================
// Active state
//=============================================================================



state Active
{
	function BeginState()
	{
		class'Debug'.static.DebugLog( Self, "Active::BeginState", DebugCategoryName );
		Super.BeginState();
	}
	
	function EndState()
	{
		class'Debug'.static.DebugLog( Self, "Active::EndState", DebugCategoryName );
		Super.EndState();
	}
	
	function PlayPostSelect()
	{
		local WotPawn WotPawnOwner;

		//Log( Self $ "::PlayPostSelect" );
		WotPawnOwner = WotPawn( Owner );
		
		if( ( None == WotPawnOwner ) || !WotPawnOwner.PrepareInventoryItem( Self ) )
		{
			//the owner is not a wot pawn or
			//the weapon is not suposed to be specially prepared
			//the owner is a wot pawn and did not prepare the inventory item
			Global.PlayPostSelect();
		}
		else
		{
			//the owner is a wot pawn and 
			//the owner prepared the inventory item
			GotoState( 'WaitForBringUpWeaponOwnerAnimation', 'WaitForOwnerAnimation' );
		}
	}

OwnerAnimationFinished:
	//Log( Self $ "::" $ GetStateName() $ "::OwnerAnimationFinished" );
	if( Owner.IsA( 'Pawn' ) )
	{
		Pawn( Owner ).Weapon = Self;
	}
	FinishAnim();
	Finish();
	Stop;
}



//=============================================================================
// DownWeapon state
//=============================================================================



state DownWeapon
{
	function TweenDown()
	{
		local WotPawn WotPawnOwner;
		
		//Log( Self $ "::DownWeapon::TweenDown" );
		WotPawnOwner = WotPawn( Owner );
		if( ( None == WotPawnOwner ) || !WotPawnOwner.PrepareInventoryItem( Self ) )
		{
			//the owner is not a wot pawn or
			//the owner was a wot pawn that did not prepare the inventory item
			Global.TweenDown();
		}
		else
		{
			//the owner is a wot pawn and 
			//the owner prepared the inventory item
			GotoState( 'WaitForDownWeaponOwnerAnimation', 'WaitForOwnerAnimation' );
		}
	}

OwnerAnimationFinished:
	//Log( Self $ "::" $ GetStateName() $ "::OwnerAnimationFinished" );
	if( Owner.IsA( 'Pawn' ) )
	{
		Pawn( Owner ).Weapon = None;
	}
	bOnlyOwnerSee = false;
	Pawn( Owner ).ChangedWeapon();
	Stop;
}


//=============================================================================
// WaitForxxxWeaponOwnerAnimation states
//=============================================================================



state WaitForWeaponOwnerAnimation
{
WaitForOwnerAnimation:
	Stop;
}



state WaitForDownWeaponOwnerAnimation expands WaitForWeaponOwnerAnimation {}
state WaitForBringUpWeaponOwnerAnimation expands WaitForWeaponOwnerAnimation {}

defaultproperties
{
     DebugCategoryName=WotWeapon
     bRequireTargetVisibility=True
     MPTossedLifeSpan=60.000000
     RemovedFromOwnerInventoryEvent=RemovedFromOwnerInventory
     DestroyedEvent=WeaponDestroyed
     bAmbientGlow=False
     RespawnTime=0.000000
     AmbientGlow=0
}
