//=============================================================================
// Warder.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 10 $
//=============================================================================

// The grunt for the Aes Sedai

class Warder expands WarderAssets;

#exec MESH NOTIFY MESH=Warder SEQ=AttackRunLunge			TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=AttackRunLunge			TIME=0.40 FUNCTION=Attack1DamageTarget

#exec MESH NOTIFY MESH=Warder SEQ=AttackRunSwipe			TIME=0.35 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=AttackRunSwipe			TIME=0.40 FUNCTION=Attack1DamageTarget

#exec MESH NOTIFY MESH=Warder SEQ=SkewRip       TIME=0.20 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=SkewRip       TIME=0.02 FUNCTION=AttackSkewDamageTarget
#exec MESH NOTIFY MESH=Warder SEQ=SkewRip       TIME=0.65 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=SkewRip       TIME=0.70 FUNCTION=AttackRipDamageTarget

#exec MESH NOTIFY MESH=Warder SEQ=DbleSwipe     TIME=0.10 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=DbleSwipe     TIME=0.20 FUNCTION=Attack3DamageTarget
#exec MESH NOTIFY MESH=Warder SEQ=DbleSwipe     TIME=0.60 FUNCTION=PlaySlashSound
#exec MESH NOTIFY MESH=Warder SEQ=DbleSwipe     TIME=0.70 FUNCTION=Attack3DamageTarget

#exec MESH NOTIFY MESH=Warder SEQ=Look			TIME=0.05 FUNCTION=IncreaseVisibilitySlow
#exec MESH NOTIFY MESH=Warder SEQ=Look			TIME=0.94 FUNCTION=DecreaseVisibilitySlow
#exec MESH NOTIFY MESH=Warder SEQ=RubNeck		TIME=0.05 FUNCTION=IncreaseVisibilitySlow
#exec MESH NOTIFY MESH=Warder SEQ=RubNeck		TIME=0.94 FUNCTION=DecreaseVisibilitySlow

//notification functions triggered right at the start of the corresponding animations
#exec MESH NOTIFY MESH=Warder SEQ=Breath		TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=Landed		TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=Listen		TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=Look      	TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=ReactP  		TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=ReactPLoop	TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Warder SEQ=RubNeck   	TIME=0.01 FUNCTION=PlayAnimSound

#exec MESH NOTIFY MESH=Warder  SEQ=Walk         TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Warder  SEQ=Walk         TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Warder  SEQ=Run          TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Warder  SEQ=Run          TIME=0.87 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Warder  SEQ=DeathL		TIME=0.40 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Warder  SEQ=DeathF		TIME=0.70 FUNCTION=TransitionToCarcassNotification

#exec TEXTURE IMPORT NAME=WCamo_01	FILE=MODELS\Camo-1.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_02	FILE=MODELS\Camo-2.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_03	FILE=MODELS\Camo-3.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_04	FILE=MODELS\Camo-4.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_05	FILE=MODELS\Camo-5.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_06	FILE=MODELS\Camo-6.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_07	FILE=MODELS\Camo-7.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_08	FILE=MODELS\Camo-8.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_09	FILE=MODELS\Camo-9.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_10	FILE=MODELS\Camo-10.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=WCamo_11	FILE=MODELS\Camo-11.pcx GROUP=Skins FLAGS=2

enum FadeType
{
	FT_FadeIn,
	FT_FadeOut
};

// damage per slash for various attacks
var() float	 			Attack1Damage;				
var() float	 			Attack2Damage;				
var() float  			Attack3Damage;	
			
var() float				MinScaleGlow;				//minimum scale glow for weapon
var() float				MaxScaleGlow;				//maximum scale glow for weapon
var() float				MinVisibility;				//minimum visibility to other NPCs

var() float				FadeInChangeTime;			//secs to go from completely faded to completely visible
var() float				FadeOutChangeTime;			//secs to go from completely visible to completely faded
var() float				FadeInSlowChangeTime;		//secs to go from completely faded to completely visible when guarding and moves a bit
var() float				FadeOutSlowChangeTime;		//secs to go from completely visible to completely faded when guarding and moves a bit
var() float				FadeLevels;					//number of fade levels mapped to FadeSkins
var() Texture			FadeSkins[ 12 ];			//camouflage skins
var private FadeType 	FadeDirection;

var private int			FadeLevel;
var private int			NumAnimSkins;

var() float				ConscriptedStrengthMultiplier;
var() float				SkewRipVelocityZ;			//upward velocity for skew-rip lift
var() float				MaxAcquireTargeDistance;	//target (enemy) must be this close for the warder to acquire him
var() bool				bChaseOnLossOfLOS;			//whether to chase if LOS to goal we are waiting for is lost
//var private Actor   	WaitingAcquiredGoalActor;	//waiting for this actor to get in range

