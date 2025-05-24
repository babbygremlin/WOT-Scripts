//------------------------------------------------------------------------------
// LegionStompAngrealInv.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Causes the earth to shake within a certain radius. Anyone on 
//				the ground within that radius takes damage and gets pushed back.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionStompAngrealInv expands AngrealInventory;

var() vector LeftStompOffset;
var() vector RightStompOffset;
var() vector ForwardStompOffset;

//------------------------------------------------------------------------------
function Cast();
function UnCast();

//------------------------------------------------------------------------------
function LeftStomp()
{
	if( Owner != None )
	{
		Stomp( Owner.Location + (LeftStompOffset >> Owner.Rotation) );
	}
}

//------------------------------------------------------------------------------
function RightStomp()
{
	if( Owner != None )
	{
		Stomp( Owner.Location + (RightStompOffset >> Owner.Rotation) );
	}
}

//------------------------------------------------------------------------------
function ForwardStomp()
{
	if( Owner != None )
	{
		Stomp( Owner.Location + ( ForwardStompOffset >> Owner.Rotation ) );
	}
}

//------------------------------------------------------------------------------
function Stomp( vector StompLocation )
{
	local vector Dir;
	local EarthTremor ET;

	if( Owner != None )
	{	
		Dir = StompLocation - Owner.Location;
		Dir.z = 0.0;

		ET = Spawn( class'LegionEarthTremor',,, StompLocation, rotator(Dir) );
		ET.SetSourceAngreal( Self );
		ET.Go();

		if( FRand() < 0.5 )
		{
			Spawn( class'FireballExplode',,, StompLocation );
		}
		else
		{
			Spawn( class'FireballExplode2',,, StompLocation );
		}
	}
}

defaultproperties
{
     LeftStompOffset=(X=50.000000,Y=-75.000000,Z=-50.000000)
     RightStompOffset=(X=50.000000,Y=75.000000,Z=-50.000000)
     ForwardStompOffset=(X=50.000000,Z=-50.000000)
     bElementFire=True
     bElementEarth=True
     bRare=True
     bOffensive=True
     bCombat=True
     ChargeCost=0
     Priority=-999.000000
     Title="Legion Stomp"
     Description="None"
     Quote="None"
     StatusIconFrame=Texture'Angreal.Icons.M_EarthTremor'
     InventoryGroup=60
     PickupMessage="You got the Legion Stomp Ter'angreal"
     PickupViewMesh=Mesh'Angreal.AngrealEarthTremorPickup'
     StatusIcon=Texture'Angreal.Icons.I_EarthTremor'
     Mesh=Mesh'Angreal.AngrealEarthTremorPickup'
}
