//=============================================================================
// RainCyd.
//=============================================================================
class RainCyd expands Effects;

#exec MESH IMPORT MESH=RainCyd ANIVFILE=MODELS\RainCyd_a.3d DATAFILE=MODELS\RainCyd_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=RainCyd X=0 Y=0 Z=240

#exec MESH SEQUENCE MESH=RainCyd SEQ=All  STARTFRAME=0 NUMFRAMES=1

// Skins
#exec TEXTURE IMPORT NAME=RainDropsA FILE=MODELS\RainDropsA.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=RainDropsB FILE=MODELS\RainDropsB.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=RainDropsC FILE=MODELS\RainDropsC.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=SnowA FILE=MODELS\SnowA.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=RainCyd MESH=RainCyd
#exec MESHMAP SCALE MESHMAP=RainCyd X=0.1 Y=0.1 Z=0.2

// Set this to be the height of the cylinder when DrawScale == 1.0
// The rest of the calculations will be done automatically.
var() float CylinderHeight;

// Number of units this object may be place above the ground.
var() float TraceDepth;	

// How many should be stacked on top of each other.
var() int StackNum;

// Must set this to true if placed via the editor.
var() bool bMaster;
var bool bMasterInited;

// How many units to fall per second.
var() float MinFallRate;
var() float MaxFallRate;

// A directional vector that faces "down".
// Think of it as velocity.
//OLD var vector FallRate;

// How many degrees to rotate per second.
var() float MinRotRate;
var() float MaxRotRate;
var float RotRate;
var float RotAngle;
var rotator InitialRotation;
var bool bInitialized;
var vector InitialLocation;

// The point below us where we hit the ground.
var vector HitLocation;

// The distance beneath the ground this object must be
// before being moved back to the top of the stack.
var() float BuryDistance;

replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		CylinderHeight, TraceDepth, StackNum, bMaster, MinFallRate, MaxFallRate, MinRotRate, MaxRotRate, BuryDistance,
		InitialLocation, InitialRotation;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector X, Y, Z, NotUsed;
	local rotator Rot;
	local int i;
	local RainCyd R;
	
	if( Role == ROLE_Authority && !bInitialized )
	{
		bInitialized = true;
		// Randomize roll.
		SetRotation( Rotation + rot(0,65536,0) * FRand() );
		InitialRotation = Rotation;
		InitialLocation = Location;
	}
	
	if( bMaster && !bMasterInited )
	{
		bMasterInited = true;

		GetAxes( Rotation, NotUsed, NotUsed, Z ); 
		Velocity = -Z * RandRange( MinFallRate, MaxFallRate );
		RotRate = RandRange( MinRotRate, MaxRotRate );
		CylinderHeight = default.CylinderHeight * DrawScale;
		Trace( HitLocation, NotUsed, InitialLocation + Normal(Velocity) * TraceDepth, InitialLocation, False );

		SetLocation( HitLocation - Normal(Velocity) * CylinderHeight + Normal(Velocity) * BuryDistance );
		
		for( i = 1; i < StackNum; i++ )
		{
			R = Spawn( Class,,, Location - Normal(Velocity) * (i * CylinderHeight) );
			
			// Copy all relavant variables.
			R.HitLocation		= HitLocation;
			R.InitialRotation	= InitialRotation;
			R.Velocity			= Velocity;
			R.RotRate			= RotRate;
			R.ScaleGlow			= ScaleGlow;
			R.DrawScale			= DrawScale;
			R.VisibilityRadius	= VisibilityRadius;
			R.VisibilityHeight	= VisibilityHeight;
			R.DetailLevel		= DetailLevel;
			R.CylinderHeight	= CylinderHeight;
			R.StackNum			= StackNum;
			R.BuryDistance		= BuryDistance;
			R.Skin				= Skin;
			R.RemoteRole		= ROLE_None;
		}
	}

	// Update location.
	SetLocation( Location + Velocity * DeltaTime );

	// Update rotation.
	if( RotRate != 0 )
	{
		RotAngle += RotRate * DeltaTime;
		GetAxes( InitialRotation, X, Y, Z );
		SetRotation( InitialRotation + rotator(X * class'Util'.static.DCos( RotAngle ) + Y * class'Util'.static.DSin( RotAngle )) );
	}

	// If we go BuryDistance beyond our HitLocation, go back to the top of the stack.
	// NOTE: This assumes that FallRate will never change.  
	// This prevents us from having rain tha changes direction over time.  
	if( !class'Util'.static.VectorAproxEqual( Normal(Velocity), Normal(HitLocation + (Normal(Velocity) * BuryDistance) - Location) ) )
	{
		SetLocation( Location - Normal(Velocity) * (StackNum * CylinderHeight) );
	}
	
	Super.Tick( DeltaTime );
}

defaultproperties
{
     CylinderHeight=48.000000
     TraceDepth=1000.000000
     StackNum=5
     MinFallRate=500.000000
     MaxFallRate=700.000000
     BuryDistance=100.000000
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=None
     Skin=Texture'Environment.Skins.RainDropsA'
     Mesh=Mesh'Environment.RainCyd'
     bUnlit=True
     bAlwaysRelevant=True
}
