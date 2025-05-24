//=============================================================================
// MashadarFocusPawn.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//=============================================================================

class MashadarFocusPawn expands Captain;

#exec MESH IMPORT MESH=MashDagger ANIVFILE=MODELS\MashDagger_a.3d DATAFILE=MODELS\MashDagger_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MashDagger X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=MashDagger SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JMashDagger1 FILE=MODELS\MashDagger1.PCX GROUP=Skins FLAGS=2 // Material #1
#exec MESHMAP NEW   MESHMAP=MashDagger MESH=MashDagger
#exec MESHMAP SCALE MESHMAP=MashDagger X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=MashDagger NUM=0 TEXTURE=JMashDagger1

#exec TEXTURE IMPORT FILE=Models\MashadarX.PCX GROUP=Effects

var int GuardID;			// The identification of our last order.

var MashadarGuide Tendril;	// The tendril we are acting as a focus pawn for.
var MashadarGuide ClosestMashadar;

//------------------------------------------------------------------------------
function InitPlayerReplicationInfo()
{
	Super.InitPlayerReplicationInfo();

	if( PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo.PlayerName = NameArticle $ "Mashadar tendril";
	}
}


//////////////////////////////
// Order handling functions //
//////////////////////////////

//------------------------------------------------------------------------------
function OnKillIntruder()
{
	Super.OnKillIntruder();
	UnGuard();
}

//------------------------------------------------------------------------------
function OnGuardLocation()
{
	Super.OnGuardLocation();
	GuardID = Tendril.GuardLocation( Location );
}

//------------------------------------------------------------------------------
function OnGuardSeal()
{
	Super.OnGuardSeal();
	if( GuardID != class'MashadarGuide'.default.GuardSealID )
	{
		GuardID = Tendril.GuardSeal();
	}
}

//------------------------------------------------------------------------------
function OnSoundAlarm()
{
	Super.OnSoundAlarm();
	UnGuard();
}

//------------------------------------------------------------------------------
function OnGetHelp()
{
	Super.OnGetHelp();
	UnGuard();
}

//------------------------------------------------------------------------------
// Undo any existing guarding orders and act as normal.
//------------------------------------------------------------------------------
function UnGuard()
{
	if( GuardID != class'MashadarFocusPawn'.default.GuardID )
	{
		Tendril.UnGuard( GuardID );
		GuardID = class'MashadarFocusPawn'.default.GuardID;
	}
}

//------------------------------------------------------------------------------
// How this class works:
//
// Note: The following has been OBE in favor of a simpler interface.
// + On Hide()		- Tell our Mashadar to retract.
// + On Deploy()	- Get the closest Mashadar and tell it to follow us.
//					- Fail if there is no Mashadar that is "close enough".
// + On EndEdit()	- Deploy our Mashadar.
//					- Retract our Mashadar.
//------------------------------------------------------------------------------


//////////////////////
// Editor Interface //
//////////////////////

//------------------------------------------------------------------------------
// Deploy our ClosestMashadar and tell it to retract.
// - Called when the server exits the CitadelEditor.
//------------------------------------------------------------------------------
function EndEditingResource()
{
	if( ClosestMashadar != None && ClosestMashadar.FocusPawn == Self )
	{
		ClosestMashadar.SetFocusPawn( None );
	}

	Hide();

	Super.EndEditingResource();
}

//------------------------------------------------------------------------------
simulated function BeginEditingResource( int PlacedByTeam )
{
	Super.BeginEditingResource( PlacedByTeam );
	
	Show();

	if( ClosestMashadar != None && ClosestMashadar.FocusPawn != Self )
	{
		ClosestMashadar.SetFocusPawn( Self );
	}
}

//------------------------------------------------------------------------------
// Called when the user left clicks to place us in the level.
//------------------------------------------------------------------------------
function bool ActivateResource( bool bChangeState )
{
	if( ClosestMashadar != None ) 
	{
		if( ClosestMashadar.FocusPawn != Self )
		{
			ClosestMashadar.SetFocusPawn( Self );
		}
		ClosestMashadar.Deploy();
	}

	return true;	// This return value has no specific meaning associated with it.
}

