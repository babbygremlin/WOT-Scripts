//------------------------------------------------------------------------------
// DartExplosion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class DartExplosion expands Effects;

#exec OBJ LOAD FILE=Textures\DartExplode.utx PACKAGE=Angreal.Dart

var() float FadeTime;
var() float LightFadeTime;
var() float ScaleTime;

var float ScaleTimer;
var float FadeTimer;
var float LightFadeTimer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	FadeTimer = FadeTime;
	LightFadeTimer = LightFadeTime;
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	FadeTimer -= DeltaTime;
	if( FadeTimer < 0 )
		FadeTimer = 0;

	LightFadeTimer -= DeltaTime;
	if( LightFadeTimer < 0 )
		LightFadeTimer = 0;

	ScaleGlow = default.ScaleGlow * (FadeTimer / FadeTime);
	LightBrightness = default.LightBrightness * (LightFadeTimer / LightFadeTime);

	ScaleTimer += DeltaTime;
	if( ScaleTimer > ScaleTime )
		ScaleTimer = ScaleTime;
		
	DrawScale = default.DrawScale * Sqrt( ScaleTimer / ScaleTime );
	
	Super.Tick( DeltaTime );
}

defaultproperties
{
    FadeTime=0.25
    LightFadeTime=0.40
    ScaleTime=0.25
    RemoteRole=0
    LifeSpan=0.40
    DrawType=1
    Style=3
    Texture=WetTexture'Dart.DartExpl'
    DrawScale=0.50
    LightType=1
    LightEffect=13
    LightBrightness=255
    LightHue=154
    LightSaturation=50
    LightRadius=2
}
