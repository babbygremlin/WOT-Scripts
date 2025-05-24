//=============================================================================
// BATrolloc.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 12 $
//=============================================================================

class BATrolloc expands BATrollocAssets;

/*=============================================================================
  BATrolloc

  The champion for the Forsaken.

  Has a number of close range attacks, most of which are only valid if the BAT
  has the halberd in his possesion. 

  For his ranged attack, the BAT throws his halberd with a fairly high degree
  of accuracy. 

  TBD: how the halberd returns to the BAT:

	Infinite supply with some faily long delay in between attacks? -- simplest
	Fade out thrown halberd, fade in held halberd? -- pbly fairly simple
    Move to halberd location and pick it up? -- many potential problems

  TBD: throwing the halberd is also a melee attack (pbly less common than
  other melee attacks.

=============================================================================*/

#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackJab		TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackJab		TIME=0.5  FUNCTION=JabHalberdDamageTarget

#exec MESH NOTIFY MESH=BATrolloc SEQ=LongJab            TIME=0.6 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=LongJab            TIME=0.7  FUNCTION=JabHalberdLongDamageTarget

#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDbleSwipe	TIME=0.15 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDbleSwipe	TIME=0.2  FUNCTION=DbleHalberdDamageTarget
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDbleSwipe	TIME=0.4  FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDbleSwipe	TIME=0.45 FUNCTION=DbleHalberdDamageTarget

#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDblePunch	TIME=0.15 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDblePunch	TIME=0.2  FUNCTION=DblePunchDamageTarget
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDblePunch TIME=0.4  FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=AttackRunDblePunch TIME=0.45 FUNCTION=DblePunchDamageTarget

#exec MESH NOTIFY MESH=BATrolloc SEQ=Charge  		TIME=0.25 FUNCTION=HeadTossDamageTarget
#exec MESH NOTIFY MESH=BATrolloc SEQ=Charge  		TIME=0.45 FUNCTION=HeadTossTarget

#exec MESH NOTIFY MESH=BATrolloc SEQ=THROWHALBERD	TIME=0.40 FUNCTION=ShootRangedAmmo

#exec MESH NOTIFY MESH=BATrolloc SEQ=Walk			TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=Walk			TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=Run			TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=Run			TIME=0.87 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=ReactP  		TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=BATrolloc SEQ=ReactPLoop		TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=BATrolloc SEQ=DeathF		TIME=0.77 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=BATrolloc SEQ=DeathB		TIME=0.56 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=BATrolloc SEQ=DeathR		TIME=0.80 FUNCTION=TransitionToCarcassNotification

var() float JabHalberdDamage;
var() float JabHalberdLongDamage;
var() float DbleHalberdDamage;
var() float DblePunchDamage;
var() float HeadTossDamage;
var() int HeadTossPitch;
var() float HeadTossVelocity;
var() float RecoveryInterval;
var() bool bNoInitialRecovery;
var() float RecoveryDamageAmount;

var private bool bHeadTossAttackSuccess;
var private float LastRecoveryTime;

const AdjustCollisionThreshhold = 750;
const BiggerAssRadius = 90;



function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, name DamageType )
{
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if( ( Damage > RecoveryDamageAmount ) && ( Health > 0 ) && ( ( LastRecoveryTime + RecoveryInterval ) < Level.TimeSeconds ) )
	{
		if( ( LastRecoveryTime == 0 ) && bNoInitialRecovery )
		{
			LastRecoveryTime = Level.TimeSeconds + RecoveryInterval;
		}
		else
		{
			GotoState( 'Recovering' );
		}
	}
}



function BeginStatePrepareNotifiers()
{
	Super.BeginStatePrepareNotifiers();
	DurationNotifiers[ EDurationNotifierIndex.DNI_Misc2 ].EnableNotifier();
}



function OnAdjustCollisionNotification( Notifier Notifier )
{
	local float CurrentGoalDistance;
	local bool bBiggerAssRadius;
	
	if( ( CurrentGoalIdx == EGoalIndex.GI_Threat ) &&
			( GetGoal( CurrentGoalIdx ).GetGoalDistance( Self, CurrentGoalDistance, Self ) ) &&
			( CurrentGoalDistance < AdjustCollisionThreshhold ) )
	{
		SetCollisionSize( BiggerAssRadius, CollisionHeight );
		bBiggerAssRadius = true;
	}
	if( !bBiggerAssRadius )
	{
		SetCollisionSize( Default.CollisionRadius, CollisionHeight );
	}
}



