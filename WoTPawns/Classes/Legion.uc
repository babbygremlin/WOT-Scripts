//=============================================================================
// Legion.uc
// $Author: Mfox $
// $Date: 1/09/00 4:49p $
// $Revision: 21 $
//=============================================================================

class Legion expands LegionAssets;

// The champion for the Hound.

#exec AUDIO IMPORT FILE=Sounds\Pawn\NPCs\Legion\Leg_Ambient.wav

#exec MESH NOTIFY MESH=Legion SEQ=Shoot			TIME=0.01 FUNCTION=DisableMovement
#exec MESH NOTIFY MESH=Legion SEQ=Shoot			TIME=0.55 FUNCTION=PlayShootSound
#exec MESH NOTIFY MESH=Legion SEQ=Shoot			TIME=0.45 FUNCTION=ShootRangedAmmo

#exec MESH NOTIFY MESH=Legion SEQ=Look			TIME=0.05 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Legion SEQ=LookGroan		TIME=0.05 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP1	TIME=0.01 FUNCTION=DisableMovement
#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP1	TIME=0.1  FUNCTION=PlaySlashSound
//#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP1	TIME=0.71 FUNCTION=AttackStomp1DamageTarget
#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP1	TIME=0.65 FUNCTION=SpawnDamageWave1

#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP2	TIME=0.01 FUNCTION=DisableMovement
#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP2	TIME=0.1  FUNCTION=PlaySlashSound
//#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP2	TIME=0.75 FUNCTION=AttackStomp2DamageTarget
#exec MESH NOTIFY MESH=Legion SEQ=ATTACKSTOMP2	TIME=0.4 FUNCTION=SpawnDamageWave1

#exec MESH NOTIFY MESH=Legion SEQ=Walk			TIME=0.26 FUNCTION=PlayMovementSound 
#exec MESH NOTIFY MESH=Legion SEQ=Walk			TIME=0.53 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Legion SEQ=Walk  		TIME=0.80 FUNCTION=PlayMovementSound 
#exec MESH NOTIFY MESH=Legion SEQ=Walk  		TIME=0.94 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Legion SEQ=Run 			TIME=0.26 FUNCTION=PlayMovementSound 
#exec MESH NOTIFY MESH=Legion SEQ=Run 			TIME=0.53 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Legion SEQ=Run   		TIME=0.80 FUNCTION=PlayMovementSound 
#exec MESH NOTIFY MESH=Legion SEQ=Run   		TIME=0.94 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Legion SEQ=DeathL		TIME=0.66 FUNCTION=TransitionToCarcassNotification

//var () float AttackStomp1Damage=40.000000;
//var () float AttackStomp2Damage=40.000000;
var () Vector SpiritOffsets[ 3 ];
var private LegionSpirit Spirits[ 3 ];
var private AngrealWeaponAdapter AngrealInterface;

const ShootSpiritSoundSlot = 'ShootSpirit';



function AddDefaultInventoryItems()
{
	Super.AddDefaultInventoryItems();
	AngrealInterface = AngrealWeaponAdapter( class'Util'.static.GetInventoryWeapon( Self, class'AngrealWeaponAdapter' ) );
}



simulated function Destroyed()
{
	DestroySpirits();
	Super.Destroyed();
}



simulated function DestroySpirits()
{
	local int i;
	for( i = 0; i < ArrayCount( Spirits ); i++ )
	{
		if( Spirits[ i ] != None )
		{
			Spirits[ i ].Destroy();
			Spirits[ i ] = None;
		}
	}
}



simulated function SetSpiritVisibilities( bool bVisibility )
{
	local int i;
	for( i = 0; i < ArrayCount( Spirits ); i++ )
	{
		if( Spirits[ i ] != None )
		{
			Spirits[ i ].SetVisibility( bVisibility );
		}
	}
}



