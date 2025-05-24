//=============================================================================
// FireWallSlab.uc
// $Author: Jcrable $
// $Date: 10/17/99 6:58p $
// $Revision: 11 $
//=============================================================================
class FireWallSlab expands WallSlab;

#exec OBJ LOAD FILE=Textures\FireWall\FireWallT.utx PACKAGE=WOTTraps.FireWall

#exec MESH IMPORT MESH=FWBaseLogs ANIVFILE=MODELS\Firewall\FWBaseLogs_a.3d DATAFILE=MODELS\FIREWALL\FWBaseLogs_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=FWBaseLogs X=0 Y=0 Z=40 PITCH=0 YAW=64 ROLL=0

#exec MESH SEQUENCE MESH=FWBaseLogs SEQ=All        STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=FWBaseLogs SEQ=FWBASELOGS STARTFRAME=0 NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JFWBaseLogs0 FILE=MODELS\FIREWALL\FWBase0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=FWBaseLogs MESH=FWBaseLogs
#exec MESHMAP SCALE MESHMAP=FWBaseLogs X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=FWBaseLogs NUM=0 TEXTURE=JFWBaseLogs0

var()	class<ParticleSprayer>	FlameSprayerType1,		// Largest part of the flame
								FlameSprayerType2,		// Secondary part of the flame
								FlameSprayerType3;		// Smoke particle system

var		ParticleSprayer			FlameSprayer1,			// Largest part of the flame
								FlameSprayer2,			// Secondary part of the flame
								FlameSprayer3;			// Smoke particle system

var()	vector					FlameSprayerOffset1,	// Offset from our Location.
								FlameSprayerOffset2,	// Offset from our Location.
								FlameSprayerOffset3;	// Offset from our Location.

var()	float					DamageAmount;			// How how much damage is given per interval.
var()	int						Health;					// How much damage we can withstand.
var		int						PrevHealth;				// How much health we had the last time the flames were scaled.

// The fire wall is made blocking, to stop the player -- this does not affect the touching array
// The flame is made non-blocking, to set the touching array to do the damage.

replication
{
	unreliable if( Role==ROLE_Authority )
		Health;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float Scalar;

	Super.Tick( DeltaTime );

	// Update visuals.
	if( !bDeleteMe )
	{
		if( FlameSprayer1 == None )	FlameSprayer1 = Spawn( FlameSprayerType1, Self,, Location + FlameSprayerOffset1, rotator(vect(0,0,1)) );
		if( FlameSprayer2 == None )	FlameSprayer2 = Spawn( FlameSprayerType2, Self,, Location + FlameSprayerOffset2, rotator(vect(0,0,1)) );
		if( FlameSprayer3 == None )	FlameSprayer3 = Spawn( FlameSprayerType3, Self,, Location + FlameSprayerOffset3, rotator(vect(0,0,1)) );

		FlameSprayer1.bOn = !bHidden;
		FlameSprayer2.bOn = !bHidden;
		FlameSprayer3.bOn = !bHidden;

		// Scale volume based on health.
		if( Health != PrevHealth )
		{
			PrevHealth = Health;
			Scalar = float(Health) / float(default.Health);
			ScaleFlameSprayer( FlameSprayer1, Scalar );
			ScaleFlameSprayer( FlameSprayer2, Scalar );
			ScaleFlameSprayer( FlameSprayer3, Scalar );
		}

		if( FlameSprayer1.Location != Location + FlameSprayerOffset1 )	FlameSprayer1.SetLocation( Location + FlameSprayerOffset1 );
		if( FlameSprayer2.Location != Location + FlameSprayerOffset2 )	FlameSprayer2.SetLocation( Location + FlameSprayerOffset2 );
		if( FlameSprayer3.Location != Location + FlameSprayerOffset3 )	FlameSprayer3.SetLocation( Location + FlameSprayerOffset3 );
	}
}