state PerformMeleeAttack
{
	//BATrolloc has no halberd:
	function HeadTossTarget() 
	{
		local Rotator NewGoalRotation;
	    local Actor	GoalActor;	
		//!!!	if( HeadTossAttackSuccess && ( VSize( Target.Location - Location ) < CollisionRadius + Target.CollisionRadius + 1.5 * MeleeRange ) )
		if( bHeadTossAttackSuccess && GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) )
		{
			NewGoalRotation = GoalActor.Rotation;
			NewGoalRotation.Pitch = HeadTossPitch;
			GoalActor.SetRotation( NewGoalRotation );
			if( GoalActor.IsA( 'Pawn' ) )
			{
				Pawn( GoalActor ).AddVelocity( ( HeadTossVelocity * ( Normal( GoalActor.Location - Location ) + vect( 0, 0, 1 ) ) ) / GoalActor.Mass );
				if( GoalActor.IsA( 'PlayerPawn' ) )
				{
					PlayerPawn( GoalActor ).ShakeView( 0.2, 2000, -10 );
				}
			}
		}
	}

	function DblePunchDamageTarget()
	{
		AttackDamageTarget( DblePunchDamage, 0.0, 'Punched' );
	}

	function HeadTossDamageTarget()
	{
		bHeadTossAttackSuccess = AttackDamageTarget( HeadTossDamage, 0.0, 'Tossed' );
	}

	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, MeleeAttackAnimSlot );
	}
}



state PerformMeleeWeaponAttack
{
	//BATrolloc has his halberd:
	function JabHalberdDamageTarget()
	{
		AttackDamageTarget( JabHalberdDamage, 0.0, 'Jabbed' );
	}

	function JabHalberdLongDamageTarget()
	{
		AttackDamageTarget( JabHalberdLongDamage, 0.0, 'Skewered' );
	}

	function DbleHalberdDamageTarget()
	{
		AttackDamageTarget( DbleHalberdDamage, 0.0, 'Chopped' );
	}

	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, MeleeWeaponAttackAnimSlot );
	}
}



state Recovering
{
	function GetNextStateAndLabelForReturn( out Name ReturnState, out Name ReturnLabel );
	function TransitionToTakeHitState( float Damage, vector HitLocation, name DamageType, float MomentumZ );

Begin:
	LastRecoveryTime = Level.TimeSeconds;
	InterruptMovement();
	PlayAnim( 'Recover', 0.45 );
	FinishAnim();
	GotoState( NextState, NextLabel );
}			



// Evil hack to fix BATrolloc's "running through target" syndrome.
//state AttemptAttack
//{
//	function FinishedAttackAttempt()
//	{
//		SetCollisionSize( Default.CollisionRadius, Default.CollisionHeight );
//		Super.FinishedAttackAttempt();
//	}
//	
//	function PerformAttack( Actor AttackActor, GoalAbstracterInterf Goal )
//	{
//		SetCollisionSize( 90, Default.CollisionHeight );
//		Super.PerformAttack( AttackActor, Goal );
//	}
//}

defaultproperties
{
     JabHalberdDamage=10.000000
     JabHalberdLongDamage=20.000000
     DbleHalberdDamage=30.000000
     DblePunchDamage=20.000000
     HeadTossDamage=30.000000
     HeadTossPitch=4096
     HeadTossVelocity=200000.000000
     RecoveryInterval=5.000000
     bNoInitialRecovery=True
     RecoveryDamageAmount=15.000000
     BaseWalkingSpeed=140.000000
     DefaultWeaponType=Class'WOTPawns.BATHalberd'
     MeleeWeaponType=Class'WOTPawns.BATHalberd'
     RangedWeaponType=Class'WOTPawns.BATHalberd'
     GroundSpeedMin=560.000000
     GroundSpeedMax=560.000000
     HealthMPMin=700.000000
     HealthMPMax=700.000000
     HealthSPMin=700.000000
     HealthSPMax=700.000000
     TextureHelperClass=Class'WOTPawns.NPCBATrollocTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableBATrolloc'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListBATrolloc'
     AnimationTableClass=Class'WOTPawns.AnimationTableBATrolloc'
     GibForSureFinalHealth=-120.000000
     GibSometimesFinalHealth=-90.000000
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryBATrolloc'
     GoalSuggestedSpeeds(0)=560.000000
     GoalSuggestedSpeeds(2)=560.000000
     GoalSuggestedSpeeds(3)=560.000000
     GoalSuggestedSpeeds(4)=560.000000
     GoalSuggestedSpeeds(5)=560.000000
     GoalSuggestedSpeeds(6)=140.000000
     DurationNotifierClasses(8)=Class'Legend.DurationNotifier'
     DurationNotifierNotifications(8)=OnAdjustCollisionNotification
     DurationNotifierDurations(8)=0.500000
     NavigationProxyClass=Class'Legend.NavigationProxyPawn'
     MeleeRange=60.000000
     GroundSpeed=560.000000
     BaseEyeHeight=84.000000
     FovAngle=45.000000
     Health=200
     DrawScale=1.150000
     CollisionRadius=30.000000
     CollisionHeight=88.000000
     Mass=800.000000
}