const MaxAnimSkins = 12;
const WaitAcquiredAnimSlot			= 'WaitAcquired';
const CloakVolumeReductionPct = 0.10;



function PreBeginPlay()
{
	Super.PreBeginPlay();
	NumAnimSkins = 0;
	while( NumAnimSkins<MaxAnimSkins && FadeSkins[ NumAnimSkins ] != None )
	{
		NumAnimSkins++;
	}
	FadeLevel = FadeLevels;		
}



function Died( Pawn Killer, Name DamageType, vector HitLocation )
{
	//if pawn dies while in WaitingIdle, he stays WaitingIdle
	//until after the call to died, so SetStyleForVisible has no effect -- for
	//now forcing state to '', but why should an attacked and killed pawn be
	//staying in WaitingIdle?
	Global.SetStyleForVisible();
	Super.Died( Killer, damageType, HitLocation );
}



function SetStyleForFaded()
{
	//warder uses a set of modulated textures
	Style = STY_Modulated;
  	AmbientGlow = 0;
  	//weapon uses a translucent skin
	Weapon.Style = STY_Translucent;
	Weapon.AmbientGlow = 0;
}



static function SetStyleForVisibleActor( Actor VisibleActor )
{
	local int i;
	VisibleActor.Style = VisibleActor.default.Style;
	VisibleActor.Skin = VisibleActor.default.Skin;
	for( i = 0; i < ArrayCount( VisibleActor.MultiSkins ); i++ )
	{
		VisibleActor.MultiSkins[ i ] = VisibleActor.default.MultiSkins[ i ];
	}
	VisibleActor.AmbientGlow = VisibleActor.default.AmbientGlow;
}
	


function SetStyleForVisible()
{
	SetStyleForVisibleActor( Self );
	if( Weapon != None )
	{
		SetStyleForVisibleActor( Weapon );
	}
	Visibility = default.Visibility;
}



function SetFadeSkins( int SkinIndex )
{
	if( MultiSkins[ 1 ] != FadeSkins[ SkinIndex ] )
	{
		MultiSkins[ 1 ] = FadeSkins[ SkinIndex ];
		MultiSkins[ 2 ] = FadeSkins[ SkinIndex ];
		MultiSkins[ 4 ] = FadeSkins[ SkinIndex ];
	}
}
		


function SetFadeLevel( float NewFadeLevel )
{
	local int SkinIndex;
	local float NewScaleGlow;	
	
//assert( NewFadeLevel >= 0 && NewFadeLevel <= FadeLevels );

	FadeLevel = NewFadeLevel;
	//pick 1 of N skins
	SkinIndex = Min( FadeLevel / FadeLevels * NumAnimSkins, NumAnimSkins-1 );
	SetFadeSkins( SkinIndex );
	NewScaleGlow = FadeLevel / FadeLevels * ( MaxScaleGlow - MinScaleGlow ) + MinScaleGlow;
	if( Weapon != None )
	{
		//use scaleglow for the weapon
		Weapon.ScaleGlow = NewScaleGlow;
	}
	//visibility to bots/NPCs should be linked to fade level / scale glow
	Visibility = ( FadeLevel / FadeLevels * ( default.Visibility - MinVisibility ) + MinVisibility );
}



function OnFadeNotification( Notifier Notification )
{
	local float NewFadeLevel, DeltaTime;
	DeltaTime = DurationNotifier( Notification ).ElapsedTime;
	if( FadeDirection == FT_FadeOut )
	{
		// make sure we are transparent etc.
		SetStyleForFaded();
		NewFadeLevel = FadeLevel - ( FadeLevels * DeltaTime / FadeOutChangeTime );
		if( NewFadeLevel <= 0 )
		{
			// min visibility reached
			NewFadeLevel = 0;
			DurationNotifiers[ EDurationNotifierIndex.DNI_Misc2 ].DisableNotifier();
		}
	}
	else
	{
		NewFadeLevel = FadeLevel + ( FadeLevels * DeltaTime / FadeInChangeTime );
		if( NewFadeLevel >= FadeLevels )
		{
			// max visibility restored
			NewFadeLevel = FadeLevels;
			DurationNotifiers[ EDurationNotifierIndex.DNI_Misc2 ].DisableNotifier();
			SetStyleForVisible();
		}
	}
	SetFadeLevel( NewFadeLevel );
}



function float GetStrengthMultiplier()
{
	local float StrengthMultiplier;
	if( FindLeader() )
	{
		//Warder gets a strength increase when conscripted by a guarding Aes Sedai.
		StrengthMultiplier = ConscriptedStrengthMultiplier;
	}
	else
	{
		StrengthMultiplier = 1.0;
	}
	return StrengthMultiplier;
}



