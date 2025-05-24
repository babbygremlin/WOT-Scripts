//------------------------------------------------------------------------------
// AngrealInvLevitate.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 8 $
//
// Description:	Caster floats gently above the ground.  This is not flying.
//				If he walks off of a cliff, he will float downward.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvLevitate expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealLevitatePickup ANIVFILE=MODELS\AngrealLevitate_a.3D DATAFILE=MODELS\AngrealLevitate_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealLevitatePickup X=0 Y=0 Z=0 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealLevitatePickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealLevitatePickupTex FILE=MODELS\AngrealLevitate.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=AngrealLevitatePickupTex2 FILE=MODELS\AngrealLevitate.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealLevitatePickup MESH=AngrealLevitatePickup
#exec MESHMAP SCALE      MESHMAP=AngrealLevitatePickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealLevitatePickup NUM=1 TEXTURE=AngrealLevitatePickupTex
#exec MESHMAP SETTEXTURE MESHMAP=AngrealLevitatePickup NUM=2 TEXTURE=AngrealLevitatePickupTex2

#exec TEXTURE IMPORT FILE=Icons\I_Levitation.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Levitation.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Levitate\DeActivateLT.wav	GROUP=Levitate
#exec AUDIO IMPORT FILE=Sounds\Levitate\LoopLT.wav			GROUP=Levitate

var bool bLevitate;

var EPhysics InitialPhysics;

var float ChargeTimer;

var() float RiseHeight;
var() float LevitateSpeed;
//var() float RoundsPerMinute;

//------------------------------------------------------------------------------
function Cast()
{
	if( !class'AngrealInvWhirlwind'.static.PlayerIsBeingWhilrwinded( Pawn(Owner) ) )
	{
		InitialPhysics = Owner.Physics;
		bLevitate = True;
		Super.Cast();
	}
	else
	{
		Failed();
	}
}

//------------------------------------------------------------------------------
function UnCast()
{
	if( bLevitate )
	{
		Owner.SetPhysics( InitialPhysics );
		bLevitate = False;
		Super.UnCast();
	}
}

//------------------------------------------------------------------------------
function GoEmpty()
{
	UnCast();
	Super.GoEmpty();
}

//------------------------------------------------------------------------------
// Try to keep our castor RiseHeight off the ground.
// Move him/her at a constant velocity LevitateSpeed to get there.
//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	local vector DesiredLocation;
	local vector HitNormal;
	
	Super.Tick( DeltaTime );

	if( bLevitate )
	{
		Owner.SetPhysics( PHYS_Flying );

		class'util'.static.TraceRecursive( Self, DesiredLocation, HitNormal, Owner.Location, false );
		DesiredLocation.Z += (RiseHeight + Owner.CollisionHeight);
		
		if( Abs(DesiredLocation.Z - Owner.Location.Z) > 2.0 )	// To alleviate vibrations.
		{
			Owner.Velocity.Z = (Normal( DesiredLocation - Owner.Location ) * LevitateSpeed).Z;
		}
		else
		{
			Owner.Velocity.Z = 0.0;
		}

		ChargeTimer -= DeltaTime;
		while( ChargeTimer < 0.0 )
		{
			ChargeTimer += (60.0/RoundsPerMinute);
			UseCharge();
		}
	}
}

////////////////
// AI Support //
////////////////

defaultproperties
{
    RiseHeight=24.00
    LevitateSpeed=96.00
    DurationType=0
    bElementAir=True
    bUncommon=True
    MinInitialCharges=10
    MaxInitialCharges=30
    MaxCharges=50
    FailMessage="cannot be used while in Whirlwind"
    bDisplayIcon=True
    ActivateSoundName="Angreal.LoopLT"
    DeActivateSoundName="Angreal.DeActivateLT"
    MaxChargesInGroup=20
    MinChargesInGroup=10
    MaxChargeUsedInterval=1.00
    Title="Levitate"
    Description="While you continue to activate Levitate, you float slightly above the ground. This effect is not flight, however; a thin weave of air merely cushions your descent."
    Quote="Suddenly she lifted into the air, and Elayne, too; they stared at each other, wide-eyed, as they floated a pace above the carpet."
    StatusIconFrame=Texture'Icons.M_Levitation'
    PickupMessage="You got the Levitate ter'angreal"
    PickupViewMesh=Mesh'AngrealLevitatePickup'
    StatusIcon=Texture'Icons.I_Levitation'
    Texture=None
    Mesh=Mesh'AngrealLevitatePickup'
}
