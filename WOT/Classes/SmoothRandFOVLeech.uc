//------------------------------------------------------------------------------
// SmoothRandFOVLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Set FluxFOV to the amount of change in FOV.  This will fluxuate your FOV
//   within +/- FluxFOV of your current FOV.
// + Set FOVRate to the number of degrees FOV changes per second.
//------------------------------------------------------------------------------
class SmoothRandFOVLeech expands Leech;

// NOTE[aleiby]: Make client-side only.

var() float FluxFOV;
var() float FOVRate;
						
var float InitialFOV;	// Our host's FOV before we started mucking with it.

var float NextFOV;		// Our next desired FOV;
var bool bGrowing;		// Is our FOV getting larger or smaller?

//------------------------------------------------------------------------------
simulated function AttachTo( Pawn NewHost )
{
	if( WOTPlayer(NewHost) != None && NewHost.bIsPlayer )
	{
		Super.AttachTo( NewHost );
		
		// If succeeded.
		if( Owner == NewHost )
		{
			InitialFOV = PlayerPawn(Owner).DesiredFOV;
			SetNextFOV();
		}
	}
}

//------------------------------------------------------------------------------
simulated function Unattach()
{
	SetDesiredFOV( PlayerPawn(Owner), InitialFOV );
	Super.Unattach();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Owner != None )
	{
		if( bGrowing )
		{
			SetDesiredFOV( PlayerPawn(Owner), PlayerPawn(Owner).DesiredFOV + FOVRate * DeltaTime );
			if( PlayerPawn(Owner).DesiredFOV >= NextFOV )
			{
				SetNextFOV();
			}
		}
		else
		{
			SetDesiredFOV( PlayerPawn(Owner), PlayerPawn(Owner).DesiredFOV - FOVRate * DeltaTime );
			if( PlayerPawn(Owner).DesiredFOV <= NextFOV )
			{
				SetNextFOV();
			}
		}
	}
	else
	{
		// If our owner gets destroyed (like when a client leaves the game) we are no longer needed.
		// Note: Make sure you AttachTo() in the same tick that you Spawn() one of these sucker in
		// or else it will destroy itself when it finds it doesn't yet have an Owner.
		Destroy();
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function SetNextFOV()
{
	NextFOV = RandRange( InitialFOV - FluxFOV, InitialFOV + FluxFOV );
	bGrowing = NextFOV > PlayerPawn(Owner).DesiredFOV;
}

//------------------------------------------------------------------------------
// SetDesiredFOV() ripped from PlayerPawn, but without the safety check.
//------------------------------------------------------------------------------
simulated function SetDesiredFOV( PlayerPawn P, float F )
{
	P.DefaultFOV = FClamp(F, 1, 170);
	P.DesiredFOV = P.DefaultFOV;
}

defaultproperties
{
     FluxFOV=3.000000
     FOVRate=1.000000
     bRemovable=False
     RemoteRole=ROLE_SimulatedProxy
}
