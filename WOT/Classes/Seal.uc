//=============================================================================
// Seal.uc
// $Author: Mfox $
// $Date: 1/06/00 4:34p $
// $Revision: 32 $
//=============================================================================
class Seal expands WOTInventory;

#exec MESH IMPORT MESH=Seal ANIVFILE=MODELS\Seal_a.3D DATAFILE=MODELS\Seal_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Seal X=0 Y=0 Z=0 YAW=64 PITCH=64
#exec MESH SEQUENCE MESH=Seal SEQ=All      STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=S_Seal			FILE=MODELS\Seal.PCX			GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=S_AesSedaiSeal	FILE=MODELS\AesSedaiSeal.PCX	GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=S_ForsakenSeal	FILE=MODELS\ForsakenSeal.PCX	GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=S_HoundSeal		FILE=MODELS\HoundSeal.PCX		GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=S_WhitecloakSeal	FILE=MODELS\WhitecloakSeal.PCX	GROUP=Skins FLAGS=2
#exec MESHMAP NEW   MESHMAP=Seal MESH=Seal
#exec MESHMAP SCALE MESHMAP=Seal X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=Seal NUM=1 TEXTURE=S_Seal

#exec TEXTURE IMPORT FILE=Icons\I_SSeal.PCX				GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_AesSedaiSeal.PCX		GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_ForsakenSeal.PCX		GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_HoundSeal.PCX			GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\I_WhitecloakSeal.PCX	GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_SSeal.PCX				GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_AesSedaiSeal.PCX		GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_ForsakenSeal.PCX		GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_HoundSeal.PCX			GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_WhitecloakSeal.PCX	GROUP=UI MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Notification\PossesionChangeSound.wav GROUP=Seal

#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\DeploySeal.wav    GROUP=Editor
#exec AUDIO IMPORT FILE=Sounds\UI\CitadelEditor\RemoveSeal.wav    GROUP=Editor

// Seal possesion change vars.
var byte Team;					// the team that placed the seal
var byte ControllingTeam;		// the team currently credited with the seal capture

var string PossesionChangeSoundName;
var localized string PossesionChangeStr;

var() const editconst Name DestroyedEvent;
var() const editconst Name OwnershipChangedEvent;

var float PathNodeDeltaH;		// Maximum allowed DeltaH from pathnode when placed
var float PathNodeDeltaR;		// Maximum allowed DeltaR from pathnode when placed or dropped

var CarrySealSprayer Indicator;

var() name BlockingActor[3];	// hidden actors the seal must avoid
var() name IgnoreActor[2];		// actors that should not disrupt placement

function ClearControllingTeam()
{
	local giMPBattle Game;

	Game = giMPBattle(Level.Game);

	if( Game != None && Game.Battle != None )
	{
		if( ControllingTeam != 255 )
		{
			Game.Battle.DecrementTeamSealCount( ControllingTeam );
			ControllingTeam = 255;
		}
	}
}

function SetControllingTeam( WOTPlayer Player )
{
	local giMPBattle Game;

	if( ControllingTeam != Player.PlayerReplicationInfo.Team )
	{
		Game = giMPBattle(Level.Game);

		if( Game != None && Game.Battle != None )
		{
			if( ControllingTeam != 255 )
			{
				Game.Battle.DecrementTeamSealCount( ControllingTeam );
			}
			ControllingTeam = Player.PlayerReplicationInfo.Team;
			Game.Battle.IncrementTeamSealCount( ControllingTeam );

			switch( Player.PlayerClass.Name )
			{
			case 'AesSedai':
				StatusIcon		= Texture'I_AesSedaiSeal';
				StatusIconFrame	= Texture'M_AesSedaiSeal';
				MultiSkins[1]	= Texture'S_AesSedaiSeal';
				break;
			case 'Forsaken':
				StatusIcon		= Texture'I_ForsakenSeal';
				StatusIconFrame	= Texture'M_ForsakenSeal';
				MultiSkins[1]	= Texture'S_ForsakenSeal';
				break;
			case 'Hound':
				StatusIcon		= Texture'I_HoundSeal';
				StatusIconFrame	= Texture'M_HoundSeal';
				MultiSkins[1]	= Texture'S_HoundSeal';
				break;
			case 'Whitecloak':
				StatusIcon		= Texture'I_WhitecloakSeal';
				StatusIconFrame	= Texture'M_WhitecloakSeal';
				MultiSkins[1]	= Texture'S_WhitecloakSeal';
				break;
			}
		}
	}
}

//=============================================================================
// Citadel Editor support functions.
//-----------------------------------------------------------------------------

