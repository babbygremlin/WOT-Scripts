//=============================================================================
// DripGenerator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================
class DripGenerator expands Decoration;

var() float DripPause;		// pause between drips
var() float DripVariance;	// how different each drip is 

auto state Dripping
{
	function Timer()
	{
		local drip d;
		d = Spawn( class'Drip' );
		d.DrawScale = 0.5 + FRand() * DripVariance;
	}

Begin:
	SetTimer( DripPause + FRand() * DripPause, True );
}

defaultproperties
{
     DripPause=0.700000
     DripVariance=0.500000
     bStatic=False
     bHidden=True
}
