//------------------------------------------------------------------------------
// LegionSpirit.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionSpirit expands ActorRotator;

#exec OBJ LOAD FILE=Textures\LegionSpiritT.utx PACKAGE=WOTPawns.Legion

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	// -- Dont call Super.BeginPlay();
	MyActor = Spawn( class'LegionSpiritHead', Owner );
	Initialize();
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( MyActor != None )
	{
		MyActor.Destroy();
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
// If you want these values to take effect right away, you need to call
// Initialize() afterward.  This will cause a visual jump, but if you 
// are calling this function in the same Tick that this object was created,
// you won't notice the jump.  If you don't call Initialize(), the new values
// will be tweened to nice and smoothly (as long as your shift rates are set).
//------------------------------------------------------------------------------
simulated function SetSize( float Radius, float Height )
{
	MaxRadius = Radius + 20;
	MinRadius = Radius - 20;
	MaxHeight = Height;
	MinHeight = -Height;
}

//------------------------------------------------------------------------------
simulated function SetVisibility( bool bHidden )
{
	LegionSpiritHead(MyActor).SetVisibility( bHidden );
}

defaultproperties
{
     MinRadius=40.000000
     MaxRadius=80.000000
     RadiusShiftRate=11.000000
     MinRotationRate=10000.000000
     MaxRotationRate=18000.000000
     RotationShiftRate=3000.000000
     MaxHeight=90.000000
     MinHeight=-90.000000
     HeightShiftRate=40.000000
     ActorRotatorClass=Class'WOTPawns.LegionSpirit'
}
