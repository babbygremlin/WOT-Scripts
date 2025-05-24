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
     RemoteRole=ROLE_None
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=None
     DrawScale=0.500000
     ScaleGlow=0.300000
}
