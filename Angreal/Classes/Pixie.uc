//------------------------------------------------------------------------------
// Pixie.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Pixie expands ActorRotator;

//------------------------------------------------------------------------------
simulated function SetLightRadius( byte Radius )
{
	if( MyActor != None )
	{
		MyActor.LightRadius = Radius;
	}
}

//------------------------------------------------------------------------------
simulated function SetMyActor( Actor A )
{
	MyActor = A;
	Initialize();
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( MyActor != None )
	{
		if( ParticleSprayer(MyActor) != None )
		{
			ParticleSprayer(MyActor).bOn = false;
			MyActor.Lifespan = 2.0;
			MyActor.LightType = LT_None;
			MyActor.AmbientSound = None;
		}
		else
		{
			MyActor.Destroy();
		}
	}

	Super.Destroyed();
}

defaultproperties
{
     bUpdateActorRotation=False
     MinRadius=-8.000000
     MaxRadius=8.000000
     RadiusShiftRate=30.000000
     MinRotationRate=20.000000
     MaxRotationRate=100.000000
     RotationShiftRate=60.000000
     MaxHeight=8.000000
     MinHeight=-8.000000
     HeightShiftRate=20.000000
     ActorRotatorClass=Class'Angreal.Pixie'
     Physics=PHYS_Rotating
     RemoteRole=ROLE_None
     bFixedRotationDir=True
     RotationRate=(Pitch=15000,Yaw=10000,Roll=20000)
}
