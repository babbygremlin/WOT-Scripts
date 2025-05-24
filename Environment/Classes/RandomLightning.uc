//------------------------------------------------------------------------------
// RandomLightning.uc
// $Author: Mpoesch $
// $Date: 8/25/99 2:19a $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Look at Battle2_02.
//------------------------------------------------------------------------------
class RandomLightning expands Effects;

#exec AUDIO IMPORT FILE=Sounds\Thunder10.wav	GROUP=Thunder	
#exec AUDIO IMPORT FILE=Sounds\Thunder3.wav		GROUP=Thunder
#exec AUDIO IMPORT FILE=Sounds\Thunder9.wav		GROUP=Thunder
#exec AUDIO IMPORT FILE=Sounds\Thunder2.wav		GROUP=Thunder
#exec AUDIO IMPORT FILE=Sounds\Thunder4.wav		GROUP=Thunder
#exec AUDIO IMPORT FILE=Sounds\Thunder8.wav		GROUP=Thunder

// Amount of time between the lightning and the thunder.
var() float MaxThunderDelay;
var() float MinThunderDelay;

// Amount of time between consecutive lighting strikes
var() float MaxLightningTime;
var() float MinLightningTime;

// Sounds 
// 0 - Closest.
// 10 - Furthest.
var() string ThunderSounds[10];

// Sounds are played are played relative to the delay.
var float SoundDelays[10];

// The time lightning strikes next.
var float TimeToNextLighning;

// The last time lightning struck
var float LastLightningTime;

// Next thunder/lightning characteristics.
var float ThunderDelay, HalfLightPct;

// If you want to use a precompiled light, 
// set this to match the Tag of that light.
// Warning: If two Lightning objects try to use
// the same light at the same time, bad things might happen.
// This will happen if your MinLightningTime is very close
// to zero, and if two seperate RandomLightning objects try to
// use the same light.
var() name LightTag;

// Used to carry Event to the clients.
var name TriggerEvent;

// Used so we turn off the light we are going to use on the first tick,
// after we already know it's been created.
var bool bTurnedOffLight;

// Set to False if you don't want this object to generate its
// own lightning objects.  This is usefull if you are going to 
// create your own Lightning objects and associate them via tags.
var() bool bSpawnsLightning;

var bool bInitalized;

var() bool bPreLoadSounds;

replication
{
	unreliable if( Role==ROLE_Authority )
		TimeToNextLighning, ThunderDelay, HalfLightPct;

	reliable if( Role==ROLE_Authority && bNetInitial )
		LightTag, bSpawnsLightning, TriggerEvent;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local int i;

	Super.PreBeginPlay();

	if( bPreLoadSounds )
	{
		for( i = 0; i < ArrayCount(ThunderSounds); i++ )
		{
			if( ThunderSounds[i] != "" )
			{
				DynamicLoadObject( ThunderSounds[i], class'Sound');
			}
		}
	}
}

//------------------------------------------------------------------------------
// This used to be a BeginPlay(), but Level.TimeSeconds is no longer valid
// for objects in levels until some time after BeginPlay().
//------------------------------------------------------------------------------
simulated function Initialize()
{
	local int NumSounds, i;
	
	// Calculate sound delays.
	for( NumSounds = 0; NumSounds < ArrayCount(ThunderSounds) && ThunderSounds[NumSounds] != ""; NumSounds++ );
	for( i = 0; i < NumSounds; i++ )
	{
		SoundDelays[i] = MinThunderDelay + (float(i+1) * (MaxThunderDelay - MinThunderDelay) / NumSounds);
	}

	CalcNextTimes();
	
	if( Role == ROLE_Authority )
	{
		TriggerEvent = Event;	// will replicate to client.
	}

	// Make sure we have a valid TriggerEvent.
	if( TriggerEvent == '' )
	{
		TriggerEvent = Name;
	}
	
	bInitalized = True;
}

//------------------------------------------------------------------------------
// Notice this is server-side only.
//------------------------------------------------------------------------------
function CalcNextTimes()
{
	// Initialize our first LightningTime.
	TimeToNextLighning = RandRange( MinLightningTime, MaxLightningTime );

	// Calculate the random variables in advance so they can be used for all 
	// triggered Lightning objects.
	ThunderDelay = RandRange( MinThunderDelay, MaxThunderDelay );
	HalfLightPct = RandRange( 0.1, 0.7 );
}

//------------------------------------------------------------------------------
// Spawn a new lightning object every LightningTime seconds.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local Lightning L;
	local int i;
	local Actor A;
	
	if( !bInitalized )
	{
		Initialize();
	}
	
	// Turn off our light if we are going to reuse one.
	if( !bTurnedOffLight && LightTag != '' )
	{
		foreach AllActors( class'Actor', A, LightTag )
		{
			A.LightType = LT_None;
			bTurnedOffLight = true;
			break;	// We only ever use the first one we find.
		}
	}
	
	if( Level.TimeSeconds >= LastLightningTime + TimeToNextLighning )
	{
		CalcNextTimes();
		LastLightningTime = Level.TimeSeconds;
		if( Role < ROLE_Authority )
		{
			TimeToNextLighning = MaxInt;	// Wait for server to replicate real number to us.
		}

		// Only spawn lightning if we are supposed to.
		if( bSpawnsLightning )
		{
			L = Spawn( class'Lightning' );
			L.LightTag = LightTag;
			L.Tag = TriggerEvent;
			L.Lifespan = ThunderDelay + 30.0;
		}
		
		// Find the sound that corresponds to our delay.
		for
		(	i = 0;
			i < ArrayCount(ThunderSounds) 
		&&	ThunderSounds[i] != ""
		&&	SoundDelays[i] < ThunderDelay; 
			i++ 
		);
		
		// Trigger all listening objects, 
		// including the Lightning object we just created.
		foreach AllActors( class'Actor', A, TriggerEvent )
		{
			if( Lightning(A) != None )
			{
				L = Lightning(A);
				L.ThunderSound = ThunderSounds[i];
				L.ThunderDelay = ThunderDelay;
				L.HalfLightPct = HalfLightPct;
			}
		
			A.Trigger( Self, Instigator );
		}
	}
}

defaultproperties
{
     MaxThunderDelay=3.000000
     MaxLightningTime=7.000000
     MinLightningTime=3.000000
     ThunderSounds(0)="Environment.Thunder9"
     ThunderSounds(1)="Environment.Thunder3"
     ThunderSounds(2)="Environment.Thunder10"
     ThunderSounds(3)="Environment.Thunder2"
     ThunderSounds(4)="Environment.Thunder4"
     ThunderSounds(5)="Environment.Thunder8"
     bSpawnsLightning=True
     bHidden=True
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     bAlwaysRelevant=True
}
