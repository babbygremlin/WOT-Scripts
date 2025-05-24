//------------------------------------------------------------------------------
// AngrealInvWhirlwind.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	Causes the victim to be lifted up and whirled around.  
//				Stops when the caster ceases to pump charges into it.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvWhirlwind expands AngrealInventory;

#exec MESH    IMPORT     MESH=AngrealWhirlwindPickup ANIVFILE=MODELS\AngrealWhirlwind_a.3D DATAFILE=MODELS\AngrealWhirlwind_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AngrealWhirlwindPickup X=0 Y=0 Z=0 ROLL=-64
#exec MESH    SEQUENCE   MESH=AngrealWhirlwindPickup SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT     NAME=AngrealWhirlwindPickupTex FILE=MODELS\AngrealWhirlwind.PCX GROUP="Skins"
#exec TEXTURE IMPORT     NAME=AngrealWhirlwindPickupTex2 FILE=MODELS\AngrealWhirlwind.PCX GROUP="Skins"
#exec MESHMAP NEW        MESHMAP=AngrealWhirlwindPickup MESH=AngrealWhirlwindPickup
#exec MESHMAP SCALE      MESHMAP=AngrealWhirlwindPickup X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=AngrealWhirlwindPickup NUM=1 TEXTURE=AngrealWhirlwindPickupTex

#exec TEXTURE IMPORT FILE=Icons\I_Whirlwind.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Whirlwind.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Whirlwind\ActivateWW.wav			GROUP=Whirlwind

var bool bCasting;

// Number of charges used per minute while whirlwind is in effect.
//var() float RoundsPerMinute;

// Used for keeping track of when we are supposed to use a charge.
var float ChargeTimer;

// Targeting
var() float MaxAngle; 

var float InitialDistance;

// Our friendly whirlwind leech...let's get some! :)
var WhirlwindLeech WWLeech;

// Our persistant Leech Attacher.
var AttachLeechEffect Attacher;

///////////////
// Overrides //
///////////////

//------------------------------------------------------------------------------
// Give our victim a nice friendly WhirlwindLeech to deal with.
//------------------------------------------------------------------------------
function Cast()
{
	local Actor BestTarget;
	
	// Get the best target from our owner.
	if( WOTPlayer(Owner) != None )
	{					
		BestTarget = WOTPlayer(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, MaxAngle );
	}
	else if( WOTPawn(Owner) != None )
	{
		BestTarget = WOTPawn(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, MaxAngle );
	}

	if( WOTPawn(BestTarget) != None || WOTPlayer(BestTarget) != None )
	{
		WWLeech = Spawn( class'WhirlwindLeech' );
		WWLeech.SetSourceAngreal( Self );
		WWLeech.Tag = Name;
/*
		// Only spawn our persitant attacher if we need one.
		if( Attacher == None )
		{
			Attacher = Spawn( class'AttachLeechEffect' );
			Attacher.SetSourceAngreal( Self );
		}
*/
		Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
		Attacher.SetSourceAngreal( Self );

		Attacher.SetLeech( WWLeech );
		Attacher.SetVictim( Pawn(BestTarget) );
		
		if( WOTPawn(BestTarget) != None )
		{
			WOTPawn(BestTarget).ProcessEffect( Attacher );
		}
		else
		{
			WOTPlayer(BestTarget).ProcessEffect( Attacher );
		}

		if( WWLeech == None || WWLeech.Owner != BestTarget )
		{
			Failed();

			if( WWLeech != None )
			{
				WWLeech.UnAttach();
				WWLeech.Destroy();
			}
		}
		else
		{
			InitialDistance = VSize( BestTarget.Location - Owner.Location );
			
			bCasting = True;
			Super.Cast();
		}
	}
	else
	{
		Failed();
	}
}

//------------------------------------------------------------------------------
// Stops the madness!!!
//------------------------------------------------------------------------------
singular function UnCast()
{
	if( bCasting )
	{
		if( WWLeech != None )
		{
			WWLeech.UnAttach();
			WWLeech.Destroy();
		}

		bCasting = False;
		Super.UnCast();
	}
}

//------------------------------------------------------------------------------
// Update the desired location of our WhirlwindLeech
//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	// Only try to update while we are still casting.
	if( bCasting )
	{
		if( WWLeech != None )
		{
			WWLeech.SetDesiredLocation( Owner.Location + ((vect(1,0,0)*InitialDistance) >> Pawn(Owner).ViewRotation) );
		}
		else
		{
			UnCast();
		}

		// Suck up charges while we are casting.
		ChargeTimer += DeltaTime;
		if( ChargeTimer >= (60.0 / RoundsPerMinute) )
		{
			ChargeTimer -= (60.0 / RoundsPerMinute);
			UseCharge();
		}
	}
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
function Destroyed()
{
	if( bCasting )
	{
		UnCast();
	}
	Super.Destroyed();
}

//------------------------------------------------------------------------------
function NotifyLeechLost()
{
	if( bCasting )
	{
		UnCast();
	}
}

//////////////////////
// Helper functions //
//////////////////////

//------------------------------------------------------------------------------
static simulated function bool PlayerIsBeingWhilrwinded( Pawn Other )
{
	local Leech L;
	local LeechIterator IterL;
	local bool bPlayerIsBeingWhilrwinded;
	
	IterL = class'LeechIterator'.static.GetIteratorFor( Other );
	for( IterL.First(); !IterL.IsDone(); IterL.Next() )
	{
		L = IterL.GetCurrent();

		if( WhirlwindLeech(L) != None )
		{
			bPlayerIsBeingWhilrwinded = true;
			break;
		}
	}
	IterL.Reset();
	IterL = None;

	return bPlayerIsBeingWhilrwinded;
}


////////////////
// AI Support //
////////////////

//------------------------------------------------------------------------------
function float GetMinRange()
{
	return 200.0;	// Beyond arms' reach.
}

defaultproperties
{
    MaxAngle=22.50
    DurationType=0
    bElementAir=True
    bUncommon=True
    bOffensive=True
    bCombat=True
    RoundsPerMinute=20.00
    MinInitialCharges=10
    MaxInitialCharges=20
    MaxCharges=40
    FailMessage="requires a target"
    bDisplayIcon=True
    ActivateSoundName="Angreal.ActivateWW"
    MaxChargesInGroup=20
    MinChargesInGroup=10
    MaxChargeUsedInterval=3.00
    MinChargeGroupInterval=4.00
    Title="Whirlwind"
    Description="As long as you continue to activate Whirlwind, your target is spun and lifted up into the air, in any direction you point."
    Quote="Dead leaves whirled into the air and branches whipped as if a dustdevil ran along the line she pointed to."
    StatusIconFrame=Texture'Icons.M_Whirlwind'
    PickupMessage="You got the Whirlwind ter'angreal"
    PickupViewMesh=Mesh'AngrealWhirlwindPickup'
    StatusIcon=Texture'Icons.I_Whirlwind'
    Texture=None
    Mesh=Mesh'AngrealWhirlwindPickup'
}
