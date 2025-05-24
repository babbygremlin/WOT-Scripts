//=============================================================================
// Spear.uc
// $Author: Mfox $
// $Date: 9/29/99 11:45p $
// $Revision: 8 $
//=============================================================================
class Spear expands Trap;

#exec MESH IMPORT MESH=Spear ANIVFILE=MODELS\Spear\SpearTrap_a.3D DATAFILE=MODELS\Spear\SpearTrap_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Spear X=0 Y=-8 Z=0 ROLL=64 PITCH=64 
#exec MESH SEQUENCE MESH=Spear SEQ=All      STARTFRAME=0   NUMFRAMES=20
#exec MESH SEQUENCE MESH=Spear SEQ=Waiting  STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Spear SEQ=Activating   STARTFRAME=1   NUMFRAMES=19
#exec TEXTURE IMPORT NAME=SpearTex FILE=MODELS\Spear\TrapSpear.PCX FAMILY=Skins
#exec MESHMAP NEW   MESHMAP=Spear MESH=Spear
#exec MESHMAP SCALE MESHMAP=Spear X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=Spear NUM=1 TEXTURE=SpearTex

#exec AUDIO IMPORT FILE=Sounds\Spear\ActivateSP.wav			GROUP=Spear
#exec AUDIO IMPORT FILE=Sounds\Spear\RetractSP.wav			GROUP=Spear

var() float			ImpaleRange;
var   TrapBlocker	Blockers[4];
var() float			TriggerRadius;
var() float			DamageRadius;
var() int			MomentumConstant;

function Destroyed()
{
	local int	i;

	Super.Destroyed();

	for( i = 0; i < ArrayCount(Blockers); i++)
	{
		if( Blockers[i] != None )
		{
			Blockers[i].Destroy();
			Blockers[i] = None;
		}
	}
}

function InitSinglePlayer()
{
	SetCollision( false, false, false ); // wait for message from TrapBlockers
	InitBlockers();
}

function bool DeployResource( vector HitLocation, vector HitNormal )
{
	if( !CalcLocation( HitLocation, HitNormal ) )
	{
		return false;
	}

	if( AnyActorsInArea( HitLocation, SeparationDistance ) != None )
	{
		return false;
	}

	SetLocation( HitLocation );
	SetRotation( rotator( HitNormal ) );

	return ValidateTrap();
}

function bool RemoveResource()
{
	local int	i;

	if( bLocked )
	{
		return false;
	}

	for( i = 0; i < ArrayCount(Blockers); i++)
	{
		if( Blockers[i] != None )
		{
			Blockers[i].Destroy();
			Blockers[i] = None;
		}
	}

	return Super.RemoveResource();
}

function BeginEditingResource( int PlacedByTeam )
{
	Super.BeginEditingResource( PlacedByTeam );
	InitBlockers();
	HideBlockers();
	SetCollision( true, false, false ); // make spears traceable
}

function EndEditingResource()
{
	Super.EndEditingResource();
	SetCollision( false, false, false ); // wait for message from TrapBlockers
	SetBlockers( true, false, false, TriggerRadius, TriggerRadius );
}

function InitBlockers()
{
	local int	i;
	local float	Increment;
	local vector x, y, z;
	local vector BlockerLocation;

	Increment = ImpaleRange / ( ArrayCount(Blockers) + 1 );
	GetAxes( Rotation, x, y, z );
	if( Blockers[0] == None )
	{
		for( i = 0; i < ArrayCount( Blockers ); i++ )
		{
			BlockerLocation = Location + Increment * ( i + 1 ) * x;
			Blockers[i] = spawn( class 'TrapBlocker', Self,, BlockerLocation );
		}
	}
	SetBlockers( true, false, false, TriggerRadius, TriggerRadius );
}

function SetBlockers( bool bCollide, bool bBlock, bool bDamage, float NewRadius, float NewHeight )
{
	local int	i;

	// The first blocker is the only one that collides when retracted
	Blockers[0].SetBlocking( true, bBlock, bDamage, NewRadius, NewHeight );

	for( i = 1; i < ArrayCount(Blockers) - 1; i++ )
	{
		// set to cause damage (or not)
		Blockers[i].SetBlocking( bCollide, bBlock, bDamage, NewRadius, NewHeight );
	}

	// The last blocker is the only one that causes damage when extended
	Blockers[ ArrayCount(Blockers) - 1 ].SetBlocking( true, bBlock, true, NewRadius, NewHeight );
}

function HideBlockers()
{
	local int	i;

	for( i = 0; i < ArrayCount(Blockers); i++ )
	{
		// set to cause damage (or not)
		Blockers[i].SetBlocking( false, false, false, TriggerRadius, TriggerRadius );
	}
}

auto state Waiting
{
	function Touch( actor Other )
	{
		if( IsInactive( Other ) )
			return;

		if( Pawn( Other ) != None )
		{
			Disable( 'Touch' );
			SetBlockers( false, false, false, DamageRadius, TriggerRadius );
			GotoState( 'Activating' );
			Enable( 'Touch' );
		}
	}

	function DamageActor( actor Other )
	{
		Touch( Other );
	}

begin:
	PlayAnim( 'Waiting' );
}

state Activating
{
	function DamageActor( actor Other )
	{
		local vector MomentumVec;

		if( Pawn( Other ) != None )
		{
			MomentumVec = MomentumConstant * Normal( Other.Location - Location );
			Other.TakeDamage( DamageAmount, None, Location, MomentumVec, 'killed' );
		}
	}

begin:
	SetBlockers( true, true, false, DamageRadius, TriggerRadius );
	PlaySound( Sound( DynamicLoadObject( ActivatingSoundName, class'Sound' ) ) );
	PlayAnim( 'Activating' );
	FinishAnim();
	SetBlockers( true, true, false, DamageRadius, TriggerRadius );
	SetTimer( 2, false );
	GotoState( 'Extended' );
}

state Extended
{
	function Timer()
	{
		GotoState( 'Reseting' );
	}
}

state Reseting
{
	function Timer()
	{
		local int i;

		for( i = 0; i < ArrayCount(Touching); i++ )
		{
			if( Touching[ i ] != None && Touching[ i ].IsA( 'Pawn' ) )
			{
				GotoState( 'Activating' );
				return;
			}
		}
		GotoState( 'Waiting' );
	}

begin:
	PlaySound( Sound( DynamicLoadObject( ResetingSoundName, class'Sound' ) ) );
	SetBlockers( false, false, false, TriggerRadius, TriggerRadius );
	TweenAnim( 'Activating', 0.25 );
	FinishAnim();
	PlayAnim( 'Waiting' );
	SetTimer( 1, false );
}

// end of Spear.uc

defaultproperties
{
     ImpaleRange=64.000000
     TriggerRadius=32.000000
     DamageRadius=4.000000
     MomentumConstant=20000
     DamageAmount=5
     HeightAboveFloor=48
     SeparationDistance=32
     TrapRadius=10
     ActivatingSoundName="WOTTraps.Spear.ActivateSP"
     ResetingSoundName="WOTTraps.Spear.RetractSP"
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=Mesh'WOTTraps.Spear'
     bProjTarget=True
}
