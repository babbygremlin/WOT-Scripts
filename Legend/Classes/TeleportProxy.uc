//=============================================================================
// TeleportProxy.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class TeleportProxy expands LegendActorComponent;



function bool EnableTeleportProxy( Actor TeleportPosition )
{
	local bool bEnableTeleportProxy;
	if( SetLocation( TeleportPosition.Location ) )
	{
		SetCollision( true, false, false );
		bEnableTeleportProxy = SetCollisionSize( default.CollisionRadius, default.CollisionHeight );
	}
	if( !bEnableTeleportProxy )
	{
		DisableTeleportProxy();
	}
	return bEnableTeleportProxy;
}



function DisableTeleportProxy()
{
	SetCollisionSize( 0, 0 );
	SetCollision( false, false, false );
}

defaultproperties
{
     CollisionRadius=32.000000
     CollisionHeight=64.000000
}
