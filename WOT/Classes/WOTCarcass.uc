//=============================================================================
// WOTCarcass.
//=============================================================================

class WOTCarcass expands WOTCarcassBase;

#exec AUDIO IMPORT FILE=Sounds\Pawn\Carcass\Landed1.wav

//=============================================================================
// Note that when a pawn is gibbed immediately, this class is still used to 
// create the effect -- ChunkUp is immediately called for the carcass.
//=============================================================================

struct BodyPartT
{
	var() string			MeshName; 					// mesh to use
	var() string			SkinName;					// skin to use
	var() int				SkinSlot;					// slot 
	var() string			BounceSoundStr;				// special bounce sound, usually none
	var() bool				bNoBlood;					// whether to spawn blood when bouncing (e.g. false for bones)
	var() float 			Odds;						// odds of using this part
	var() bool				bNoDamage;					// if true, chunk doesn't take damage
	var() bool				bZeroYaw;					// if true, final (landed) yaw is zeroed out
	var() bool				bZeroRoll;					// if true, final (landed) roll is zeroed out
	var() bool				bZeroPitch;					// if true, final (landed) pitch is zeroed out
};

var() BodyPartT BodyParts[16];							// parts to spawn when carcass gibbed (or if pawn gibbed)
var() float  ZOffsets[16];								// offset wrt Pawn to spawn gibbed part at (e.g. +0.5 for head)
var() float  DefaultInitialDamage;						// initial damage to give to carcass (usually 0.0)
var() string GibSound1Name;								// gib sound #1
var() string GibSound2Name;								// gib sound #2 (optional)
var() float  CleanBoneOdds;								// odds of clean bone vs bloody one if arm/thigh bone mesh used
var() float  CleanSkullOdds;							// odds of clean skull vs bloody one if skull mesh used
var() float  BentLegOdds;								// odds that leg chunks will be bent vs straight
var() float  BaseGibDamage;								// min damage needed to gib at GibForSureCummulativeDamage inherited from Pawn
var() float  CarcassCCHeightMultiplier;					// CC height is multipled by this wrt source pawn height (usually make a lot shorter)
var() float  CarcassCCRadiusMultiplier;					// CC radius is multipled by this wrt source pawn radius (usually make bit wider)
var() class<AnimationTableWOT> AnimationTableClass;		// source class for mesh (only useful for pawns) -- used to determine offset for CC
var() float  GibForSureCummulativeDamage;				// taken from source actor, or for placed carcasses, set to damage level at which carcass should gib
var() float  ChunkPainZoneDamageScale;					// use to override PainZoneDamageScale in chunks (if >= 0)
var() string LandedSoundStr;							// sound to play when carcass hits the ground

var	  bool bThumped;
var   ZoneInfo DeathZone;
var   bool bAdjustedCylinder;
var   Rotator CollisionCylinderRotation;
var	  vector CollisionCylinderShiftVector;
var   Actor SourceActor;

//=============================================================================

function PostBeginPlay()
{
	if ( !bDecorative )
	{
		DeathZone = Region.Zone;
		DeathZone.NumCarcasses++;
	}

	if ( Physics == PHYS_None )
	{
		SetCollision( bCollideActors, false, false );
	}

	SourceCollisionHeight		= CollisionHeight;
	SourceCollisionRadius		= CollisionRadius;
	CollisionCylinderRotation	= Rotation;

	if( AnimationTableClass	!= None )
	{
		CollisionCylinderShiftVector = AnimationTableClass.static.GetAnimEndVector( AnimSequence );
	}

	// carcass can start out with some default amount of damage (usually 0.0)
	CumulativeDamage = DefaultInitialDamage;

	Super.PostBeginPlay();
}

//=============================================================================

event BaseChange()
{
}

