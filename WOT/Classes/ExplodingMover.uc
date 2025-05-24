//=============================================================================
// ExplodingMover.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================
class ExplodingMover expands Mover;

#exec Texture Import File=models\exp001.pcx  Name=s_Exp Mips=Off Flags=2

var() float ExplosionSize;
var() float ExplosionDimensions;
var() float WallParticleSize;
var() float WoodParticleSize;
var() float GlassParticleSize;
var() int NumWallChunks;
var() int NumWoodChunks;
var() int NumGlassChunks;
var() texture WallTexture;
var() texture WoodTexture;
var() texture GlassTexture;
var() int Health;
var() name ActivatedBy[5];
var() sound BreakingSound;
var() bool bTranslucentGlass;
var() bool bUnlitGlass;
var() bool bOnlyTriggerable;

state() ExplodingMover
{
}

	singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
		local int i;
		local bool bAbort;	

		if( bOnlyTriggerable )
			return;
		
		if( DamageType != 'All' )
		{
			bAbort = true;
			for( i = 0; i < 5; i++ )	 
				if( ActivatedBy[i] == 'All' || ActivatedBy[i] == DamageType || class'AngrealInventory'.static.DamageTypeContains( DamageType, ActivatedBy[i] ) )
					bAbort = False;
			if( bAbort )
				return;
		}
		
		Health -= NDamage;
		if( Health <= 0 )
		{
			Explode( instigatedBy, momentum );
		}
	}

	singular function Trigger( actor Other, pawn EventInstigator )
	{
		Explode( EventInstigator, Vector(Rotation) );
	}

	function Explode( pawn EventInstigator, vector Momentum )
	{
		local int i;
		local Fragment s;
		local actor A;

		DoOpen();
		
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Instigator, Instigator );

		Instigator = EventInstigator;
		if( Instigator != None )
			MakeNoise( 1.0 );
		
		PlaySound( BreakingSound, SLOT_Interact, 2.0 );
	
		for( i = 0 ; i < NumWallChunks ; i++ )
		{
			s = Spawn( class 'WallFragments',,, Location + ExplosionDimensions * VRand() );
			if( s != None )
			{
				s.CalcVelocity(vect(0,0,0),ExplosionSize);
				s.DrawScale = WallParticleSize;
				s.Skin = WallTexture;
			}
		}
		
		for( i = 0 ; i < NumWoodChunks; i++ ) 
		{
			s = Spawn( class 'WoodFragments',,,Location+ExplosionDimensions*VRand());
			if( s != None )
			{
				s.CalcVelocity(vect(0,0,0),ExplosionSize);
				s.DrawScale = WoodParticleSize;
				s.Skin = WoodTexture;
			}
		}
		
		for( i = 0 ; i < NumGlassChunks; i++ )
		{
			s = Spawn( class 'GlassFragments', Owner,,Location+ExplosionDimensions*VRand());
			if( s != None )
			{
				s.CalcVelocity(Momentum, ExplosionSize);
				s.DrawScale = GlassParticleSize;
				s.Skin = GlassTexture;
				s.bUnlit = bUnlitGlass;
				if( bTranslucentGlass )
					s.Style = STY_Translucent;
			}
		}
	}

// end of ExplodingMover.uc

defaultproperties
{
     ExplosionSize=200.000000
     ExplosionDimensions=120.000000
     WallParticleSize=1.000000
     WoodParticleSize=1.000000
     GlassParticleSize=1.000000
     NumWallChunks=10
     NumWoodChunks=3
     ActivatedBy(0)=All
     MoverEncroachType=ME_IgnoreWhenEncroach
     MoverGlideType=MV_MoveByTime
     MoveTime=0.000000
     bTriggerOnceOnly=True
     InitialState=ExplodingMover
     CollisionRadius=32.000000
     CollisionHeight=32.000000
     bCollideWorld=True
     bProjTarget=True
}
