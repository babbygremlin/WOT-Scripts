//=============================================================================
// Effects, the base class of all gratuitous special effects.
//=============================================================================
class Effects extends Actor;

var() sound 	EffectSound1;
var() sound 	EffectSound2;
var() bool bOnlyTriggerable;

defaultproperties
{
    bNetTemporary=True
    DrawType=0
    bGameRelevant=True
    CollisionRadius=0.00
    CollisionHeight=0.00
}
