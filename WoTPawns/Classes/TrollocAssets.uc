//=============================================================================
// TrollocAssets.
//=============================================================================
class TrollocAssets expands Grunt;

#exec MESH IMPORT MESH=Trolloc ANIVFILE=MODELS\Trolloc_a.3d DATAFILE=MODELS\Trolloc_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Trolloc X=0 Y=0 Z=-27


#exec MESH SEQUENCE MESH=Trolloc SEQ=All          STARTFRAME=0 NUMFRAMES=281
#exec MESH SEQUENCE MESH=Trolloc SEQ=ATTACKRUN    STARTFRAME=7 NUMFRAMES=8	// ANIFIX: +7 zap windup frames
#exec MESH SEQUENCE MESH=Trolloc SEQ=ATTACKRUNB   STARTFRAME=20 NUMFRAMES=10	// ANIFIX: +5 zap windup frames
#exec MESH SEQUENCE MESH=Trolloc SEQ=ATTACKTHROW1 STARTFRAME=30 NUMFRAMES=30
#exec MESH SEQUENCE MESH=Trolloc SEQ=BREATH       STARTFRAME=60 NUMFRAMES=10	Group=Waiting    
#exec MESH SEQUENCE MESH=Trolloc SEQ=DEATHB       STARTFRAME=70 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Trolloc SEQ=DEATHC       STARTFRAME=95 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Trolloc SEQ=DEATHF       STARTFRAME=120 NUMFRAMES=28
#exec MESH SEQUENCE MESH=Trolloc SEQ=DODGELEFT    STARTFRAME=148 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Trolloc SEQ=DODGERIGHT   STARTFRAME=149 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Trolloc SEQ=FALL         STARTFRAME=150 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Trolloc SEQ=HITB         STARTFRAME=152 NUMFRAMES=1	Group=TakeHit// ANIFIX: 2nd frame of hitbhard
#exec MESH SEQUENCE MESH=Trolloc SEQ=HITBHARD     STARTFRAME=151 NUMFRAMES=7	Group=TakeHit                                
#exec MESH SEQUENCE MESH=Trolloc SEQ=HITF         STARTFRAME=162 NUMFRAMES=7	Group=TakeHit// ANIFIX: 4th frame of hitfhard
#exec MESH SEQUENCE MESH=Trolloc SEQ=HITFHARD     STARTFRAME=158 NUMFRAMES=7	Group=TakeHit                                
#exec MESH SEQUENCE MESH=Trolloc SEQ=JUMP         STARTFRAME=165 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Trolloc SEQ=LANDED       STARTFRAME=166 NUMFRAMES=9	Group=Landing// ANIFIX: start with 2nd frame
#exec MESH SEQUENCE MESH=Trolloc SEQ=LISTEN       STARTFRAME=177 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Trolloc SEQ=LOOK         STARTFRAME=201 NUMFRAMES=10	Group=Waiting               
#exec MESH SEQUENCE MESH=Trolloc SEQ=REACTP       STARTFRAME=211 NUMFRAMES=10	// ANIFIX: zap last 5 frames
#exec MESH SEQUENCE MESH=Trolloc SEQ=RUN          STARTFRAME=226 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Trolloc SEQ=SCRATCH      STARTFRAME=241 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Trolloc SEQ=WALK         STARTFRAME=266 NUMFRAMES=15

// needed
#exec MESH SEQUENCE MESH=Trolloc SEQ=REACTPLOOP	STARTFRAME=216 NUMFRAMES=5	// ANIFIX: +5 ReactP 

// give trollocs a ranged attack test -- start
#exec MESH NOTIFY MESH=Trolloc SEQ=ATTACKRUNB	TIME=0.75  FUNCTION=ShootRangedAmmo
#exec MESH NOTIFY MESH=Trolloc SEQ=ATTACKTHROW1	TIME=0.17  FUNCTION=ShootRangedAmmo
// give trollocs a ranged attack test -- end

#exec TEXTURE IMPORT NAME=TMonkey	FILE=MODELS\TMonkey.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=TBird		FILE=MODELS\TBird.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=TCat		FILE=MODELS\TCat.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=TWolf		FILE=MODELS\TWolf.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Trolloc MESH=Trolloc
#exec MESHMAP SCALE MESHMAP=Trolloc X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Trolloc NUM=1 TEXTURE=TMonkey

function float	GetShootTweenToTime()				{ return 0.2; }
function float	GetShootAnimRate()					{ return 0.5; }
function Name	GetShootAnimName()					{ return 'ATTACKTHROW1'; }

// testing
function float	GetSeeEnemyTweenToTime()			{ return 0.1; }
function float	GetSeeEnemyAnimRate()				{ return 0.7; }

#exec TEXTURE IMPORT FILE=Icons\Grunts\H_TrollocDisguise.PCX GROUP=UI MIPS=Off

defaultproperties
{
     DisguiseIcon=Texture'WOTPawns.UI.H_TrollocDisguise'
     Mesh=LodMesh'WOTPawns.Trolloc'
}
