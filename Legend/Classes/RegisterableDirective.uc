//=============================================================================
// RegisterableDirective.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class RegisterableDirective expands ObservableDirective abstract native;

var () private bool	bIgnoreNonZoneRegistration;
var private Actor Registered[ 50 ];



function Register( Actor Registrant )
{
	local int RegisteredIter;
	class'Debug'.static.DebugLog( Self, "Register Registrant " $ Registrant, 'RegisterableDirective' );
	if( !IsObserverIgnored( Registrant, Pawn( Registrant ) ) )
	{
		for( RegisteredIter = 0; RegisteredIter < ArrayCount( Registered ); RegisteredIter++ )
		{
			if( Registered[ RegisteredIter ] == None )
			{
				Registered[ RegisteredIter ] = Registrant;
				break;
			}
		}
	}
}



function bool IsObserverIgnored( Actor Observer, Pawn EventInstigator )
{
	local bool bIgnored;
	bIgnored = super.IsObserverIgnored( Observer, EventInstigator );
	if( !bIgnored && bIgnoreNonZoneRegistration )
	{
		bIgnored = ( Region.Zone != Observer.Region.Zone );
	}
	return bIgnored;
}



function Unregister( Actor Registrant )
{
	local int RegisteredIter;
	class'Debug'.static.DebugLog( Self, "Unregister Registrant " $ Registrant, 'RegisterableDirective' );
	for( RegisteredIter = 0; RegisteredIter < ArrayCount( Registered ); RegisteredIter++ )
	{
		if( Registered[ RegisteredIter ] == Registrant )
		{
			Registered[ RegisteredIter ] = None;
			break;
		}
	}
}



native function DirectObservers( Pawn EventInstigator );
/*
{
//xxxrloremove
	local int RegisteredIter;
	class'Debug'.static.DebugLog( Self, "DirectObservers", 'RegisterableDirective' );
	for( RegisteredIter = 0; RegisteredIter < ArrayCount( Registered ); RegisteredIter++ )
	{
		if( Registered[ RegisteredIter ] != None )
		{
			DirectObserver( Registered[ RegisteredIter ], EventInstigator );
		}
	}
}
*/

defaultproperties
{
}
