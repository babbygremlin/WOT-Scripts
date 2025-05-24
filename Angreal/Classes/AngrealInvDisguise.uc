//------------------------------------------------------------------------------
// AngrealInvDisguise.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 16 $
//
// Description:	Player takes on the form of the nearest creature-including other 
//				players--for a short time.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvDisguise expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealDisguisePickup ANIVFILE=MODELS\AngrealDisguise_a.3D DATAFILE=MODELS\AngrealDisguise_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealDisguisePickup X=0 Y=0 Z=0 YAW=64 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealDisguisePickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealDisguisePickupTex FILE=MODELS\AngrealDisguise.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealDisguisePickup MESH=AngrealDisguisePickup
#exec MESHMAP SCALE      MESHMAP=AngrealDisguisePickup X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AngrealDisguisePickup NUM=7 TEXTURE=AngrealDisguisePickupTex

#exec AUDIO IMPORT FILE=Sounds\Disguise\ActivateDG.wav		Group=Disguise
#exec AUDIO IMPORT FILE=Sounds\Disguise\DeActivateDG.wav	Group=Disguise

#exec TEXTURE IMPORT FILE=Icons\I_Disguise.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Disguise.pcx         GROUP=Icons MIPS=Off

const MinPlayerIDVersion = 333;

var float ChargeTimer;	// Used to keep track of using charges while casting.

struct TPreDisguiseData
{
	// display
	var float DrawScale;
	var Mesh Mesh;
	var Texture MultiSkins[8];
	var ERenderStyle Style;
	var byte AmbientGlow;
	var byte Visibility;

	// collision
	var float CollisionHeight;
	var float CollisionRadius;

	// misc
	var float BaseEyeHeight;
	var float FOVAngle;

	// physics messed with in SP only
	var float AccelRate;   
	var float AirSpeed;
	var float Buoyancy;
	var float GroundSpeed;
	var float JumpZ;
	var float Mass;
	var float MaxStepHeight;
	var rotator RotationRate;
	var float WaterSpeed;

	// WOT
	var class<AnimationTableWOT> AnimationTableClass;
	var	class<Pawn> ApparentClass;
	var	int ApparentTeam;
};

var TPreDisguiseData SavedSettings;

var bool bCasting;

//var() float RoundsPerMinute;

//////////////////////////
// Engine Notifications //
//////////////////////////

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( bCasting )
	{
		ChargeTimer -= DeltaTime;
		while( ChargeTimer < 0.0 )
		{
			ChargeTimer += (60.0 / RoundsPerMinute);
			UseCharge();
		}
	}
}

//------------------------------------------------------------------------------
function GoEmpty()
{
	UnCast();
	Super.GoEmpty();
}

//////////////////////////
// Overridden functions //
//////////////////////////

//------------------------------------------------------------------------------
function Cast()
{
	local Pawn LookLikeMe;
	local AppearEffect AE;

	if( WOTPlayer(Owner) != None )
	{
		LookLikeMe = GetClosestPawn();

		if( LookLikeMe != None )
		{
			bCasting = true;
			Super.Cast();
			AcquireAppearance( Pawn(Owner), LookLikeMe );
			
			AE = Spawn( class'AppearEffect' );
			AE.SetColors( WOTPlayer(Owner).PlayerColor );
			AE.bFadeIn = false;
			AE.SetAppearActor( Owner );
		}
		else
		{
			Failed();
		}
	}
	else
	{
		warn( "Only WOTPlayers are allowed to use Disguise." );
	}
	
}

//------------------------------------------------------------------------------
function UnCast()
{
	if( bCasting )
	{
		bCasting = False;
		RevertAppearance( Pawn(Owner) );
		Super.UnCast();
	}
}

//////////////////////
// Helper Functions //
//////////////////////

//------------------------------------------------------------------------------
function Pawn GetClosestPawn()
{
	local Pawn ClosestPawn, IterPawn;

	foreach AllActors( class'Pawn', IterPawn )
	{
		if( IterPawn != Owner && IterPawn.Health > 0 && !IterPawn.IsA( 'NavigationProxyPawn' ) && !IterPawn.IsA( 'MashadarFocusPawn' ) )
		{
			if( ClosestPawn == None )
			{
				ClosestPawn = IterPawn;
			}
			else if( VSize( Owner.Location - IterPawn.Location ) <
					 VSize( Owner.Location - ClosestPawn.Location ) )
			{
				ClosestPawn = IterPawn;
			}
		}
	}

	return ClosestPawn;
}