//=============================================================================
// If this is ever changed so that killed PCs/NPCs become carcasses
// right away (main reason for doing would be so the dying sound could be played
// from the carcass so it tracks it instead of the PC/NPC) will no longer need 
// SourceActor (can play/kill sound through carcass using Other's SoundTable
// and the amount of damage done to determine soft/hard death). Instead of 
// using notification functions, the animation frames, rate could tell us about
// when the animation ends ==> time to reduce CC (or use per-Pawn values from
// somewhere to control this).
function InitFor( Actor Other )
{
	SourceActor = Other;

	class'Util'.static.CopyDisplaySettings( Other, Self );

	DesiredRotation			= Other.Rotation;
	DesiredRotation.Roll	= 0;
	DesiredRotation.Pitch	= 0;

	if ( bDecorative )
	{
		DeathZone = Region.Zone;
		DeathZone.NumCarcasses++;
	}
	bDecorative = false;

	Mass = Other.Mass;
	Tag = Other.Tag;

	if( Buoyancy < 0.8 * Mass )
	{
		Buoyancy = 0.9 * Mass;
	}

	// save height/radius for scaling chunks etc.
	SourceCollisionHeight = Other.CollisionHeight;
	SourceCollisionRadius = Other.CollisionRadius;

	if( Other.IsA( 'Pawn' ) )
	{
		CumulativeDamage += -Pawn(Other).Health;
	}

	if( Other.IsA( 'WOTPawn' ) )
	{
		bTakesDamage = !WOTPawn(Other).bNeverGib;
		GibForSureCummulativeDamage = -WOTPawn(Other).GibForSureFinalHealth;
		BaseGibDamage = WOTPawn(Other).BaseGibDamage;

		CollisionCylinderShiftVector = WOTPawn(Other).AnimationTableClass.static.GetAnimEndVector( Other.AnimSequence );
	}
	else if( Other.IsA( 'WOTPlayer' ) )
	{
		bTakesDamage = !WOTPlayer(Other).bNeverGib;
		GibForSureCummulativeDamage = -WOTPlayer(Other).GibForSureFinalHealth;
		BaseGibDamage = WOTPlayer(Other).BaseGibDamage;

		CollisionCylinderShiftVector = WOTPlayer(Other).AnimationTableClass.static.GetAnimEndVector( Other.AnimSequence );
	}

	CollisionCylinderRotation = Other.Rotation;

	SetCollision( bCollideActors, false, false );
	bProjTarget = true;

	// can't take Other.Physics since, if Other was Landed, its physics will
	// now be PHYS_Walking and we might still want to bounce around for a bit
	if( Tag != 'Balefired' )
	{
		AdjustCylinder();
		SetPhysics( PHYS_Falling );
		Velocity = Other.Velocity;
	}
	else
	{
		SetPhysics( PHYS_None );
		Acceleration = vect(0,0,0);
	}
}

//=============================================================================

function Destroyed()
{
	if ( !bDecorative && DeathZone != None )
	{
		DeathZone.NumCarcasses--;
	}

	Super.Destroyed();
}

//=============================================================================
// Carcass can take damage in which case it should spurt blood near the hit
// location and eventually gib.

function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, name DamageType )
{
	if( bTakesDamage && Tag != 'Balefired' )
	{
		// angle up
		SpawnBlood( HitLocation, DamageCarcassBloodClassStr );

		if ( !bDecorative )
		{
			bBobbing = false;
			SetPhysics( PHYS_Falling );
		}

		if ( (Physics == PHYS_None) && (Momentum.Z < 0) )
			Momentum.Z *= -1;
		Velocity += 3 * Momentum/(Mass + 200);

		CumulativeDamage += Damage;

		// scale final health needed for gib with amount of damage
		if ( CumulativeDamage > (BaseGibDamage/Damage * GibForSureCummulativeDamage) ) 
		{
			ChunkUp( Damage );
		}
	}
}

//=============================================================================

function ThrowOthers()
{
	local float dist, shake;
	local pawn Thrown;
	local PlayerPawn aPlayer;
	local vector Momentum;

	Thrown = Level.PawnList;
	While ( Thrown != None )
	{
		aPlayer = PlayerPawn(Thrown);
		if ( aPlayer != None )
		{	
			dist = VSize(Location - aPlayer.Location);
			shake = FMax(500, 1500 - dist);
			aPlayer.ShakeView( FMax(0, 0.35 - dist/20000),shake, 0.015 * shake );
			if ( (aPlayer.Physics == PHYS_Walking) && (dist < 1500) )
			{
				Momentum = -0.5 * aPlayer.Velocity + 100 * VRand();
				Momentum.Z =  7000000.0/((0.4 * dist + 350) * aPlayer.Mass);
				aPlayer.AddVelocity(Momentum);
			}
		}
	Thrown = Thrown.nextPawn;
	}
}

