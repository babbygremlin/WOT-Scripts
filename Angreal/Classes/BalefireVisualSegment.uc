//------------------------------------------------------------------------------
// BalefireVisualSegment.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	Streak effect for balefire.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireVisualSegment expands Effects;

#exec MESH IMPORT MESH=BF010 ANIVFILE=MODELS\BF010_a.3d DATAFILE=MODELS\BF010_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BF010 X=-303 Y=0 Z=0

#exec MESH SEQUENCE MESH=BF010 SEQ=All   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BF010 SEQ=BF010 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBF0101 FILE=MODELS\Balefire2.PCX GROUP=Skins FLAGS=2 // BFIRE

#exec MESHMAP NEW   MESHMAP=BF010 MESH=BF010
#exec MESHMAP SCALE MESHMAP=BF010 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BF010 NUM=0 TEXTURE=JBF0101

#exec TEXTURE IMPORT FILE=MODELS\BFbeam01.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam02.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam03.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam04.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam05.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam06.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam07.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam08.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam09.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam10.PCX GROUP=BalefireBeam FLAGS=2
#exec TEXTURE IMPORT FILE=MODELS\BFbeam11.PCX GROUP=BalefireBeam FLAGS=2

var() float SegmentLength;

//var float InitialLifeSpan;

var() vector StartPoint, EndPoint;

var bool bInitialized;

var() Texture BFTextures[11];

var float BFAnimRate;
var float BFAnimFrame;

replication
{
	reliable if( Role==ROLE_Authority && StartPoint!=EndPoint )
		StartPoint, EndPoint;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	//InitialLifeSpan = LifeSpan;
	Super.PreBeginPlay();

	BFAnimRate = ArrayCount(BFTextures) / LifeSpan;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( !bInitialized )
	{
		bInitialized = true;
		if( StartPoint != EndPoint )
		{
			SetEndpoints( StartPoint, EndPoint );
		}
	}

	//ScaleGlow = default.ScaleGlow * LifeSpan / InitialLifeSpan;

	BFAnimFrame += BFAnimRate * DeltaTime;
	Texture = BFTextures[ int(BFAnimFrame) ];

	//Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function SetEndpoints( vector Start, vector End )
{
	local vector P;
	local vector Dir;
	local vector Interval;
	local rotator Rot;
	local Actor A;

	if( Start != End )
	{
		// Send to client to do.
		StartPoint = Start;
		EndPoint = End;

		// Precalc vars.
		Dir = Normal(End - Start);
		Interval = Dir * SegmentLength;
		Rot = rotator(Dir);

		// Create and align segments.
		SetLocation( Start );
		SetRotation( Rot );

		for( P = Start + Interval; class'Util'.static.VectorAproxEqual( Dir, Normal(End - P) ); P += Interval )
		{
			A = Spawn( Class, Owner, Tag, P, Rot );
			A.RemoteRole = ROLE_None;
			A.LifeSpan = LifeSpan;
		}
	}
}

defaultproperties
{
     SegmentLength=3190.000000
     BFTextures(0)=Texture'Angreal.BalefireBeam.BFbeam01'
     BFTextures(1)=Texture'Angreal.BalefireBeam.BFbeam02'
     BFTextures(2)=Texture'Angreal.BalefireBeam.BFbeam03'
     BFTextures(3)=Texture'Angreal.BalefireBeam.BFbeam04'
     BFTextures(4)=Texture'Angreal.BalefireBeam.BFbeam05'
     BFTextures(5)=Texture'Angreal.BalefireBeam.BFbeam06'
     BFTextures(6)=Texture'Angreal.BalefireBeam.BFbeam07'
     BFTextures(7)=Texture'Angreal.BalefireBeam.BFbeam08'
     BFTextures(8)=Texture'Angreal.BalefireBeam.BFbeam09'
     BFTextures(9)=Texture'Angreal.BalefireBeam.BFbeam10'
     BFTextures(10)=Texture'Angreal.BalefireBeam.BFbeam11'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.200000
     DrawType=DT_Mesh
     Style=STY_Translucent
     bMustFace=False
     Texture=Texture'Angreal.BalefireBeam.BFbeam01'
     Mesh=Mesh'Angreal.BF010'
     DrawScale=100.000000
     AmbientGlow=254
     bUnlit=True
     RenderIteratorClass=Class'Legend.AlwaysFaceRI'
}
