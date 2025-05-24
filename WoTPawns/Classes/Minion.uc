//=============================================================================
// Minion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 23 $
//=============================================================================

//Shadar Logoth Minion, the grunt for the Hound

class Minion expands MinionAssets;

#exec TEXTURE IMPORT NAME=MinionEyes FILE=MODELS\MinionEyes.PCX GROUP=Skins FLAGS=2 // glowing eyes

#exec MESH NOTIFY MESH=Minion  SEQ=AttackBite			TIME=0.25 FUNCTION=AttackBiteSound
#exec MESH NOTIFY MESH=Minion  SEQ=AttackBite			TIME=0.35 FUNCTION=AttackBiteDamage

#exec MESH NOTIFY MESH=Minion  SEQ=AttackClawL			TIME=0.20 FUNCTION=AttackClawSound
#exec MESH NOTIFY MESH=Minion  SEQ=AttackClawL			TIME=0.35 FUNCTION=AttackClawDamage

#exec MESH NOTIFY MESH=Minion  SEQ=AttackClawR			TIME=0.20 FUNCTION=AttackClawSound
#exec MESH NOTIFY MESH=Minion  SEQ=AttackClawR			TIME=0.35 FUNCTION=AttackClawDamage

#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNCLAWL		TIME=0.27 FUNCTION=AttackClawSound
#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNCLAWL		TIME=0.38 FUNCTION=AttackRunClawDamage

#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNCLAWR		TIME=0.22 FUNCTION=AttackClawSound
#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNCLAWR		TIME=0.38 FUNCTION=AttackRunClawDamage

#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNTENT		TIME=0.22 FUNCTION=TentacleWhipAttackSound
#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNTENT		TIME=0.30 FUNCTION=TentacleWhipAttackDamage
//#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNTENT		TIME=0.35 FUNCTION=TentacleWhipAttackSound
//#exec MESH NOTIFY MESH=Minion  SEQ=ATTACKRUNTENT		TIME=0.40 FUNCTION=TentacleWhipAttackDamage

// tentacle grab attack
#exec MESH NOTIFY MESH=Minion  SEQ=AttackTent			TIME=0.30 FUNCTION=TentacleGrabAttackSound
#exec MESH NOTIFY MESH=Minion  SEQ=AttackTent			TIME=0.40 FUNCTION=TentacleGrabAttackDamage1	// damage opponent and draw in and set to spin towards minion
#exec MESH NOTIFY MESH=Minion  SEQ=AttackTent			TIME=0.50 FUNCTION=TentacleGrabAttackDamage2	// finish tentacle grab

#exec MESH NOTIFY MESH=Minion  SEQ=Walk		   		TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Minion  SEQ=Walk				TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Minion  SEQ=Run				TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Minion  SEQ=Run				TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Minion  SEQ=Breath			TIME=0.01 FUNCTION=PlayAnimSound
//#exec MESH NOTIFY MESH=Minion  SEQ=Listen			TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Minion  SEQ=Look				TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Minion  SEQ=ReactP  			TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Minion  SEQ=ReactPLoop			TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Minion  SEQ=DeathB			TIME=0.76 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Minion  SEQ=DeathEx			TIME=0.89 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Minion  SEQ=DeathF			TIME=0.71 FUNCTION=TransitionToCarcassNotification

var () float AttackBiteDamage1;
var () float AttackRunClawDamage1;
var () float AttackClawDamage1;
var () float AttackRunTentDamage1;
var () float AttackTentDamage1;

var () bool bStealthAttacks;				//no attacks if the threat has visibility
var () float HoldingAngleCos;				//cos view angle within which minion won't attack opponent
var () float MaxStareTime;					//this is the maximum amount of time that the npc will wait before attacking
var float StareTimeThreshold;
var () float AttackAngleCos;				//cos of view angle outside of which player will be attacked

var () float DrawInVelocity;					
var () float GrabDistanceDivisor;			//grab velocity is proportional to distance/this

var () float MinTentacleAttackDistance;
var () float MaxTentacleAttackDistance;

var () bool bEnableEyes;
var () float MinEyeOffTime;
var () float MaxEyeOffTime;
var () float MinEyeOnTime;
var () float MaxEyeOnTime;
var () Texture EyesTexture;

