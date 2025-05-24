//=============================================================================
// WOTCarcassLegion.
//=============================================================================

class WOTCarcassLegion expands WOTCarcass;

//=============================================================================

var()	float		SinkRatePerSec;					// rate at which carcass sinks into ground
var		bool		bSinking;						// once set to true, carcass will disapper into the ground
var		bool		bDoneSinking;
var		float		TotalSinkDistance;

//=============================================================================

function Tick( float DeltaTime )
{
	local vector NewLocation;
	local float AmountToSink;

	Super.Tick( DeltaTime );

	if( bSinking )
	{
		// sink into floor:
		NewLocation = Location;

		AmountToSink = DeltaTime*SinkRatePerSec;

		NewLocation.Z -= AmountToSink;

		SetLocation( NewLocation );

		TotalSinkDistance += AmountToSink;

		if( TotalSinkDistance > 3.5*CollisionHeight )
		{
			bDoneSinking = true;
			Destroy();
		}
	}
}

//=============================================================================

function StartSinking()
{
	local vector CCOffset;

	SetPhysics( Phys_None );
	SetCollision( false, false, false );
	bCollideWorld = false;
	bProjTarget = false;
	
   	// Shift the collision cylinder way up so center of gibs won't sink out
   	// of sight before the mesh (engine makes these bUnlit otherwise). This
   	// seems to be the easiest way to fix this problem -- can't find another
   	// (real problem is that Actor->Region.iLeaf becomes INDEX_NONE in SetupForActor).
   	CCOffset.x = 0;
   	CCOffset.y = 0;
   	CCOffset.z = 4*CollisionHeight;
   	class'Util'.static.ShiftCollisionCylinder( Self, CCOffset );

	SinkRatePerSec = class'util'.static.PerturbFloatPercent( default.SinkRatePerSec, 50.0 );
	bSinking = true;
}

//=============================================================================

function BaseChange()
{
	if( !bDoneSinking )
	{
		TotalSinkDistance = 0.0;
		Super.BaseChange();
	}
}

//=============================================================================

function Landed( vector HitNormal )
{
	Super.Landed( HitNormal );

	if( SinkRatePerSec > 0.0 )
	{
		StartSinking();
	}
}

//=============================================================================
// no chest, armbone

defaultproperties
{
     SinkRatePerSec=3.000000
     BodyParts(2)=(MeshName="",Odds=1.000000)
     BodyParts(5)=(MeshName="")
     BodyParts(8)=(MeshName="WOT.ChunkA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     BodyParts(9)=(MeshName="WOT.ChunkA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     BodyParts(12)=(MeshName="WOT.OrganA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     BodyParts(13)=(MeshName="WOT.OrganA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     AnimationTableClass=Class'WOTPawns.AnimationTableLegion'
     GibForSureCummulativeDamage=120.000000
     AnimSequence=DEATHL
     Mesh=LodMesh'WOTPawns.Legion'
     DrawScale=2.500000
     MultiSkins(1)=Texture'WOTPawns.Skins.Jlegion1'
     MultiSkins(2)=Texture'WOTPawns.Skins.Jlegion2'
     MultiSkins(3)=Texture'WOTPawns.Skins.Jlegion3'
     MultiSkins(4)=Texture'WOTPawns.Skins.Jlegion4'
     MultiSkins(5)=Texture'WOTPawns.Skins.Jlegion5'
     AmbientSound=Sound'WOTPawns.Leg_Ambient'
     CollisionRadius=100.000000
     CollisionHeight=110.000000
}