simulated function Tick( float DeltaTime )
{
	local int i;
	Super.Tick( DeltaTime );

	if( Health <= 0 )
	{
		DestroySpirits();
	}
	else if( !bDeleteMe )
	{
		for( i = 0; i < ArrayCount( Spirits ); i++ )
		{
			if( Spirits[ i ] == None )
			{
				Spirits[ i ] = Spawn( class'LegionSpirit', Self );
				if( i == 1 )
				{
					Spirits[ i ].MinRotationRate *= -1;
					Spirits[ i ].MaxRotationRate *= -1;
					Spirits[ i ].Initialize();
				}
			}
			else
			{
				if( i == 1 )
				{
					Spirits[ i ].SetRotation( Rotation + rot( 8192, 0, 0 ) );
				}
				else
				{
					Spirits[ i ].SetRotation( Rotation );
				}
				Spirits[ i ].SetLocation( Location + ( SpiritOffsets[ i ] >> Rotation ) );
			}
		}
	}
}



simulated function Hide()
{
	Super.Hide();
	SetSpiritVisibilities( bHidden );
}



simulated function Show()
{
	Super.Show();
	SetSpiritVisibilities( bHidden );
}



//=============================================================================
// Notification for when a charge has been used.
//=============================================================================



function ChargeUsed( AngrealInventory Ang )
{
	AngrealInterface.ChargeUsed( Ang );
	Super.ChargeUsed( Ang );
}



//Make sure Legion still fires at the threat even if it is not visible
function EnableDefensiveNotifierNonVisibleNavigation()
{
	//if the npc is intended to use automatic attacks the offensive notifier must be enabled
	//otherwise the npc must explicitly invoke attacks (probably though movement pattern elements and hints)
	DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].EnableNotifier();
	DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].SetDuration( DurationNotifierDurations[ EDurationNotifierIndex.DNI_Offensive ] + 0.45 );
}

function DisableDefensiveNotifierNonVisibleNavigation()
{
	DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].DisableNotifier();
	DurationNotifiers[ EDurationNotifierIndex.DNI_Offensive ].SetDuration( DurationNotifierDurations[ EDurationNotifierIndex.DNI_Offensive ] );
}

	
	
//=============================================================================
//	AttemptAttack state
//=============================================================================



state AttemptAttack
{
	function bool WithinMaxMeleeDistance( GoalAbstracterInterf Goal )
	{
		local float GoalDistance;
		local bool bWithinMaxMeleeDistance;
		if( !Goal.IsGoalVisible( Self ) )
		{
			// throw in the odd seeker even at melee distance
			bWithinMaxMeleeDistance = false;
		}
		else if( Super.WithinMaxMeleeDistance( Goal ) )
		{
			bWithinMaxMeleeDistance = true;
		}
		return bWithinMaxMeleeDistance;
	}

	function bool GetAttackActor( out Actor AttackActor, GoalAbstracterInterf Goal )
	{
		local bool bGetAttackActor;
		class'Debug'.static.DebugLog( Self, "GetAttackActor", 'Legion' );
		if( WithinMaxMeleeDistance( Goal ) )
		{
			//no current weapon
			//in melee range
			AttackActor = Self;
			bGetAttackActor = true;
		}
		else
		{
			bGetAttackActor = Super.GetAttackActor( AttackActor, Goal );
		}
		class'Debug'.static.DebugLog( Self, "GetAttackActor AttackActor " $ AttackActor $ " returning " $ bGetAttackActor, 'Legion' );
		return bGetAttackActor;
	}
}



//=============================================================================
//	PerformMeleeAttack state
//=============================================================================