const AttackBiteSoundSlot			= 'AttackBite';
const AttackClawSoundSlot			= 'AttackClaw';
const AttackTentacleSoundSlot		= 'AttackTentacle';
const TentacleGrabAnimSlot			= 'TentacleGrab';
const MeleeStandingAttackAnimSlot	= 'MeleeStandingAttack';

const TentacleGrabAnim				= 'AttackTent';
const AttackBiteAnim				= 'AttackBite';
const AttackRunClawLAnim			= 'AttackRunClawL';
const AttackRunClawRAnim			= 'AttackRunClawR';
const AttackRunTentAnim				= 'AttackRunTent';
const AttackClawAnim				= 'AttackClaw';

//exposed for waypoint selector minion
//function float GetMaxTentacleAttackDistance() { return MaxTentacleAttackDistance; }

function PreBeginPlay()
{
	Super.PreBeginPlay();
	ToggleEyes();
}



//swap the eyes texture to simulate blinking
function ToggleEyes()
{
	if( bEnableEyes )
	{
		if( MultiSkins[ 4 ] == EyesTexture )
		{
			//the eyes are on, turn them off
			MultiSkins[ 4 ] = default.MultiSkins[ 4 ];
			SetTimer( RandRange( MinEyeOffTime, MaxEyeOffTime ), false );
		}
		else
		{
			//the eyes are off, turn them on
			MultiSkins[ 4 ] = EyesTexture;
			SetTimer( RandRange( MinEyeOnTime, MaxEyeOnTime ), false );
		}
	}
}



//make sure the eyes are off when the minion dies
function Died( Pawn Killer, Name DamageType, Vector HitLocation )
{
	MultiSkins[ 4 ] = default.MultiSkins[ 4 ];
	bEnableEyes = false;
	TimerRate = 0.0;
	Super.Died( Killer, DamageType, HitLocation );
}



function Timer()
{
	Super.Timer();
	ToggleEyes();
}



function Tick( float DeltaTime )
{

	Super.Tick( DeltaTime );
	if( ( StareTimeThreshold != 0 ) && ( Level.TimeSeconds > StareTimeThreshold ) )
	{
		bStealthAttacks = false;
	}
}



function GoalInitialized( EGoalIndex GoalIdx )
{
	Super.GoalInitialized( GoalIdx );
	if( ( GoalIdx == EGoalIndex.GI_Threat ) && ( StareTimeThreshold == 0 ) )
	{
		StareTimeThreshold = Level.TimeSeconds + MaxStareTime;
	}
}



function GetPriorityGoalIndex( out EGoalIndex PriorityGoalIndex )
{
	local Actor GoalActor;
	Super.GetPriorityGoalIndex( PriorityGoalIndex );
	if( bStealthAttacks && ( PriorityGoalIndex == EGoalIndex.GI_Threat ) &&
			GetGoal( EGoalIndex.GI_Threat ).GetGoalActor( Self, GoalActor ) &&
			GoalActor.IsA( 'Pawn' ) &&
			class'Util'.static.PawnCanSeeActor( Pawn( GoalActor ), Self, HoldingAngleCos, true ) )
	{
		ForceStationary();
	}
	else
	{
		UnForceStationary();
	}
}



function PerformDefensiveDodge( Vector DodgeDestination )
{
	bStealthAttacks = false; //the minion has been attacked
	Super.PerformDefensiveDodge( DodgeDestination );
}



event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType )
{
	bStealthAttacks = false; //the minion has been attacked
	Super.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType );
}



function bool InUseTentacleDistance( GoalAbstracterInterf Goal )
{
	local bool bInUseTentacleDistance;
	local float GoalDistance;
	if( Goal.GetGoalDistance( Self, GoalDistance, Self ) )
	{
		if( ( GoalDistance >= MinTentacleAttackDistance ) &&
				( GoalDistance <= MaxTentacleAttackDistance ) )
		{
			bInUseTentacleDistance = true;
			bStealthAttacks = false; //the threat is in tentacle attack range so scew the stealth attacks
		}
	}
	return bInUseTentacleDistance;
}



