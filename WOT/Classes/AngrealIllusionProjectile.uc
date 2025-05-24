//------------------------------------------------------------------------------
// AngrealIllusionProjectile.uc
// $Author: Mfox $
// $Date: 1/09/00 4:04p $
// $Revision: 8 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealIllusionProjectile expands AngrealProjectile;

var byte Team;

var() float FadePercent;							// Percentage of lifespan to use to fade out.
													// Set to 0.0 to preserve bandwidth.
var() bool bAnimate;								// Whether or not to animate the mesh
var class<AnimationTableWOT>  AnimationTableClass;	// Used for animating the mesh.

var() float ShowSelfResolution;		// How often we call MyShowSelf().
var float NextShowSelfTime;

var Leech Timer;

var Actor ReplicatedOwner;

replication
{
	reliable if( Role==ROLE_Authority )
		Team,
		ReplicatedOwner;
}

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();
	FClamp( FadePercent, 0.0, 1.0 );	// Just to be safe.

	// Send SeePlayer notifications.
	MyShowSelf();

	ReplicatedOwner = Owner;
}

//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	Super.SetSourceAngreal( Source );

	// IconInfo.
	if( SourceAngreal != None && WOTPlayer(SourceAngreal.Owner) != None )
	{
		RemoveIcon();
		Timer = Spawn( class'IllusionTimerLeech' );
		Timer.InitializeWithProjectile( Self );
		Timer.LifeSpan = LifeSpan;
		Timer.AttachTo( WOTPlayer(SourceAngreal.Owner) );
	}
}

//------------------------------------------------------------------------------
simulated function MyShowSelf()
{
	local Projectile Proj;
	local vector Vect2D;

	// Send SeePlayer notifications.
	for( Proj = Level.ProjectileList; Proj != None; Proj = Proj.nextProjectile )
	{
		if( Proj.bNotifySeePlayer )
		{
			// Check visibility.
			Vect2D = Location - Proj.Location;
			Vect2D.Z = 0.0;
			if
			(	VSize(Vect2D)						<= Proj.SeePlayerRadius 
			&&	Abs( Location.Z - Proj.Location.Z )	<= Proj.SeePlayerHeight
			)
			{
				Proj.SeePlayer( Self );
			}
		}
	}

	NextShowSelfTime = Level.TimeSeconds + ShowSelfResolution;
}

//------------------------------------------------------------------------------
simulated function bool SetAnimationTableClass( Pawn Image )
{
	AnimationTableClass = None;
	if( WOTPlayer(Image) != None )
	{	
		AnimationTableClass = WOTPlayer(Image).AnimationTableClass;
	}
	else if( WOTPawn(Image) != None )
	{
		AnimationTableClass = WOTPawn(Image).AnimationTableClass;
	}
	else
	{
		warn( "Invalid illusion source!" );
	}

	return (AnimationTableClass != None);
}

//------------------------------------------------------------------------------
simulated function AcquireImage( Pawn Image )
{
	local int i;
	local AppearEffect AE;

	// Add others as needed.
	
	if( Image != None )
	{
		Mesh			= Image.Mesh;
		DrawType		= Image.DrawType;
		Style			= Image.Style;
		DrawScale		= Image.DrawScale;
		Team			= Image.PlayerReplicationInfo.Team;

		Texture			= Image.Texture;
		Skin			= Image.Skin;
		Sprite			= Image.Sprite;

		for( i = 0; i < ArrayCount(MultiSkins); i++ )
		{
			MultiSkins[i] = Image.MultiSkins[i];
		}

		SetCollisionSize( Image.CollisionRadius, Image.CollisionHeight );

		bHidden			= False;

		// Visual
		AE = Spawn( class'AppearEffect' );
		if( WOTPlayer(Owner) != None )
		{
			AE.SetColors( WOTPlayer(Owner).PlayerColor );
		}
		else
		{
			// Defaults to Blue.
			AE.SetColors();
		}
		AE.SetAppearActor( Self );

		if( bAnimate && SetAnimationTableClass( Image ) )
		{
			GotoState( 'WaitingIdle' );
		}
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Fade out the last FadePercent of our lifespan.
	if( FadePercent > 0.0 )
	{
		if( LifeSpan <= default.LifeSpan * FadePercent )
		{
			Style = STY_Translucent;
			ScaleGlow = LifeSpan / (default.LifeSpan * FadePercent);
		}
	}

	// Send see player notifications.
	if( Level.TimeSeconds > NextShowSelfTime )
	{
		MyShowSelf();
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	RemoveIcon();
	Super.Destroyed();
}

//------------------------------------------------------------------------------
function RemoveIcon()
{
	if( Timer != None && !Timer.bDeleteMe )
	{
		Timer.UnAttach();
		Timer.Destroy();
		Timer = None;
	}
}

//------------------------------------------------------------------------------
// Don't explode.
//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal );


//------------------------------------------------------------------------------
state WaitingIdle
{
Begin:
LoopAnimation:
	AnimationTableClass.static.TweenLoopSlotAnim( Self, 'Wait' );
	FinishAnim();
	Goto( 'LoopAnimation' );
}

defaultproperties
{
     FadePercent=0.100000
     bAnimate=True
     bNetTemporary=False
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=20.000000
     bCollideWorld=False
     bProjTarget=True
}
