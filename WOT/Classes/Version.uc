//=============================================================================
// Version.uc
// $Author: Mfox $
// $Date: 1/12/00 9:51p $
// $Revision: 46 $
//=============================================================================

class Version expands Object
	native;

const ENGINE_VERSION = 333;
const GAME_VERSION = 310;

static function String GetVersionStr()
{
	return "Game Version " $ ENGINE_VERSION $ "." $ GAME_VERSION $ ". Distributed under license from Red Eagle Games.";
}

defaultproperties
{
}