//=============================================================================

function LandThump()
{
	local float impact;

	if ( Physics == PHYS_None)
	{
		bThumped = true;

		if ( Role == ROLE_Authority )
		{
			impact = 0.75 + Velocity.Z * 0.004;
			impact = Mass * impact * impact * 0.015;

			if ( Mass >= 500 )
			{
				ThrowOthers();
			}
		}
	}
}

//=============================================================================

function WOTCreatureChunk CreateChunk( Class<WOTCreatureChunk> ChunkClass, BodyPartT BodyPart, int Offset )
{
	local WOTCreatureChunk CreatureChunkA;

	CreatureChunkA = Spawn( ChunkClass,,, Location + Offset * CollisionHeight * vect(0,0,1)); 

	if( CreatureChunkA != None )
	{
		CreatureChunkA.Initfor( Self );
		CreatureChunkA.Mesh	= Mesh( DynamicLoadObject( BodyPart.MeshName, class'Mesh' ) );
		CreatureChunkA.MultiSkins[BodyPart.SkinSlot] = Texture( DynamicLoadObject( BodyPart.SkinName, class'Texture' ) );
		CreatureChunkA.SpecialSound = BodyPart.BounceSoundStr;
		CreatureChunkA.bSpawnBlood = !BodyPart.bNoBlood;
		CreatureChunkA.bZeroYaw = BodyPart.bZeroYaw;
		CreatureChunkA.bZeroRoll = BodyPart.bZeroRoll;
		CreatureChunkA.bZeroPitch = BodyPart.bZeroPitch;
		CreatureChunkA.bTakesDamage = !BodyPart.bNoDamage;

		if( ChunkPainZoneDamageScale >= 0 )
		{
			CreatureChunkA.PainZoneDamageScale = ChunkPainZoneDamageScale;
		}

		// couple of special cases
		if( BodyPart.MeshName == "WOT.ArmBone" && FRand() < CleanBoneOdds )
		{
			CreatureChunkA.MultiSkins[BodyPart.SkinSlot] = Texture( DynamicLoadObject( "WOT.Bones", class'Texture' ) );
		}
		else if( BodyPart.MeshName == "WOT.ThighBone" && FRand() < CleanBoneOdds )
		{
			CreatureChunkA.MultiSkins[BodyPart.SkinSlot] = Texture( DynamicLoadObject( "WOT.Bones", class'Texture' ) );
		}
		else if( BodyPart.MeshName == "WOT.Leg" && FRand() < BentLegOdds )
		{
			CreatureChunkA.Mesh	= Mesh( DynamicLoadObject( "WOT.LegBent", class'Mesh' ) );
		}
		else if( BodyPart.MeshName == "WOT.Skull" && FRand() < CleanSkullOdds )
		{
			CreatureChunkA.MultiSkins[BodyPart.SkinSlot] = Texture( DynamicLoadObject( "WOT.Skull03", class'Texture' ) );
		}
	}

	return CreatureChunkA;
}

//=============================================================================

function CreateReplacement()
{
	local WOTCreatureChunk CreatureChunkA;

	if ( BodyParts[0].MeshName != "" )
	{
		CreatureChunkA = CreateChunk( class'WOTReplacementChunk', BodyParts[0], ZOffsets[0] );

		if( CreatureChunkA != None )
		{
			CreatureChunkA.Bugs = Bugs;

			if ( Bugs != None )
			{
				Bugs.SetBase( CreatureChunkA );
			}

			Bugs = None;
		}
		else if ( Bugs != None )
		{
			Bugs.Destroy();
		}
	}
}

//=============================================================================