function Sound GetDeploySound()
{
	return Sound( DynamicLoadObject( "WOT.Editor.DeploySeal", class'Sound' ) );
}

function Sound GetRemoveSound()
{
	return Sound( DynamicLoadObject( "WOT.Editor.RemoveSeal", class'Sound' ) );
}

function BeginEditingResource( int PlacedByTeam )
{
	Team = PlacedByTeam;
	AmbientGlow = 64;
}

function EndEditingResource()
{
	AmbientGlow = 0;
}

function Actor GetBaseResource()
{
	return Self;
}

function bool CheckInsideCylinder( vector Dist, float Radius, float Height )
{
	return abs( Dist.Z ) <= Height && ( Dist.X * Dist.X + Dist.Y * Dist.Y ) <= Radius * Radius;
}

// Finds pathnode which is closest to given location and returns its location (height adjusted
// so seal placed there will be on the floor).
function bool GetClosestPathNodeLocation( out vector NodeLocation )
{
	local NavigationPoint Node;
	local vector BaseLocation;
	local bool bFound;
	local float Dist, MinDist;

	bFound = false;
	MinDist = 999999.0;
	BaseLocation = NodeLocation;

	Node = Level.NavigationPointList;
	while( Node != None )
	{
		Dist = VSize( BaseLocation - Node.Location );

		if( Dist < MinDist )
		{
			bFound = true;

			MinDist = Dist;
			NodeLocation = Node.Location;
			NodeLocation.Z -= Node.CollisionHeight; 
			NodeLocation.Z += CollisionHeight; 
		}

		Node = Node.nextNavigationPoint;
	}

	return bFound;
}

function bool GetTouchingPathNode( vector StartLocation, float Radius, float Height )
{
	local NavigationPoint Node;
	local vector BaseLoc;

	Node = Level.NavigationPointList;
	while( Node != None )
	{
		BaseLoc = Node.Location;
		BaseLoc.Z -= Node.CollisionHeight;
		if( CheckInsideCylinder( BaseLoc - StartLocation, Radius, Height ) )
		{
			return true;
		}
		Node = Node.nextNavigationPoint;
	}
	return false;
}

// mdf-tbd: takes an "out" parameter, but calls a function which doesn't modify StartLocation...
function bool CalcLocation( out vector StartLocation )
{
	return GetTouchingPathNode( StartLocation, PathNodeDeltaR, PathNodeDeltaH );
}

function actor AnyActorsInArea( vector SearchLocation, int SearchDistance )
{
	local Actor A;
	local int i;
	local bool bIgnoreActor;
	local vector Dist;
	local float Radius, Height;

	foreach RadiusActors( class'Actor', A, SearchDistance, SearchLocation )
	{
		bIgnoreActor = false;
		for( i = 0; i < ArrayCount(IgnoreActor); i++ )
		{
			if( A.IsA( IgnoreActor[i] ) )
			{
				bIgnoreActor = true;
				break;
			}
		}
		if( !bIgnoreActor )
		{
			Dist = A.Location - SearchLocation;
			Radius = A.CollisionRadius + CollisionRadius;
			Height = A.CollisionHeight + CollisionHeight;
			if( CheckInsideCylinder( Dist, Radius, Height ) )
			{
//log( "Dist = "$ Dist $" Radius = "$ Radius $" Height = "$ Height $" for Actor = "$ A );
				for( i = 0; i < ArrayCount(BlockingActor); i++ )
				{
					if( A.IsA( BlockingActor[i] ) )
					{
						return A;
					}
				}
				if( !SameLogicalActor( A ) && !A.bHidden )
				{
					return A;
				}
			}
		}
	}

	return None;
}

function bool DeployResource( vector StartLocation, vector StartNormal )
{
    local vector    HitLocation;
    local vector    HitNormal;
    local vector    EndTrace;
    local Actor     Other;

	if( StartNormal.Z < 0.9 )
	{
//PlayerPawn(Owner).ClientMessage( "Surface isn't flat!!! Normal="$ StartNormal );
		return false;
	}

	// trace down a foot
	EndTrace = StartLocation + vect( 0, 0, -16 );
	Other = Trace( HitLocation, HitNormal, EndTrace, StartLocation, true );
	if( Other != Level )
	{
//PlayerPawn(Owner).ClientMessage( "No level!!!" );
		return false;
	}

	StartLocation = HitLocation;
	if( !CalcLocation( StartLocation ) )
	{
//PlayerPawn(Owner).ClientMessage( "No path nodes!!!" );
		return false;
	}

	Other = AnyActorsInArea( StartLocation, PathNodeDeltaR );
	if( Other != None )
	{
//PlayerPawn(Owner).ClientMessage( Other$" too close!!!" );
		return false;
	}

	StartLocation = HitLocation;
	StartLocation.Z += CollisionHeight;

	SetLocation( StartLocation );
	SetRotation( rot(0,0,0) );

	Show();
//PlayerPawn(Owner).ClientMessage( " " );
	
	return true;
}

