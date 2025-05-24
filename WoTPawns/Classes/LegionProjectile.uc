//=============================================================================
// LegionProjectile.
//=============================================================================

class LegionProjectile expands SeekingProjectile;



#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_Ambient1.wav	// ambient sound
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_Spawn1.wav		// sound when spawned
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_HitPawn1.wav	// sound when hits a pawn
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_HitWall1.wav	// sound when hits wall
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_Closing1.wav	// played when close to target
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_TakeDamage1.wav	// played when projectile takes damage #1
#exec AUDIO IMPORT FILE=Sounds\Weapon\Spirit\Spirit_TakeDamage2.wav	// played when projectile takes damage #2

#exec TEXTURE IMPORT NAME=LegionSpiritHead2 FILE=MODELS\LegionSpiritHead2.PCX GROUP=Skins FLAGS=2 // bigpart01


var() vector					Offset;
var(WOTSounds) Sound			SoundClosing;				// sound for when approaches target
var(WOTSounds) Sound			SoundHitWall;				// hit wall sound
var(WOTSounds) Sound			SoundTakeDamage1;			// took damage sound
var(WOTSounds) Sound			SoundTakeDamage2;			// took damage sound
var(WOTSounds) Sound			SoundKilled;				// "died" sound
var(WOTSounds) Sound			SoundTouchDown;				// landed after dying sound
var(WOTSounds) float			ClosingVolume;

var() int						RotationRange;
var() float						SpinRate;
var private float				TotalRotDelta;
var private int					SpinDir;

var() float						ClosingEffectMaxSpeedRatio;
var() float						ClosingEffectSpeed;
var() float						ClosingEffectMinTime;
var() float						ClosingEffectDistance;
var private float				ClosingEffectTimer;
var private bool				bClosingEffect;
var() Texture					ClosingEffectSkin;
var() int						Health;

var	private	LegionSpiritTail	Trail;



simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Trail = Spawn( class'LegionSpiritTail',,, Location );

	SpinDir = 1;
	TotalRotDelta = 0.0;
}



simulated function Destroyed()
{
	Super.Destroyed();

	if( Trail != None )
	{
		Trail.Destroy();
	}
}



simulated function EnableClosingEffect()
{
	MultiSkins[1]=ClosingEffectSkin;

    AmbientGlow=255;

	if( SoundClosing != None )
	{
	    PlaySound( SoundClosing,, ClosingVolume ); 
	}

	bClosingEffect=true;
}



simulated function DisableClosingEffect()
{
	MultiSkins[1]=default.MultiSkins[1];

    AmbientGlow=default.AmbientGlow;

	bClosingEffect=false;
}



simulated function bool ClosingEffectConditions()
{
	local bool bRetVal;

	if( (Destination != None) && 
		(VSize(Location - Destination.Location) <= ClosingEffectDistance) )
	{
		// have a target, close to target, moving at specified % of max speed
		// use different sound?
		bRetVal = true;
	}
	else
	{
		bRetVal = false;
	}

	return bRetVal;
}



simulated function Tick( float DeltaTime )
{
	local rotator Rot;
	local float RotDelta;
	
	Super.Tick( DeltaTime );

	if( SpinRate != 0.0 )
	{
		// Make the projectile's head toss from side to side a bit.
		Rot = Rotation;

		RotDelta = SpinDir * DeltaTime*SpinRate;

/*
		log( "Rot.Roll: "		$ Rot.Roll );
		log( "DeltaTime: "		$ DeltaTime );
		log( "RotDelta: "		$ RotDelta );
		log( "TotalRotDelta: "	$ TotalRotDelta );
		log( "SpinRate: "		$ SpinRate );
		log( "SpinDir: "		$ SpinDir );
*/
		Rot.Roll = (Rot.Roll + RotDelta) & 0xFFFF;

		TotalRotDelta += RotDelta;

		if( Abs( TotalRotDelta ) >= RotationRange )
		{
//			log( "  resetting, speed: " $ speed );

			// set RotationRange to bring us x units past roll=0
			if( SpinDir == 1 )
			{
				RotationRange = Rot.Roll + class'util'.static.PerturbInt( default.RotationRange, default.RotationRange/4 );
			}
			else
			{
				RotationRange = (65536-Rot.Roll) + class'util'.static.PerturbInt( default.RotationRange, default.RotationRange/4 );
			}

			SpinRate = speed/default.speed*class'util'.static.PerturbFloatPercent( default.SpinRate, 50.0 );

			SpinDir *= -1;
			TotalRotDelta = 0.0;
		}

		SetRotation( Rot );
	}

	if( ClosingEffectConditions() )
	{
		if( !bClosingEffect && Health > 0 )
		{
			// not already doing the closing effect
			EnableClosingEffect();
			ClosingEffectTimer = Level.TimeSeconds + ClosingEffectMinTime;
		}
	}
	else if( bClosingEffect && (ClosingEffectMinTime!= 0.0) && (Level.TimeSeconds >= ClosingEffectTimer) )
	{
		DisableClosingEffect();
	}

	Trail.SetLocation( Location+(Offset >> Rotation) );
}



