//------------------------------------------------------------------------------
// LegionSpiritTail.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionSpiritTail expands Effects;

var ActorRotator Rot1, Rot2;
var GenericSprite S1, S2;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Rot1 == None )
	{
		if( S1 != None ) 
		{
			S1.Destroy();	// just in case.
		}

		S1 = Spawn( class'GenericSprite', Owner );
		S1.Texture = WetTexture'WOTPawns.Legion.wet3';
//		S1.RenderIteratorClass = class'Legend.MedMotionBlurRI';
		S1.DrawScale = 0.400000;
		S1.ScaleGlow = 0.090000;
		S1.Style = STY_Translucent;

		Rot1 = Spawn( class'ActorRotator', Owner );
		Rot1.bUpdateActorRotation = False;
		Rot1.MinRadius = -10.000000;
		Rot1.MaxRadius = 10.000000;
		Rot1.RadiusShiftRate = 5.000000;
		Rot1.MinRotationRate = 100000.000000;
		Rot1.MaxRotationRate = 150000.000000;
		Rot1.RotationShiftRate = 1000.000000;
		Rot1.HeightShiftRate = 1.000000;
		Rot1.MyActor = S1;
		Rot1.Initialize();
	}

	if( Rot2 == None )
	{
		if( S2 != None ) 
		{
			S2.Destroy();	// just in case.
		}

		S2 = Spawn( class'GenericSprite', Owner );
		S2.Style = STY_Translucent;
		S2.Texture = WetTexture'WOTPawns.Legion.wet4';
		S2.DrawScale = 0.650000;
		S2.ScaleGlow = 0.090000;
//		S2.RenderIteratorClass = class'Legend.MedMotionBlurRI';

		Rot2 = Spawn( class'ActorRotator', Owner );
		Rot2.bUpdateActorRotation = False;
		Rot2.MinRadius = -5.000000;
		Rot2.MaxRadius = 5.000000;
		Rot2.RadiusShiftRate = 16.000000;
		Rot2.MinRotationRate = 30000.000000;
		Rot2.MaxRotationRate = 80000.000000;
		Rot2.RotationShiftRate = 2000.000000;
		Rot2.MyActor = S2;
		Rot2.Initialize();
	}

	Rot1.SetLocation( Location );
	Rot1.SetRotation( Rotation );
	Rot2.SetLocation( Location );
	Rot2.SetRotation( Rotation );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Rot1 != None ) Rot1.Destroy();
	if( Rot2 != None ) Rot2.Destroy();
	if( S1 != None   ) S1.Destroy();
	if( S2 != None   ) S2.Destroy();
	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function SetVisibility( bool bHidden )
{
	S1.bHidden = bHidden;
	S2.bHidden = bHidden;
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
}
