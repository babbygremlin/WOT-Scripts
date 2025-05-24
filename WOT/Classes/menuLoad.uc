//=============================================================================
// menuLoad.uc
//=============================================================================
class menuLoad expands menuSlot;

// Restart <Game Name>
// <1 - saved game>
// <2 - saved game>
// <3 - saved game>
// <4 - saved game>
// <5 - saved game>
// <6 - saved game>
// <7 - saved game>
// <8 - saved game>
// <9 - saved game>

var() localized string RestartString;

//=============================================================================

function BeginPlay()
{
	local int i;

	Super.BeginPlay();
	
	// start on a non-empty slot, if possible
	for( i=0; i<MenuLength; i++ )
	{
		if( !(SlotNames[i] ~= EmptySlotName) )
		{
			Selection = i + 1;
			break;
		}
	}
}

//=============================================================================

function bool ProcessSelection()
{
	if( Selection == 1 )
	{
		PlayerOwner.ReStartLevel(); 
		return true;
	}
	if( SlotNames[Selection - 2] ~= EmptySlotName )
	{
		return false;
	}
	bExitAllMenus = true;
	PlayerOwner.ClientMessage("");
	WOTPlayer(PlayerOwner).SetTransitionType( TRT_LoadLevel );
	if( Left(SlotNames[Selection - 2], 4) == "Net:" )
	{
		Level.ServerTravel( "?load=" $ (Selection - 2), false);
	}
	else
	{
		PlayerOwner.ClientTravel( "?load=" $ (Selection - 2), TRAVEL_Absolute, false );
	}
	return true;
}

//=============================================================================

function DrawMenu( Canvas C )
{
	DrawTitle( C );
	DrawSlots( C );	
}

//=============================================================================

function DrawSlots( Canvas C )
{
	local int StartX, StartY, Spacing, i;

	GetSlotParams( C, StartX, StartY, Spacing );			

	// draw "Restart"
	C.SetFont( Font'WOT.F_WOTReg14' );
	SetFontBrightness( C, 1 == Selection );
	C.SetPos( StartX, StartY + Spacing );
	C.DrawText( RestartString$Level.Title, false );

	C.SetFont( Font'WOT.F_WOTReg14' );

	for( i=1; i<=(MenuLength-1); i++ )
	{
		SetFontBrightness( C, (i+1) == Selection );
		C.SetPos( StartX, StartY + (i+1) * Spacing );
		C.DrawText(SlotNames[i-1], False);
	}

	// show selection
	SetFontBrightness( C, true );
	C.SetPos( StartX - 20, StartY + Spacing * Selection );
	C.DrawText("[]", false);	
	SetFontBrightness( C, false);
}

defaultproperties
{
     MenuLength=10
}