state PerformMeleeAttack
{
	function EndState()
	{
		bNotifyAchievedRotation = false;
		RotationRate = default.RotationRate; //xxxrlo set rotation back to normal
		Super.EndState();
	}

	simulated function SpawnDamageWave1()
	{
		local LegionStompVolcano Volcano;
		local Actor GoalActor;
		local Vector HitLocation, HitNormal, VolcanoLocation, GoalLocation;
		RotationRate *= 0; //xxxrlo hack to make shure he does not move any more
		if( GetGoal( CurrentGoalIdx ).GetGoalLocation( Self, GoalLocation ) )
		{
			if( WithinMaxMeleeDistance( GetGoal( CurrentGoalIdx ) ) )
			{
				VolcanoLocation = GoalLocation;
			}
			else
			{
				VolcanoLocation = Normal( GoalLocation  - Location ) * ( CollisionRadius + MeleeRange );
			}

			if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) )
			{
				VolcanoLocation += GoalActor.Velocity * 0.3;
			}
			
			ShakeRadius();

			Volcano = Spawn( class'LegionStompVolcano', GoalActor, , VolcanoLocation );
			
			if( Trace( HitLocation, HitNormal, Volcano.Location + ( ( vect( 0, 0, -1 ) * 1000 ) >> Volcano.Rotation ), Volcano.Location, false ) != None )
			{
				Volcano.SetLocation( HitLocation );
			}
		}
	}

	function ShakeRadius( optional float MomentumModifier )
	{
		local Pawn PawnIter;
		local float Distance, ShakeMag;
		local Vector Momentum;
		foreach RadiusActors( class'Pawn', PawnIter, 2500 )
		{
			if( ( PawnIter.Physics == PHYS_Walking ) && ( PawnIter.Velocity.Z == 0 ) )
			{
				Distance = VSize( Location - PawnIter.Location );
				ShakeMag = FMax( 750, ( 2400 - Distance ) );
				if( PawnIter.IsA( 'PlayerPawn' ) )
				{
					PlayerPawn( PawnIter ).ShakeView( FMax( 0, 0.35 - ( Distance / 25000 ) ), ShakeMag, ( ShakeMag * 0.015 ) );
				}
				if( ( PawnIter != Self ) && ( PawnIter.Velocity.Z == 0 ) )
				{
					Momentum = ( -0.75 * PawnIter.Velocity ) + ( 100 * VRand() );
					Momentum.Z =  7000000.0 / ( ( 0.75 * ( Distance + 500 ) ) * PawnIter.Mass );
					if( MomentumModifier != 0 )
					{
						Momentum.Z *= MomentumModifier;
					}
					PawnIter.AddVelocity( Momentum );
				}
			}
		}
	}
}



//=============================================================================
//	PerformProjectileAttack state
//=============================================================================



state PerformProjectileAttack
{
	function BeginState()
	{
		bNotifyAchievedRotation = false;
		Super.BeginState();
	}
	
	function EndState()
	{
		bNotifyAchievedRotation = false;
		RotationRate = default.RotationRate; //xxxrlo set rotation back to normal
		Super.EndState();
	}

	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
	}

	function ExecuteLabel( name LabelToExecute, name ReturnLabel )
	{
		NextLabel = ReturnLabel;
		GotoState( GetStateName(), LabelToExecute );
	}
	
	event OnAchievedRotation( Vector FocalPoint )
	{
		class'Debug'.static.DebugLog( Self, "OnAchievedRotation", DebugCategoryName );
		GotoState( GetStateName(), 'FinsidedTurnTo' );
	}

	function InterruptMovement()
	{
		Super.InterruptMovement();
		if( bNotifyAchievedRotation )
		{
			bNotifyAchievedRotation = false;
			OnAchievedRotation( Location );
		}
	}
	
	function PrePerformingAttack()
	{
		class'Debug'.static.DebugLog( Self, "PrePerformingAttack:", DebugCategoryName );
		RotationRate *= 0; //xxxrlo hack to make shure he does not move any more
		Super.PrePerformingAttack();
	}
	
/*
//xxxrlo multiple projectile attacks
	function PerformingAttack()
	{
		class'Debug'.static.DebugLog( Self, "PerformingAttack:", DebugCategoryName );
		if( FRand() < 0.33 )
		{
			PrePerformingAttack();
		}
		else
		{
			Super.PerformingAttack();
		}
	}
*/
	
	function PlayShootSound()
	{
		MySoundTable.PlaySlotSound( Self, ShootSpiritSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}

Begin:
	class'Debug'.static.DebugLog( Self, "Begin:", class'Debug'.default.DC_StateCode );
	LastTrackingTime = Level.TimeSeconds;
	class'FocusSelectorOnGoal'.static.SelectFocus( GetGoal( EGoalIndex.GI_CurrentFocus ),
			GetGoal( EGoalIndex.GI_CurrentWaypoint ), Self, CurrentConstrainer, GetGoal( CurrentGoalIdx ) );

	class'Debug'.static.DebugLog( Self, "PerformTurnPlayAnim:", class'Debug'.default.DC_StateCode );
	LoopMovementAnim( GetGoal( CurrentGoalIdx ).GetSuggestedSpeed( Self ) );
	bNotifyAchievedRotation = true;
	if( CurrentMovementManager.ReturnFocus().IsValid( Self ) )
	{
		DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].EnableNotifier();
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
	Stop;
	
FinsidedTurnTo:
	class'Debug'.static.DebugLog( Self, "FinsidedTurnTo:", class'Debug'.default.DC_StateCode );
	bNotifyAchievedRotation = false;
	DurationNotifiers[ EDurationNotifierIndex.DNI_Rotation ].DisableNotifier();
	GotoState( GetStateName(), 'PrePerformingAttack' );
}



