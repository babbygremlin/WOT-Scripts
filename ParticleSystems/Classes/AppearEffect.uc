//------------------------------------------------------------------------------
// AppearEffect.uc
// $Author: Aleiby $
// $Date: 10/09/99 11:25a $
// $Revision: 2 $
//
// Description:	Magically fades in the give actor, surrounded by a cool particle
//				effect.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + Set LifeSpan to determine the duration the effect.
// + Set Actor to fade in.
//------------------------------------------------------------------------------
class AppearEffect expands Effects;

var ActorRotator BottomRotator, TopRotator;
var ParticleSprayer BottomSprayer, TopSprayer;
var Actor AppearActor;
var() int SprayerRotationRate;
var float HeightShiftRate;
var float RotatorOffset;

var ERenderStyle InitialStyle;
var float InitialScaleGlow;
var float DesiredScaleGlow;

var() bool bFadeIn;				// Do we fade in, ever? (Overrides bMultiplayerFade).
var() bool bMultiplayerFade;	// Do we fade in, in multiplayer games?

var float InitialLifeSpan;		// of us -- not the AppearActor.

var bool bParticles;

var() float ExtraFadeTime;

var() Texture TopSprite, BottomSprite;

replication
{
	reliable if( Role==ROLE_Authority )
		AppearActor, 
		SprayerRotationRate, 
		bMultiplayerFade, 
		ExtraFadeTime, 
		TopSprite, 
		BottomSprite;
}

//------------------------------------------------------------------------------
simulated function SetColors( optional name TopColor, optional name BottomColor  )
{
	if( TopColor != '' && BottomColor != '' )
	{
		SetTopColor( TopColor );
		SetBottomColor( BottomColor );
	}
	else if( TopColor == '' && BottomColor != '' )
	{
		SetTopColor( BottomColor );
		SetBottomColor( BottomColor );
	}
	else if( TopColor != '' && BottomColor == '' )
	{
		SetTopColor( TopColor );
		SetBottomColor( TopColor );
	}
	else
	{
		SetTopColor( 'Blue' );
		SetBottomColor( 'Blue' );
	}
}

//------------------------------------------------------------------------------
simulated function SetTopColor( name Color )
{

	switch( Color )
	{
	case 'Red':
	case 'PC_Red':
		TopSprite = Texture'ParticleSystems.Appear.RedCorona';
		break;

	case 'Green':
	case 'PC_Green':
		TopSprite = Texture'ParticleSystems.Appear.GreenCorona';
		break;

	case 'Purple':
	case 'PC_Purple':
		TopSprite = Texture'ParticleSystems.Appear.PurpleCorona';
		break;

	case 'Gold':
	case 'PC_Gold':
		TopSprite = Texture'ParticleSystems.Appear.YellowCorona';
		break;

	case 'Blue':
	case 'PC_Blue':
	default:
		TopSprite = Texture'ParticleSystems.Appear.CyanCorona';
		break;
	}
}

