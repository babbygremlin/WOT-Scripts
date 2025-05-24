//------------------------------------------------------------------------------
// DistantEyeLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class DistantEyeLeech expands Leech;

var() vector GlowFog;
var() float GlowScale;

var float InitFOV;

var() float FOV;

//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	local PlayerPawn P;

	P = PlayerPawn(NewHost);

	if( P != None )
	{
		//InitFOV = P.DesiredFOV;
		//P.DesiredFOV = FOV;
		InitFOV = P.FOVAngle;
		P.SetFOVAngle( FOV );
	}

	Super.AttachTo( NewHost );
		
	// If succeeded.
	if( Owner == NewHost )
	{
		P.ClientAdjustGlow( GlowScale, GlowFog );
	}
	else if( P != None )
	{
		//P.DesiredFOV = InitFOV;
		P.SetFOVAngle( InitFOV );
	}
}

//------------------------------------------------------------------------------
function Unattach()
{
	local PlayerPawn P;

	P = PlayerPawn(Owner);
	P.ClientAdjustGlow( -GlowScale, -GlowFog );
	Super.Unattach();
	//P.DesiredFOV = InitFOV;
	P.SetFOVAngle( InitFOV );
}

defaultproperties
{
     GlowFog=(X=281.250000,Y=421.875000,Z=140.625000)
     FOV=120.000000
}
