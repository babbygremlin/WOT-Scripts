//------------------------------------------------------------------------------
// RemoveCurseEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	Removes all latent effects and untaints victim's angreal.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class RemoveCurseEffect expands SingleVictimEffect;

//------------------------------------------------------------------------------
// Removes all latent effects and untaints victim's angreal.
//------------------------------------------------------------------------------
function Invoke()
{
	local Leech L;
	local Reflector R;

	local LeechIterator IterL;
	local ReflectorIterator IterR;

	local Inventory Inv;

	// Remove bad Leeches.
	IterL = class'LeechIterator'.static.GetIteratorFor( Victim );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( L.bRemovable && (L.SourceAngreal == None || L.SourceAngreal != SourceAngreal) )	// Don't remove our own leeches.
		{
			L.Unattach();
			L.Destroy();
		}
	}
	IterL.Reset();
	IterL = None;

	// Remove bad Reflectors.
	IterR = class'ReflectorIterator'.static.GetIteratorFor( Victim );
	for( IterR.First(); !IterR.IsDone(); IterR.Next() )
	{
		R = IterR.GetCurrent();

		if( R.bRemovable && (R.SourceAngreal == None || R.SourceAngreal != SourceAngreal) )	// Don't remove our own reflectors.
		{
			R.Uninstall();
			R.Destroy();
		}
	}
	IterR.Reset();
	IterR = None;

	// Untaint all angreal.
	for( Inv = Victim.Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if( AngrealInventory(Inv) != None )
		{
			AngrealInventory(Inv).bTainted = False;
		}
	}
}
	

defaultproperties
{
}
