//------------------------------------------------------------------------------
// TaintVisual.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class TaintVisual expands Effects;

#exec OBJ LOAD FILE=Textures\TaintPartsT.utx PACKAGE=Angreal.TaintVisual

var GenericSprite Assets[5];

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();
	//SetRotation( rot(65536,65536,65536) * FRand() );
	CreateAssets();
}

//------------------------------------------------------------------------------
simulated function CreateAssets()
{
	// Red comet 1.
	Assets[0] = Spawn( class'GenericSprite',,,, rotator(vect(1,0,0)) );
    Assets[0].SetPhysics( PHYS_Rotating );
    Assets[0].Style = STY_Translucent;
    Assets[0].Skin = Texture'Angreal.TaintVisual.TaintRedcomet3';
    Assets[0].DrawScale = 0.700000;
    Assets[0].bFixedRotationDir = true;
    Assets[0].RotationRate = rot(0,0,100000);
	Assets[0].DrawType = DT_Mesh;
	Assets[0].Mesh = Mesh'Angreal.ExpWard';
	Assets[0].bUnlit = true;
	Assets[0].ScaleGlow = 5.000000;
	Assets[0].DrawScale = 1.500000;

	// Red comet 2.
	Assets[1] = Spawn( class'GenericSprite',,,, rotator(vect(0,1,0)) );
    Assets[1].SetPhysics( PHYS_Rotating );
    Assets[1].Style = STY_Translucent;
    Assets[1].Skin = Texture'Angreal.TaintVisual.TaintRedcomet3';
    Assets[1].DrawScale = 0.700000;
    Assets[1].bFixedRotationDir = true;
    Assets[1].RotationRate = rot(0,0,60000);
	Assets[1].DrawType = DT_Mesh;
	Assets[1].Mesh = Mesh'Angreal.ExpWard';
	Assets[1].bUnlit = true;
	Assets[1].ScaleGlow = 5.000000;
	Assets[1].DrawScale = 1.500000;

	// Red comet 3.
	Assets[2] = Spawn( class'GenericSprite',,,, rotator(vect(0,0,1)) );
    Assets[2].SetPhysics( PHYS_Rotating );
    Assets[2].Style = STY_Translucent;
    Assets[2].Skin = Texture'Angreal.TaintVisual.TaintRedcomet3';
    Assets[2].DrawScale = 0.700000;
    Assets[2].bFixedRotationDir = true;
    Assets[2].RotationRate = rot(0,-80000,0);
	Assets[2].DrawType = DT_Mesh;
	Assets[2].Mesh = Mesh'Angreal.ExpWard';
	Assets[2].bUnlit = true;
	Assets[2].ScaleGlow = 5.000000;
	Assets[2].DrawScale = 1.500000;

	// Center.
	Assets[3] = Spawn( class'GenericSprite' );
    Assets[3].Style = STY_Modulated;
    Assets[3].Texture = WetTexture'Angreal.TaintVisual.TntCntrA';
    Assets[3].DrawScale = 0.450000;

	// Inner glow.
	Assets[4] = Spawn( class'GenericSprite' );
    Assets[4].Style = STY_Translucent;
    Assets[4].Texture = Texture'Angreal.TaintVisual.T2';
    Assets[4].DrawScale = 0.090000;
	Assets[4].ScaleGlow = 5.000000;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;
	
	Super.Tick( DeltaTime );

	for( i = 0; i < ArrayCount(Assets); i++ )
	{
		if( Assets[i] != None )
		{
			Assets[i].SetLocation( Location );
		}
	}
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	for( i = 0; i < ArrayCount(Assets); i++ )
	{
		if( Assets[i] != None )
		{
			Assets[i].Destroy();
			Assets[i] = None;
		}
	}

	Super.Destroyed();
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightRadius=7
     LightPeriod=32
}
