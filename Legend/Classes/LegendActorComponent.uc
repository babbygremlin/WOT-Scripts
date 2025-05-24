//=============================================================================
// LegendActorComponent.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class LegendActorComponent expands Actor abstract native;

var () const Name DebugCategoryName;

//xxxrlofuture function DebugLog( Object Invoker );

defaultproperties
{
     DebugCategoryName=LegendActorComponent
     bHidden=True
     RemoteRole=ROLE_None
}
