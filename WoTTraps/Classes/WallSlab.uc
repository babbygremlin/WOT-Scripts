//=============================================================================
// WallSlab.uc
// $Author: Jcrable $
// $Date: 10/13/99 5:52p $
// $Revision: 6 $
//=============================================================================
class WallSlab expands Trap;

#exec MESH IMPORT MESH=WallSlab ANIVFILE=MODELS\Wall\TrapWall_a.3D DATAFILE=MODELS\Wall\TrapWall_d.3D X=0 Y=0 Z=0 UNMIRROR=1 MLOD=0
#exec MESH ORIGIN MESH=WallSlab X=0 Y=0 Z=0 ROLL=64  PITCH=128
#exec MESH SEQUENCE MESH=WallSlab SEQ=All      STARTFRAME=0   NUMFRAMES=1
//#exec TEXTURE IMPORT NAME=WallSlabTex FILE=MODELS\Wall\TrapWall.PCX FAMILY=Skins
#exec TEXTURE IMPORT FILE=Textures\Wall\TrapWall1.PCX NAME=TrapWall1 GROUP=Skins MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\Wall\TrapWall2.PCX NAME=TrapWall2 GROUP=Skins MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Textures\Wall\TrapWall3.PCX NAME=TrapWall3 GROUP=Skins MIPS=Off FLAGS=2
#exec MESHMAP NEW   MESHMAP=WallSlab MESH=WallSlab
#exec MESHMAP SCALE MESHMAP=WallSlab X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=WallSlab NUM=0 TEXTURE=TrapWall1

#exec AUDIO IMPORT FILE=Sounds\Wall\BreakWL.wav				GROUP=Wall
#exec AUDIO IMPORT FILE=Sounds\Wall\DestroyedWL.wav			GROUP=Wall

var (Trap) int		SlabWidth;		 // width of a slab
var (Trap) int		WithstandDamage; // amount of damage the wallslab can withstand
var (Trap) Texture	Stage1Texture;
var (Trap) Texture	Stage2Texture;
var (Trap) Texture	Stage3Texture;
var (Trap) string	DestroyedSoundName;

replication
{
	// Data the server should send to all clients
	unreliable if( Role==ROLE_Authority )
		WithstandDamage;
}

function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name damageType )
{
	if( !IsInactive( None ) ) // for damage, ignore the instigator
	{
		Spawn( class'TrapBurst',,, HitLocation );

		PlaySound( Sound( DynamicLoadObject( DamageSoundName, class'Sound' ) ) );

		WithstandDamage -= Damage;
		if( WithstandDamage > class'WallSlab'.default.WithstandDamage * 2 / 3 ) 
		{
			// Skin = Stage1Texture;
		}
		else if( WithstandDamage > class'WallSlab'.default.WithstandDamage * 1 / 3 ) 
		{
			Skin = Stage2Texture;
		} 
		else if( WithstandDamage > 0 ) 
		{
			Skin = Stage3Texture;
		}
		else
		{
			PlaySound( Sound( DynamicLoadObject( DestroyedSoundName, class'Sound' ) ) );
			Destroy();
		}
	}
}

function bool RemoveResource()
{
    return Owner.RemoveResource();
}

function Actor GetBaseResource()
{
	return Owner;
}

// end of WallSlab.uc

defaultproperties
{
     SlabWidth=28
     WithstandDamage=150
     Stage2Texture=Texture'WOTTraps.Skins.TrapWall2'
     Stage3Texture=Texture'WOTTraps.Skins.TrapWall3'
     DestroyedSoundName="WOTTraps.Wall.DestroyedWL"
     DamageSoundName="WOTTraps.Wall.BreakWL"
     DrawType=DT_Mesh
     Mesh=Mesh'WOTTraps.WallSlab'
     bAlwaysRelevant=True
     CollisionRadius=28.000000
     CollisionHeight=142.000000
     bBlockActors=True
     bBlockPlayers=True
}