//=============================================================================
// PerformMeleeWeaponAttack state
//=============================================================================

state PerformMeleeWeaponAttack
{
	function Attack1DamageTarget()
	{
		AttackDamageTarget( Attack1Damage * GetStrengthMultiplier(), -0.5, 'Sliced' );
	}

	function AttackSkewDamageTarget()
	{
		if( !AttackDamageTarget( Attack2Damage * GetStrengthMultiplier(), 0.0, 'SkewRip' ) )
		{
			bAnimFinished = true;
		}
	}

	function AttackRipDamageTarget()
	{
		local Actor	GoalActor;	
		
		if( AttackDamageTarget( Attack2Damage * GetStrengthMultiplier(), 0.0, 'Ripped' ) )
		{
			if( GetGoal( CurrentGoalIdx ).GetGoalActor( Self, GoalActor ) && GoalActor.IsA( 'Pawn' ) && GoalActor.Velocity.Z <= 0 )
			{
				Pawn( GoalActor ).AddVelocity( ( 75000 * ( Normal( Location - GoalActor.Location ) + vect( 0, 0, 0 ) ) ) / GoalActor.Mass );
				Pawn( GoalActor ).Velocity.Z += SkewRipVelocityZ;
			}
		}			
	}
		
	function Attack3DamageTarget()
	{
		if( !AttackDamageTarget( Attack3Damage * GetStrengthMultiplier(), 0.5, 'Diced' ) )
		{
			bAnimFinished = true;
		}
	}
	
	function PlayStateAnimation()
	{
		Super.PlayStateAnimation();
		if( AnimSequence == 'SkewRip' || AnimSequence == 'DbleSwipe' )
		{
			InterruptMovement();
			DurationNotifiers[ EDurationNotifierIndex.DNI_Movement ].DisableNotifier();
		}
	}
}



//=============================================================================
// InitialAcquisition state
//=============================================================================

state InitialAcquisition
{
	function PlayStateAnimation() {}
}



//=============================================================================
// WaitingIdle state
//=============================================================================

state () WaitingIdle
{
	function EndState()
	{
		if( !bCowering )
		{
			DisableFade();
			bCowering = true;
		}
	}
	
	function bool ShouldContinueWaiting( EGoalIndex PriorityGoalIndex )
	{
		local bool bContinue;
		local Actor GoalActor;
		
		bContinue = Super.ShouldContinueWaiting( PriorityGoalIndex );
		if( !bContinue && ( PriorityGoalIndex == EGoalIndex.GI_Threat ) )
		{
			//warder waits until goal is within xxx units before attacking if he loses
			//LOS to the actor that he is waiting for, he goes back to waiting as before
			if( GetGoal( PriorityGoalIndex ).GetGoalActor( Self, GoalActor ) &&
				GoalActor.IsA( 'Pawn' ) )
			{
				// have a valid pawn goal
				if( class'Util'.static.PawnCanSeeActor( Self, GoalActor, , true ) )
				{
					//wait for pawn to get closer
					bContinue = ( VSize( Location - GoalActor.Location ) > MaxAcquireTargeDistance );
				}
				else
				{
					//the threat is not visible
					//go searching...or back to waiting
					bContinue = !bChaseOnLossOfLOS;
				}
			}
		}
		return bContinue;
	}
	
	function PlayStateAnimation()
	{
		if( GetGoal( EGoalIndex.GI_Threat ).IsValid( Self ) )
		{
			AnimationTableClass.static.TweenPlaySlotAnim( Self, WaitAnimSlot );
		}
		else
		{
			AnimationTableClass.static.TweenPlaySlotAnim( Self, WaitAcquiredAnimSlot );
		}
	}

	//should never become totally visible in this state
	//xxxrlo function SetStyleForVisible();

	function IncreaseVisibility()
	{
		FadeDirection = FT_FadeIn;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Misc2 ].EnableNotifier();
	}
	
	function DecreaseVisibility()
	{
		FadeDirection = FT_FadeOut;
		DurationNotifiers[ EDurationNotifierIndex.DNI_Misc2 ].EnableNotifier();
	}
	
	function IncreaseVisibilitySlow()
	{
		FadeInChangeTime = FadeInSlowChangeTime;
		IncreaseVisibility();
	}
	
	function DecreaseVisibilitySlow()
	{
		FadeOutChangeTime = FadeOutSlowChangeTime;
		DecreaseVisibility();
	}
	
	function DisableFade()
	{
		FadeInChangeTime = default.FadeInChangeTime;
		IncreaseVisibility();
	}
	
	function EnableFade()
	{
		FadeOutChangeTime = default.FadeOutChangeTime;
		DecreaseVisibility();
    }
    
