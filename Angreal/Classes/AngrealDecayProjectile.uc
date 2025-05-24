//------------------------------------------------------------------------------
// AngrealDecayProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 6 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealDecayProjectile expands SeekingProjectile;

#exec TEXTURE IMPORT FILE=MODELS\DC_A01.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A02.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A03.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A04.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A05.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A06.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A07.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A08.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A09.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A10.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A11.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A12.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A13.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A14.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A15.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A16.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A17.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A18.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A19.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A20.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A21.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A22.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A23.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A24.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A25.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A26.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A27.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A28.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A29.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A30.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A31.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A32.pcx GROUP=Effects
#exec TEXTURE IMPORT FILE=MODELS\DC_A33.pcx GROUP=Effects

#exec AUDIO IMPORT FILE=Sounds\Decay\HitDC.wav			GROUP=Decay
#exec AUDIO IMPORT FILE=Sounds\Decay\LaunchDC.wav		GROUP=Decay
#exec AUDIO IMPORT FILE=Sounds\Decay\LoopDC.wav			GROUP=Decay

// NOTE[aleiby]: This code looks suspiciously like LeechAttacher.uc.
// Is there a way we can put this in a single place?

// How long does this effect last?
// This number gets used for all the leeches installed.
// That way they will all get unattached at the same time.
var() float Duration;

// The reflector to install. 
var() class<Leech> LeechClasses[10];

// The type of Installer to use.
var() class<AttachLeechEffect> AttachLeechEffectClass;

// Our persistant Attacher.
var AttachLeechEffect Attacher;

// Drip parameters.
var() class<Decal> DripType;
var() float MinDripTime, MaxDripTime;
var float NextDripTime;

// DamageRates.
var() float PlayerDamageRate;
var() float NPCDamageRate;

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( NextDripTime == 0 )
	{
		NextDripTime = Level.TimeSeconds + RandRange( MinDripTime, MaxDripTime );
	}

	if( Level.TimeSeconds > NextDripTime )
	{
		NextDripTime = Level.TimeSeconds + RandRange( MinDripTime, MaxDripTime );
		Spawn( DripType,,, Location );
	}
}

//------------------------------------------------------------------------------
function ProcessDamage( Actor Other, int GivenDamage, Pawn GivenInstigator, vector HitLocation, vector GivenMomentum )
{
	local int i;
	local Leech L;
/*	
	// Create a leech attacher if we need one.
	if( Attacher == None )
	{
		Attacher = Spawn( AttachLeechEffectClass );
		Attacher.InitializeWithProjectile( Self );
	}
*/
	Attacher = AttachLeechEffect( class'Invokable'.static.GetInstance( Self, AttachLeechEffectClass ) );
	Attacher.InitializeWithProjectile( Self );

	// Set its victim to be the person we just hit.
	Attacher.SetVictim( Pawn(Other) );
	
	for( i = 0; i < ArrayCount(LeechClasses) && LeechClasses[i] != None; i++ )
	{
		// Initialize it with the appropriate Reflector and lifespan.
		Attacher.Initialize( LeechClasses[i], Duration );

		// Damage NPCs more than players.
		if( LeechClasses[i].Name == 'DecreaseHealthLeech' )
		{
			L = Spawn( LeechClasses[i] );
			L.Lifespan = Duration;
			L.InitializeWithProjectile( Self );

			if( WOTPawn(Other) != None )
			{
				L.AffectResolution = NPCDamageRate;
			}
			else
			{
				L.AffectResolution = PlayerDamageRate;
			}

			Attacher.SetLeech( L );
		}

		// Pass it off to our owner for processing.
		if( WOTPlayer(Other) != None )
		{
			WOTPlayer(Other).ProcessEffect( Attacher );
		}
		else if( WOTPawn(Other) != None )
		{
			WOTPawn(Other).ProcessEffect( Attacher );
		}
	}
	
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	local vector Loc;

	if( Destination != None )
	{
		Loc = Destination.Location;
	}
	else
	{
		Loc = DestLoc;
	}

	// NOTE[aleiby]: Account for decay exploding without ever reaching its destination.
	// (i.e. When it hits AMA.)
 	Spawn( class'DecayExplosion', Destination,, Loc );

	Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
     Duration=15.000000
     LeechClasses(0)=Class'Angreal.DecreaseCommonChargesLeech'
     LeechClasses(1)=Class'Angreal.DecreaseUncommonChargesLeech'
     LeechClasses(2)=Class'Angreal.DecreaseRareChargesLeech'
     LeechClasses(3)=Class'WOT.DecreaseHealthLeech'
     AttachLeechEffectClass=Class'Angreal.AttachLeechEffect'
     DripType=Class'ParticleSystems.DecaySplatter'
     MinDripTime=1.000000
     MaxDripTime=2.000000
     PlayerDamageRate=0.200000
     NPCDamageRate=0.100000
     speed=75.000000
     MaxSpeed=800.000000
     SpawnSound=Sound'Angreal.Decay.LaunchDC'
     ImpactSound=Sound'Angreal.Decay.HitDC'
     bAnimLoop=True
     LifeSpan=0.000000
     AnimRate=1.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Angreal.Effects.DC_A01'
     DrawScale=0.800000
     SoundRadius=160
     SoundVolume=255
     AmbientSound=Sound'Angreal.Decay.LoopDC'
     CollisionRadius=6.000000
     CollisionHeight=12.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=64
     LightHue=96
     LightSaturation=128
     LightRadius=8
}
