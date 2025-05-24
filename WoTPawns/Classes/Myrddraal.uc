//=============================================================================
// Myrddraal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 17 $
//=============================================================================

class Myrddraal expands MyrddraalAssets;

#exec MESH NOTIFY MESH=Myrddraal SEQ=AttackRunSwipe		TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=AttackRunSwipe		TIME=0.40 FUNCTION=SwipeDamageTarget
#exec MESH NOTIFY MESH=Myrddraal SEQ=AttackRunSkewer	TIME=0.63 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=AttackRunSkewer	TIME=0.75 FUNCTION=SkewerDamageTarget
#exec MESH NOTIFY MESH=Myrddraal SEQ=Shoot				TIME=0.5  FUNCTION=ShootRangedAmmo

#exec MESH NOTIFY MESH=Myrddraal SEQ=SwordDown			TIME=0.8  FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Myrddraal SEQ=SwordDown			TIME=0.85 FUNCTION=PlaySwordDownSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=SwordUp			TIME=0.8  FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Myrddraal SEQ=SwordUp			TIME=0.85 FUNCTION=PlaySwordUpSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=BowDown	  		TIME=0.7  FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Myrddraal SEQ=BowDown	  		TIME=0.75 FUNCTION=PlayBowDownSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=BowUp				TIME=0.7  FUNCTION=WeaponSwitchAnimNotification
#exec MESH NOTIFY MESH=Myrddraal SEQ=BowUp				TIME=0.75 FUNCTION=PlayBowUpSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=SeeEnemy			TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=GiveOrders			TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=ReactP  		    TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=ReactPLoop	        TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=Walk				TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=Walk				TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=Run				TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Myrddraal SEQ=Run				TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Myrddraal SEQ=PreTeleport		Time=0.01 FUNCTION=EnableScaleGlowAdjust
#exec MESH NOTIFY MESH=Myrddraal SEQ=PreTeleport		Time=0.05 FUNCTION=InitTeleportEffect

#exec MESH NOTIFY MESH=Myrddraal SEQ=DeathB				TIME=0.70 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Myrddraal SEQ=DeathF				TIME=0.88 FUNCTION=TransitionToCarcassNotification

#exec AUDIO IMPORT FILE=Sounds\Weapon\Myrddraal\Myrddraal_Teleport.wav
#exec AUDIO IMPORT FILE=Sounds\Weapon\Myrddraal\Myrddraal_Reappear.wav

var() float SwipeDamage;	//Total damage this attack sequence does
var() float SkewerDamage;	//Total damage this attack sequence does
//delayed damage to target when hit with melee attack
var() class<AngrealInventory> DelayedDamageAngrealType;
var AngrealInventory DelayedDamageAngreal;
var DecreaseHealthLeech CurrentDecreaseHealthLeech;
var() float DelayedDamageRate;			//rate at which host is affected
var() float DelayedDamageRateScale;		//rate at which rate is scaled
var() float DelayedDamageLifeSpanSecs;	//time (secs) that effect lasts

var TeleportProxy MyrddraalTeleporter;
var () float TeleportPositionCollectionRadius;
var () class<Actor> TeleportPositionCollectionClass;
var () bool bOnlyCollectShadowNodes;

var () class<ParticleSprayer> TeleportParticleSprayerClass;
var ParticleSprayer EnterTeleportParticleSprayer;
var ParticleSprayer ExitTeleportParticleSprayer;
var () float TeleportDuration;
var () float TeleportEffectCrankupDuration;
var private Actor LastTeleportPosition;
var private ActorRotator TeleportSprayerRotator;

const HintName_MyrddraalTeleport = 'MyrddraalTeleport';
const HintName_MyrddraalTaunt = 'PlayTaunt';
const HintName_MyrddraalSniping = 'Snipe';

const TeleportSoundSlot = 'Teleport';
const ReappearSoundSlot = 'Reappear';



function PreBeginPlay()
{
	Super.PreBeginPlay();
	DelayedDamageAngreal = Spawn( DelayedDamageAngrealType );
	MyrddraalTeleporter = Spawn( class'TeleportProxy' );
}



