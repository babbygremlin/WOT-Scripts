//=============================================================================
// SoulBarbEffect.
//=============================================================================
class SoulBarbEffect expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\SB_A00.pcx GROUP=Effects

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

// end of SoulBarbEffect.

defaultproperties
{
    bAnimLoop=True
    AnimRate=0.05
    DrawType=1
    Style=3
    Texture=Texture'Effects.SB_A00'
    DrawScale=0.75
}
