//------------------------------------------------------------------------------
// RemoveCurseLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class RemoveCurseLeech expands Leech;

var RCAMAPearl Pearl;

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	Super.AttachTo( NewHost );

	if( Owner == NewHost )
	{
		Pearl = Spawn( class'RCAMAPearl', Owner,, Owner.Location );
		Pearl.SetSourceAngreal( SourceAngreal );
		Pearl.ParentLeech = Self;
		Pearl.Go();
	}
}

//------------------------------------------------------------------------------
singular function UnAttach()
{
	Super.UnAttach();

	if( Pearl != None && !Pearl.bDeleteMe )
	{
		Pearl.Destroy();
	}
}

defaultproperties
{
}
