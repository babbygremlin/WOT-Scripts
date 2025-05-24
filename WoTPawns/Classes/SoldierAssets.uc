//=============================================================================
// SoldierAssets.
//=============================================================================
class SoldierAssets expands ShieldUser;

#exec MESH IMPORT MESH=Soldier ANIVFILE=MODELS\Soldier_a.3d DATAFILE=MODELS\Soldier_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Soldier X=-20 Y=0 Z=-20

#exec MESH SEQUENCE MESH=Soldier SEQ=All             STARTFRAME=0 NUMFRAMES=354
#exec MESH SEQUENCE MESH=Soldier SEQ=ATTACKRUNLUNGE  STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Soldier SEQ=ATTACKRUNSHIELD STARTFRAME=15 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Soldier SEQ=ATTACKRUNSWIPE  STARTFRAME=30 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Soldier SEQ=BREATH          STARTFRAME=45 NUMFRAMES=10		Group=Waiting
#exec MESH SEQUENCE MESH=Soldier SEQ=CHECKSWORD      STARTFRAME=55 NUMFRAMES=45
#exec MESH SEQUENCE MESH=Soldier SEQ=CROUCH          STARTFRAME=100 NUMFRAMES=5
#exec MESH SEQUENCE MESH=Soldier SEQ=DEATHB          STARTFRAME=105 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Soldier SEQ=DEATHF          STARTFRAME=130 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Soldier SEQ=DODGELEFT       STARTFRAME=145 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Soldier SEQ=DODGERIGHT      STARTFRAME=146 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Soldier SEQ=FALL            STARTFRAME=147 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Soldier SEQ=GETUP           STARTFRAME=148 NUMFRAMES=11					// TBD: not used at present     
#exec MESH SEQUENCE MESH=Soldier SEQ=HITB            STARTFRAME=162 NUMFRAMES=1		Group=TakeHit	                                
#exec MESH SEQUENCE MESH=Soldier SEQ=HITBHARD        STARTFRAME=159 NUMFRAMES=8		Group=TakeHit	// AniFix: 3rd frame of HitBHard
#exec MESH SEQUENCE MESH=Soldier SEQ=HITCROUCH       STARTFRAME=167 NUMFRAMES=2		Group=TakeHit                                
#exec MESH SEQUENCE MESH=Soldier SEQ=HITF            STARTFRAME=174 NUMFRAMES=1		Group=TakeHit	// AniFix: 5th frame of HitFHard
#exec MESH SEQUENCE MESH=Soldier SEQ=HITFHARD        STARTFRAME=169 NUMFRAMES=8		Group=TakeHit                                
#exec MESH SEQUENCE MESH=Soldier SEQ=JUMP            STARTFRAME=177 NUMFRAMES=1						// AniFix: only 1 frame needed  
#exec MESH SEQUENCE MESH=Soldier SEQ=LANDED          STARTFRAME=180 NUMFRAMES=10	Group=Landing	// ANIFIX: start with 2nd frame
#exec MESH SEQUENCE MESH=Soldier SEQ=LISTEN          STARTFRAME=189 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Soldier SEQ=LOOK            STARTFRAME=209 NUMFRAMES=30	Group=Waiting
#exec MESH SEQUENCE MESH=Soldier SEQ=REACTP          STARTFRAME=239 NUMFRAMES=9						// AniFix: zap last 16 frames
#exec MESH SEQUENCE MESH=Soldier SEQ=RECOVER         STARTFRAME=264 NUMFRAMES=20					// Questioner only animation 
#exec MESH SEQUENCE MESH=Soldier SEQ=RUN             STARTFRAME=284 NUMFRAMES=15	                             
#exec MESH SEQUENCE MESH=Soldier SEQ=SHLDHURL        STARTFRAME=299 NUMFRAMES=15					// Questioner only animation 
#exec MESH SEQUENCE MESH=Soldier SEQ=TURNCRCH        STARTFRAME=314 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Soldier SEQ=WALK            STARTFRAME=339 NUMFRAMES=15

// "created" anims:
#exec MESH SEQUENCE MESH=Soldier SEQ=CROUCHING       STARTFRAME=330 NUMFRAMES=5		// use frames from TURNCRCH
// needed
#exec MESH SEQUENCE MESH=soldier SEQ=REACTPLOOP      STARTFRAME=248 NUMFRAMES=1   // +9 ReactP

#exec TEXTURE IMPORT NAME=JSoldier1 FILE=MODELS\Soldier1.PCX GROUP=Skins FLAGS=2 // Soldier1

#exec MESHMAP NEW   MESHMAP=Soldier MESH=Soldier
#exec MESHMAP SCALE MESHMAP=Soldier X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Soldier NUM=1 TEXTURE=JSoldier1
#exec MESHMAP SETTEXTURE MESHMAP=Soldier NUM=2 TEXTURE=JSoldier1
#exec MESHMAP SETTEXTURE MESHMAP=Soldier NUM=4 TEXTURE=JSoldier1
#exec MESHMAP SETTEXTURE MESHMAP=Soldier NUM=5 TEXTURE=JSoldier1
#exec MESHMAP SETTEXTURE MESHMAP=Soldier NUM=6 TEXTURE=JSoldier1

#exec TEXTURE IMPORT FILE=Icons\Grunts\H_SoldierDisguise.PCX GROUP=UI MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\Weapon\Shield\Shield_HitPawn1.wav

defaultproperties
{
     DisguiseIcon=Texture'WOTPawns.UI.H_SoldierDisguise'
     Mesh=LodMesh'WOTPawns.Soldier'
}
