//=============================================================================
// FakeCorona.
//=============================================================================
class FakeCorona expands Effects;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( Owner != None && Base == None )
	{
		SetLocation( Owner.Location );
		SetBase( Owner );
	}
}

defaultproperties
{
    bCanTeleport=True
    RemoteRole=0
    DrawType=1
    Style=3
    Texture=None
    DrawScale=0.50
    ScaleGlow=0.30
}
