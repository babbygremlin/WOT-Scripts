//------------------------------------------------------------------------------
// DistantEyeCastReflector
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class DistantEyeCastReflector expands Reflector;

var AngrealDistantEyeProjectile Eye;

/////////////////////////
// Overriden Functions //
/////////////////////////

//-----------------------------------------------------------------------------
function UseAngreal()
{
	Eye.Fire();

	// Don't pass control off to next reflector.
	//Super.UseAngreal();
}

//-----------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	Eye.UnFire();

	// Don't pass control off to next reflector.
	//Super.CeaseUsingAngreal();
}

//------------------------------------------------------------------------------
function float GetInitialDuration()
{
	return Eye.default.Health;
}

//------------------------------------------------------------------------------
function float GetDuration()
{
	return Eye.Health;
}

defaultproperties
{
    Priority=128
    bRemovable=False
}