PostTrackGoal:
	bCowering = true; //xxxrlo hyper bogus
	
WaitingIdle:
	LastTrackingTime = Level.TimeSeconds;
	if( bCowering )
	{
   		EnableFade();
		bCowering = false;
   	}
	if( GetGoal( EGoalIndex.GI_Threat ).IsValid( Self ) )
	{
		// waiting for goal to get closer -- don't make as much noise
		VolumeMultiplier = CloakVolumeReductionPct * default.VolumeMultiplier;
		AnimationTableClass.static.TweenPlaySlotAnim( Self, WaitAcquiredAnimSlot );
		FinishAnim();
		VolumeMultiplier = default.VolumeMultiplier;
	}
	else
	{
		AnimationTableClass.static.TweenPlaySlotAnim( Self, WaitAnimSlot );
		FinishAnim();
	}
	ExecuteLabel( 'PerformInactivity', 'WaitingIdle_PostPerformInactivity' );
	WaitingIdle_PostPerformInactivity:
	Goto( 'WaitingIdle' );
	Stop;

WaitingCower:
	if( !bCowering )
	{
		DisableFade();
		bCowering = true;
	}
	AnimationTableClass.static.TweenPlaySlotAnim( Self, ShowRespectAnimSlot );
	FinishAnim();
	AnimationTableClass.static.TweenLoopSlotAnim( Self, ShowRespectLoopAnimSlot );
	// sit in loop until hell freezes over (or state changes...)
	Stop;
}

defaultproperties
{
     Attack1Damage=20.000000
     Attack2Damage=20.000000
     Attack3Damage=15.000000
     MinScaleGlow=0.040000
     MaxScaleGlow=1.000000
     MinVisibility=16.000000
     FadeInChangeTime=1.000000
     FadeOutChangeTime=2.000000
     FadeInSlowChangeTime=10.000000
     FadeOutSlowChangeTime=2.000000
     FadeLevels=1000.000000
     FadeSkins(0)=Texture'WOTPawns.Skins.WCamo_11'
     FadeSkins(1)=Texture'WOTPawns.Skins.WCamo_10'
     FadeSkins(2)=Texture'WOTPawns.Skins.WCamo_09'
     FadeSkins(3)=Texture'WOTPawns.Skins.WCamo_08'
     FadeSkins(4)=Texture'WOTPawns.Skins.WCamo_07'
     FadeSkins(5)=Texture'WOTPawns.Skins.WCamo_06'
     FadeSkins(6)=Texture'WOTPawns.Skins.WCamo_05'
     FadeSkins(7)=Texture'WOTPawns.Skins.WCamo_04'
     FadeSkins(8)=Texture'WOTPawns.Skins.WCamo_03'
     FadeSkins(9)=Texture'WOTPawns.Skins.WCamo_02'
     FadeSkins(10)=Texture'WOTPawns.Skins.WCamo_01'
     FadeSkins(11)=Texture'WOTPawns.Skins.JWarder1'
     ConscriptedStrengthMultiplier=2.000000
     SkewRipVelocityZ=250.000000
     MaxAcquireTargeDistance=300.000000
     bChaseOnLossOfLOS=True
     BrokenMoralePct=5
     BaseWalkingSpeed=156.250000
     DefaultWeaponType=Class'WOTPawns.WarderSword'
     MeleeWeaponType=Class'WOTPawns.WarderSword'
     GroundSpeedMin=625.000000
     GroundSpeedMax=625.000000
     HealthMPMin=150.000000
     HealthMPMax=150.000000
     HealthSPMin=150.000000
     HealthSPMax=150.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableWarder'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListWarder'
     AnimationTableClass=Class'WOTPawns.AnimationTableWarder'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     DebugCategoryName=Warder
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryWarder'
     GoalSuggestedSpeeds(0)=580.000000
     GoalSuggestedSpeeds(2)=580.000000
     GoalSuggestedSpeeds(3)=580.000000
     GoalSuggestedSpeeds(4)=580.000000
     GoalSuggestedSpeeds(5)=580.000000
     GoalSuggestedSpeeds(6)=156.250000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorWarder'
     DurationNotifierClasses(8)=Class'Legend.DurationNotifier'
     DurationNotifierNotifications(8)=OnFadeNotification
     DurationNotifierDurations(8)=0.010000
     DodgeVelocityFactor=200.000000
     DodgeVelocityAlltitude=80.000000
     MeleeRange=50.000000
     GroundSpeed=580.000000
     WaterSpeed=160.000000
     Health=150
     DrawScale=1.180000
     CollisionRadius=17.000000
     Mass=200.000000
}
