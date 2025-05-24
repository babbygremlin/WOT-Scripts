//=============================================================================
// AnimationTableInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class AnimationTableInterf expands LegendAssetComponent abstract;

/*=============================================================================

The RateMultiplier parameter (defaults to 1.0) can be used to scale the default
rate which is given through the default properties, eg. to have running/walking
anims better synced with the rate at which an NPC is moving.

The TweenToTime, if given, completely overrides the tween to time in the default
properties. This is generally used in cases where we want to tween to a new
animation using a tween to time that is calculated elsewhere. In most other 
situations the tween to time in the default properties will be used.

The TweenPlaySlotAnim and TweenLoopSlotAnim functions tween to the new animation
then play/loop it. This makes it possible to replace code like:

	TweenSlotAnim(...);
	FinishAnim();
	PlaySlotAnim(...);
	FinishAnim();

with

	TweenPlaySlotAnim(...);
	FinishAnim();

Use PickSlotAnim to determine which animation will be played for the given slot 
without playing it immediately. The animation name is returned to the caller 
(allowing this to call animation-specific code) then the animation can be passed 
back to TweenSlotAnim etc. with the bNotSlot parameter set to true so this exact
animation will be played.

Use AnimEndVector to specify the direction in which the mesh "sticks out" 
relative to the front of the mesh. This is only currently used for filtering
out death animations which will stick into geometry. The default value of
vect(0,0,0) means that no filtering will be done for that animation, vect(1,0,0)
means the mesh will "fall forward", vect(-1,0,0) = "fall backward" etc.

=============================================================================*/

struct EngineAnimInfoT
{
	var() Name				AnimName;			
	var() float				AnimRate;			
	var() float				AnimTweenToTime;	
};



struct AnimInfoT
{
	var() Name				AnimSlot;			// anim category (can have multiple anims per slot)
	var() float				AnimOdds; 			// Odds of anim being used (within a slot)
	var() EGameType			GameType;			// game type(s) where anim is used
	var() vector			AnimEndVector;		// direction relative to forward that mesh sticks out the most in
	
	var() EngineAnimInfoT	EAnimInfo;			// engine anim parameters
};



const DefaultAnimRate			= 1.0;
const DefaultAnimTweenToTime	= 0.2;

static function PlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot );
static function LoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot );
static function TweenPlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot );
static function TweenLoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot );
static function TweenSlotAnim( Actor SourceActor, name LookupName, optional float TweenToTime, optional bool bNotSlot );
static function Name PickSlotAnim( Actor SourceActor, name LookupName );

defaultproperties
{
}
