//=============================================================================
// EarthquakeTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
//=============================================================================
class EarthquakeTrigger expands Trigger;

var() float Duration;				// how long quake should last
var() float BaseRollMagnitude;		// roll Magnitudenitude at epicenter, 0 at radius
var() float BaseVertMagnitude;		// vertical Magnitudenitude at epicenter, 0 at radius
var() float BaseTossMagnitude;		// toss Magnitudenitude at epicenter, 0 at radius
var() float Radius;					// radius of quake
var() bool	bTossNPCs;				// if true, NPCs in area are tossed around
var() bool	bTossPCs;				// if true, PCs in area are tossed around
var() float	MaxTossedMass;			// if bTossPawns true, only pawns <= this mass are tossed
var() float	TimeBetweenShakes;		// time between each shake
var() string AmbientSoundStr;		// sound for duration of quake
var() string ShakeSoundStr;			// sound for each shake

var float TimeRemaining;

state() Waiting
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		Instigator = EventInstigator;

		TimeRemaining = Duration;
		SetTimer( TimeBetweenShakes, false );

		if( AmbientSoundStr != "" )
		{
			AmbientSound = Sound( DynamicLoadObject( AmbientSoundStr, class'Sound') );
		}
					
		Disable( 'Trigger' );
		Disable( 'Touch' );
	}

	function ShakePawn( Pawn P )
	{
		local float DistanceToEpicenter;
  		local float ScaleFactor;
		local vector Momentum;
  		
		DistanceToEpicenter	= VSize( Location - P.Location );
		ScaleFactor = (Radius-DistanceToEpicenter) / Radius;
		
		if(	PlayerPawn(P) != None )
		{
			// shake player's view depending on distance to epicenter
			PlayerPawn(P).ShakeView( TimeBetweenShakes, 
									 ScaleFactor* BaseRollMagnitude,
									 ScaleFactor* BaseVertMagnitude );
		}

		if( P.Mass <= MaxTossedMass && 
			P.Physics == PHYS_Walking &&
			( (PlayerPawn(P) != None && bTossPCs) ||
			  (PlayerPawn(P) == None && bTossNPCs) ) )
			{
				Momentum = -0.5 * P.Velocity + 100 * VRand();
				Momentum.Z = BaseTossMagnitude/((0.4 * DistanceToEpiCenter + 350) * P.Mass);
				Momentum.Z *= 5.0;

				P.AddVelocity( Momentum );
			}
	}

	function Timer()
	{
		local Pawn P;

		TimeRemaining -= TimeBetweenShakes;
				
		if ( TimeRemaining > TimeBetweenShakes )
		{
			SetTimer( TimeBetweenShakes, false );
			
			if( ShakeSoundStr != "" )
			{
				PlaySound( Sound( DynamicLoadObject( ShakeSoundStr, class'Sound') ), SLOT_Misc );
			}
		  		
			// shake/toss all pawns in the area every 0.5 seconds until quake over
			ForEach RadiusActors( class 'Pawn', P, Radius )
			{
				ShakePawn( P );
			}
		}
		else
		{
			AmbientSound = None;
			Enable( 'Trigger' );
			Enable( 'Touch' );
		}
	}	
}

defaultproperties
{
     Duration=10.000000
     BaseRollMagnitude=2000.000000
     BaseTossMagnitude=2500000.000000
     Radius=2048.000000
     bTossNPCs=True
     bTossPCs=True
     MaxTossedMass=500.000000
     TimeBetweenShakes=0.500000
     InitialState=Waiting
}
