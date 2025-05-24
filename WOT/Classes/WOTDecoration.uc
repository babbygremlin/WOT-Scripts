//=============================================================================
// WOTDecoration.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================
class WOTDecoration expands Decoration
	abstract;

var(Animation) float MaxAnimRate, MinAnimRate;
var(Animation) name AnimationSequence;
var(Animation) bool bAutoAnimate;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if( bAutoAnimate )
	{
		LoopAnim( AnimationSequence, RandRange( MinAnimRate, MaxAnimRate ) );
	}
}

defaultproperties
{
     MaxAnimRate=1.000000
     MinAnimRate=1.000000
     AnimationSequence=All
     bCanTeleport=True
     DrawType=DT_Mesh
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
