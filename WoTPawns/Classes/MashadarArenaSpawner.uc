//------------------------------------------------------------------------------
// MashadarArenaSpawner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MashadarArenaSpawner expands Effects;

var() float TraceDist;

//------------------------------------------------------------------------------
function PreBeginPlay()
{
	local AngrealInvGuardian SourceAngreal;
	local vector Offset;
	local vector HitLocation, HitNormal;
	local Actor HitActor;
	local Decal Crack;
	local MashadarGuide Mash;
	
	Super.PreBeginPlay();

	SourceAngreal = AngrealInvGuardian(Owner);
	if( SourceAngreal == None )
	{
		warn( "Owner is not an AngrealInvGuardian... aborting." );
		return;
	}

	Offset = Normal(vector(SourceAngreal.Owner.Rotation)) * (SourceAngreal.Owner.CollisionRadius + (TraceDist/2) + SourceAngreal.SpawnSeparation);

	// Trace out.
	HitActor = class'Util'.static.TraceRecursive( SourceAngreal.Owner, HitLocation, HitNormal, SourceAngreal.Owner.Location,,, vector(SourceAngreal.Owner.Rotation), TraceDist );
	if( HitActor == None )	// Didn't hit any geometry.
	{
		// Trace down.
		class'Util'.static.TraceRecursive( SourceAngreal.Owner, HitLocation, HitNormal, SourceAngreal.Owner.Location + Offset );
	}

	Crack = Spawn( class'MashadarCrack',,, HitLocation + HitNormal );
	if( Crack != None )
	{
		Crack.Align( HitNormal );
	}

	if( Crack != None && !Crack.bDeleteMe )
	{
		Mash = Spawn( class'MashadarGuide', SourceAngreal.Owner, 'AngrealSpawned', HitLocation + HitNormal, rotator(HitNormal) );

		// Set default props.
		Mash.Team = Pawn(SourceAngreal.Owner).PlayerReplicationInfo.Team;
		Mash.SearchRadius = 1000.0;
		Mash.TriggerRadius = Mash.SearchRadius;

		// Adjust speed.
		Mash.Speed = 200.0;
		Mash.MaxSpeed = 300.0;
		Mash.Acceleration = 15.0;
		Mash.MPSpeed = Mash.Speed;
		Mash.MPAccel = Mash.Acceleration;

		Mash.Initialize();
		
		// Give it its own manager.
		Mash.Manager = Spawn( class'MashadarManager' );
		//assert(Mash.Manager!=None);
		if( Mash.Manager != None )
		{
			Mash.Manager.Team = Mash.Team;
			Mash.Manager.ArenaMashadarPawnInterface = Spawn( class'MashadarFocusPawn', SourceAngreal.Owner, 'AngrealSpawned', HitLocation + (HitNormal*30.0) );
			//assert(Mash.Manager.ArenaMashadarPawnInterface!=None);
			if( Mash.Manager.ArenaMashadarPawnInterface != None )
			{
				Mash.Manager.ArenaMashadarPawnInterface.Hide();
				Mash.Manager.ArenaMashadarPawnInterface.PlayerReplicationInfo.Team = Mash.Team;
				Mash.Manager.ArenaMashadarPawnInterface.PlayerReplicationInfo.PlayerName = Pawn(SourceAngreal.Owner).PlayerReplicationInfo.PlayerName $ "'s " $ "Mashadar tendril";
				
				Mash.Deploy();

				SourceAngreal.SuperCast();
				SourceAngreal.UseCharge();
			}
			else
			{
				Mash.Manager.Destroy();
				Mash.Destroy();
				SourceAngreal.Failed();
			}
		}
		else
		{
			Mash.Destroy();
			SourceAngreal.Failed();
		}
	}
	else
	{
		SourceAngreal.Failed();
	}
}

defaultproperties
{
     TraceDist=100.000000
     bHidden=True
     RemoteRole=ROLE_None
     DrawType=DT_Sprite
}
