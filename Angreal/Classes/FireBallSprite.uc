//------------------------------------------------------------------------------
// FireBallSprite.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireBallSprite expands Decoration;

#exec TEXTURE IMPORT FILE=MODELS\FireBall01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\FireBall02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\FireBall03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\FireBall04.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\FireBall05.pcx GROUP=Effects

var() vector RiseRate;

var() float FrameTime;	// Seconds per frame.
var float FrameTimer;

var() float FadeTime;

var() Texture SkinTextures[5];
var int FrameNumber;

function Tick( float DeltaTime )
{
	SetLocation( Location + (RiseRate * DeltaTime) );

	FrameTimer -= DeltaTime;
	if( FrameTimer < 0.0 )
	{
		if( FrameNumber < ArrayCount(SkinTextures) )
		{
			FrameTimer += FrameTime;
			Texture = SkinTextures[FrameNumber++];
		}
		else
		{
			FrameTimer += FadeTime;
			ScaleGlow *= 0.7;

			if( ScaleGlow < default.ScaleGlow * 0.1 )
			{
				Destroy();
			}
		}
	}
}

defaultproperties
{
    FrameTime=0.20
    FadeTime=0.10
    bStatic=False
    bCanTeleport=True
    Style=3
    DrawScale=0.50
    NetPriority=6.00
}
