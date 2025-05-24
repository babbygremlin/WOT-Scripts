//------------------------------------------------------------------------------
// ExplosiveWard.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	The visual component of ExplosiveWard.  (No replication).
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ExplosiveWard expands Effects;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	warn( "This is a legacy class, and should not be placed in levels." );
	Destroy();
}

defaultproperties
{
}
