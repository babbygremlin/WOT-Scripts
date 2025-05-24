//------------------------------------------------------------------------------
// ETSoundProxy.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	This is just used to play ambient sounds from.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ETSoundProxy expands Effects;

#exec AUDIO IMPORT FILE=Sounds\EarthTremor\LoopET.wav			GROUP=EarthTremor

var EarthTremorRock Rocks[32];
var int NumRocks;
var float InitialLifeSpan;

simulated function SetLifeSpan( float T )
{
	LifeSpan = T;
	InitialLifeSpan = LifeSpan;
}

//------------------------------------------------------------------------------
simulated function AddRock( EarthTremorRock R )
{
	if( NumRocks < ArrayCount(Rocks) )
	{
		Rocks[NumRocks++] = R;
	}
	else
	{
		warn( "Capacity exceeded." );
		assert( false );
	}
}

//------------------------------------------------------------------------------
simulated function RemoveRock(  EarthTremorRock R )
{	
	local int i;

	// Find the rock in our array, and set it to None.
	for( i = 0; i < NumRocks; i++ )
	{
		if( Rocks[i] == R )
		{
			Rocks[i] = None;
			break;
		}
	}

	// See if there are any rocks left.
	for( i = 0; i < ArrayCount(Rocks); i++ )
		if( Rocks[i] != None )
			break;
	
	if( i < ArrayCount(Rocks) )
	{
		// We still have rocks.
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local float Scalar;
	
	Super.Tick( DeltaTime );
	
	Scalar = FMin(1.0, ((LifeSpan / InitialLifeSpan) * 10.0) );
	
	LightBrightness = byte(float(default.LightBrightness)*Scalar);
	SoundVolume = byte(float(default.SoundVolume)*Scalar);
}

defaultproperties
{
    bMovable=False
    RemoteRole=0
    SoundRadius=83
    SoundVolume=255
    SoundPitch=50
    AmbientSound=Sound'EarthTremor.LoopET'
    LightType=1
    LightEffect=13
    LightBrightness=204
    LightHue=12
    LightRadius=22
}