function ChunkUp( int Damage )
{
	if( Level.NetMode != NM_Standalone || GetGoreDetailLevel() >= 2 )
	{
		if( bTakesDamage && !bHidden && Tag != 'Balefired' )
		{
			if( SourceActor != None )
			{
				SourceActor.PlaySound( None, SLOT_Talk );
			}
		
			SpawnBlood( Location+0.5*CollisionHeight*vect(0,0,1), GibbedBloodClassStr );
			CreateReplacement();
			ClientExtraChunks();
		
			SetPhysics( PHYS_None );
		
			bHidden = true;
		
			SetCollision( bCollideActors, false, false );
			bProjTarget = false;
			GotoState( 'Gibbing' );
		}
	}
	else
	{
		// didn't gib because of low/very low gib settings
		// and should no longer take damage (e.g. for fire pits)
		bTakesDamage = false;	
	}
}

//=============================================================================

function ClientExtraChunks()
{
	local int n;

	for( n=1; n<ArrayCount(BodyParts); n++ )
	{
		if( BodyParts[n].MeshName != "" && FRand() < BodyParts[n].Odds )
		{
			CreateChunk( class'WOTCreatureChunk', BodyParts[n], ZOffsets[n] );
		}
	}
}

//=============================================================================
// Dying state.
//=============================================================================

auto state Dying
{
	ignores TakeDamage;

Begin:
	if ( bDecorative && !bAdjustedCylinder )
	{
		AdjustCylinder();
//		SetPhysics( PHYS_None );
	}

	Sleep(0.2);

	GotoState('Dead');
}

//=============================================================================
// Dead state.
//=============================================================================

state Dead 
{
	/*
	function AddFliesAndRats()
	{
		if ( (flies > 0) && (Bugs == None) && (Level.NetMode == NM_Standalone) )
		{
			Bugs = Spawn(class 'DeadBodySwarm');

			if (Bugs != None)
			{
				Bugs.SetBase(Self);
				DeadBodySwarm(Bugs).swarmsize = flies * (FRand() + 0.5);
				DeadBodySwarm(Bugs).swarmradius = collisionradius;
			}
		}
	}
	*/

	//=============================================================================
	// Even if the we decide not to clean up carcasses in BeginState below, we will
	// still clean them up if the max for the zone is exceeded.

	function CheckZoneCarcasses()
	{
		local WOTCarcass C, Best;

		if ( !bDecorative && (DeathZone.NumCarcasses > DeathZone.MaxCarcasses) )
		{
			Best = Self;
			ForEach AllActors( class'WOTCarcass', C )
			{
				if ( (C != Self) && !C.bDecorative && (C.DeathZone == DeathZone) && !C.IsAnimating() )
				{
					if ( Best == self )
					{
						Best = C;
					}
					else if ( !C.PlayerCanSeeMe() )
					{
						Best = C;
						break;
					}
				}
			}

			Best.Destroy();
		}
	}

	function BeginState()
	{
		if( bDecorative || bPermanent || ((Level.NetMode == NM_Standalone) && !Level.Game.IsA('giCombatBase')) )
		{
			// carcass will never be cleaned up (e.g. in singleplayer)
			LifeSpan = 0.0;
		}
		else
		{
			SetTimer( FMax(12.0, 30.0 - 2 * DeathZone.NumCarcasses), false ); 
		}
	}

}

//=============================================================================

state Gibbing
{
	ignores Landed, HitWall, AnimEnd, TakeDamage, ZoneChange;

	function GibSound()
	{
		if( FRand() < 0.50 )
		{
			PlaySound( Sound( DynamicLoadObject( GibSound1Name, class'Sound' ) ), SLOT_Misc );
		}
		else
		{
			PlaySound( Sound( DynamicLoadObject( GibSound2Name, class'Sound' ) ), SLOT_Misc );
		}
	}

Begin:
	Sleep(0.2);
	GibSound();

	if ( !bPlayerCarcass )
	{
		Destroy();
	}
}

//=============================================================================
      
