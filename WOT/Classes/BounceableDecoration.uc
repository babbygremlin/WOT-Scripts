//=============================================================================
// BounceableDecoration.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================
class BounceableDecoration expands WOTDecoration;

var bool bFirstHit;

var() float Damage;
var() float MomentumTransfer;
var() name DamageType;
var() sound LandSound1;
var() float MinBounceSoundSpeed;
var() float MinFirstHitSpeed;
var() float MinBounceSpeed;
var() float SpeedDampeningRatio;
var() float RotationDampeningRatio;
var() float VolumePerturbPercent;
var() float PitchPerturbPercent;
var() float BaseBounceVolume;
var() float BaseBouncePitch;
var() float LandedYaw;						// if > 0, final (landed) yaw is set to this
var() float LandedRoll;						// if > 0, final (landed) roll is set to this
var() float LandedPitch;					// if > 0, final (landed) pitch is set to this


//=============================================================================

function SetupBounce()
{
	SetPhysics( PHYS_Falling );
	bBounce = true;
	RotationRate.Yaw = 250000 * FRand() - 125000;
	RotationRate.Pitch = 250000 * FRand() - 125000;
	RotationRate.Roll = 250000 * FRand() - 125000;	
	DesiredRotation = RotRand();
	bRotateToDesired = false;
	bFixedRotationDir = true;
	bFirstHit=true;
}

//=============================================================================

auto state Animate
{
	function HitWall( vector HitNormal, Actor Wall )
	{
		local float Speed;
		local float Volume, Pitch;

		// record speed before changing velocity
		Speed = VSize(Velocity);
		
		if( bBounce && (bFirstHit || Speed > MinBounceSoundSpeed) ) 
		{
			Volume = class'util'.static.PerturbFloatPercent( BaseBounceVolume, VolumePerturbPercent );
			Pitch = class'util'.static.PerturbFloatPercent( BaseBouncePitch, PitchPerturbPercent );

			PlaySound( LandSound1, SLOT_Misc, Volume,,,Pitch );
		}

		if( bFirstHit && Speed < MinFirstHitSpeed ) 
		{
			bFirstHit = false;
			bRotatetoDesired = true;
			bFixedRotationDir = false;
			DesiredRotation.Pitch = 0;	
			DesiredRotation.Yaw = FRand() * 65536;
			DesiredRotation.Roll = 0;		
		}

		RotationRate.Yaw = RotationRate.Yaw * RotationDampeningRatio;
		RotationRate.Roll = RotationRate.Roll * RotationDampeningRatio;
		RotationRate.Pitch = RotationRate.Pitch * RotationDampeningRatio;	

		// reflect of surface with dampening		
		Velocity = SpeedDampeningRatio*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);
		
		// should we bounce with the *next* hit?
		if( VSize(Velocity) < MinBounceSpeed ) 
		{
			bBounce = false;
		}
	}	

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType )
	{
		Momentum.Z = abs( Momentum.Z * 4 + 3000 );
		Velocity = Momentum * 0.02;

		SetupBounce();
	}

	singular function Touch( Actor Other )
	{
		if( Damage > 0 )
		{
			Other.TakeDamage( Damage, None, Location, Normal(Other.Location - Location) * MomentumTransfer, DamageType );
		}
	}

}

//=============================================================================
// If Other is a weapon attached to a weapon triangle, the decoration
// probably won't be initially positioned the same as the weapon was.
// We can inherit the velocity though.

function InitFor( Actor Other )
{
	local int i;
	
	Velocity = Other.Velocity;
	Tag	= Other.Tag;
	
	if( Other.IsA( 'Pawn' ) || Other.IsA( 'Weapon' ) )
	{
		// make sure any damage skins are inherited
		for( i = 0; i < ArrayCount( MultiSkins ); i++ )
		{
			MultiSkins[ i ] = Other.MultiSkins[ i ];
		}
		Skin = Other.Skin;
		Texture = Other.Texture;
	}

	// make sure decoration bounces/makes a noise at least once
	SetupBounce();
}

//=============================================================================

simulated function Landed( vector HitNormal )
{
	local rotator FinalRot;
	local rotator SurfaceRotator;

	FinalRot = Rotation;

	if( LandedYaw >= 0 )
	{
		class'util'.static.SetLandedRotParam( FinalRot.Yaw, LandedYaw );
	}
	if( LandedRoll >= 0 )
	{
		class'util'.static.SetLandedRotParam( FinalRot.Roll, LandedRoll );
	}
	if( LandedPitch >= 0 )
	{
		class'util'.static.SetLandedRotParam( FinalRot.Pitch, LandedPitch );
	}

	SurfaceRotator = Rotator( Normal(vect(0,0,1) - HitNormal) );
	FinalRot += SurfaceRotator;

	SetRotation( FinalRot );

	SetPhysics( PHYS_None );

	// otherwise, can stand on decoration and bounce-fly around the level
	SetCollision( true, false, false );
}

//=============================================================================

defaultproperties
{
     DamageType=hurt
     MinBounceSoundSpeed=10.000000
     MinFirstHitSpeed=400.000000
     MinBounceSpeed=10.000000
     SpeedDampeningRatio=0.330000
     RotationDampeningRatio=0.750000
     VolumePerturbPercent=30.000000
     PitchPerturbPercent=30.000000
     BaseBounceVolume=1.000000
     BaseBouncePitch=1.000000
     LandedYaw=-1.000000
     LandedRoll=-1.000000
     LandedPitch=-1.000000
     bPushable=True
     bStatic=False
     CollisionRadius=12.000000
     CollisionHeight=4.000000
     bCollideWorld=True
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=True
     Mass=1.000000
}