//------------------------------------------------------------------------------
// Make DisguisingPawn look like DisguiseSource (also inherits FOV, collision
// height and a few other properties).
//------------------------------------------------------------------------------
function AcquireAppearance( Pawn DisguisingPawn, Pawn DisguiseSource )
{
	if( WOTPlayer( DisguisingPawn ) != None )
	{
		SaveDisguisePawnProperties( SavedSettings, DisguisingPawn );

		if( !CopyDisguisePawnProperties( DisguisingPawn, DisguiseSource ) )
		{
			RevertAppearance( DisguisingPawn );
			Failed();
		}
	}
}

//------------------------------------------------------------------------------
// Restore DisguisingPawn's appearance to look like it did previoulsy and 
// restore any other properties that were changed.
//------------------------------------------------------------------------------
function RevertAppearance( Pawn DisguisingPawn )
{
	RestoreDisguisePawnProperties( DisguisingPawn, SavedSettings );
}

//------------------------------------------------------------------------------
// Assumes that A is currently sitting on the ground.
//------------------------------------------------------------------------------
function bool AdjustToNewCollisionHeight( Actor A, float OldCollisionHeight, float NewCollisionHeight )
{
	local vector NewLocation;
	local bool bActorFits;

	NewLocation = A.Location;
	NewLocation.Z = NewLocation.Z + (NewCollisionHeight - OldCollisionHeight); 


	bActorFits = class'Util'.static.ActorFits( A, NewLocation, 1024 );

	if( bActorFits )
	{	
		A.SetLocation( NewLocation );
	}

	return bActorFits;
}

//------------------------------------------------------------------------------
// Make a backup of the Source Pawn's properties which could be changed when
// disguised so we can restore these later. In theory, the Source Pawn can not
// be disguised at this point.
//------------------------------------------------------------------------------
function SaveDisguisePawnProperties( out TPreDisguiseData Dest, Pawn Source )
{
	local WOTPlayer SourcePlayer;
	local int i;

	Dest.DrawScale			= Source.DrawScale;
	Dest.Mesh				= Source.Mesh;

	for( i=0; i<ArrayCount(MultiSkins); i++ )
	{
		Dest.MultiSkins[i]	= Source.MultiSkins[i];
    }

	Dest.AmbientGlow		= Source.AmbientGlow;
	Dest.Style				= Source.Style;
	Dest.Visibility			= Source.Visibility;

	Dest.CollisionHeight	= Source.CollisionHeight; 
	Dest.CollisionRadius	= Source.CollisionRadius; 

	Dest.BaseEyeHeight		= Source.BaseEyeHeight;
	Dest.FOVAngle			= Source.default.FOVAngle;	// must save default or could pick up intermediate value

	if( Level.Netmode == NM_Standalone )
	{
		Dest.AccelRate			= Source.AccelRate;
		Dest.AirSpeed			= Source.AirSpeed;     
		Dest.GroundSpeed		= Source.GroundSpeed;  
		Dest.WaterSpeed			= Source.WaterSpeed;   
		Dest.Buoyancy			= Source.Buoyancy;     
		Dest.JumpZ				= Source.JumpZ;        
		Dest.Mass				= Source.Mass;         
		Dest.MaxStepHeight		= Source.MaxStepHeight;
		Dest.RotationRate		= Source.RotationRate; 
	}

	if( Source.IsA( 'WOTPlayer' ) )
	{
		SourcePlayer = WOTPlayer( Source );

		Dest.ApparentClass			= SourcePlayer.ApparentClass;
		Dest.ApparentTeam			= SourcePlayer.ApparentTeam;
		Dest.AnimationTableClass	= SourcePlayer.AnimationTableClass;
	}
	else
	{
		warn( "SaveDisguisePawnProperties: disguised NPCs not supported!" );
	}
}

