//=============================================================================
// menuSlot.uc
//=============================================================================
class menuSlot expands menuLong abstract
	config(user);

const SlotOffsetX = 240;
const SlotOffsetY = 120;

var localized string EmptySlotName;
var localized globalconfig string SlotNames[9];
var localized string MonthNames[12];
var() int MenuStartIndex;

//=============================================================================

function GetSlotParams( Canvas C, out int StartX, out int StartY, out int Spacing )
{
	Spacing = Clamp(0.05 * C.ClipY, 12, 32);
	StartX = LegendCanvas(C).ScaleValX( SlotOffsetX );
	StartY = LegendCanvas(C).ScaleValY( SlotOffsetY );
}

//=============================================================================

function DrawSlots( Canvas C )
{
	local int StartX, StartY, Spacing, i;
			
	GetSlotParams( C, StartX, StartY, Spacing );			
	C.SetFont( Font'WOT.F_WOTReg14' );

	for( i=1; i<=MenuLength; i++ )
	{
		SetFontBrightness( C, i == Selection );
		C.SetPos( StartX, StartY + i * Spacing );
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
     SlotNames(0)="..Empty.."
     SlotNames(1)="..Empty.."
     SlotNames(2)="..Empty.."
     SlotNames(3)="..Empty.."
     SlotNames(4)="..Empty.."
     SlotNames(5)="..Empty.."
     SlotNames(6)="..Empty.."
     SlotNames(7)="..Empty.."
     SlotNames(8)="..Empty.."
     MenuLength=9
}
