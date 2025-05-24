//------------------------------------------------------------------------------
// AngrealInvWallOfAir.uc
// $Author: Mfox $
// $Date: 1/07/00 12:15p $
// $Revision: 12 $
//
// Description:	A semi-invisible wall is erected between you and the target.
//				It lasts for a short time, unless you keep pumping charges 
//				into it.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvWallOfAir expands AngrealInventory;

#exec MESH IMPORT MESH=WallAir ANIVFILE=MODELS\WallAir_a.3d DATAFILE=MODELS\WallAir_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WallAir X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WallAir SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JWallAir1 FILE=MODELS\WallAir1.PCX GROUP=Skins FLAGS=2 // WallOfAir

#exec MESHMAP NEW   MESHMAP=WallAir MESH=WallAir
#exec MESHMAP SCALE MESHMAP=WallAir X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=WallAir NUM=1 TEXTURE=JWallAir1

#exec TEXTURE IMPORT FILE=Icons\I_WallOfAir.pcx         GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_WallOfAir.pcx         GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\WallOfAir\DeActivateWA.wav	GROUP=WallOfAir

var AngrealWallOfAirProjectile WOA;
var Leech CastorLeech, VictimLeech;
	
var float CastTimer;

//var() float RoundsPerMinute;

var() float MaxAngle;

var bool bCasting;

//------------------------------------------------------------------------------
function Cast()
{
	local Actor A;

	if( WOTPlayer(Owner) != None )
	{					
		A = WOTPlayer(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, MaxAngle );
	}
	else if( WOTPawn(Owner) != None )
	{
		A = WOTPawn(Owner).FindBestTarget( GetTrajectorySource(), Pawn(Owner).ViewRotation, MaxAngle );
	}

	if( A != None )
	{
		bCasting = true;
		
		WOA = Spawn( class'AngrealWallOfAirProjectile' );
		WOA.SetSourceAngreal( Self );
		WOA.Source = Owner;
		WOA.Destination = A;
		
		// NOTE[aleiby]: The WallOfAir projectile should probably be doing this rather than us.
		CastorLeech = InstallDestroyLeech( WOA, Owner, false );
		VictimLeech = InstallDestroyLeech( WOA, A, true );
		
		if( CastorLeech == None || VictimLeech == None )
		{
			bCasting = false;
			UnCast();
		}
		
		if( bCasting )
		{
			Super.Cast();
			UseCharge();
		}
		else
		{
			Failed();
		}
	}
	else
	{
		Failed();
	}
}

function Leech InstallDestroyLeech( Actor DestroyActor, Actor Victim, optional bool bShowIcon )
{
	local DestroyOnDestroyLeech DODL;
	local AttachLeechEffect Attacher;

	DODL = Spawn( class'DestroyOnDestroyLeech' );
	DODL.SetSourceAngreal( Self );
	DODL.bDisplayIcon = bShowIcon;
	DODL.SetDestroyActor( DestroyActor );

	//Attacher = Spawn( class'AttachLeechEffect' );
	Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, class'AttachLeechEffect' ) );
	Attacher.SetSourceAngreal( Self );
	Attacher.SetVictim( Pawn(Victim) );
	Attacher.SetLeech( DODL );

	if( WOTPlayer(Victim) != None )
	{
		WOTPlayer(Victim).ProcessEffect( Attacher );
	}
	else if( WOTPawn(Victim) != None )
	{
		WOTPawn(Victim).ProcessEffect( Attacher );
	}
	
	// Check for failure.
	if( DODL.Owner != Victim )
	{
		DODL.Destroy();
		DODL = None;
	}

	return DODL;
}

//------------------------------------------------------------------------------
singular function UnCast()
{
	if( WOA != None )
	{
		WOA.Destroy();
		WOA = None;		// Just to be safe.
	}

	if( CastorLeech != None && !CastorLeech.bDeleteMe )
	{
		CastorLeech.UnAttach();
		CastorLeech.Destroy();
	}
	CastorLeech = None;

	if( VictimLeech != None && !VictimLeech.bDeleteMe )
	{
		VictimLeech.UnAttach();
		VictimLeech.Destroy();
	}
	VictimLeech = None;
	
	if( bCasting )
	{
		Super.UnCast();
	}

	bCasting = false;
}

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// If we are casting.
	if( WOA != None )
	{
		CastTimer -= DeltaTime;
		while( CastTimer <= 0 )
		{
			CastTimer += (60.0 / RoundsPerMinute);
			UseCharge();
		}
	}
}

defaultproperties
{
     MaxAngle=22.500000
     bElementWater=True
     bElementEarth=True
     bElementSpirit=True
     bUncommon=True
     bDefensive=True
     bCombat=True
     RoundsPerMinute=40.000000
     MinInitialCharges=10
     MaxInitialCharges=20
     MaxCharges=40
     FailMessage="requires a target"
     DeActivateSoundName="Angreal.DeActivateWA"
     MaxChargesInGroup=20
     MinChargesInGroup=10
     MaxChargeUsedInterval=1.000000
     Title="Sever"
     Description="This ter'angreal erects a barrier between you and your target. It lasts for a short time, unless you continue to activate the artifact. This barrier unravels any weaves that strike it."
     Quote="Sword coming out, long legs carried him ahead of her, color-shifting cloak waving behind as he charged. Suddenly he seemed to run into an invisible stone wall, bounce back, try to stagger forward again."
     StatusIconFrame=Texture'Angreal.Icons.M_WallOfAir'
     PickupMessage="You got the Sever ter'angreal"
     PickupViewMesh=Mesh'Angreal.WallAir'
     PickupViewScale=0.500000
     StatusIcon=Texture'Angreal.Icons.I_WallOfAir'
     Style=STY_Translucent
     Mesh=Mesh'Angreal.WallAir'
     DrawScale=0.500000
}
