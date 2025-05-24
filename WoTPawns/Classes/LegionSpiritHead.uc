//------------------------------------------------------------------------------
// LegionSpiritHead.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionSpiritHead expands Effects;

#exec MESH IMPORT MESH=LegionSpiritHead ANIVFILE=MODELS\LegionSpiritHead_a.3d DATAFILE=MODELS\LegionSpiritHead_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LegionSpiritHead X=-120 Y=0 Z=0

#exec MESH SEQUENCE MESH=LegionSpiritHead SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JLegionSpiritHead1 FILE=MODELS\LegionSpiritHead1.PCX GROUP=Skins FLAGS=2 // bigpart01

#exec MESHMAP LegionSpiritHead   MESHMAP=LegionSpiritHead MESH=LegionSpiritHead
#exec MESHMAP SCALE MESHMAP=LegionSpiritHead X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LegionSpiritHead NUM=1 TEXTURE=JLegionSpiritHead1

var LegionSpiritTail Tail;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Tail == None ) 
	{
		Tail = Spawn( class'LegionSpiritTail', Owner );
	}

	Tail.SetLocation( Location );
	Tail.SetRotation( Rotation );

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Tail != None ) 
	{
		Tail.Destroy();
	}
	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function SetVisibility( bool bHidden )
{
	Self.bHidden = bHidden;
	Tail.SetVisibility( bHidden );
}

//     AmbientGlow=222

defaultproperties
{
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=Mesh'WOTPawns.LegionSpiritHead'
     DrawScale=0.700000
     ScaleGlow=2.000000
     bUnlit=True
}
