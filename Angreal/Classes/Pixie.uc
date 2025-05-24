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
    MinRadius=-8.00
    MaxRadius=8.00
    RadiusShiftRate=30.00
    MinRotationRate=20.00
    MaxRotationRate=100.00
    RotationShiftRate=60.00
    MaxHeight=8.00
    MinHeight=-8.00
    HeightShiftRate=20.00
    ActorRotatorClass=Class'Pixie'
    Physics=5
    RemoteRole=0
    bFixedRotationDir=True
    RotationRate=(Pitch=15000,Yaw=10000,Roll=20000),
}