function Destroyed()
{
	if( DelayedDamageAngreal != None )
	{
		DelayedDamageAngreal.Destroy();
		DelayedDamageAngreal = None;
	}
	if( MyrddraalTeleporter != None )
	{
		MyrddraalTeleporter.Destroy();
		MyrddraalTeleporter = None;
	}
	if( EnterTeleportParticleSprayer != None )
	{
		EnterTeleportParticleSprayer.Destroy();
		EnterTeleportParticleSprayer = None;
	}
	if( TeleportSprayerRotator != None )
	{
		TeleportSprayerRotator.Destroy();
		TeleportSprayerRotator = None;
	}
	if( ExitTeleportParticleSprayer != None )
	{
		ExitTeleportParticleSprayer.Destroy();
		ExitTeleportParticleSprayer = None;
	}
	Super.Destroyed();
}



function DefensivePerimiterCompromisedByOffender( DefensiveDetector DefensiveNotification )
{
	local Actor Offender;
	Offender = DefensiveNotification.GetOffender();
	if( Offender.IsA( 'SeekingProjectile' ) && ( SeekingProjectile( Offender ).Destination == Self ) )
	{
		PerformTeleportation();
	}
}



function MoveAwayFromTakeDamageArea()
{
	if( !GetGoal( EGoalIndex.GI_Intermediate ).IsValid( Self ) )
	{
		PerformTeleportation();
	}
	else
	{
		Super.MoveAwayFromTakeDamageArea();
	}
}



function PlaySwordDownSound()
{
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeSheathSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
}



function PlaySwordUpSound()
{
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponMeleeDrawSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
}



function PlayBowDownSound()
{																	 
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponRangedSheathSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
}



function PlayBowUpSound()
{
	MySoundTable.PlaySlotSound( Self, MySoundTable.WeaponRangedDrawSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
}



function HandleHint( Name Hint )
{

	switch( Hint )
	{
		case HintName_MyrddraalTeleport:
			PerformTeleportation();
			break;
		case HintName_MyrddraalTaunt:
			GetNextStateAndLabelForReturn( NextState, NextLabel );
			PlayTaunt();
			break;
		case HintName_MyrddraalSniping:
			GetNextStateAndLabelForReturn( NextState, NextLabel );
			PerformSnipe();
			break;
		default:
			Super.HandleHint( Hint );
			break;
	}
}



function PlayTaunt()
{
	GetNextStateAndLabelForReturn( NextState, NextLabel );
	InterruptMovement();
	GotoState( 'Taunting' );
}



function PerformSnipe()
{
	//xxxrlojbc fix this
	class'WayPointSelectorSniping'.static.SelectWayPoint( GetGoal( EGoalIndex.GI_Intermediate ), Self, CurrentConstrainer, GetGoal( EGoalIndex.GI_Threat ) );
}



function PerformTeleportation()
{
	local Actor TeleportPosition;

	if( FindTeleportPosition( Self, TeleportPosition ) &&
			MyrddraalTeleporter.EnableTeleportProxy( TeleportPosition ) )
	{
		InitGoalWithObject( EGoalIndex.GI_Intermediate, MyrddraalTeleporter );
	}
}



function bool FindTeleportPosition( Pawn TeleportAnchor, out Actor TeleportDestination )
{
   	local int ItemCount, i;
    local Actor PotentialTeleportPosition;
    local ItemSorter TeleportDestinationSorter;
    local bool bGetTeleportDestionation;
    local Actor TeleportPath;
	local Actor ClosestTeleportPosition;
	
	class'Debug'.static.DebugLog( Self, "FindTeleportPosition", DebugCategoryName );
	TeleportDestinationSorter = ItemSorter( class'Singleton'.static.GetInstance( Self.XLevel, class'ItemSorter' ) );
	TeleportDestinationSorter.CollectRadiusItems( TeleportAnchor, TeleportPositionCollectionClass, TeleportPositionCollectionRadius );
	if( TeleportDestinationSorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			if( RejectTeleportPosition( TeleportDestinationSorter.GetItem( i ) ) )
      		{
	      		TeleportDestinationSorter.RejectItem( i );
    	    }
		}
	}
	
	TeleportDestinationSorter.InitSorter();
	TeleportDestinationSorter.SortReq.IR_Origin = TeleportAnchor.Location;
	TeleportDestinationSorter.SortItems();
	
	if( TeleportDestinationSorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			if( TeleportDestinationSorter.IsItemAccepted( i ) )
			{
				PotentialTeleportPosition = TeleportDestinationSorter.GetItem( i );
				if( ClosestTeleportPosition == None )
				{
					ClosestTeleportPosition = PotentialTeleportPosition;
				}
				else
				{
					if( VSize( PotentialTeleportPosition.Location - Location ) < VSize( ClosestTeleportPosition.Location - Location ) )
					{
						ClosestTeleportPosition = PotentialTeleportPosition;
					}
				}
				if( ( ClosestTeleportPosition != None ) &&
						( TeleportAnchor.ActorReachable( ClosestTeleportPosition ) ||
						( TeleportAnchor.FindPathToward( ClosestTeleportPosition ) != None ) ) )
      			{
					bGetTeleportDestionation = true;
					TeleportDestination = TeleportDestinationSorter.GetItem( i );
					LastTeleportPosition = TeleportDestination;
					break;
    	   	 	}
    	    }
		}
	}

	class'Debug'.static.DebugLog( Self, "FindTeleportPosition returning " $ bGetTeleportDestionation, DebugCategoryName );
	return bGetTeleportDestionation;
}



