//=============================================================================
// Champion.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class Champion expands Captain abstract;

const RecoverAnimSlot = 'Recover';



simulated event SetInitialState()
{
    //initialize command system
    AssignedOrders = OT_KillIntruder;
   	ChangeOrders( AssignedOrders );
    class'WotUtil'.static.InvokeWotPawnFindLeader( Self );
	Super( Grunt ).SetInitialState();
}

defaultproperties
{
     BrokenMoralePct=0
     MoveFromTakeDamageThreshold=-1
}
