//=============================================================================
// MusicTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================
class MusicTrigger expands Trigger;

function PreBeginPlay()
{
	Warn( "Please remove MusicTriggers!!!" );
	assert( false );
}

defaultproperties
{
}
