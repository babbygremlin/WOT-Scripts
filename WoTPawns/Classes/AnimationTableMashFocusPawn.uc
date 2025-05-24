//=============================================================================
// AnimationTableMashFocusPawn.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class AnimationTableMashFocusPawn expands AnimationTableWOT abstract;

// disable any animation "stuff" for Mashadar
static function PlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot );
static function LoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot );
static function TweenPlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot );
static function TweenLoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot );
static function TweenSlotAnim( Actor SourceActor, name LookupName, optional float TweenToTime, optional bool bNotSlot );
static function Name PickSlotAnim( Actor SourceActor, name LookupName ) { return ''; }

defaultproperties
{
}
