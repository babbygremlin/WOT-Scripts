//------------------------------------------------------------------------------
// AMANetSpawner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Hack so that when the server detects that an AMA box has been
//				touched, it can spawn one of these doobies that will replicate
//				to all the clients, and spawn an AMAPearl for it and set its
//				(the box) state to fading.  Essentially, an RPC done the hard
//				way.
//------------------------------------------------------------------------------
// How to use this class: Don't :)
//------------------------------------------------------------------------------

class AMANetSpawner expands Effects;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local AMAPearl Pearl;

	Super.PreBeginPlay();

	Pearl = Spawn( class'AMAPearl' );
	Pearl.SetSourceAngreal( AngrealProjectile(Owner).SourceAngreal );
	Pearl.Go();

	Owner.GotoState('Fading');
}

defaultproperties
{
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.000000
     bAlwaysRelevant=True
}
