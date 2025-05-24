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
     Spread=1.000000
     Volume=20.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=3.000000,MaxInitialVelocity=50.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=1,MaxGrowRate=0.800000,MinGrowRate=0.800000)
     MeshData(0)=(MaxInitialRotation=(Pitch=1000,Yaw=1000,Roll=1000),MinInitialRotation=(Pitch=-1000,Yaw=-1000,Roll=-1000),MaxRotationRate=(Yaw=64000),MinRotationRate=(Yaw=64000))
     Particles(0)=Texture'Angreal.Skins.WWtop'
     ParticleDistribution=DIST_Linear
     VolumeScalePct=0.000000
     MinVolume=20.000000
     bStatic=False
     LifeSpan=3.000000
     DrawType=DT_Mesh
     bMustFace=False
     Mesh=Mesh'Angreal.WhirlwindSlice'
     bUnlit=True
     VisibilityRadius=5000.000000
     VisibilityHeight=5000.000000
}