//------------------------------------------------------------------------------
simulated function SetBottomColor( name Color )
{

	switch( Color )
	{
	case 'Red':
	case 'PC_Red':
		BottomSprite = Texture'ParticleSystems.Appear.RedCorona';
		break;

	case 'Green':
	case 'PC_Green':
		BottomSprite = Texture'ParticleSystems.Appear.GreenCorona';
		break;

	case 'Purple':
	case 'PC_Purple':
		BottomSprite = Texture'ParticleSystems.Appear.PurpleCorona';
		break;

	case 'Gold':
	case 'PC_Gold':
		BottomSprite = Texture'ParticleSystems.Appear.YellowCorona';
		break;

	case 'Blue':
	case 'PC_Blue':
	default:
		BottomSprite = Texture'ParticleSystems.Appear.CyanCorona';
		break;
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	
	if( AppearActor != None && !AppearActor.bHidden )
	{
		if( LifeSpan > ExtraFadeTime )
		{
			if( !bParticles )
			{
				Initialize();
			}
			else
			{
				RotatorOffset -= HeightShiftRate * DeltaTime;
				UpdateRotatorLocations();
			}
		}
		else if( bParticles )
		{
			TurnOffParticles();
		}

		// 0.0 to InitialScaleGlow in LifeSpan seconds.
		if( ShouldFade() )
		{
			AppearActor.ScaleGlow = InitialScaleGlow * ((InitialLifeSpan - LifeSpan) / InitialLifeSpan);
		}
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function Initialize()
{
	if( ShouldFade() )
	{
		InitialStyle = AppearActor.Style;
		if( DesiredScaleGlow > 0.0 )
		{
			InitialScaleGlow = DesiredScaleGlow;
		}
		else
		{
			InitialScaleGlow = AppearActor.ScaleGlow;
		}
		AppearActor.Style = STY_Translucent;
		AppearActor.ScaleGlow = 0.0;
	}

	BottomRotator = Spawn( class'ActorRotator',,,, rotator(vect(0,0,1)) );
	BottomRotator.bUpdateActorRotation = False;
	BottomRotator.MinRotationRate = SprayerRotationRate;
	BottomRotator.MaxRotationRate = SprayerRotationRate;
	BottomRotator.MinRadius = AppearActor.CollisionRadius;
	BottomRotator.MaxRadius = AppearActor.CollisionRadius;
	BottomSprayer = Spawn( class'AppearSprayer',,,, rotator(vect(0,0,1)) );
	BottomSprayer.Particles[0] = BottomSprite;
	BottomRotator.MyActor = BottomSprayer;
	BottomRotator.Initialize();

	TopRotator = Spawn( class'ActorRotator',,,, rotator(vect(0,0,1)) );
	TopRotator.bUpdateActorRotation = False;
	TopRotator.MinRotationRate = -SprayerRotationRate;
	TopRotator.MaxRotationRate = -SprayerRotationRate;
	TopRotator.MinRadius = AppearActor.CollisionRadius;
	TopRotator.MaxRadius = AppearActor.CollisionRadius;
	TopSprayer = Spawn( class'AppearSprayer',,,, rotator(vect(0,0,-1)) );
	TopSprayer.Particles[0] = TopSprite;
	TopRotator.MyActor = TopSprayer;
	TopRotator.Initialize();

	bParticles = True;

	RotatorOffset = AppearActor.CollisionHeight;
	HeightShiftRate = (AppearActor.CollisionHeight * 2) / LifeSpan;

	LifeSpan += ExtraFadeTime;
	InitialLifeSpan = LifeSpan;

	UpdateRotatorLocations();
}

//------------------------------------------------------------------------------
simulated function UpdateRotatorLocations()
{
	local vector Loc;

	Loc = AppearActor.Location;
	Loc.z -= RotatorOffset;
	BottomRotator.SetLocation( Loc );

	Loc = AppearActor.Location;
	Loc.z += RotatorOffset;
	TopRotator.SetLocation( Loc );
}

//------------------------------------------------------------------------------
simulated function SetAppearActor( Actor A, optional float optDesiredScaleGlow )
{
	if( optDesiredScaleGlow > 0.0 )
	{
		DesiredScaleGlow = optDesiredScaleGlow;
	}

	if( A != None && !A.bHidden )
	{
		AppearActor = A;
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( ShouldFade() && AppearActor != None )
	{
		AppearActor.Style = InitialStyle;
		AppearActor.ScaleGlow = InitialScaleGlow;
	}

	if( bParticles ) TurnOffParticles();

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function TurnOffParticles()
{
	bParticles = False;

	BottomSprayer.bOn = False;
	BottomSprayer.LifeSpan = 2.000000;
	TopSprayer.bOn = False;
	TopSprayer.LifeSpan = 2.000000;
	BottomRotator.Destroy();
	TopRotator.Destroy();
}

//------------------------------------------------------------------------------
simulated function bool ShouldFade()
{
	return bFadeIn && (bMultiplayerFade || (Level.Netmode == NM_Standalone));
}

defaultproperties
{
     SprayerRotationRate=131072
     bFadeIn=True
     ExtraFadeTime=1.000000
     TopSprite=Texture'ParticleSystems.Appear.CyanCorona'
     BottomSprite=Texture'ParticleSystems.Appear.PurpleCorona'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.500000
}
