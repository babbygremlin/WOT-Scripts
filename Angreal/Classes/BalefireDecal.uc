//------------------------------------------------------------------------------
// BalefireDecal.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------
class BalefireDecal expands Decal;

#exec TEXTURE IMPORT FILE=MODELS\BFhole01.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole02.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole03.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole04.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole05.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole06.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole07.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole08.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole09.pcx GROUP=BFDecals
#exec TEXTURE IMPORT FILE=MODELS\BFhole10.pcx GROUP=BFDecals
//#exec TEXTURE IMPORT FILE=MODELS\BFhole11.pcx GROUP=BFDecals
//#exec TEXTURE IMPORT FILE=MODELS\BFhole12.pcx GROUP=BFDecals
//#exec TEXTURE IMPORT FILE=MODELS\BFhole13.pcx GROUP=BFDecals
//#exec TEXTURE IMPORT FILE=MODELS\BFhole14.pcx GROUP=BFDecals

var() Texture AnimTextures[10];
var int TextureIndex;

var() float FrameTime;
var float FrameTimer;

var bool bSpawnedHole;

var() float FadeTime;
var bool bLastFrame;

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();

	Skin = AnimTextures[ TextureIndex ];
	FrameTimer = FrameTime;
}

//------------------------------------------------------------------------------
simulated function AttemptRegistration()
{
	// Don't register, since we will be destroying ourself shortly anyway.
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local Decal D;

	Super.Tick( DeltaTime );

	if( !bSpawnedHole )
	{
		bSpawnedHole = true;
		D = Spawn( class'BFHole',,, Location );
		D.Align( vector(Rotation) );
	}

	if( !bLastFrame )
	{
		FrameTimer -= DeltaTime;
		if( FrameTimer <= 0.0 )
		{
			FrameTimer = FrameTime;		
			TextureIndex++;
			if( TextureIndex < ArrayCount(AnimTextures) && AnimTextures[ TextureIndex ] != None )
			{
				Skin = AnimTextures[ TextureIndex ];
			}
			else
			{
				//Destroy();
				bLastFrame = true;
				AmbientGlow = 0;
				LifeSpan = FadeTime;
			}
		}
	}
	else
	{
		ScaleGlow = LifeSpan / FadeTime;
	}
}

defaultproperties
{
    AnimTextures(0)=Texture'BFDecals.BFhole01'
    AnimTextures(1)=Texture'BFDecals.BFhole02'
    AnimTextures(2)=Texture'BFDecals.BFhole03'
    AnimTextures(3)=Texture'BFDecals.BFhole04'
    AnimTextures(4)=Texture'BFDecals.BFhole05'
    AnimTextures(5)=Texture'BFDecals.BFhole06'
    AnimTextures(6)=Texture'BFDecals.BFhole07'
    AnimTextures(7)=Texture'BFDecals.BFhole08'
    AnimTextures(8)=Texture'BFDecals.BFhole09'
    AnimTextures(9)=Texture'BFDecals.BFhole10'
    FrameTime=0.10
    FadeTime=5.00
    DetailLevel=3
    RemoteRole=2
    Style=3
    Skin=Texture'BFExplodeA.BFimpact101'
    DrawScale=0.50
    AmbientGlow=180
}