simulated function HitWall( vector HitNormal, actor Wall )
{
	if( SoundHitWall != None )
	{
	    PlaySound( SoundHitWall );
	}

	Destroy();
}



simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	Super.ProcessTouch( Other, HitLocation );

    if( Pawn(Other) == None ) 
	{
		// ran into something which isn't alive
		if( SoundHitWall != None )
		{
		    PlaySound( SoundHitWall );
		}
		Destroy();
	}
}



function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, vector Momentum, name DamageType )
{
    Health -= Damage;
	if( Health <= 0 )
	{
		GotoState( 'VeryDead' );
	}
	else
	{
		if( FRand() < 0.5 && SoundTakeDamage2 != None )
		{
			PlaySound( SoundTakeDamage2 );
		}
		else
		{
			if( SoundTakeDamage1 != None )
			{
				PlaySound( SoundTakeDamage1 );
			}
		}
	}			   
}



//=============================================================================
// VeryDead state
//=============================================================================



state VeryDead
{
	ignores ProcessDamage, TakeDamage;

	simulated function TouchDown()
	{
		if( SoundTouchDown != None )
		{
		    PlaySound( SoundTouchDown );
		}

		Destroy();
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		TouchDown();
	}

	simulated function Landed( vector HitNormal )
	{
		TouchDown();
	}

	simulated function Tick( float DeltaTime )
	{
		local rotator Rot;
		local float RotDelta;
	
		Super.Tick( DeltaTime );

		Rot = Rotation;

		RotDelta = SpinDir * DeltaTime*SpinRate;

		Rot.Roll = (Rot.Roll + RotDelta) & 0xFFFF;

		TotalRotDelta += RotDelta;

		SetRotation( Rot );

		Trail.SetLocation( Location+(Offset >> Rotation) );
	}

	function BeginState()
	{	
		SpinRate=default.SpinRate*100;

		DisableClosingEffect();

		if( SoundKilled != None )
		{
		    PlaySound( SoundKilled );
		}

		SetPhysics( PHYS_FALLING );

		class'util'.static.Fade( Self, 0.5 );

		// go into dive
  		Velocity = vect( 100, 0, -10 )*Normal( Velocity );
	}
}

//=============================================================================

function TargetDestroyed()
{
	// target died -- destroy ourself
	GotoState( 'VeryDead' );
}

//=============================================================================

defaultproperties
{
     SoundClosing=Sound'WOTPawns.Spirit_Closing1'
     SoundTakeDamage1=Sound'WOTPawns.Spirit_TakeDamage1'
     SoundTakeDamage2=Sound'WOTPawns.Spirit_TakeDamage2'
     SoundKilled=Sound'WOTPawns.Spirit_TakeDamage1'
     SoundTouchDown=Sound'WOTPawns.Spirit_Spawn1'
     ClosingVolume=1.000000
     RotationRange=12288
     spinRate=2048.000000
     ClosingEffectMaxSpeedRatio=0.900000
     ClosingEffectMinTime=1.000000
     ClosingEffectDistance=256.000000
     ClosingEffectSkin=Texture'WOTPawns.Skins.LegionSpiritHead2'
     Health=30
     Acceleration=20.000000
     bNotifiesDestination=False
     LaunchOffset=(X=170.000000,Z=-110.000000)
     bRequiresDestination=False
     speed=250.000000
     MaxSpeed=450.000000
     Damage=25.000000
     MomentumTransfer=200
     SpawnSound=Sound'WOTPawns.Spirit_Spawn1'
     ImpactSound=Sound'WOTPawns.Spirit_HitPawn1'
     LifeSpan=0.000000
     Style=STY_Translucent
     Mesh=Mesh'WOTPawns.LegionSpiritHead'
     ScaleGlow=2.000000
     SoundRadius=160
     SoundVolume=100
     AmbientSound=Sound'WOTPawns.Spirit_Ambient1'
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     bProjTarget=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=64
     LightSaturation=255
     LightRadius=5
}