function Landed( vector HitNormal )
{
	local rotator FinalRot;
	local float OldHeight;

	if( bTakesDamage && ( Velocity.Z < -1000 ) )
	{
		ChunkUp(200);
		return;
	}

	FinalRot = Rotation;
	FinalRot.Roll = 0;
	FinalRot.Pitch = 0;
	SetRotation( FinalRot );

	if( !IsAnimating() )
	{
		LieStill();
	}

	// PHYS_Rolling doesn't seem to work that well and hoses 
	// dying carcass landing on top of geometry when it should bounce off
	// SetPhysics( PHYS_Rolling );
	SetCollision( bCollideActors, false, false );

	PlaySound( Sound( DynamicLoadObject( LandedSoundStr, class'Sound' ) ), SLOT_Misc );
}

//=============================================================================

function AdjustCylinder()
{
	local float OldHeight;

	RemoteRole=ROLE_DumbProxy;
	bAdjustedCylinder = true;

	if( CollisionCylinderShiftVector != vect(0,0,0) )
	{
		CollisionCylinderRotation.Roll = 0;
		CollisionCylinderRotation.Pitch = 0;

		// vector from anim table really represents # collision radii to shift by * 1/2 for centering
		CollisionCylinderShiftVector = CollisionRadius/2.0 * ( CollisionCylinderShiftVector >> CollisionCylinderRotation );
	}

	// now reduce collision cylinder and shift down to bottom of old collision cylinder
	// while making sure the mesh stays in the same place.
	// carcass should be pretty "flat" by now -- immediately squash CC
	SetCollisionSize( CarcassCCRadiusMultiplier*SourceCollisionRadius + 4, CarcassCCHeightMultiplier*SourceCollisionRadius );
	if ( !SetLocation( Location ) )
	{
		SetCollisionSize( CarcassCCRadiusMultiplier*CollisionRadius - 4, CollisionRadius );
	}

	CollisionCylinderShiftVector.Z += (CollisionHeight - SourceCollisionHeight );
	
	if( CollisionCylinderShiftVector != vect(0,0,0) )
	{
		// shift the carcass' CC without shifting the mesh
		class'Util'.static.ShiftCollisionCylinder( Self, CollisionCylinderShiftVector );
	}

	Mass = Mass * 0.8;
	Buoyancy = Buoyancy * 0.8;
}

//=============================================================================

simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.7 * ( Velocity - 2 * HitNormal * ( Velocity Dot HitNormal ) );
	Velocity.Z *= 0.9;
	if ( Abs( Velocity.Z ) < 120 )
	{
		bBounce = false;
		Disable( 'HitWall' );
	}
}

//=============================================================================

function LieStill()
{
	if ( !bThumped && !bDecorative )
	{
		LandThump();
	}

	if ( !bAdjustedCylinder )
	{
		AdjustCylinder();
	}
}

//=============================================================================

defaultproperties
{
     BodyParts(0)=(MeshName="WOT.ChunkA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     BodyParts(1)=(MeshName="WOT.Spine",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000,bZeroPitch=True)
     BodyParts(2)=(MeshName="WOT.Chest",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000,bZeroPitch=True)
     BodyParts(3)=(MeshName="WOT.ChunkA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000)
     BodyParts(4)=(MeshName="WOT.OrganA",SkinName="WOT.Skins.GIBpartA",SkinSlot=1,Odds=0.900000,bZeroPitch=True)
     BodyParts(5)=(MeshName="WOT.ArmBone",SkinName="WOT.Skins.BonesBloody",BounceSoundStr="WOT.GibBounceBone1",bNoBlood=True,Odds=1.000000,bNoDamage=True,bZeroPitch=True)
     GibSound1Name="WOT.GibExplode1"
     GibSound2Name="WOT.GibExplode2"
     BentLegOdds=0.500000
     BaseGibDamage=40.000000
     CarcassCCHeightMultiplier=0.400000
     CarcassCCRadiusMultiplier=1.200000
     GibForSureCummulativeDamage=40.000000
     ChunkPainZoneDamageScale=-1.000000
     LandedSoundStr="WOT.Landed1"
     NetPriority=6.000000
}
