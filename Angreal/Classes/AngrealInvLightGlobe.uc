//------------------------------------------------------------------------------
// AngrealInvLightGlobe.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvLightGlobe expands AngrealInventory;

#exec MESH IMPORT MESH=LightGlobe ANIVFILE=MODELS\LightGlobe_a.3d DATAFILE=MODELS\LightGlobe_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LightGlobe X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LightGlobe SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JLightGlobe0 FILE=MODELS\LightGlobe0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec TEXTURE IMPORT FILE=MODELS\LightGlobeGlow1.PCX GROUP=Effects FLAGS=2 // Sprite

#exec MESHMAP NEW   MESHMAP=LightGlobe MESH=LightGlobe
#exec MESHMAP SCALE MESHMAP=LightGlobe X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=LightGlobe NUM=0 TEXTURE=JLightGlobe0

#exec TEXTURE IMPORT FILE=Icons\I_LtGlobe.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_LtGlobe.pcx	GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\LightGlobe\ActivateLG.wav	GROUP=LightGlobe

var() class<LightGlobe> LightType;		// Type of light to use.
var LightGlobe Light;

var() vector LightGlobeGlowOffset;		// Sprite offset from model, relative to rotation.
var GenericSprite Globe;

var bool bAmPickup;
var bool bClientAmPickup;

replication
{
	reliable if( Role==ROLE_Authority )
		bAmPickup, LightType;
}

//------------------------------------------------------------------------------
function BecomePickup()
{
	Super.BecomePickup();
	ClientBecomePickup();
}

//------------------------------------------------------------------------------
simulated function ClientBecomePickup()
{
	if( Globe == None )
	{
		Globe = Spawn( class'LightGlobeStar',,, Location + (LightGlobeGlowOffset >> Rotation) );
	}
	else
	{
		Globe.SetLocation( Location + (LightGlobeGlowOffset >> Rotation) );
		Globe.bHidden = false;
	}

	bAmPickup = true;
}

//------------------------------------------------------------------------------
simulated function BecomeItem()
{
	Super.BecomeItem();
	ClientBecomeItem();
}

//------------------------------------------------------------------------------
simulated function ClientBecomeItem()
{
	if( Globe != None )
	{
		Globe.bHidden = true;
	}

	bAmPickup = false;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Globe != None )
	{
		Globe.Destroy();
		Globe = None;
	}

	if( Role==ROLE_Authority && Light != None )
	{
		Light.Follow( None );
		Light = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;

	if( Role<ROLE_Authority )
	{
		if( bAmPickup && !bClientAmPickup )
		{
			ClientBecomePickup();
			bClientAmPickup = true;
		}
		else if( !bAmPickup && bClientAmPickup )
		{
			ClientBecomeItem();
			bClientAmPickup = false;
		}
	}

	if( Globe != None && !Globe.bHidden )
	{
		Globe.SetLocation( Location + (LightGlobeGlowOffset >> Rotation) );
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
function Cast()
{
	if( Light == None )
	{
		Light = Spawn( LightType );
		Light.Follow( Owner );
		Super.Cast();
		UseCharge();
	}
	else
	{
		Light.Follow( None );
		Light = None;
		Super.UnCast();
	}
}

//------------------------------------------------------------------------------
function UnCast()
{
	if( Pawn(Owner) != None && Pawn(Owner).Health <= 0 && Light != None )
	{
		Cast();
	}

	// Don't call -- Super.UnCast();
}

//------------------------------------------------------------------------------
function Trigger( Actor Other, Pawn EventInstigator )
{
	if( Light != None )
	{
		Cast();
	}
}

//-----------------------------------------------------------------------------
// Called when we run out of charges.  
//-----------------------------------------------------------------------------
function GoEmpty()
{
	if( Light != None )
	{
		Light.Destroy();
		Light = None;		// Just in case.
	}

	Super.GoEmpty();
}

//-----------------------------------------------------------------------------
// Called when our owner drops us.
//-----------------------------------------------------------------------------
function DropFrom( vector StartLocation )
{
	if( Light != None )
	{
		Light.Destroy();
		Light = None;								// Just in case.
	}

	Super.UnCast();

	Super.DropFrom( StartLocation );
}

//------------------------------------------------------------------------------
function GiveTo( Pawn Other )
{
	Super.GiveTo( Other );
	
	if( WOTPlayer(Other) != None )
	{
		SetColor( WOTPlayer(Other).PlayerColor );
	}
	else if( Other.Mesh.Name == 'AesSedai' )
	{
		SetColor( 'Blue' );
	}
	else if( Other.Mesh.Name == 'Forsaken' )
	{
		SetColor( 'Red' );
	}
	else if( Other.Mesh.Name == 'Whitecloak' )
	{
		SetColor( 'Gold' );
	}
	else if( Other.Mesh.Name == 'Hound' )
	{
		SetColor( 'Purple' );
	}
	else
	{
		SetColor( 'Green' );
	}
}

//------------------------------------------------------------------------------
function SetColor( name Color )
{
	switch( Color )
	{
	case 'Red':
	case 'PC_Red':
		LightType = class'Angreal.LightGlobeRed';
		break;

	case 'Yellow':
	case 'PC_Gold':
	case 'Gold':
		LightType = class'Angreal.LightGlobeYellow';
		break;

	case 'PC_Green':
	case 'Green':
		LightType = class'Angreal.LightGlobeGreen';
		break;

	case 'PC_Purple':
	case 'Purple':
		LightType = class'Angreal.LightGlobePurple';
		break;

	case 'PC_Blue':
	case 'Blue':
	default:
		LightType = class'Angreal.LightGlobeBlue';
		break;
	}
}

////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetPriority()
{
	// If we're in a WaysZone, and we don't have our light on... turn it on.
	if( Owner != None && Owner.Region.Zone.IsA('WaysZone') && Light == None )
	{
		return Priority;
	}

	// If we're not in a WaysZone, and we do have our light on... turn it off.
	if( Owner != None && !Owner.Region.Zone.IsA('WaysZone') && Light != None )
	{
		return Priority;
	}

	return -MaxInt;	// Don't do anything.
}

defaultproperties
{
    LightType=Class'LightGlobe'
    LightGlobeGlowOffset=(X=0.00,Y=7.00,Z=3.00),
    bElementFire=True
    bElementAir=True
    bRare=True
    MinInitialCharges=999
    MaxInitialCharges=999
    ChargeCost=0
    Priority=100.00
    ActivateSoundName="Angreal.ActivateLG"
    Title="Light Sphere"
    Description="Activating the ter'angreal weaves a simple sphere of light.  The sphere accompanies you, until unraveled by a subsequent activation."
    Quote="She channeled even as she moved, weaving a web of light that hung to one side, a sphere of pure white that cast lurid shadows about the room."
    StatusIconFrame=Texture'Icons.M_LtGlobe'
    InventoryGroup=51
    PickupMessage="You got the Light Sphere ter'angreal"
    PickupViewMesh=Mesh'LightGlobe'
    StatusIcon=Texture'Icons.I_LtGlobe'
    Texture=None
    Mesh=Mesh'LightGlobe'
}
