//=============================================================================
// Portcullis.uc
// $Author: Mpoesch $
// $Date: 9/14/99 5:13p $
// $Revision: 9 $
//=============================================================================
class Portcullis expands Trap;

#exec TEXTURE IMPORT FILE=Graphics\Portcullis\PortcullisActiveHighlight.pcx		MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Portcullis\PortcullisActive.pcx				MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Portcullis\PortcullisInactiveHighlight.pcx	MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Graphics\Portcullis\PortcullisInactive.pcx			MIPS=Off FLAGS=2

#exec TEXTURE IMPORT FILE=Textures\Portcullis\Portcullis.pcx     GROUP=Skins FLAGS=2

var	PortcullisMover	Mover;

replication
{
	// Data the server should send to all clients
	reliable if( Role==ROLE_Authority )
		Mover;
}

function PreBeginPlay()
{
	local PortcullisMover M;

	bHidden = true;
	foreach AllActors( class 'PortcullisMover', M, Event )
	{
		Mover = M;
		Mover.SetOwner( self );
		break;
	}

	// call after the Mover and Mover owner are set
	Super.PreBeginPlay();
}

function InitSinglePlayer()
{
	InitialState = 'Active';
	Texture = texture'PortcullisActive';

	Mover.InitialState = 'TriggerToggle';
	Mover.Activate();
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
		Texture = texture'PortcullisActiveHighlight';
		GotoState( 'Active' );
		Mover.Activate();
		return true;
	}
	else if( GetStateName() == 'Active' )
	{
		Texture = texture'PortcullisActiveHighlight';
	}
	else
	{
		Texture = texture'PortcullisInactiveHighlight';
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
		Texture = texture'PortcullisInactiveHighlight';
		GotoState( 'Inactive' );
		Mover.Deactivate();
		return true;
	}
	else if( GetStateName() == 'Active' )
	{
		Texture = texture'PortcullisActive';
	}
	else
	{
		Texture = texture'PortcullisInactive';
	}
	return false;
}

auto state Inactive
{
}

state Active
{
	function Trigger( Actor Other, Pawn EventInstigator ) // tutorial support
	{
		Mover.Trigger( Other, EventInstigator );
	}

	function Touch( actor Other )
	{
		local Pawn P;

		if( IsInactive( Other ) )
			return;

		if( Pawn(Other) != None )
		{
			Mover.Trigger( Other, Pawn(Other) );
		}
	}
}

// end of Portcullis.uc

defaultproperties
{
     bHidden=True
     Style=STY_Masked
     Texture=Texture'WOTTraps.PortcullisInactive'
     DrawScale=0.400000
     CollisionRadius=64.000000
     CollisionHeight=160.000000
}
