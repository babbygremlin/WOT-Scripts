//=============================================================================
// BreakableDecoration.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================
class BreakableDecoration expands WOTDecoration
	abstract;

var() int Health;
var() class<Fragment> fragmentClass;
var() float fragmentSize;
var() int MinDamageVelocityZ;

// lets us control minimum drop needed for decorations to take damage
// the base version in Decoration cuts off at -500 (hard-coded value)
singular function BaseChange()
{
	local float decorMass, decorMass2;

	decormass= FMax(1, Mass);
	bBobbing = false;
	if( Velocity.Z <= -MinDamageVelocityZ)
	{
//		Debug.message( "BreakableDecoration::BaseChange decoration is taking damage" );
		TakeDamage( (1-Velocity.Z/30),Instigator,Location,vect(0,0,0) , 'crushed');
	}
	if( (base == None) && (bPushable || IsA('Carcass')) && (Physics == PHYS_None) )
	{
		SetPhysics(PHYS_Falling);
	}
	else if( (Pawn(base) != None) && (Pawn(Base).CarriedDecoration != self) )
	{
		Base.TakeDamage( (1-Velocity.Z/400)* decormass/Base.Mass,Instigator,Location,0.5 * Velocity , 'crushed');
		Velocity.Z = 100;
		if( FRand() < 0.5)
		{
			Velocity.X += 70;
		}
		else
		{
			Velocity.Y += 70;
		}
		SetPhysics(PHYS_Falling);
	}
	else if( Decoration(Base)!=None && Velocity.Z<-500 )
	{
		decorMass2 = FMax(Decoration(Base).Mass, 1);
		Base.TakeDamage((1 - decorMass/decorMass2 * Velocity.Z/30), Instigator, Location, 0.2 * Velocity, 'stomped');
		Velocity.Z = 100;
		if( FRand() < 0.5 )
		{
			Velocity.X += 70;
		}
		else
		{
			Velocity.Y += 70;
		}
		SetPhysics(PHYS_Falling);
	}
	else
		instigator = None;
}

Auto State Animate
{
	function HitWall (vector HitNormal, actor Wall)
	{
		if( Velocity.Z<-200 )
		{
			TakeDamage( 100, Pawn( Owner ), HitNormal, HitNormal * 10000, 'shattered' );
		}
		bBounce = False;
		Velocity = vect( 0, 0, 0 );
	}


	function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		if(bStatic)
			return;

		Instigator = InstigatedBy;
		bBobbing = false;
		if( Health<=0 )
		{
			Return;
		}
			
		if( Instigator != None )
		{
			MakeNoise( 1.0 );
		}
			
		Health -= NDamage;
		if( Health <= 0 )
		{
//			Debug.message( "Throwing " $ fragmentClass $ ", " $ fragmentSize );
			if( fragmentClass != None )
			{
				Frag(fragmentClass,Momentum,fragmentSize,12);
			}
		}		
		else 
		{
			SetPhysics(PHYS_Falling);
			bBounce = True;
			Momentum.Z = 1000;
			Velocity=Momentum*0.01;
		}
	}

Begin:
}

defaultproperties
{
     Health=10
     MinDamageVelocityZ=500
     bPushable=True
     bStatic=False
     CollisionRadius=29.000000
     CollisionHeight=29.000000
     bCollideWorld=True
     bProjTarget=True
     Mass=50.000000
     Buoyancy=60.000000
}
