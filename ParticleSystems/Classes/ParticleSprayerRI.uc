//=============================================================================
// ParticleSprayerRI.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class ParticleSprayerRI expands RenderIterator
	native
	noexport;

struct DataBuffer
{
	var float GrowRate;
	var float GrowTime;
	var float GrowTimer;
	var float FadeRate;
	var float FadeTime;
	var float FadeTimer;
	var rotator RotationRate;
};

var transient ActorBuffer Actors[128];

var transient DataBuffer	Data[128];

var transient float	PreviousTickTime;
var transient float	ParticleTimer;
var transient int		Cursor;
var transient int		TemplateIndex;
var transient int		TemplateIteration;
var transient float		LargestWeight;
var transient int		NumParticles;
var transient bool	bClipped;
var transient vector	LastLocation;
var transient rotator	LastRotation;
var transient rotator	LastParticleRotation;

// end of RenderIterator.uc

defaultproperties
{
}