function bool RemoveResource()
{
	Hide();
	return true;
}

function Hide()
{
	Super.Hide();
	SetCollision( false, false, false );
}

function Show()
{
	Super.Show();
	SetCollision( false, false, false );
}

//=============================================================================

function bool HandlePickupQuery( Inventory Item )
{
	return Super( Inventory ).HandlePickupQuery( Item );
}

function Destroyed()
{
	ClearIndicator();

	ClearControllingTeam();
    Super.Destroyed();
	class'Util'.static.TriggerAllInstances( Self, class'Pawn', None, DestroyedEvent );
}

function DropFrom( Vector StartLocation )
{
	if ( !SetLocation(StartLocation) )
	{
		if( !GetClosestPathNodeLocation( StartLocation ) )
		{
			warn( "Seal::DropFrom -- couldn't use location of nearest pathnode: " $ StartLocation );
		}
	}

	Super.DropFrom( StartLocation );
	SetCollision( true, true, true );
	class'Util'.static.TriggerAllInstances( Self, class'Pawn', None, OwnershipChangedEvent );
}

auto state Pickup
{
	function Landed( vector HitNormal )
	{
		SetCollision( true, false, false );
		Super.Landed( HitNormal );
	}
}

function PickupFunction( Pawn Other )
{
//	Super.PickupFunction( Other );
	class'Util'.static.TriggerAllInstances( Self, class'Pawn', Other, OwnershipChangedEvent );
}

function GiveTo( pawn Other )
{
	// Get rid of existing indicator.
	if( Indicator != None )
	{
		Indicator.bOn = false;
		Indicator.LifeSpan = 1.0;
		Indicator = None;
	}

	Super.GiveTo( Other );

	if( Other != None && Other == Owner )	// Successfully given to a player.
	{
		if( ControllingTeam != 255 && Other.PlayerReplicationInfo.Team != ControllingTeam )
		{
			SendTakeNotification( ControllingTeam );
		}

		// Create visual indicator.
		Indicator = Spawn( class'CarrySealSprayer', Owner );
		if( WOTPlayer(Owner) != None )
			Indicator.SetColor( WOTPlayer(Owner).PlayerColor );
	}
}

function ClearIndicator()
{
	// Get rid of indicator over player.
	if( Indicator != None )
	{
		Indicator.bOn = false;
		Indicator.LifeSpan = 1.0;
		Indicator = None;
	}
}

function BecomePickup()
{
	Super.BecomePickup();

	ClearIndicator();
}

function SendTakeNotification( byte Team )
{
	local Pawn P;

	for( P = Level.PawnList; P != None; P = P.nextPawn )
	{
		if( WOTPlayer(P) != None && P.PlayerReplicationInfo.Team == Team )
		{
			WOTPlayer(P).ClientPlaySound( Sound( DynamicLoadObject( PossesionChangeSoundName, class'Sound' ) ) );
			WOTPlayer(P).CenterMessage( PossesionChangeStr,, true );
		}
	}
}

// end of Seal.uc

defaultproperties
{
     Team=255
     ControllingTeam=255
     PossesionChangeSoundName="WOT.Seal.PossesionChangeSound"
     DestroyedEvent=SealDestroyed
     OwnershipChangedEvent=SealOwnershipChanged
     PathNodeDeltaH=8.000000
     PathNodeDeltaR=512.000000
     BlockingActor(0)=BlockAll
     BlockingActor(1)=BlockPlayer
     BlockingActor(2)=ParticleSprayer
     IgnoreActor(0)=Mover
     IgnoreActor(1)=Inventory
     StatusIconFrame=Texture'WOT.UI.M_SSeal'
     Count=1
     InventoryGroup=40
     bDisplayableInv=True
     bAmbientGlow=False
     PickupMessage="You got the seal"
     PickupViewMesh=Mesh'WOT.Seal'
     PickupViewScale=0.500000
     StatusIcon=Texture'WOT.UI.I_SSeal'
     PickupSound=Sound'WOT.Player.Pickup'
     bCanTeleport=True
     bCollideWhenPlacing=True
     Texture=None
     Mesh=Mesh'WOT.Seal'
     DrawScale=0.500000
     AmbientGlow=0
     CollisionRadius=17.000000
     CollisionHeight=3.000000
}
