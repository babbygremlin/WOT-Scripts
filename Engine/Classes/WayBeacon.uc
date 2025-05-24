//=============================================================================
// WayBeacon.
//=============================================================================
class WayBeacon extends Keypoint;

//temporary beacon for serverfind navigation

function PostBeginPlay()
{
	local class<actor> NewClass;

	Super.PostBeginPlay();
	NewClass = class<actor>( DynamicLoadObject( "Unreali.Lamp4", class'Class' ) );
	if( NewClass!=None )
		Mesh = NewClass.Default.Mesh;
}

function touch(actor other)
{
	if (other == owner)
	{
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(owner).ShowPath();
		Destroy();
	}
}

defaultproperties
{
    bStatic=False
    bHidden=False
    RemoteRole=0
    LifeSpan=6.00
    DrawType=2
    DrawScale=0.50
    AmbientGlow=40
    bOnlyOwnerSee=True
    bCollideActors=True
    LightType=1
    LightBrightness=125
    LightSaturation=125
}
