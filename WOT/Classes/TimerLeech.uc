//------------------------------------------------------------------------------
// TimerLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class TimerLeech expands Leech;

#exec TEXTURE IMPORT FILE=Icons\SunRiseTimer.PCX	GROUP=Timers MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\MachinShinTimer.PCX	GROUP=Timers MIPS=Off

//StatusIconFrame=Texture'WOT.Timers.SunRiseTimer'

defaultproperties
{
     bDisplayIcon=True
     bRemovable=False
     LifeSpan=60.000000
}
