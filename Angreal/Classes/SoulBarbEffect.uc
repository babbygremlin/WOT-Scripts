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
     AnimRate=0.050000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Angreal.Effects.SB_A00'
     DrawScale=0.750000
}
