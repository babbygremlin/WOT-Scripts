//------------------------------------------------------------------------------
// WhirlwindSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class WhirlwindSprayer expands ParticleSprayer;

#exec MESH IMPORT MESH=WhirlwindSlice ANIVFILE=MODELS\TwoTriangles_a.3d DATAFILE=MODELS\TwoTriangles_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WhirlwindSlice X=0 Y=0 Z=0 Pitch=64 Yaw=0 Roll=0

#exec MESH SEQUENCE MESH=WhirlwindSlice SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\WWtop.pcx GROUP=Skins

#exec MESHMAP NEW   MESHMAP=WhirlwindSlice MESH=WhirlwindSlice
#exec MESHMAP SCALE MESHMAP=WhirlwindSlice X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=WhirlwindSlice NUM=0 TEXTURE=WWtop

var() float WWHeight;

replication
{
	unreliable if( Role == ROLE_Authority )
		WWHeight;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function SetHeight( float Height )
{
	WWHeight = Height;
	Tick( 0.0 );	// Update height.
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Templates[0].MaxInitialVelocity = WWHeight / Templates[0].LifeSpan;
	Templates[0].MinInitialVelocity = Templates[0].MaxInitialVelocity;
}

defaultproperties
{
    Spread=1.00
    Volume=20.00
    NumTemplates=1
    Templates=(LifeSpan=3.00,Weight=1.00,MaxInitialVelocity=50.00,MinInitialVelocity=50.00,MaxDrawScale=0.00,MinDrawScale=0.00,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=0.80,MinGrowRate=0.80,FadePhase=0,MaxFadeRate=0.00,MinFadeRate=0.00),
    MeshData=�  �  �  ���������     �           �      
    Particles=Texture'Skins.WWtop'
    ParticleDistribution=1
    VolumeScalePct=0.00
    MinVolume=20.00
    bStatic=False
    LifeSpan=3.00
    DrawType=2
    bMustFace=False
    Mesh=Mesh'WhirlwindSlice'
    bUnlit=True
    VisibilityRadius=5000.00
    VisibilityHeight=5000.00
}
