//=============================================================================
// ShieldUser.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 11 $
//=============================================================================

class ShieldUser expands Grunt;

var() float	 AttackRunShieldDamage;
var() float	 AttackRunSwipeDamage;
var() float	 AttackRunLungeDamage;

var private bool bUninstallShieldReflector;
var private bool bDeflectEnabled;
var private float UninstallShieldReflectorTime;
var private ShieldReturnToSenderReflector ShieldReflector;
var () class<ShieldReturnToSenderReflector> ShieldReflectorClass;
var () class<Inventory> ShieldReflectorInventoryProxyClass;
var () string ShieldReflectorSoundName;
var () float UnistallShieldReflectorDelay;

var () name ShieldReflectorIrreleventProjectileType;
var () bool bShieldReflectorDeflect; 			//if set to true the shield will deflect instead of reflect
var () bool bShieldReflectorLeadWhenReflecting; //if set to true the shield will reflect with leading as normal

const CrouchAnimSlot					= 'Crouch';
const CrouchingAnimSlot					= 'Crouching';
const WeaponMeleeShieldHitSoundSlot		= 'WeaponMeleeShieldHitEnemy';

//=============================================================================
// All code below here is exactly the same as the questioner
// (or at least it was at one time) Welcome to code maintenance nightmare
//=============================================================================


function PostBeginPlay()
{
	Super.PostBeginPlay();
	ShieldReflector = ShieldReturnToSenderReflector( ShieldReflectorClass.static.GetReflector( Self ) );
	ShieldReflector.IrreleventProjectileType = ShieldReflectorIrreleventProjectileType;
	ShieldReflector.bDeflect = bShieldReflectorDeflect;
	ShieldReflector.bLeadWhenReflecting = bShieldReflectorLeadWhenReflecting;
	if( ShieldReflectorSoundName != "" )
	{
		ShieldReflector.SoundReflectName = ShieldReflectorSoundName;
	}
	DisableDeflect();
}



function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	if( bUninstallShieldReflector && ( Level.TimeSeconds >= UninstallShieldReflectorTime ) )
	{
//xxxrlo adjust collision cylinder SetTimer( 0.1, false );
		DisableDeflect();
	}
}



function bool DeleteInventory( Inventory Item )
{
	local bool bDeleteInventory;
	bDeleteInventory = Super.DeleteInventory( Item );
	if( class'Util'.static.GetInventoryItem( Self, ShieldReflectorInventoryProxyClass ) == None )
	{
		DisableDeflect();
	}
	return bDeleteInventory;
}



function CancelAngrealEffects()
{
	DisableDeflect();
	if( ShieldReflector != None )
	{
		ShieldReflector.Destroy();
		ShieldReflector = None;
	}
	Super.CancelAngrealEffects();
}



function EnableDeflect()
{
	if( ShieldReflector != None )
	{
		ShieldReflector.Install( Self );
		ForceStationary();
		bUninstallShieldReflector = false;
		bDeflectEnabled = true;
	}
	else
	{
		UnforceStationary();
		bUninstallShieldReflector = false;
		bDeflectEnabled = false;
	}
}



function DisableDeflect()
{
	if( ShieldReflector != None )
	{
		ShieldReflector.Uninstall();
	}
	UnforceStationary();
	bUninstallShieldReflector = false;
	bDeflectEnabled = false;
}



function DefensivePerimiterUncompromised()
{
	DontUseShield();
}



function DefensivePerimiterCompromisedByRejectedOffender( DefensiveDetector DefensiveNotification )
{
	DontUseShield();
}



function PendingOffenderCollision( DefensiveDetector DefensiveNotification, Vector PendingHitLocation )
{
	local Inventory ShieldReflectorInventoryProxy;
	
	ShieldReflectorInventoryProxy = class'Util'.static.GetInventoryItem( Self, ShieldReflectorInventoryProxyClass );

	if( ShieldReflectorInventoryProxy != None )
	{
		UseShield();
	}
	else
	{
		Super.PendingOffenderCollision( DefensiveNotification, PendingHitLocation );
	}
}



function DontUseShield()
{
	class'Debug'.static.DebugLog( Self, "DontUseShield", DebugCategoryName );
	if( !bUninstallShieldReflector && bDeflectEnabled )
	{
		UninstallShieldReflectorTime = Level.TimeSeconds + UnistallShieldReflectorDelay;
		bUninstallShieldReflector = true;
		AnimationTableClass.static.TweenSlotAnim( Self, WalkAnimSlot /*, UninstallShieldReflectorTime*/ );
	}
}



function UseShield()
{
	local Inventory ShieldReflectorInventoryProxy;
	class'Debug'.static.DebugLog( Self, "UseShield", DebugCategoryName );
	ShieldReflectorInventoryProxy = class'Util'.static.GetInventoryItem( Self, ShieldReflectorInventoryProxyClass );
	if( ShieldReflectorInventoryProxy != None )
	{
		SelectedItem = ShieldReflectorInventoryProxy;
		if( !bDeflectEnabled )
		{
			EnableDeflect();
			AnimationTableClass.static.TweenPlaySlotAnim( Self, CrouchAnimSlot );
//xxxrlo adjust collision cylinder SetTimer( 0.05, false );
			InterruptMovement();
		}
	}
}



/*
//xxxrlo adjust collision cylinder
function Timer()
{
	if( CollisionHeight == Default.CollisionHeight )
	{
		SetCollisionSize( Default.CollisionRadius, CollisionHeight * 0.5 );
	}
	else
	{
		SetCollisionSize( Default.CollisionRadius, Default.CollisionHeight );
	}
}*/



function LoopMovementAnim( float IntendedMovementSpeed )
{
	if( bDeflectEnabled )
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, CrouchingAnimSlot );
	}
	else
	{
		Super.LoopMovementAnim( IntendedMovementSpeed );
	}
}



function PlayInactiveAnimation()
{ 
	if( bDeflectEnabled )
	{
		AnimationTableClass.static.TweenLoopSlotAnim( Self, CrouchingAnimSlot );
	}
	else
	{
		Super.PlayInactiveAnimation();
	}
}



state PerformMeleeAttack
{
	function AttackRunSwipeDamageTarget()
	{
		AttackDamageTarget( AttackRunSwipeDamage, 0.0, 'Sliced' );
	}

	function AttackRunLungeDamageTarget()
	{
		AttackDamageTarget( AttackRunLungeDamage, 0.0, 'Skewered' );
	}
}



state PerformMeleeWeaponAttack
{
	function PlayMeleeHitSound()
	{
		if( AnimSequence == 'AttackRunShield' )
		{
			MySoundTable.PlaySlotSound( Self, WeaponMeleeShieldHitSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		}
		else
		{
			Super.PlayMeleeHitSound();
		}
	}

	function AttackRunShieldDamageTarget()
	{
		AttackDamageTarget( AttackRunShieldDamage, 0.0, 'Slammed' );
	}

	function AttackRunSwipeDamageTarget()
	{
		AttackDamageTarget( AttackRunSwipeDamage, 0.0, 'Sliced' );
	}

	function AttackRunLungeDamageTarget()
	{
		AttackDamageTarget( AttackRunLungeDamage, 0.0, 'Skewered' );
	}
}

defaultproperties
{
     ShieldReflectorClass=Class'WOTPawns.ShieldReturnToSenderReflector'
     UnistallShieldReflectorDelay=0.500000
     DefaultReflectorClasses(18)=Class'WOTPawns.ShieldReturnToSenderReflector'
     DodgeVelocityFactor=200.000000
     DodgeVelocityAlltitude=80.000000
}