//------------------------------------------------------------------------------
// Called when the user right clicks to remove us from the level.
// 1) Undeploy our closest mashadar.
// 2) Tell it to retract.
//------------------------------------------------------------------------------
function bool RemoveResource()
{
	if( ClosestMashadar != None && ClosestMashadar.FocusPawn == Self )
	{
		UnGuard();
		ClosestMashadar.SetFocusPawn( None );
	}

	Super.RemoveResource();

	return true;	// This return value has no specific meaning associated with it.
}

//------------------------------------------------------------------------------
// 1) Trys to place the MashadarFocusPawn at the given position.  
// 2) Adjusts the position as needed.
// 3) Returns false if it simply cannot place it there.
// 4) Finds the closest MashadarGuide and tells it to follow our parent.
//------------------------------------------------------------------------------
function bool DeployResource( vector HitLocation, vector HitNormal )
{
	Super.DeployResource( HitLocation, HitNormal );

	// Find the closest MashadarGuide.
	ClosestMashadar = GetClosestMashadar( Location );

	return ClosestMashadar != None;
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
// Returns the MashadarGuide closest to the given Position that is not
// currently active or doing a full retract.
//------------------------------------------------------------------------------
function MashadarGuide GetClosestMashadar( vector Position )
{
	local MashadarGuide IterM, ClosestM;

	// NOTE[aleiby]: Factor out duplicate code?
	
	// As an optimization, if we already have a ClosestMashadar, only check 
	// for Mashadar that are closer.
	if( ClosestMashadar != None )
	{
		if( VSize( Position - ClosestMashadar.HidingPlace.Location ) < ClosestMashadar.SearchRadius )
		{
			ClosestM = ClosestMashadar;
		}
		foreach RadiusActors( class'MashadarGuide', IterM, VSize( Position - ClosestMashadar.HidingPlace.Location ) )
		{
			// Only check Mashadar that are not activated, can reach the given position,
			// are on our team, and are not in the midst of a full retract.
			if
			(	!IterM.bFullRetract
			//&&	IterM.Team == Team
			&&	!IterM.FollowingFocusPawn() 
			&&	VSize( Position - IterM.HidingPlace.Location ) < IterM.SearchRadius
			)
			{
				if( ClosestM == None )
				{
					ClosestM = IterM;
				}
				else if
				(	VSize( Position - IterM.HidingPlace.Location ) 
				<	VSize( Position - ClosestM.HidingPlace.Location ) 
				)
				{
					ClosestM = IterM;
				}
			}
		}
	}
	else
	{
		foreach AllActors( class'MashadarGuide', IterM )
		{
			// Only check Mashadar that are not activated, can reach the given position,
			// are on our team, and are not in the midst of a full retract.
			if
			(	!IterM.bFullRetract
			//&&	IterM.Team == Team
			&&	!IterM.FollowingFocusPawn() 
			&&	VSize( Position - IterM.HidingPlace.Location ) < IterM.SearchRadius
			)
			{
				if( ClosestM == None )
				{
					ClosestM = IterM;
				}
				else if
				(	VSize( Position - IterM.HidingPlace.Location ) 
				<	VSize( Position - ClosestM.HidingPlace.Location ) 
				)
				{
					ClosestM = IterM;
				}
			}
		}
	}

	return ClosestM;
}

defaultproperties
{
     GuardID=-1
     SoundTableClass=Class'WOTPawns.SoundTableMashadar'
     AnimationTableClass=Class'WOTPawns.AnimationTableMashFocusPawn'
     DurationNotifierClasses(3)=Class'Legend.DurationNotifier'
     InitialState=Dormant
     Texture=None
     Mesh=Mesh'WOTPawns.MashDagger'
     DrawScale=1.500000
     ScaleGlow=20.000000
     bAlwaysRelevant=True
     CollisionRadius=11.000000
     CollisionHeight=33.000000
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