//------------------------------------------------------------------------------
// Copy disguise properties from Source to Dest. Takes the current values of
// the Source, not defaults in most cases (e.g. if you disguise yourself as a
// faded warder, you will be faded too). If you disguise yourself as someone who
// is disguised themselves, you will take their current mesh etc.
//------------------------------------------------------------------------------
function bool CopyDisguisePawnProperties( Pawn Dest, Pawn Source )
{
	local WOTPlayer DestPlayer;
	local WOTPlayer SourcePlayer;
	local WOTPawn SourcePawn;
	local float SavedCollisionHeight;
	local int i;

	Dest.DrawScale			= Source.DrawScale;
	Dest.Mesh				= Source.Mesh;

/* disabled for now -- native replication crashes server when trying to replicate to unpatched clients?	
	// Player ID support. 
	// xxxrlo: need to change for bot support (if they use disguise)
//	if( PlayerPawn(Dest).Player.ClientEngineVersion >= MinPlayerIDVersion )
//	{
		if( Source.bIsPlayer )
		{
			Dest.PlayerReplicationInfo.DisguiseName = Source.PlayerReplicationInfo.PlayerName;
		}
		else
		{
			Dest.PlayerReplicationInfo.DisguiseName = " ";
		}
//	}
*/

	// have to set collision size before changing Z location or SetLocation might fail
	SavedCollisionHeight = Dest.CollisionHeight;
	Dest.SetCollisionSize( Source.CollisionRadius, Source.CollisionHeight );
	
	// move player's location up/down so feet are on ground with new mesh
	if( !AdjustToNewCollisionHeight( Dest, SavedCollisionHeight, Source.CollisionHeight ) )
	{
		// disguised pawn won't fit -- abort
		return false;
	}

	for( i=0; i<ArrayCount(MultiSkins); i++ )
	{
		Dest.MultiSkins[i]	= Source.MultiSkins[i];
	}					  

	Dest.AmbientGlow		= Source.AmbientGlow;
	Dest.Style				= Source.Style;
	Dest.Visibility			= Source.Visibility;

	Dest.BaseEyeHeight		= Source.BaseEyeHeight;

	if( PlayerPawn( Dest ) != None )
	{
		PlayerPawn( Dest ).DefaultFOV = Source.FOVAngle;
		PlayerPawn( Dest ).DesiredFOV = Source.FOVAngle;
	}

	if( Level.Netmode == NM_Standalone )
	{
		Dest.AccelRate			= Source.AccelRate;    
		Dest.AirSpeed			= Source.AirSpeed;     
		Dest.Buoyancy			= Source.Buoyancy;     
		Dest.GroundSpeed		= Source.GroundSpeed;  
		Dest.JumpZ				= Source.JumpZ;        
		Dest.Mass				= Source.Mass;         
		Dest.MaxStepHeight		= Source.MaxStepHeight;
	
		// only copy pitch setting -- others cause too much banking?
		Dest.RotationRate.Pitch		= Source.RotationRate.Pitch; 
		Dest.WaterSpeed			= Source.WaterSpeed;   
	}

	if( Dest.IsA( 'WOTPlayer' ) )
	{
		DestPlayer = WOTPlayer( Dest );

		if( Source.IsA( 'WOTPlayer' ) )
		{
			SourcePlayer = WOTPlayer( Source );

			DestPlayer.ApparentClass		= SourcePlayer.ApparentClass;
			DestPlayer.ApparentTeam			= SourcePlayer.GetApparentTeam();
			DestPlayer.AnimationTableClass	= SourcePlayer.AnimationTableClass;
			DestPlayer.ApparentIcon			= SourcePlayer.GetDisguiseIcon();
		}
		else if( Source.IsA( 'WOTPawn' ) )
		{
			SourcePawn = WOTPawn( Source );

			DestPlayer.ApparentClass		= SourcePawn.Class;
			DestPlayer.ApparentTeam			= SourcePawn.PlayerReplicationInfo.Team;
			DestPlayer.AnimationTableClass	= SourcePawn.AnimationTableClass;
			DestPlayer.ApparentIcon			= SourcePawn.DisguiseIcon;
		}
	}
	else
	{
		warn( "CopyDisguisePawnProperties: disguised NPCs not supported!" );
	}

	return true;
}

