//------------------------------------------------------------------------------
// AngrealDistantEyeProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealDistantEyeProjectile expands AngrealProjectile;

#exec MESH IMPORT MESH=FlatEye ANIVFILE=MODELS\FlatEye_a.3d DATAFILE=MODELS\FlatEye_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=FlatEye X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=FlatEye SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=FlatEye MESH=FlatEye
#exec MESHMAP SCALE MESHMAP=FlatEye X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT FILE=MODELS\DE_01.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_02.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_03.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_04.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_05.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_06.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\DE_07.pcx GROUP=Skins FLAGS=2

var() float FrameTime;	// Seconds per frame.
var() Texture AnimSkins[7];
var int AnimSkinIndex;

var bool bOpen;

var() float RoundsPerMinute;
var float NextFireTime;
var bool bFiring;

var() class<GenericProjectile> ProjectileType;

var DistantEyeCastReflector Ref;
var DistantEyeLeech Leech;

var() int Health;

replication
{
	reliable if( Role==ROLE_Authority )
		bOpen;
}

/////////////
// Ignores //
/////////////

//------------------------------------------------------------------------------
simulated function Touch( Actor Other );

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, name DamageType )
{
	Health -= Damage;

	if( Health <= 0 )
	{
		// NOTE[aleiby]: Hurt SourceAngreal.Owner?
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local GreenExplode Exp;

	Exp = Spawn( class'GreenExplode',,, Location );
	Exp.DrawScale = 0.3;

	ServerDestroyed();
	
	Super.Destroyed();
}

//------------------------------------------------------------------------------
function ServerDestroyed()
{
	PlaySound( ImpactSound );
	AngrealInvDistantEye(SourceAngreal).NotifyEyeDestroyed();
	SourceAngreal.UseCharge();
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
function Open()
{
	bOpen = true;
	InstallReflectors();
	GotoState('Opening');
}

//------------------------------------------------------------------------------
function Close()
{
	bOpen = false;
	UnFire();
	UnInstallReflectors();
	GotoState('Closing');
}

//------------------------------------------------------------------------------
function Fire()
{
	bFiring = true;
	LaunchProjectile();
}

//------------------------------------------------------------------------------
function UnFire()
{
	bFiring = false;
}

////////////
// States //
////////////

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Needed? -- Super.Tick( DeltaTime );

	if( bOpen && Instigator != None )
	{
		if( Instigator.Health > 0 )
		{
			SetRotation( Instigator.ViewRotation );
		}
		else if( Role == ROLE_Authority )
		{
			Destroy();
		}
	}

	if( Role == ROLE_Authority )
	{
		if( bFiring )
		{
			LaunchProjectile();
		}
	}
}

//------------------------------------------------------------------------------
state Opening
{
	function BeginState()
	{
		AnimSkinIndex = 0;
	}

	function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		FrameTime -= DeltaTime;
		while( FrameTime < 0.0 )
		{
			FrameTime += default.FrameTime;
			AnimSkinIndex++;
			if( AnimSkinIndex < ArrayCount(AnimSkins) )
			{
				Skin = AnimSkins[AnimSkinIndex];
			}
			else
			{
				GotoState('');
			}
		}
	}
}

//------------------------------------------------------------------------------
state Closing
{
	function BeginState()
	{
		AnimSkinIndex = ArrayCount(AnimSkins)-1;
	}

	function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		FrameTime -= DeltaTime;
		while( FrameTime < 0.0 )
		{
			FrameTime += default.FrameTime;
			AnimSkinIndex--;
			if( AnimSkinIndex >= 0 )
			{
				Skin = AnimSkins[AnimSkinIndex];
			}
			else
			{
				GotoState('');
			}
		}
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
function LaunchProjectile()
{
	local GenericProjectile Proj;

	if( Level.TimeSeconds >= NextFireTime )
	{
		NextFireTime = Level.TimeSeconds + (1.0 / (RoundsPerMinute / 60.0));

		Proj = Spawn( ProjectileType,,, Location, Rotation );
		Proj.SetSourceAngreal( SourceAngreal );
	}
}

//------------------------------------------------------------------------------
function InstallReflectors()
{
	if( Ref != None && Ref.Owner != None )
	{
		warn( "Reflector not previously uninstalled.  Uninstalling now." );
		Ref.UnInstall();
	}

	Ref = Spawn( class'DistantEyeCastReflector' );
	Ref.InitializeWithProjectile( Self );
	Ref.Eye = Self;
	Ref.Install( Instigator );

	if( Leech != None && Leech.Owner != None )
	{
		warn( "Leech not previously unattached.  Unattaching now." );
		Leech.UnAttach();
	}

	Leech = Spawn( class'DistantEyeLeech' );
	Leech.InitializeWithProjectile( Self );
	Leech.AttachTo( Instigator );
}

//------------------------------------------------------------------------------
function UnInstallReflectors()
{
	if( Ref != None )
	{
		Ref.UnInstall();
		Ref.Destroy();
		Ref = None;
	}

	if( Leech != None )
	{
		Leech.UnAttach();
		Leech.Destroy();
		Leech = None;
	}
}

defaultproperties
{
    FrameTime=0.20
    AnimSkins(0)=Texture'Skins.DE_01'
    AnimSkins(1)=Texture'Skins.DE_02'
    AnimSkins(2)=Texture'Skins.DE_03'
    AnimSkins(3)=Texture'Skins.DE_04'
    AnimSkins(4)=Texture'Skins.DE_05'
    AnimSkins(5)=Texture'Skins.DE_06'
    AnimSkins(6)=Texture'Skins.DE_07'
    RoundsPerMinute=320.00
    ProjectileType=Class'GreenDart'
    Health=50
    ImpactSound=Sound'DistantEye.DropDE'
    bCanTeleport=False
    bNetTemporary=False
    Physics=0
    LifeSpan=0.00
    Skin=Texture'Skins.DE_01'
    Mesh=Mesh'FlatEye'
    bAlwaysRelevant=True
    CollisionRadius=8.00
    CollisionHeight=8.00
    bCollideWorld=False
    bProjTarget=True
}