function bool RejectTeleportPosition( Actor TeleportPosition )
{
	local bool bRejectTeleportPosition;

	if( TeleportPosition == None || TeleportPosition == LastTeleportPosition )
	{
		bRejectTeleportPosition = true;
	}
	else if( bOnlyCollectShadowNodes )
	{
		bRejectTeleportPosition = !TeleportPosition.IsA( 'WotPathNode' ) || !WotPathNode( TeleportPosition ).GetDarkFlag();
	}
	return bRejectTeleportPosition;
}



state Taunting expands AnimatingEndOnTakeDamage
{
	function PlayStateAnimation() { PlayAnim( 'SeeEnemy', 0.5 ); }
}



state SuccessfullyNavigatedToGoal
{
	function BeginState()
	{
		local Actor GoalActor;

		if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && ( GoalActor == MyrddraalTeleporter ) )
		{
			SuccessfullyNavigatedToTeleportProxy();
		}
		else if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && ( GoalActor.IsA( 'WOTPathNode' ) ) && WOTPathNode( GoalActor ).GetSnipeFlag() )
		{
			InterruptMovement();
			SuccessfullyNaviagedtoSnipeLocation();
		}
   		else
   		{
	    	Super.BeginState();
   		}
	}

	function SuccessfullyNavigatedToTeleportProxy() { GotoState( 'TeleporterReached' ); }

	function SuccessfullyNaviagedtoSnipeLocation()
	{
		GotoState( 'SnipePointReached' );
	}
}



state SnipePointReached
{
	Begin:
		StopMovement();
		InvalidateGoal( EGoalIndex.GI_Intermediate );
		TransitionOnGoalPriority( true );
		Stop;
}



