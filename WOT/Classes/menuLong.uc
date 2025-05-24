//=============================================================================
// menuLong.uc
//
// The long menus.
//=============================================================================
class menuLong expands menuWOT abstract;

var localized string VeryLowText, LowText, MediumText, HighText, ExtremeText;
var localized string OnText, OffText;

//=============================================================================

function PlayerMenu()
{
	local Menu ChildMenu;

	ChildMenu = spawn( class'menuPlayer', Owner );
	if( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = Self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
}

//=============================================================================

function StartMap( string Map, optional bool bMultiPlayer )
{
	SaveConfigs();
	bExitAllMenus = true;
	if( bMultiPlayer )
	{
		Map = Map
			$"?Name="$PlayerOwner.PlayerReplicationInfo.PlayerName
			$"?Rate="$PlayerOwner.Player.CurrentNetSpeed;
	}
//log( Self$".ClientTravel() " $ Map );
	PlayerOwner.ClientTravel( Map, TRAVEL_Absolute, false );
}

//=============================================================================
// Each menu provides its own implementation of DrawMenu.

function DrawMenu( Canvas C )
{
	// draw text
	C.bCenter = true;
	C.SetFont( Font'WOT.F_WOTReg14' );
	C.SetPos( C.SizeX/2, C.SizeY/2 );
	C.DrawText( "DrawMenu not implemented in subclass!", false );
	C.bCenter = false;
}

//=============================================================================

simulated function string GetOnOffStr( bool bVal )
{
	if( bVal )
	{
		return OnText;
	}
	else
	{
		return OffText;
	}
}

//=============================================================================

simulated function string GetLowMediumHighStr( byte n )
{
	switch( n )
	{
		case 0:	return LowText;
		case 1:	return MediumText;
		case 2:	return HighText;
		default: assert( false );
	}
}

//=============================================================================

simulated function string GetHighLowStr( bool bHigh )
{
	if( bHigh )
	{
		return HighText;
	}
	else
	{
		return LowText;
	}
}

defaultproperties
{
}
