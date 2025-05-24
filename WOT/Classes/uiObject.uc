//=============================================================================
// uiObject.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================
class uiObject expands Actor abstract;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	assert( Level.NetMode != NM_DedicatedServer );	// Fix ARL: If RemoteRole=ROLE_SimulatedProxy, then these should never get created on the server.
}

// end of uiObject.uc

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
}
