//------------------------------------------------------------------------------
// FireballFire.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireballFire expands Flame01;

var() float Duration;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	LifeSpan = Duration;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Volume = default.Volume * LifeSpan / Duration;
	bOn = (FollowActor != None && !FollowActor.bDeleteMe);
	Super.Tick( DeltaTime );
}

defaultproperties
{
    Duration=7.00
}
