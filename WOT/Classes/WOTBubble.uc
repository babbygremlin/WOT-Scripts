//=============================================================================
// WOTBubble.
//=============================================================================
class WOTBubble expands Effects;
    
#exec Texture Import File=models\bubble1.pcx Mips=Off Flags=2
#exec Texture Import File=models\bubble2.pcx Mips=Off Flags=2
#exec Texture Import File=models\bubble3.pcx Mips=Off Flags=2
#exec Texture Import File=models\bubble4.pcx Mips=Off Flags=2

//=============================================================================

simulated function ZoneChange( ZoneInfo NewZone )
{
	if ( !NewZone.bWaterZone ) 
	{
		Destroy();

		PlaySound( EffectSound1 );
	}	
}

//=============================================================================

simulated function BeginPlay()
{
	local float RandomFloat;

	Super.BeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlaySound( EffectSound2 ); //Spawned Sound

		LifeSpan = 3 + 4 * FRand();
		Buoyancy = Mass + FRand()+0.1;

		RandomFloat = FRand();

		if( RandomFloat < 0.25 ) 
		{
			Texture = texture'bubble2';
		}
		else if( RandomFloat < 0.50 ) 
		{
			Texture = texture'bubble3';
		}
		else if( RandomFloat < 0.75 ) 
		{
			Texture = texture'bubble4';
		}

		DrawScale += FRand()*DrawScale/2;
	}
}

//=============================================================================

defaultproperties
{
     bNetOptional=True
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'WOT.bubble1'
     Mass=3.000000
     Buoyancy=3.750000
}