state TeleporterReached
{
	function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType);

	function BeginState()
	{
		Disable( 'Tick' );
	}

	function TeleportEffect( out ParticleSprayer TeleportParticleSprayerEffect, Vector SprayerLocation )
	{
		if( ( TeleportParticleSprayerEffect == None ) && ( TeleportParticleSprayerClass != None ) )
		{
			TeleportParticleSprayerEffect = Spawn( TeleportParticleSprayerClass,,,, );
		}
		if( TeleportSprayerRotator == None )
		{
				TeleportSprayerRotator = spawn( class'ActorRotator',,,, rotator( vect( 0, 0, 1 ) ) );
				TeleportSprayerRotator.bBounceHeight = true;
				TeleportSprayerRotator.HeightShiftRate = 80.0;
				TeleportSprayerRotator.MaxHeight = 72.0;
				TeleportSprayerRotator.MaxRadius = 24.0;
				TeleportSprayerRotator.MaxRotationRate = 100000.0;
				TeleportSprayerRotator.MinHeight = -30.0;
				TeleportSprayerRotator.MinRadius = 5.0;
				TeleportSprayerRotator.MinRotationRate = 80000.0;
				TeleportSprayerRotator.RadiusShiftRate = 8.0;
				TeleportSprayerRotator.RotationShiftRate = 1000.0;
				TeleportSprayerRotator.MyActor = TeleportParticleSprayerEffect;
				TeleportSprayerRotator.Initialize();																				
		}
		if( TeleportParticleSprayerEffect != None )
		{
			TeleportParticleSprayerEffect.SetLocation( SprayerLocation );
			TeleportSprayerRotator.SetLocation( SprayerLocation );
			TeleportParticleSprayerEffect.Trigger( None, Self );
			TeleportSprayerRotator.Initialize();
		}
	}

	function EnableScaleGlowAdjust()
	{
		Enable( 'Tick' );
	}
	
	function Tick( float DeltaTime )
	{
		if( ScaleGlow > 0.25 )
		{
			ScaleGlow -= 0.025;
			if( Weapon != None )
			{
				Weapon.ScaleGlow -= 0.025;
			}
		}
		else
		{
			ScaleGlow = 0.0;
			if( Weapon != None )
			{
				Weapon.ScaleGlow -= 0.025;
			}
			Disable( 'Tick' );
		}
		Super.Tick( DeltaTime );
	}

	function Vector SelectTeleportLocation()
	{
		local Actor TeleportPosition, TeleportAnchor;
		local Vector TeleportLocation;
		
		if( !GetGoal( EGoalIndex.GI_Threat ).GetGoalActor( Self, TeleportAnchor ) || !TeleportAnchor.IsA( 'Pawn' ) )
		{
			TeleportAnchor = Self;
		}
	
		if( FindTeleportPosition( Pawn( TeleportAnchor ), TeleportPosition ) )
		{
			TeleportLocation = TeleportPosition.Location;
		}
		else
		{
			TeleportLocation = Location;
		}
			
		return TeleportLocation;
	}
	
	function Vector ReturnThreatLocation()
	{
		local Vector ThreatLocation;
		GetGoal( EGoalIndex.GI_Threat ).GetGoalLocation( Self, ThreatLocation );
		return ThreatLocation;
	}

	function Timer()
	{
		GotoState( GetStateName(), NextLabel );
	}
	
	function InitTeleportEffect()
	{
		TeleportEffect( EnterTeleportParticleSprayer, Location );
 	}
	
	function DestroySeekers()
	{
		local Projectile CurrentProjectile;
		local SeekingProjectile CurrentSeekingProjectile;
		for( CurrentProjectile = Level.ProjectileList; ( CurrentProjectile != None ); CurrentProjectile = CurrentProjectile.nextProjectile )
		{
			CurrentSeekingProjectile = SeekingProjectile( CurrentProjectile );
		    if( CurrentSeekingProjectile != None && CurrentSeekingProjectile.Destination == Self )
		    {
		        CurrentSeekingProjectile.SetDestination( None );
		    }
		}
		class'WotUtil'.static.ShiftOutOfLeechesAndReflectors( Self );
	}
	
	Begin:
		PlayInactiveAnimation();
		MyrddraalTeleporter.DisableTeleportProxy();
		InterruptMovement();
		PlayAnim( 'PreTeleport', 0.75 );
		FinishAnim();
		InvalidateGoal( EGoalIndex.GI_Intermediate );
		MySoundTable.PlaySlotSound( Self, TeleportSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		SetTimer( TeleportEffectCrankupDuration, false ); //wait for the effect to crank up
		NextLabel = 'EnterMyrddraalTeleporting';
	
	EnterMyrddraalTeleporting:
		DestroySeekers();
		SetCollision( false, false, false );
		TweenAnim( 'MyrdTeleport', 0.75 );
		FinishAnim();
		bHidden = true;
		SetTimer( TeleportDuration, false );
		NextLabel = 'MyrddraalTeleporting';
		Stop;
	
	MyrddraalTeleporting:
		TeleportEffect( ExitTeleportParticleSprayer, SelectTeleportLocation() ); //initiate the teleport exit effect
		MySoundTable.PlaySlotSound( Self, TeleportSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		SetTimer( TeleportEffectCrankupDuration, false ); //wait for the effect to crank up
		NextLabel = 'ExitMyrddraalTeleporting';
		Stop;
	
	ExitMyrddraalTeleporting:
		MySoundTable.PlaySlotSound( Self, ReappearSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
		SetLocation( TeleportSprayerRotator.Location );
		SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
		SetRotation( Rotator( ReturnThreatLocation() - Location ) );
		ScaleGlow = Default.ScaleGlow;
	
		if( Weapon != None )
		{
			Weapon.ScaleGlow = Weapon.Default.ScaleGlow;
		}
		bHidden = false;
		SetTimer( 0.05, false ); //wait for the fade in time
		NextLabel = 'ResumeBehavior';
		Stop;

	ResumeBehavior:
		TransitionOnGoalPriority( true );
		Stop;
}



state PerformMeleeWeaponAttack
{
	function SwipeDamageTarget()
	{
		if( AttackDamageTarget( SwipeDamage, 0.0, 'Swiped' ) )
		{
			SetupDelayedDamageToGoal();
		}
	}

	function SkewerDamageTarget()
	{
		if( AttackDamageTarget( SkewerDamage, 0.0, 'Skewered' ) )
		{
			SetupDelayedDamageToGoal();
		}
	}
	
	//=========================================================================
	// Hit target with sword -- set up delayed damage to goal using a leech
	// and the delayed damage Angreal.
	//=========================================================================
	
	function SetupDelayedDamageToGoal()
	{
		local Actor	GoalActor;
		PerformTeleportation();
		if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && GoalActor.IsA( 'Pawn' ) )
		{
			if( CurrentDecreaseHealthLeech != None )
			{
				//will replace existing one with a new one
				CurrentDecreaseHealthLeech.UnAttach();
				CurrentDecreaseHealthLeech.Destroy();
			}
			
			CurrentDecreaseHealthLeech = Spawn( class'DecreaseHealthLeech' );
			CurrentDecreaseHealthLeech.AffectResolution = DelayedDamageRate;
			
			//rate of damage will decrease with time
			CurrentDecreaseHealthLeech.AffectResolutionScale = DelayedDamageRateScale;
			CurrentDecreaseHealthLeech.LifeSpan = DelayedDamageLifeSpanSecs;
			CurrentDecreaseHealthLeech.SetSourceAngreal( DelayedDamageAngreal );
			
			//now we can attach it to the goal
			CurrentDecreaseHealthLeech.AttachTo( Pawn( GoalActor ) );
		}
	}
}

defaultproperties
{
     SwipeDamage=20.000000
     SkewerDamage=30.000000
     DelayedDamageAngrealType=Class'WOTPawns.MyrddraalSwordAngreal'
     DelayedDamageRate=1.000000
     DelayedDamageRateScale=1.200000
     DelayedDamageLifeSpanSecs=5.000000
     TeleportPositionCollectionRadius=1600.000000
     TeleportPositionCollectionClass=Class'Engine.NavigationPoint'
     bOnlyCollectShadowNodes=True
     TeleportParticleSprayerClass=Class'WOTPawns.MyrddraalTeleportSprayer2'
     TeleportDuration=2.000000
     TeleportEffectCrankupDuration=2.000000
     BaseWalkingSpeed=140.000000
     DefaultWeaponType=Class'WOTPawns.MyrddraalSword'
     MeleeWeaponType=Class'WOTPawns.MyrddraalSword'
     RangedWeaponType=Class'WOTPawns.MyrddraalBow'
     GroundSpeedMin=560.000000
     GroundSpeedMax=560.000000
     HealthMPMin=350.000000
     HealthMPMax=350.000000
     HealthSPMin=350.000000
     HealthSPMax=350.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     DamageHelperClass=Class'WOT.DamageHelperBlackBlood'
     SoundTableClass=Class'WOTPawns.SoundTableMyrddraal'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListMyrddraal'
     AnimationTableClass=Class'WOTPawns.AnimationTableMyrddraal'
     CarcassType=Class'WOTPawns.WOTCarcassMyrddraal'
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryMyrddraal'
     GoalSuggestedSpeeds(0)=560.000000
     GoalSuggestedSpeeds(2)=560.000000
     GoalSuggestedSpeeds(3)=560.000000
     GoalSuggestedSpeeds(4)=560.000000
     GoalSuggestedSpeeds(5)=560.000000
     GoalSuggestedSpeeds(6)=140.000000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorMyrddraal'
     MeleeRange=50.000000
     GroundSpeed=560.000000
     FovAngle=120.000000
     DrawScale=0.930000
     CollisionRadius=18.000000
     CollisionHeight=50.000000
     Mass=175.000000
}
