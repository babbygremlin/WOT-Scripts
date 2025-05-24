//------------------------------------------------------------------------------
// AlarmInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class AlarmInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Alarm\I_SAlarm.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Alarm\M_SAlarm.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Alarm"
     Description="The alarm is a simple gong that can be placed on any flat, clear, vertical surface.  Some captains can be commanded to sound these alarms.  When such captains spot an intruder, instead of attacking, they run to the nearest alarm to strike it.  Any guards within hearing range immediately gather to learn where to search for the intruder."
     Quote="@We must hurry! They will kill us if they find us!@ Somewhere above, gongs began to sound an alarm, and more thundered echoes through the Stone."
     StatusIconFrame=Texture'WOTTraps.UI.M_SAlarm'
     ResourceClass=Class'WOTTraps.Alarm'
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SAlarm'
}
