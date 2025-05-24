//------------------------------------------------------------------------------
// MashadarCrack.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
// How this class works:
//------------------------------------------------------------------------------
class MashadarCrack expands BloodDecal;

#exec TEXTURE IMPORT FILE=MODELS\MashadarCrack.PCX GROUP=MashCrack

var bool bAppeared;

//------------------------------------------------------------------------------
simulated function AttemptRegistration()
{
	// Don't register.
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local AppearEffect AE;

	if( !bAppeared )
	{
		bAppeared = true;

		bCollideWorld = false;
		SetCollisionSize( 20.0, 20.0 );

		AE = Spawn( class'AppearEffect' );
		AE.TopSprite = class'AngrealInvGuardian'.default.TopSparkle;
		AE.BottomSprite = class'AngrealInvGuardian'.default.BottomSparkle;
		AE.bFadeIn = false;
		AE.SetAppearActor( Self );
	}

	Super.Tick( DeltaTime );
}

defaultproperties
{
     BloodTextures(0)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(1)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(2)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(3)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(4)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(5)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(6)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(7)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(8)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(9)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(10)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(11)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(12)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(13)=Texture'WOTPawns.MashCrack.MashadarCrack'
     BloodTextures(14)=Texture'WOTPawns.MashCrack.MashadarCrack'
     GoreLevel=0
     RemoteRole=ROLE_SimulatedProxy
}
