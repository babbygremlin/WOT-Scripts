//------------------------------------------------------------------------------
// AngrealSeekerGlobe.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealSeekerGlobe expands Effects;

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
     Texture=Texture'Angreal.Seeker.SeekerGlobe.SG_A00'
     DrawScale=0.750000
}
