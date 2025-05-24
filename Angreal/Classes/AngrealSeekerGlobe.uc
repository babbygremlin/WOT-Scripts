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
    RemoteRole=0
    DrawType=1
    Style=3
    Texture=Texture'Seeker.SeekerGlobe.SG_A00'
    DrawScale=0.75
}
