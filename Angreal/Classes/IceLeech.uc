//------------------------------------------------------------------------------
// IceLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 11 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// Note: Dart does not work through ice by design.
//------------------------------------------------------------------------------
class IceLeech expands Leech;

#exec MESH IMPORT MESH=Frozen ANIVFILE=MODELS\Frozen_a.3d DATAFILE=MODELS\Frozen_d.3d X=0 Y=0 Z=0 MLOD=0
#forceexec MESH ORIGIN MESH=Frozen X=0 Y=0 Z=75

#exec MESH SEQUENCE MESH=Frozen SEQ=All    STARTFRAME=0 NUMFRAMES=2
#exec MESH SEQUENCE MESH=Frozen SEQ=FROZEN STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Frozen SEQ=MELTED STARTFRAME=1 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JFrozen1 FILE=MODELS\Frozen1.PCX GROUP=Skins FLAGS=2 // ICE

#exec MESHMAP NEW   MESHMAP=Frozen MESH=Frozen
#exec MESHMAP SCALE MESHMAP=Frozen X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Frozen NUM=0 TEXTURE=JFrozen1

#exec AUDIO IMPORT FILE=Sounds\Ice\DeActivateIC.wav		GROUP=Ice

//var EPhysics OldPhysics;		// Victim's Physics before we attach to it.
var vector OriginalLocation;	// Where the victim started out when we froze him/her.

var() float MeltTime;	// How long it takes us to melt.
var bool bMelting;
var float FadeRate;

var() Sound MeltingSound;

//var name OldState;

struct SizeException
{
	var() name ClassType;	// Name of class to apply this exception to.
	var() float Scale;		// DrawScale to use for above said class.
};

var() SizeException Exceptions[4];

var() vector GlowFog;
var() float GlowScale;

var bool bOldCollideActors, bOldBlockActors, bOldBlockPlayers;

replication
{
	reliable if( Role==ROLE_Authority )
		OriginalLocation;
}

//------------------------------------------------------------------------------
simulated function ScaleForExceptions( Pawn NewHost )
{
	local int i;

	for( i = 0; i < ArrayCount(Exceptions); i++ )
	{
		if( Exceptions[i].ClassType != '' && NewHost.IsA( Exceptions[i].ClassType ) )
		{
			DrawScale = Exceptions[i].Scale;
			break;
		}
	}

	// scale collision cylinder to fit scaled mesh
	SetCollisionSize( DrawScale/default.DrawScale * default.CollisionRadius, DrawScale/default.DrawScale * default.CollisionHeight );
}

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	local WotPawn OwnerWotPawn;

	bFromProjectile = false;	//!!hack, so we can shift and swapplace, etc out of it.

	Super.AttachTo( NewHost );

	if( Owner != None )
	{
		// Adjust DrawScale.
		ScaleForExceptions( NewHost );

		// Place on ground.
		SetLocation( Owner.Location ); //- (vect(0,0,1)*Owner.CollisionHeight) );

//		OldPhysics = Owner.Physics;
		OriginalLocation = Owner.Location;
//		Owner.SetPhysics( PHYS_None );
//		if( PlayerPawn(Owner) != None )
//		{
//			OldState = Owner.GetStateName();
//			Owner.GotoState('');
//		}

		if( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ClientAdjustGlow( GlowScale, GlowFog );
		}

		// turn off collision while frozen to prevent telefragging by SetLocation?
		bOldCollideActors	= Owner.bCollideActors;
		bOldBlockActors		= Owner.bBlockActors;
		bOldBlockPlayers	= Owner.bBlockPlayers;

		// prevents telefrag but still blocks projectiles
		Owner.SetCollision( true, false, false );  

		OwnerWotPawn = WotPawn( Owner );
		if( OwnerWotPawn != None )
		{
			OwnerWotPawn.StopMovement();
			OwnerWotPawn.DisableNotifiers();
			OwnerWotPawn.GotoState( '' );
		}

		// PCs will probably start a new animation as soon as they try to move
		Owner.bAnimFinished = true;
		Owner.bAnimLoop = false;
		Owner.AnimRate = 0.0;
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
function UnAttach()
{
	local WotPawn OwnerWotPawn;

/*
	if( Owner != None )
	{
		Owner.SetPhysics( OldPhysics );
		if( PlayerPawn(Owner) != None )
		{
			Owner.GotoState( OldState );
		}
	}
*/

	if( PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientAdjustGlow( -GlowScale, -GlowFog );
	}

	OwnerWotPawn = WotPawn( Owner );
	if( OwnerWotPawn != None && OwnerWotPawn.Health > 0 )
	{
		OwnerWotPawn.TransitionOnGoalPriority( true );
	}

	// restore saved collision	
	Owner.SetCollision( bOldCollideActors, bOldBlockActors, bOldBlockPlayers );
	
	Super.UnAttach();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( !bMelting && Lifespan <= MeltTime )
	{
		bMelting = True;
		FadeRate = 1.0 / MeltTime;
		TweenAnim( 'MELTED', MeltTime );
		PlayMeltingSound();
	}

	if( bMelting )
	{
		ScaleGlow -= FadeRate * DeltaTime;
	}

	if( Pawn(Owner) == None || Pawn(Owner).Health <= 0 )
	{
//		UnAttach();
//		Destroy();
	}
	else
	{
		Owner.SetLocation( OriginalLocation );
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function PlayMeltingSound()
{
	PlaySound( MeltingSound );
}

defaultproperties
{
    MeltTime=2.00
    MeltingSound=Sound'Ice.DeActivateIC'
    Exceptions(0)=(ClassType=Legion,Scale=12.00),
    Exceptions(1)=(ClassType=BATrolloc,Scale=6.00),
    Exceptions(2)=(ClassType=Trolloc,Scale=4.00),
    Exceptions(3)=(ClassType=Minion,Scale=4.00),
    GlowFog=(X=312.50,Y=468.75,Z=468.75),
    GlowScale=-0.39
    bDeleterious=True
    bDisplayIcon=True
    bRemoveExisting=True
    bHidden=False
    RemoteRole=2
    DrawType=2
    Style=3
    Texture=Texture'Skins.JFrozen1'
    Mesh=Mesh'Frozen'
    DrawScale=3.00
    bMeshEnviroMap=True
    CollisionRadius=40.00
    CollisionHeight=48.00
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    LightEffect=13
    LightBrightness=37
    LightHue=204
    LightSaturation=204
    LightRadius=8
}
