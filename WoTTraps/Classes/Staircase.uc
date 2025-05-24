//=============================================================================
// Staircase.uc
// $Author: Mpoesch $
// $Date: 10/05/99 8:03p $
// $Revision: 11 $
//=============================================================================
class Staircase expands Trap;

#exec TEXTURE IMPORT FILE=Graphics\Staircase\StairActiveHighlight.pcx	MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Staircase\StairActive.pcx			MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Staircase\StairInactiveHighlight.pcx	MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Staircase\StairInactive.pcx			MIPS=Off FLAGS=2

#exec AUDIO IMPORT FILE=Sounds\Staircase\ResetSC.wav			GROUP=Staircase
#exec AUDIO IMPORT FILE=Sounds\Staircase\RetractSC.wav			GROUP=Staircase

var Mover	TheStaircase;

function PreBeginPlay()
{
	local Mover M;

	foreach AllActors( class 'Mover', M, Event )
	{
		TheStaircase = M;
		TheStaircase.StayOpenTime = 6.0;
		break;
	}
	
	// call after the TheStaircase is set
	Super.PreBeginPlay();
}

function InitSinglePlayer()
{
	InitialState = 'Active';
	Texture = texture'StairActive';
}

simulated function BeginEditingResource( int PlacedByTeam )
{
	Super.BeginEditingResource( PlacedByTeam );
	SetCollision( false, false, false );
}

simulated function EndEditingResource()
{
	Super.EndEditingResource();
	SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
}

simulated function BeginSelectResource()
{
	Show();
}

simulated function EndSelectResource()
{
	if( IsResourceActive() )
	{
		Super(Actor).Hide();
	}
	else
	{
		Hide();
	}
}

simulated function bool IsTrapDeployed()
{
	return GetStateName() == 'Active';
}

function bool DeployResource( vector HitLocation, vector HitNormal )
{
	return false;
}

function bool RemoveResource()
{
	return false;
}

function bool IsResourceActive()
{
	return IsInState( 'Active' );
}

function bool ActivateResource( bool bChangeState )
{
	if( bChangeState && !ValidateTrap() )
	{
		return false;
	}

	if( GetStateName() == 'Inactive' && bChangeState )
	{
		Texture = texture'StairActiveHighlight';
		GotoState( 'Active' );
		return true;
	}
	else if( GetStateName() == 'Active' )
	{
		Texture = texture'StairActiveHighlight';
	}
	else
	{
		Texture = texture'StairInactiveHighlight';
	}
	return false;
}

function bool DeactivateResource( bool bChangeState )
{
	if( bLocked )
	{
		return false;
	}

	if( GetStateName() == 'Active' && bChangeState )
	{
		Texture = texture'StairInactiveHighlight';
		GotoState( 'Inactive' );
		return true;
	}
	else if( GetStateName() == 'Active' )
	{
		Texture = texture'StairActive';
	}
	else
	{
		Texture = texture'StairInactive';
	}
	return false;
}

auto state Inactive
{
}

state Active
{
	function EndEvent()
	{
	}
	
	function Touch( actor Other )
	{
		if( IsInactive( Other ) )
			return;

		SetTimer( TheStaircase.StayOpenTime, false );
		TheStaircase.Trigger( self, Pawn( Other ) );
		PlaySound( Sound( DynamicLoadObject( ActivatingSoundName, class'Sound' ) ) );
		Disable( 'Touch' );
	} 
	
	function Timer()
	{
		Enable( 'Touch' );
		PlaySound( Sound( DynamicLoadObject( ResetingSoundName, class'Sound' ) ) );
	}
}

// end of Staircase.uc

defaultproperties
{
     ActivatingSoundName="WOTTraps.Staircase.RetractSC"
     ResetingSoundName="WOTTraps.Staircase.ResetSC"
     bHidden=True
     Tag=StaircaseX
     Event=StaircaseX
     Texture=Texture'WOTTraps.StairInactive'
     DrawScale=0.400000
     CollisionRadius=32.000000
     CollisionHeight=32.000000
}
