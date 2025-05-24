//------------------------------------------------------------------------------
// RandFOVLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Set AverageFOV to be the normal FOV.
// + Set FluxFOV to the amount of change in FOV.  Example: If you want your
//   FOV to fluxuate between 80 and 100, set AverageFOV to 90 and FluxFOV to 10.
// + Set FluxTime to the amount of time you want it to take to tween from one
//   FOV to the next.
// + Make AffectResolution smaller to get smoother transitions.
//------------------------------------------------------------------------------
class RandFOVLeech expands Leech;

var() float AverageFOV;
var() float FluxFOV;
var() float FluxTime;

var float DeltaFOV;		// Change in FOV per AffectHost() call.
var float ReCalcTime;	// When (time in second from start of game) we need to 
						// recalc DeltaFOV.
						
var float InitialFOV;	// Our host's FOV before we started mucking with it.

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	if( WOTPlayer(NewHost) != None && NewHost.bIsPlayer )
	{
		Super.AttachTo( NewHost );
		
		// If succeeded.
		if( Owner == NewHost )
		{
			InitialFOV = PlayerPawn(Owner).DesiredFOV;
			PlayerPawn(Owner).SetDesiredFOV( AverageFOV );
			ReCalcDeltaFOV();
		}
	}
}

//------------------------------------------------------------------------------
function Unattach()
{
	PlayerPawn(Owner).SetDesiredFOV( InitialFOV );
	Super.Unattach();
}

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( Level.TimeSeconds >= ReCalcTime )
	{
		ReCalcDeltaFOV();
	}
	
	PlayerPawn(Owner).SetDesiredFOV( PlayerPawn(Owner).DesiredFOV + DeltaFOV );
}

//------------------------------------------------------------------------------
function ReCalcDeltaFOV()
{
	ReCalcTime = Level.TimeSeconds + FluxTime;
	DeltaFOV = (RandRange( AverageFOV - FluxFOV, AverageFOV + FluxFOV ) - PlayerPawn(Owner).DesiredFOV) / (FluxTime / AffectResolution);
}

defaultproperties
{
     AverageFOV=110.000000
     FluxFOV=10.000000
     FluxTime=1.000000
     AffectResolution=0.050000
     bRemovable=False
}