//------------------------------------------------------------------------------
// Copy backed up properties back to the Dest Pawn so it is no longer disgused.
//------------------------------------------------------------------------------
function RestoreDisguisePawnProperties( Pawn Dest, TPreDisguiseData Source )
{
	local WOTPlayer DestPlayer;
	local float SavedCollisionHeight;
	local int i;

	Dest.DrawScale			= Source.DrawScale;
	Dest.Mesh				= Source.Mesh;

/* disabled for now -- native replication crashes server when trying to replicate to unpatched clients?	
	// Player ID support
	// xxxrlo: need to change for bot support (if they use disguise)
//	if( PlayerPawn(Dest).Player.ClientEngineVersion >= MinPlayerIDVersion )
//	{
		Dest.PlayerReplicationInfo.DisguiseName = "";
//	}
*/

	for( i=0; i<ArrayCount(MultiSkins); i++ )
	{
		Dest.MultiSkins[i]	= Source.MultiSkins[i];
	}

	Dest.AmbientGlow		= Source.AmbientGlow;
	Dest.Style				= Source.Style;
	Dest.Visibility			= Source.Visibility;
	
	// have to set collision size before changing Z location or SetLocation might fail
	SavedCollisionHeight = Dest.CollisionHeight;
	Dest.SetCollisionSize( Source.CollisionRadius, Source.CollisionHeight );

	// move player's location up/down so feet are on ground with new mesh (might fail in rare cases if can't fit -- so what)
	AdjustToNewCollisionHeight( Dest, SavedCollisionHeight, Source.CollisionHeight );
	
	Dest.BaseEyeHeight		= Source.BaseEyeHeight;

	if( PlayerPawn( Dest ) != None )
	{
		PlayerPawn( Dest ).DefaultFOV = Source.FOVAngle;
		PlayerPawn( Dest ).DesiredFOV = Source.FOVAngle;
	}

		
	if( Level.Netmode == NM_Standalone )
	{
		Dest.AccelRate			= Source.AccelRate;    
		Dest.AirSpeed			= Source.AirSpeed;     
		Dest.Buoyancy			= Source.Buoyancy;     
		Dest.GroundSpeed		= Source.GroundSpeed;  
		Dest.JumpZ				= Source.JumpZ;        
		Dest.Mass				= Source.Mass;         
		Dest.MaxStepHeight		= Source.MaxStepHeight;
		Dest.RotationRate		= Source.RotationRate; 
		Dest.WaterSpeed			= Source.WaterSpeed;   
	}

	if( Dest.IsA( 'WOTPlayer' ) )
	{
		DestPlayer = WOTPlayer( Dest );

		DestPlayer.ApparentClass		= Source.ApparentClass;
		DestPlayer.ApparentTeam			= Source.ApparentTeam;
		DestPlayer.AnimationTableClass	= Source.AnimationTableClass;
		DestPlayer.ApparentIcon			= None;
	}
	else
	{
		warn( "RestoreDisguisePawnProperties: disguised NPCs not supported!" );
	}
}

defaultproperties
{
    DurationType=0
    bElementSpirit=True
    bRare=True
    bCombat=True
    MinInitialCharges=15
    MaxInitialCharges=20
    MaxCharges=60
    ActivateSoundName="Angreal.ActivateDG"
    DeActivateSoundName="Angreal.DeActivateDG"
    MaxChargesInGroup=20
    MinChargesInGroup=10
    MaxChargeUsedInterval=1.00
    MinChargeGroupInterval=1.00
    Title="Disguise"
    Description="As long as you continue to activate the artifact, Disguise cloaks you with the image of the nearest creature or person."
    Quote="His skin tingled slightly as she channeled, and for an instant her image changed. Her skin became coppery but dull, her hair and eyes dark but flat."
    StatusIconFrame=Texture'Icons.M_Disguise'
    InventoryGroup=67
    PickupMessage="You got the Disguise ter'angreal"
    PickupViewMesh=Mesh'AngrealDisguisePickup'
    PickupViewScale=0.70
    StatusIcon=Texture'Icons.I_Disguise'
    Texture=None
    Mesh=Mesh'AngrealDisguisePickup'
    DrawScale=0.70
}
