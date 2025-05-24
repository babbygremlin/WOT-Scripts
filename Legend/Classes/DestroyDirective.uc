//=============================================================================
// DestroyDirective.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class DestroyDirective expands ObservableDirective;



function DirectObserver( Actor Observer, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "DirectObserver", 'DestroyDirective' );
	Observer.Destroy();
}

defaultproperties
{
}
