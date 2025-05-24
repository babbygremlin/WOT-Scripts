//=============================================================================
// MyrddraalAssets.
//=============================================================================
class MyrddraalAssets expands Captain;

#exec MESH IMPORT MESH=Myrddraal ANIVFILE=MODELS\Myrddraal_a.3d DATAFILE=MODELS\Myrddraal_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Myrddraal X=0 Y=0 Z=-8

#exec MESH SEQUENCE MESH=Myrddraal SEQ=All             STARTFRAME=0 NUMFRAMES=386
#exec MESH SEQUENCE MESH=Myrddraal SEQ=ATTACKRUNSKEWER STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Myrddraal SEQ=ATTACKRUNSWIPE  STARTFRAME=15 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Myrddraal SEQ=BOWUP           STARTFRAME=317 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Myrddraal SEQ=BOWDOWN         STARTFRAME=317 NUMFRAMES=16		// copy of bowup for sound notification
#exec MESH SEQUENCE MESH=Myrddraal SEQ=BREATH          STARTFRAME=30 NUMFRAMES=10		Group=Waiting
#exec MESH SEQUENCE MESH=Myrddraal SEQ=DEATHB          STARTFRAME=40 NUMFRAMES=30
#exec MESH SEQUENCE MESH=Myrddraal SEQ=DEATHF          STARTFRAME=70 NUMFRAMES=56
#exec MESH SEQUENCE MESH=Myrddraal SEQ=DODGELEFT       STARTFRAME=126 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Myrddraal SEQ=DODGERIGHT      STARTFRAME=127 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Myrddraal SEQ=FALL            STARTFRAME=128 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Myrddraal SEQ=GIVEORDERS      STARTFRAME=129 NUMFRAMES=21
#exec MESH SEQUENCE MESH=Myrddraal SEQ=GONG            STARTFRAME=150 NUMFRAMES=9				// AniFix: Skip last frame, bad
#exec MESH SEQUENCE MESH=Myrddraal SEQ=HITB            STARTFRAME=173 NUMFRAMES=1		Group=TakeHit	// AniFix: 1 frame, +3 HitBHard
#exec MESH SEQUENCE MESH=Myrddraal SEQ=HITBHARD        STARTFRAME=160 NUMFRAMES=10		Group=TakeHit
#exec MESH SEQUENCE MESH=Myrddraal SEQ=HITF            STARTFRAME=175 NUMFRAMES=1		Group=TakeHit	// AniFix: 1 frame, +5 HitFHard
#exec MESH SEQUENCE MESH=Myrddraal SEQ=HITFHARD        STARTFRAME=170 NUMFRAMES=10		Group=TakeHit
#exec MESH SEQUENCE MESH=Myrddraal SEQ=HURT            STARTFRAME=180 NUMFRAMES=11
#exec MESH SEQUENCE MESH=Myrddraal SEQ=JUMP            STARTFRAME=191 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Myrddraal SEQ=LANDED          STARTFRAME=193 NUMFRAMES=8		Group=Landing	// ANIFIX: start with 2nd frame
#exec MESH SEQUENCE MESH=Myrddraal SEQ=LOOK            STARTFRAME=202 NUMFRAMES=35		Group=Waiting
#exec MESH SEQUENCE MESH=Myrddraal SEQ=MYRDTELEPORT    STARTFRAME=237 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Myrddraal SEQ=REACTP          STARTFRAME=238 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Myrddraal SEQ=RUN             STARTFRAME=259 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Myrddraal SEQ=SEEENEMY        STARTFRAME=274 NUMFRAMES=28
#exec MESH SEQUENCE MESH=Myrddraal SEQ=SHOOT           STARTFRAME=302 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Myrddraal SEQ=SWORDDOWN       STARTFRAME=333 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Myrddraal SEQ=SWORDUP         STARTFRAME=352 NUMFRAMES=19		// copy of swordup for sound notification
#exec MESH SEQUENCE MESH=Myrddraal SEQ=WALK            STARTFRAME=371 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Myrddraal SEQ=PRETELEPORT     STARTFRAME=274 NUMFRAMES=14		// first 14 frames of SeeEnemy
// needed
#exec MESH SEQUENCE MESH=Myrddraal SEQ=REACTPLOOP       STARTFRAME=257 NUMFRAMES=1					// Hold last frame of ReactP

#exec TEXTURE IMPORT NAME=JMyrddraal1 FILE=MODELS\Myrddraal1.PCX GROUP=Skins FLAGS=2				// Material #2

// used for weapons:
#exec TEXTURE IMPORT NAME=MMyrddraalWeapons FILE=MODELS\MyrddraalWeapons.pcx FAMILY=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Myrddraal MESH=Myrddraal
#exec MESHMAP SCALE MESHMAP=Myrddraal X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Myrddraal NUM=1 TEXTURE=JMyrddraal1
#exec MESHMAP SETTEXTURE MESHMAP=Myrddraal NUM=2 TEXTURE=JMyrddraal1

#exec TEXTURE IMPORT FILE=Icons\Captains\H_MyrddraalDisguise.PCX GROUP=UI MIPS=Off

defaultproperties
{
     DisguiseIcon=Texture'WOTPawns.UI.H_MyrddraalDisguise'
     Mesh=LodMesh'WOTPawns.Myrddraal'
}
