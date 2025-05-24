//------------------------------------------------------------------------------
// TriggeredViewFog.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
// From the source:
//
// LUTShade = Fog  +  ( TextureShade * LightShade * (0.3 + 0.7*GRender->Brightness) * 18.0 * (FlashScale/128.0) ) / 256.0
//
// FlashFog   = screen fogging: 0=none, 255=fullly saturated fog.
// FlashScale = screen scaling: 0=none, 128=normal brightness, 255=2X overbright.
//
//		FlashScale.X = Clamp( FlashScale.X, 0.f, 1.f );
// 		FlashScale.Y = Clamp( FlashScale.Y, 0.f, 1.f );
// 		FlashScale.Z = Clamp( FlashScale.Z, 0.f, 1.f );
// 		FlashFog.X   = Clamp( FlashFog.X  , 0.f, 1.f );
// 		FlashFog.Y   = Clamp( FlashFog.Y  , 0.f, 1.f );
// 		FlashFog.Z   = Clamp( FlashFog.Z  , 0.f, 1.f );
//
// Make up your mind Tim... Is is 0 to 255 or 0.0 to 1.0?
//
//------------------------------------------------------------------------------
class TriggeredViewFog expands Effects;

var() vector GlowFog;
//var() float GlowScale;

//var() float FadeInTime;		// go from GlowFog to normal.
//var() float FadeOutTime;	// go from normal to GlowFog.
var() float WaitTime;		// how long to wait in the colored state.

//var float InitialFadeInTime, InitialFadeOutTime;

//var float FadeRate;

var PlayerPawn Viewer;
var float InitialGlowScale;
/*
//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	InitialFadeInTime = FadeInTime;
	InitialFadeOutTime = FadeOutTime;
}
*/
//------------------------------------------------------------------------------
auto simulated state Trigerable
{	
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if		( PlayerPawn(Other)				!= None ) BeginEffect( PlayerPawn(Other) );
		else if	( PlayerPawn(EventInstigator)	!= None ) BeginEffect( PlayerPawn(EventInstigator) );
	}
}

//------------------------------------------------------------------------------
simulated function BeginEffect( PlayerPawn InViewer )
{
	Viewer = InViewer;
	InitialGlowScale = Viewer.ConstantGlowScale;
	Viewer.ClientAdjustGlow( 0.0, GlowFog );
/*	
	FadeInTime = InitialFadeInTime;
	FadeOutTime = InitialFadeOutTime;

	if		( FadeInTime  > 0 ) GotoState('FadeIn');
	else if	( FadeOutTime > 0 ) GotoState('FadeOut');
	else						EndEffect();
*/
	GotoState('Waiting');
}

//------------------------------------------------------------------------------
simulated function EndEffect()
{
	Viewer.ClientAdjustGlow( 0.0, -GlowFog );
	Viewer.ConstantGlowScale = InitialGlowScale;
	
	GotoState('Trigerable');
}
/*
//------------------------------------------------------------------------------
simulated state FadeIn
{
	simulated function BeginState()
	{
		FadeRate = GlowScale / FadeInTime;
		Viewer.ConstantGlowScale = GlowScale;
	}

	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		Viewer.ConstantGlowScale -= FadeRate * DeltaTime;

		if( Viewer.ConstantGlowScale <= InitialGlowScale )
		{
			Viewer.ConstantGlowScale = InitialGlowScale;
			//if( FadeOutTime > 0 )	GotoState('FadeOut');
			//else					EndEffect();
			EndEffect();
		}
	}
}

//------------------------------------------------------------------------------
simulated state FadeOut
{
	simulated function BeginState()
	{
		FadeRate = GlowScale / FadeOutTime;
		Viewer.ConstantGlowScale = InitialGlowScale;
	}

	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		Viewer.ConstantGlowScale += FadeRate * DeltaTime;

		if( Viewer.ConstantGlowScale >= GlowScale )
		{
			Viewer.ConstantGlowScale = GlowScale;
			FadeInTime = FadeOutTime;
			if( WaitTime > 0 )	GotoState('Waiting');
			else				GotoState('FadeIn');
		}
	}
}
*/
//------------------------------------------------------------------------------
simulated state Waiting
{
	simulated function BeginState()
	{
		SetTimer( WaitTime, False );
	}

	simulated function Timer()
	{
		//GotoState('FadeIn');
		EndEffect();
	}
}
/*
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	BroadcastMessage( Viewer.ConstantGlowScale );
}
*/

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
     DrawType=DT_Sprite
}