//=============================================================================
//	SearchingUnnavigable state
//=============================================================================



state SearchingUnnavigable
{
	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		EnableDefensiveNotifierNonVisibleNavigation();
	}
	
	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DisableDefensiveNotifierNonVisibleNavigation();
	}
}



//=============================================================================
//	SearchingPathable state
//=============================================================================



state SearchingPathable
{
	function BeginStatePrepareNotifiers()
	{
		Super.BeginStatePrepareNotifiers();
		EnableDefensiveNotifierNonVisibleNavigation();
	}
	
	function EndStatePrepareNotifiers()
	{
		Super.EndStatePrepareNotifiers();
		DisableDefensiveNotifierNonVisibleNavigation();
	}
}


// xxxrlo:
function Killed( pawn Killer, pawn Other, name DamageType )
{
	local LegionProjectile LProj;

	// projectiles which were seeking dead player should lose the target so they don't 
	// proceed to hunt him down again if/when he respaws in a multiplayer game
	foreach AllActors( class'LegionProjectile', LProj )
	{
		if( LProj.Destination == Other )
		{
			LProj.TargetDestroyed();
		}
	}

	Super.Killed( Killer, Other, DamageType );
}

defaultproperties
{
     SpiritOffsets(1)=(X=-50.000000)
     SpiritOffsets(2)=(X=50.000000,Z=50.000000)
     BaseWalkingSpeed=50.000000
     DefaultWeaponType=Class'WOTPawns.LegionWeaponAdapter'
     MeleeWeaponType=Class'WOTPawns.LegionWeaponAdapter'
     RangedWeaponType=Class'WOTPawns.LegionWeaponAdapter'
     DefaultReflectorClasses(1)=Class'WOTPawns.LegionTargetingReflector'
     DisguiseIcon=Texture'WOTPawns.UI.H_LegionDisguise'
     GroundSpeedMin=50.000000
     GroundSpeedMax=50.000000
     HealthMPMin=1000.000000
     HealthMPMax=1000.000000
     HealthSPMin=1000.000000
     HealthSPMax=1000.000000
     TextureHelperClass=Class'WOTPawns.NPCLegionTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableLegion'
     AnimationTableClass=Class'WOTPawns.AnimationTableLegion'
     CarcassType=Class'WOTPawns.WOTCarcassLegion'
     GibForSureFinalHealth=-120.000000
     GibSometimesFinalHealth=-90.000000
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryLegion'
     GoalSuggestedSpeeds(0)=125.000000
     GoalSuggestedSpeeds(2)=125.000000
     GoalSuggestedSpeeds(3)=125.000000
     GoalSuggestedSpeeds(4)=125.000000
     GoalSuggestedSpeeds(5)=125.000000
     GoalSuggestedSpeeds(6)=62.500000
     DefaultInventoryTypes(0)=Class'WOTPawns.LegionInvSeeker'
     DefaultInventoryTypes(1)=Class'WOTPawns.LegionStompAngrealInv'
     NavigationProxyClass=Class'Legend.NavigationProxyPawn'
     MeleeRange=500.000000
     GroundSpeed=50.000000
     BaseEyeHeight=100.000000
     FovAngle=150.000000
     Health=300
     DrawScale=2.500000
     SoundRadius=255
     AmbientSound=Sound'WOTPawns.Leg_Ambient'
     CollisionRadius=100.000000
     CollisionHeight=110.000000
     Mass=3000.000000
     RotationRate=(Pitch=0,Yaw=10000,Roll=1024)
}
