//------------------------------------------------------------------------------
// AngrealAMAProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealAMAProjectile expands GenericProjectile;

#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\PlaceAM.wav	GROUP=AMAProj
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\HitWaterAM.wav	GROUP=AMAProj
#exec AUDIO IMPORT FILE=Sounds\AntiMagicAura\LaunchAM.wav	GROUP=AMAProj

var() float TriggerRadius;		// How close someone has to get to trigger us.

var() float AlphaRate;			// ScaleGlow per second subtracted during fading state.

var() float PrimeTime;			// How long the box will sit there inactive before being triggerable.

replication
{
	reliable if( Role==ROLE_Authority )
		TriggerRadius, AlphaRate, PrimeTime;
}

//------------------------------------------------------------------------------
// Wait for a pawn or projectile to touch us.
//------------------------------------------------------------------------------
function Touch( Actor Other )
{
	local AMAPearl Pearl;

	if( Pawn(Other) != None || Projectile(Other) != None )
	{
		Pearl = Spawn( class'AMAPearl', Self );
		Pearl.SetSourceAngreal( SourceAngreal );
		Pearl.Go();
	}
}

/////////////
// Ignores //
/////////////

simulated function ProcessTouch( Actor Other, vector HitLocation );

////////////
// States //
////////////

//------------------------------------------------------------------------------
auto simulated state Placing
{
	simulated function BeginPlay()
	{
		SetPhysics( PHYS_Falling );
		bCollideWorld = True;
	}

	// Stop when we land.
	simulated function Landed( vector HitNormal )
	{
		Place( HitNormal );
	}

	// Stop when we hit a wall.
	simulated function HitWall( vector HitNormal, Actor HitWall )
	{
		Place( HitNormal );
	}

	// Place where we are, and align with the given HitNormal.
	simulated function Place( vector HitNormal )
	{
		local vector X, Y, Z;

		SetPhysics( PHYS_None );
/*
		GetAxes( Rotation, X, Y, Z );
		Z = HitNormal;
		X = Z cross Y;
		SetRotation( OrthoRotation( X, Y, Z ) );
*/
		SetRotation( rotator(HitNormal) );

		if( ImpactSound != None )
		{
			PlaySound( ImpactSound );
		}

		GotoState('Priming');
	}
}

//------------------------------------------------------------------------------
simulated state Priming
{
begin:
	Sleep( PrimeTime );
	GotoState( 'Waiting' );
}

//------------------------------------------------------------------------------
simulated state Waiting
{
	// Initialize collision.
	simulated function BeginPlay()
	{
		bCollideWorld = False;
		SetCollisionSize( TriggerRadius, TriggerRadius );
	}
/*
	// Wait for a pawn or projectile to touch us.
	function Touch( Actor Other )
	{
		local AMAPearl Pearl;

		if( Pawn(Other) != None || Projectile(Other) != None )
		{
			// -- BAD CODE: Spawn( class'AMANetSpawner', Self,, Location, Rotation );
			
			Pearl = Spawn( class'AMAPearl', Self );
			Pearl.SetSourceAngreal( SourceAngreal );
			Pearl.Go();
		}
	}
*/
}

//------------------------------------------------------------------------------
simulated state Fading
{
	simulated function BeginState()
	{
		SetPhysics( PHYS_None );
		SetCollision( False );
		SetCollisionsize( 0, 0 );
		Style = STY_Translucent;
		//bAlwaysRelevant = False;
	}

	simulated function Tick( float DeltaTime )
	{
		ScaleGlow -= AlphaRate * DeltaTime;

		if( ScaleGlow <= 0 )
		{
			Destroy();
		}
	}
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
static function float GetMaxRange()
{
	return class'AMAPearl'.default.FinalScale * class'AMAPearl'.default.CollisionRadius;
}

defaultproperties
{
     TriggerRadius=150.000000
     AlphaRate=1.500000
     HitWaterSound=Sound'Angreal.AMAProj.HitWaterAM'
     bRequiresLeading=False
     speed=200.000000
     SpawnSound=Sound'Angreal.AMAProj.LaunchAM'
     ImpactSound=Sound'Angreal.AMAProj.PlaceAM'
     Physics=PHYS_Falling
     LifeSpan=0.000000
     Mesh=Mesh'Angreal.AngrealAntiMagicAuraPickup'
     bAlwaysRelevant=True
     CollisionRadius=12.000000
     CollisionHeight=10.000000
}
