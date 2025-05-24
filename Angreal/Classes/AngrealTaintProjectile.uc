//------------------------------------------------------------------------------
// AngrealTaintProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealTaintProjectile expands SeekingProjectile;

#exec AUDIO IMPORT FILE=Sounds\Taint\HitTN.wav		GROUP=Taint
#exec AUDIO IMPORT FILE=Sounds\Taint\LaunchTN.wav	GROUP=Taint
#exec AUDIO IMPORT FILE=Sounds\Taint\LoopTN.wav		GROUP=Taint

var TaintVisual Visual;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Visual = Spawn( class'TaintVisual' );
		
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Visual != None )
	{
		Visual.SetLocation( Location );
	}
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local TaintAllAngrealEffect TE;
	local Actor Visual;
	local vector VisLoc;
	
	// Game logic.
	if( Role == ROLE_Authority )
	{
 		//TE = Spawn( class'TaintAllAngrealEffect' );
		TE = TaintAllAngrealEffect( class'Invokable'.static.GetInstance( Self, class'TaintAllAngrealEffect' ) );
		TE.InitializeWithProjectile( Self );
		TE.SetVictim( Pawn(HitActor) );
		if( WOTPlayer(HitActor) != None )
		{
			WOTPlayer(HitActor).ProcessEffect( TE );
		}
		else if( WOTPawn(HitActor) != None )
		{
			WOTPawn(HitActor).ProcessEffect( TE );
		}
	}

	// Visuals
	if( HitActor != None )
	{
		VisLoc = HitActor.Location;
	}
	else
	{
		VisLoc = HitLocation;
	}
	Visual = Spawn( class'TaintExpDarts', Destination,, VisLoc );
	Visual = Spawn( class'TaintExpTorus', Destination,, VisLoc );
	Visual = Spawn( class'TaintExpGeoB', Destination,, VisLoc );
	Visual = Spawn( class'TaintExpGeoA', Destination,, VisLoc );

	Super.Explode( HitLocation, HitNormal );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Visual != None )
	{
		Visual.Destroy();
		Visual = None;
	}

	Super.Destroyed();
}

defaultproperties
{
    speed=150.00
    MomentumTransfer=2000
    SpawnSound=Sound'Taint.LaunchTN'
    ImpactSound=Sound'Taint.HitTN'
    LifeSpan=0.00
    SoundRadius=160
    SoundVolume=255
    AmbientSound=Sound'Taint.LoopTN'
    CollisionRadius=6.00
    CollisionHeight=12.00
}
