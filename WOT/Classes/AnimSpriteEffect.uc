//=============================================================================
// AnimSpriteEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================
class AnimSpriteEffect expands Effects
	abstract;

var() Texture AnimSets[20];
var() int NumSets;

var() float RisingRate;
	
simulated function PostBeginPlay()
{
	// pick which set to animate
	Texture = AnimSets[ Rand( NumSets ) ];
	assert( Texture != None );

	// make the smoke rise
	Velocity = Vect(0,0,1) * RisingRate;
}

defaultproperties
{
     bNetOptional=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.400000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     DrawScale=0.300000
     bUnlit=True
}