//------------------------------------------------------------------------------
simulated function ScaleFlameSprayer( ParticleSprayer FlameSprayer, float Scalar )
{	
	FlameSprayer.Volume		= FlameSprayer.default.Volume		* Scalar;
	FlameSprayer.MinVolume	= FlameSprayer.default.MinVolume	* Scalar;

	FlameSprayer.SetParticleMaxScaleGlow( FlameSprayer.GetDefaultParticleMaxScaleGlow( 0 ) * Scalar, 0 );
	FlameSprayer.SetParticleMaxScaleGlow( FlameSprayer.GetDefaultParticleMaxScaleGlow( 1 ) * Scalar, 1 );
	FlameSprayer.SetParticleMaxScaleGlow( FlameSprayer.GetDefaultParticleMaxScaleGlow( 2 ) * Scalar, 2 );

	FlameSprayer.SetParticleMaxDrawScale( FlameSprayer.GetDefaultParticleMaxDrawScale( 0 ) * Scalar, 0 );
	FlameSprayer.SetParticleMaxDrawScale( FlameSprayer.GetDefaultParticleMaxDrawScale( 1 ) * Scalar, 1 );
	FlameSprayer.SetParticleMaxDrawScale( FlameSprayer.GetDefaultParticleMaxDrawScale( 2 ) * Scalar, 2 );

	FlameSprayer.SetParticleMinScaleGlow( FlameSprayer.GetDefaultParticleMinScaleGlow( 0 ) * Scalar, 0 );
	FlameSprayer.SetParticleMinScaleGlow( FlameSprayer.GetDefaultParticleMinScaleGlow( 1 ) * Scalar, 1 );
	FlameSprayer.SetParticleMinScaleGlow( FlameSprayer.GetDefaultParticleMinScaleGlow( 2 ) * Scalar, 2 );

	FlameSprayer.SetParticleMinDrawScale( FlameSprayer.GetDefaultParticleMinDrawScale( 0 ) * Scalar, 0 );
	FlameSprayer.SetParticleMinDrawScale( FlameSprayer.GetDefaultParticleMinDrawScale( 1 ) * Scalar, 1 );
	FlameSprayer.SetParticleMinDrawScale( FlameSprayer.GetDefaultParticleMinDrawScale( 2 ) * Scalar, 2 );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( FlameSprayer1 != None )
	{
		FlameSprayer1.bOn = false;
		FlameSprayer1.LifeSpan = 1.5;
	}
	if( FlameSprayer2 != None )
	{
		FlameSprayer2.bOn = false;
		FlameSprayer2.LifeSpan = 1.7;
	}
	if( FlameSprayer3 != None )
	{
		FlameSprayer3.bOn = false;
		FlameSprayer3.LifeSpan = 1.0;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
function Show()
{
	Super.Show();

	if( FlameSprayer1 != None )
	{
		FlameSprayer1.Show();
	}
}

//------------------------------------------------------------------------------
function Hide()
{
	Super.Hide();

	if( FlameSprayer1 != None )
	{
		FlameSprayer1.Hide();
	}
}

//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	if( ( Trap( Owner ) != None ) && ( Trap(Owner).IsInactive( EventInstigator ) ) )
	{
		return;
	}

	if	( !bHidden )
	{
		Health = Max( Health - Damage, 0 );
		if( Health <= 0 )
		{
			Destroy();
		}
	}
}

//------------------------------------------------------------------------------
function DamageActor( Actor Other )
{
	if( ( Trap( Owner ) != None )  && ( Trap( Owner ).IsInactive( Other ) ) )
	{
		return;
	}

	if(	!bHidden &&	Health > 0 )
	{
		TakeDamage( DamageAmount, Pawn(Other), Location, vect(0,0,0), 'Touched' );
		Other.TakeDamage( DamageAmount, Instigator, Location, vect(0,0,0), 'xxFxx' );
	}
}

//------------------------------------------------------------------------------
function UnTouch( Actor Other )
{
	if( Owner != None )
	{
		Owner.UnTouch( Other );
	}
}

defaultproperties
{
     FlameSprayerType1=Class'WOTTraps.FireWallSprayer1'
     FlameSprayerType2=Class'WOTTraps.FireWallSprayer2'
     FlameSprayerType3=Class'WOTTraps.FireWallSprayer3'
     FlameSprayerOffset1=(Z=40.000000)
     FlameSprayerOffset2=(Z=44.000000)
     FlameSprayerOffset3=(Z=40.000000)
     DamageAmount=8.000000
     Health=450
     PrevHealth=-999
     SlabWidth=38
     RemoteRole=ROLE_SimulatedProxy
     Texture=None
     Mesh=Mesh'WOTTraps.FWBaseLogs'
     DrawScale=1.200000
     CollisionRadius=19.000000
     CollisionHeight=9.500000
     bProjTarget=True
}
