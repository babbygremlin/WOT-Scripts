//=============================================================================
// MissionObjectives.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================
class MissionObjectives expands WOTTextWindowInfo;

var() string DialogSoundString;
var() bool bDidAutoPopup;

var private bool bOKTOPlaySound;

function bool GetOKToPlaySound()
{
	return bOKToPlaySound;
}

function SetOKToPlaySound( bool bVal )
{
	bOKToPlaySound = bVal;
}

// end of MissionObjectives.uc

defaultproperties
{
     bOKTOPlaySound=True
     WindowSizeX=512
     WindowSizeY=128
}
