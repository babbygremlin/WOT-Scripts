//=============================================================================
// menuSave.uc
//=============================================================================
class menuSave expands menuSlot;

// <1 - saved game>
// <2 - saved game>
// <3 - saved game>
// <4 - saved game>
// <5 - saved game>
// <6 - saved game>
// <7 - saved game>
// <8 - saved game>
// <9 - saved game>

var localized string CantSave;

//=============================================================================

function BeginPlay()
{
	local int i;

	Super.BeginPlay();
	
	// start on an empty slot, if possible
	for( i=0; i<MenuLength; i++ )
	{
		if( SlotNames[i] ~= EmptySlotName )
		{
			Selection = i + 1;
			break;
		}
	}
}

//=============================================================================

function bool ProcessSelection()
{
	if( PlayerOwner.Health <= 0 )
	{
		return true;
	}
	
	if( Level.Minute < 10 )
	{
		SlotNames[Selection - 1] = (Level.Title$" "$Level.Hour$"\:0"$Level.Minute$" "$MonthNames[Level.Month - 1]$" "$Level.Day);
	}
	else
	{
		SlotNames[Selection - 1] = (Level.Title$" "$Level.Hour$"\:"$Level.Minute$" "$MonthNames[Level.Month - 1]$" "$Level.Day);
	}

	if( Level.NetMode != NM_Standalone )
	{
		SlotNames[Selection - 1] = "Net:"$SlotNames[Selection - 1];
	}
	
	SaveConfig();
	bExitAllMenus = true;
	PlayerOwner.ClientMessage(" ");
	PlayerOwner.bDelayedCommand = true;
	PlayerOwner.DelayedCommand = "SaveGame "$(Selection - 1);
	return true;
}

//=============================================================================

function DrawMenu( Canvas C )
{
	if( PlayerOwner.Health <= 0 )
	{
		MenuTitle = CantSave;
		DrawTitle( C );
		return;
	}

	DrawTitle( C );
	DrawSlots( C );	
}

defaultproperties
{
}