function bool WithinMaxMeleeDistance( GoalAbstracterInterf Goal )
{
	return ( InUseTentacleDistance( Goal ) || Super.WithinMaxMeleeDistance( Goal ) );
}



//=============================================================================
//	Acquired states
//=============================================================================



state AcquiredReachable
{
	function Name GetPerforminactivityLabel()
	{ 
		if( bStealthAttacks )
		{
			return 'PerformingAnimInactivity';
		}
		else
		{
			return 'PerformingSleepInactivity';
		}
	}
}



state AcquiredVisible
{
	function Name GetPerforminactivityLabel()
	{ 
		if( bStealthAttacks )
		{
			return 'PerformingAnimInactivity';
		}
		else
		{
			return 'PerformingSleepInactivity';
		}
	}
}


	
//=============================================================================
//	AttemptAttack states
//=============================================================================



state AttemptAttack
{
	function bool GetAttackActor( out Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local bool bGetAttackActor;
		if( !bStealthAttacks || InUseTentacleDistance( Goal ) )
		{
			bGetAttackActor = Super.GetAttackActor( AttackActor, Goal );
		}
		return bGetAttackActor;
	}

	//let the distance to the goal determine which melee attack is used.
	//e.g. the tentacle attacks can be performed from much further away.
	function PerformAttack( Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local Actor GoalActor;
		class'Debug'.static.DebugLog( Self, "PerformAttack", DebugCategoryName );
		bStealthAttacks = false;
		if( AttackActor == Self )
		{
			if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && VSize( GoalActor.Velocity ) <= 1 )
			{
				if( InUseTentacleDistance( Goal ) )
				{
					GotoState( 'PerformTentacleGrabAttack' );
				}
				else
				{
					GotoState( 'PerformStandingAttack' );
				}
			}
			else
			{
				NextAnimation = AnimationTableClass.static.PickSlotAnim( Self, MeleeAttackAnimSlot );
				switch( NextAnimation )
				{
					case AttackRunClawLAnim:
					case AttackRunClawRAnim:
						GotoState( 'PerformClawAttack' );
						break;
					case AttackRunTentAnim:
						GotoState( 'PerformTentacleWhipAttack' );
						break;
					default:
						Super.PerformAttack( AttackActor, Goal );
						break;
				}
			}
		}
		else
		{
			Super.PerformAttack( AttackActor, Goal );
		}
	}
}



state PerformClawAttack expands PerformMeleeAttack
{
	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, NextAnimation, , , true );
	}

	function AttackClawSound()
	{
		MySoundTable.PlaySlotSound( Self, AttackClawSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}

	function AttackRunClawDamage()
	{
		AttackDamageTarget( AttackRunClawDamage1, 0.0, 'Clawed' );
	}
}



state PerformTentacleWhipAttack expands PerformMeleeAttack
{
	function PlayStateAnimation()
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, NextAnimation, , , true );
	}

	function TentacleWhipAttackSound()
	{
		MySoundTable.PlaySlotSound( Self, AttackTentacleSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}

	function TentacleWhipAttackDamage()
	{
		AttackDamageTarget( AttackRunTentDamage1, 0.5, 'Whipped' );
	}
}



