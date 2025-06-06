//=============================================================================
// BFExplodeA.
//=============================================================================
class BFExplodeA expands Explosion;

#exec TEXTURE IMPORT FILE=MODELS\BFimpact101.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact101.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact102.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact103.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact104.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact105.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact106.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact107.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact108.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact109.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact110.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact111.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact112.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact113.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact114.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact115.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact116.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact117.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact118.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact119.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact120.pcx GROUP=BFExplodeA
#exec TEXTURE IMPORT FILE=MODELS\BFimpact121.pcx GROUP=BFExplodeA

// Percentages of lifespan for stop growing, and shrinking.
var() float StopGrowPct;
var() float ShrinkPct;

// Precomputed.
var float InitialDrawScale;
var float InitialLifeSpan;
var float StopGrowSpan;
var float ShrinkSpan;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	InitialDrawScale = DrawScale;
	InitialLifeSpan = LifeSpan;
	StopGrowSpan = InitialLifeSpan * StopGrowPct;
	ShrinkSpan = InitialLifeSpan * ShrinkPct;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float A, B;

	Super.Tick( DeltaTime );

	if( LifeSpan > StopGrowSpan )
	{
		A = LifeSpan - StopGrowSpan;
		B = InitialLifeSpan - StopGrowSpan;
		DrawScale = InitialDrawScale * ((B - A) / B);
	}
	else if( LifeSpan > ShrinkSpan )
	{
		DrawScale = InitialDrawScale;
	}
	else
	{
		DrawScale = InitialDrawScale * (LifeSpan / ShrinkSpan);
	}
}

// end of BFExplodeA.

defaultproperties
{
    StopGrowPct=0.83
    ShrinkPct=0.33
    ExplosionAnim(0)=Texture'BFExplodeA.BFimpact101'
    ExplosionAnim(1)=Texture'BFExplodeA.BFimpact102'
    ExplosionAnim(2)=Texture'BFExplodeA.BFimpact103'
    ExplosionAnim(3)=Texture'BFExplodeA.BFimpact104'
    ExplosionAnim(4)=Texture'BFExplodeA.BFimpact105'
    ExplosionAnim(5)=Texture'BFExplodeA.BFimpact106'
    ExplosionAnim(6)=Texture'BFExplodeA.BFimpact107'
    ExplosionAnim(7)=Texture'BFExplodeA.BFimpact108'
    ExplosionAnim(8)=Texture'BFExplodeA.BFimpact109'
    ExplosionAnim(9)=Texture'BFExplodeA.BFimpact110'
    ExplosionAnim(10)=Texture'BFExplodeA.BFimpact111'
    ExplosionAnim(11)=Texture'BFExplodeA.BFimpact112'
    ExplosionAnim(12)=Texture'BFExplodeA.BFimpact113'
    ExplosionAnim(13)=Texture'BFExplodeA.BFimpact114'
    ExplosionAnim(14)=Texture'BFExplodeA.BFimpact115'
    ExplosionAnim(15)=Texture'BFExplodeA.BFimpact116'
    ExplosionAnim(16)=Texture'BFExplodeA.BFimpact117'
    ExplosionAnim(17)=Texture'BFExplodeA.BFimpact118'
    ExplosionAnim(18)=Texture'BFExplodeA.BFimpact119'
    ExplosionAnim(19)=Texture'BFExplodeA.BFimpact120'
    ExplosionAnim(20)=Texture'BFExplodeA.BFimpact121'
    LifeSpan=2.00
    DrawScale=2.30
    AmbientGlow=250
    LightEffect=13
    LightHue=0
    LightSaturation=255
    LightRadius=12
}
