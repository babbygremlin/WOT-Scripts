//------------------------------------------------------------------------------
// Lightning.uc
// $Author: Aleiby $
// $Date: 10/04/99 4:54a $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Look at Battle2_02.
//------------------------------------------------------------------------------
class Lightning expands Effects;

// Time between Lighting and Thunder.
var() float ThunderDelay;

// Time that the Lightning flashed.
var float LightningTime;

// Initial pulse light percentage.
// (Must be between 0.0 and 1.0)
var() float HalfLightPct;

// Change in brightness per second.
// (if this number is too small you will get too many round off errors)
var() float BrightnessPerSecond;

// Thunder sound to play.
var() string ThunderSound;

// Have we thundered yet?
var bool bThundered;

// If you want to use a precompiled light, 
// set this to match the Tag of that light.
var() name LightTag;

// Used to send tag to client.
var name TravelTag;

// Used so we turn off the light we are going to use on the first tick,
// after we already know it's been created.
var bool bTurnedOffLight;

// The light that matches our LightTag.  
// Assigned when Triggered.
// Defaults to Self.
var Actor LightningLight;

// Number of seconds to leave flickering on.
var() float LightningLength;

// Sound radius for the thunder.
var() float ThunderRadius;

// Don't do anything until we are ready.
var bool bReady;

replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		LightTag, TravelTag;
}

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	// Restrict value.
	HalfLightPct = FMin( 1.0, HalfLightPct );
	HalfLightPct = FMax( 0.0, HalfLightPct );

	// Send to client.
	if( Role == ROLE_Authority )
	{
		TravelTag = Tag;
	}

	Tag = TravelTag;
}

//------------------------------------------------------------------------------
// Call this after setting up a ThunderDelay to start the lighting.
//------------------------------------------------------------------------------
simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	local Actor A;
	
	// Trigger all listening actors.
	if( Event != '' )
	{
		foreach AllActors( class'Actor', A, Event )
		{
			A.Trigger( Other, EventInstigator );
		}
	}

	// Don't do anything until we are ready.
	if( !bReady )
		return;

	// Find our LightningLight.
	if( LightningLight == None )
	{
		LightningLight = Self;
	}
	
	bThundered = false;
	
	LightningTime = Level.TimeSeconds;
	
	if( LightTag == '' )
	{
		GotoState( 'Stage1' );
	}
	else
	{
		GotoState( 'AltStage1' );
	}
}

//------------------------------------------------------------------------------
// Check for thunder.  (server-only)
//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	local Sound TSound;

	if( !bThundered && Level.TimeSeconds >= LightningTime + ThunderDelay )
	{
		// NOTE[aleiby]: Adjust volume relational to HalfLightPct.
		TSound = Sound( DynamicLoadObject( ThunderSound, class'Sound') );
		PlaySound( TSound,,,,ThunderRadius );
		bThundered = True;
	}
}

//------------------------------------------------------------------------------
// Do nothing.  
// In particular don't call Global.Tick()
//------------------------------------------------------------------------------
auto simulated state Stage0
{
	simulated function BeginState()
	{
		// Start with no light.
		LightType = LT_None;
		LightBrightness = 0;
	}
	
	simulated function Tick( float DeltaTime )
	{
		local Actor A;

		// Turn off our light if we are going to reuse one.
		if( !bTurnedOffLight && LightTag != '' )
		{
			foreach AllActors( class'Actor', A, LightTag )
			{
				LightningLight = A;
				LightningLight.LightType = LT_None;
				bTurnedOffLight = true;
				bReady = true;
				break;	// We only ever use the first one we find.
			}
		}
		else
		{
			bReady = true;
		}

		Tag = TravelTag;
	}	
}

//------------------------------------------------------------------------------
// Light brightens to half light.
// Assumed: 
// + LightningLight.LightType == LT_None
// + LightningLight.LightBrightness == 0; 
//------------------------------------------------------------------------------
simulated state Stage1
{
	simulated function BeginState()
	{
		LightningLight.LightType = LightningLight.default.LightType;
	}
	
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		
		if
		(	float(LightningLight.LightBrightness) + (BrightnessPerSecond * DeltaTime) 
		>=	float(LightningLight.default.LightBrightness) * HalfLightPct 
		)
		{
			LightningLight.LightBrightness = LightningLight.default.LightBrightness * HalfLightPct;
			GotoState( 'Stage2' );
		}
		else
		{
			LightningLight.LightBrightness += BrightnessPerSecond * DeltaTime;
		}
	}
}

//------------------------------------------------------------------------------
// Light decays to near nothing.
//------------------------------------------------------------------------------
simulated state Stage2
{
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
			
		if
		(	float(LightningLight.LightBrightness) - (BrightnessPerSecond * DeltaTime)
		<=	0.0 
		)
		{
			LightningLight.LightBrightness = 0;
			GotoState( 'Stage3' );
		}
		else
		{
			LightningLight.LightBrightness -= BrightnessPerSecond * DeltaTime;
		}
	}
}

//------------------------------------------------------------------------------
// Light brightens to full light.
//------------------------------------------------------------------------------
simulated state Stage3
{
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
			
		if
		(	float(LightningLight.LightBrightness) + (BrightnessPerSecond * DeltaTime) 
		>=	float(LightningLight.default.LightBrightness)
		)
		{
			LightningLight.LightBrightness = LightningLight.default.LightBrightness;
			GotoState( 'Stage4' );
		}
		else
		{
			LightningLight.LightBrightness += BrightnessPerSecond * DeltaTime;
		}
	}
}

//------------------------------------------------------------------------------
// Light decays completely.
//------------------------------------------------------------------------------
simulated state Stage4
{
	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
			
		if
		(	float(LightningLight.LightBrightness) - (BrightnessPerSecond * DeltaTime)
		<=	0.0 
		)
		{
			LightningLight.LightBrightness = 0;
			LightningLight.LightType = LT_None;
			GotoState( '' );
		}
		else
		{
			LightningLight.LightBrightness -= BrightnessPerSecond * DeltaTime;
		}
	}
}

//////////////////////
// Alternate Stages //
//////////////////////

//------------------------------------------------------------------------------
simulated state AltStage1
{
begin:
	LightningLight.LightType = LT_Flicker;
	Sleep( LightningLength );
	GotoState( 'AltStage2' );
}

//------------------------------------------------------------------------------
simulated state AltStage2
{
begin:
	LightningLight.LightType = LT_None;
	GotoState( '' );
}

defaultproperties
{
     ThunderDelay=1.000000
     HalfLightPct=0.500000
     BrightnessPerSecond=2000.000000
     ThunderSound="Environment.Thunder10"
     LightningLength=0.500000
     ThunderRadius=5000.000000
     bHidden=True
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     bAlwaysRelevant=True
     LightType=LT_Steady
     LightBrightness=255
     LightSaturation=255
     LightRadius=255
}