state PerformStandingAttack expands PerformMeleeAttack
{
	function PlayStateAnimation()
	{
		InterruptMovement();
		AnimationTableClass.static.TweenPlaySlotAnim( Self, MeleeStandingAttackAnimSlot );
	}

	function AttackBiteSound()
	{
		MySoundTable.PlaySlotSound( Self, AttackBiteSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}

	function AttackBiteDamage()
	{
		AttackDamageTarget( AttackBiteDamage1, 0.0, 'Bit' );
	}

	function AttackClawSound()
	{
		MySoundTable.PlaySlotSound( Self, AttackClawSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}

	function AttackClawDamage()
	{
		AttackDamageTarget( AttackClawDamage1, 0.0, 'Clawed' );
	}
}



state PerformTentacleGrabAttack expands PerformStandingAttack
{
	function PlayStateAnimation()
	{
		InterruptMovement();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
		AnimationTableClass.static.TweenPlaySlotAnim( Self, TentacleGrabAnimSlot );
	}
	
	function TentacleGrabAttackSound()
	{
		MySoundTable.PlaySlotSound( Self, AttackTentacleSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}
	
	function TentacleGrabAttackDamage1()
	{
		//draw the opponent in, spinning him around to face us
		local Actor	GoalActor;
		local float GrabDistance;
		local PlayerPawn PlayerPawnGoal;
		if( AttackDamageTarget( AttackTentDamage1, 0.0, 'Grabbed' ) )
		{
			if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) &&
					GoalActor.IsA( 'Pawn' ) &&
					GetGoal( CurrentGoalIdx ).GetGoalDistance( Self, GrabDistance, Self ) )
			{
				if( GoalActor.IsA( 'PlayerPawn' ) )
				{
					//Stop goal's movement
					PlayerPawnGoal = PlayerPawn( GoalActor );
					PlayerPawnGoal.Velocity = vect( 0, 0, 0 );
					PlayerPawnGoal.Acceleration = vect( 0, 0, 0 );
					PlayerPawnGoal.AddVelocity( ( DrawInVelocity * ( Normal( Location - PlayerPawnGoal.Location ) ) )
							/ PlayerPawnGoal.Mass * GrabDistance / GrabDistanceDivisor );
					PlayerPawnGoal.ShakeView( 0.2, 2000, -10 );
				}
	   		}
		}
	}
	
	function TentacleGrabAttackDamage2()
	{
		local Actor	GoalActor;

		//opponent should be in close now -- nail him again
		if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) &&
				GoalActor.IsA( 'Pawn' ) )
		{
			if( GoalActor.IsA( 'PlayerPawn' ) )
			{
				//release the victim
				if(  Pawn( GoalActor ).Physics == PHYS_Walking ) 
				{
					Pawn( GoalActor ).GotoState( 'PlayerWalking' );
				}
				else if( Pawn( GoalActor ).Physics == PHYS_Swimming ) 
				{
					Pawn( GoalActor ).GotoState( 'PlayerSwimming' );
				}
			}
		}
	}
}

defaultproperties
{
     AttackBiteDamage1=30.000000
     AttackRunClawDamage1=15.000000
     AttackClawDamage1=25.000000
     AttackRunTentDamage1=15.000000
     AttackTentDamage1=10.000000
     bStealthAttacks=True
     HoldingAngleCos=0.650000
     MaxStareTime=0.000001
     AttackAngleCos=0.650000
     DrawInVelocity=100000.000000
     GrabDistanceDivisor=55.000000
     MinTentacleAttackDistance=40.000000
     MaxTentacleAttackDistance=200.000000
     bEnableEyes=True
     MinEyeOffTime=0.200000
     MaxEyeOffTime=0.300000
     MinEyeOnTime=2.750000
     MaxEyeOnTime=3.000000
     EyesTexture=Texture'WOTPawns.Skins.MinionEyes'
     BrokenMoralePct=50
     BaseWalkingSpeed=150.000000
     GroundSpeedMin=500.000000
     GroundSpeedMax=500.000000
     HealthMPMin=50.000000
     HealthMPMax=50.000000
     HealthSPMin=50.000000
     HealthSPMax=50.000000
     TextureHelperClass=Class'WOTPawns.NPCMinionTextureHelper'
     DamageHelperClass=Class'WOT.DamageHelperBlackBlood'
     SoundTableClass=Class'WOTPawns.SoundTableMinion'
     AnimationTableClass=Class'WOTPawns.AnimationTableMinion'
     CarcassType=Class'WOTPawns.WOTCarcassMinion'
     DebugCategoryName=Minion
     GoalSuggestedSpeeds(0)=500.000000
     GoalSuggestedSpeeds(2)=500.000000
     GoalSuggestedSpeeds(3)=500.000000
     GoalSuggestedSpeeds(4)=500.000000
     GoalSuggestedSpeeds(5)=500.000000
     GoalSuggestedSpeeds(6)=450.000000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorMinion'
     MeleeRange=50.000000
     GroundSpeed=500.000000
     BaseEyeHeight=35.000000
     Health=50
     DrawScale=1.400000
     CollisionRadius=30.000000
     CollisionHeight=50.000000
}
