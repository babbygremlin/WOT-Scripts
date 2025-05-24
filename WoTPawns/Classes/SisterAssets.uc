//=============================================================================
// SisterAssets.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class SisterAssets expands AngrealUser;

#exec MESH IMPORT MESH=Sister ANIVFILE=MODELS\Sister_a.3d DATAFILE=MODELS\Sister_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Sister X=0 Y=0 Z=-12

#exec MESH SEQUENCE MESH=Sister SEQ=All        STARTFRAME=0 NUMFRAMES=257
#exec MESH SEQUENCE MESH=Sister SEQ=ATTACKRUN  STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Sister SEQ=BREATH     STARTFRAME=29 NUMFRAMES=10	Group=Waiting
#exec MESH SEQUENCE MESH=Sister SEQ=CROSSARMS  STARTFRAME=39 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Sister SEQ=DEATHL     STARTFRAME=59 NUMFRAMES=15
#exec MESH SEQUENCE MESH=Sister SEQ=DODGELEFT  STARTFRAME=74 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Sister SEQ=DODGERIGHT STARTFRAME=75 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Sister SEQ=FALL       STARTFRAME=76 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Sister SEQ=GIVEORDERS STARTFRAME=77 NUMFRAMES=30
#exec MESH SEQUENCE MESH=Sister SEQ=GONG       STARTFRAME=107 NUMFRAMES=13
#exec MESH SEQUENCE MESH=Sister SEQ=HITB       STARTFRAME=121 NUMFRAMES=1	Group=TakeHit	// AniFix: 1 frame, +1 HitBHard
#exec MESH SEQUENCE MESH=Sister SEQ=HITBHARD   STARTFRAME=120 NUMFRAMES=7	Group=TakeHit                               
#exec MESH SEQUENCE MESH=Sister SEQ=HITF       STARTFRAME=130 NUMFRAMES=1	Group=TakeHit	// AniFix: 1 frame, +3 HitFHard
#exec MESH SEQUENCE MESH=Sister SEQ=HITFHARD   STARTFRAME=127 NUMFRAMES=7	Group=TakeHit                               
#exec MESH SEQUENCE MESH=Sister SEQ=JUMP       STARTFRAME=134 NUMFRAMES=1					// AniFix: 1 frame, down from 2
#exec MESH SEQUENCE MESH=Sister SEQ=LANDED     STARTFRAME=137 NUMFRAMES=10	Group=Landing	// ANIFIX: start with 2nd frame
#exec MESH SEQUENCE MESH=Sister SEQ=LOOK       STARTFRAME=146 NUMFRAMES=30	Group=Waiting
#exec MESH SEQUENCE MESH=Sister SEQ=REACTP     STARTFRAME=176 NUMFRAMES=7
#exec MESH SEQUENCE MESH=Sister SEQ=RUN        STARTFRAME=196 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Sister SEQ=SHOOT      STARTFRAME=225 NUMFRAMES=3
#exec MESH SEQUENCE MESH=Sister SEQ=WALK       STARTFRAME=228 NUMFRAMES=29

// needed
#exec MESH SEQUENCE MESH=Sister SEQ=REACTPLOOP STARTFRAME=183 NUMFRAMES=1  // AniFix: reactp, frame #8

#exec MESH NOTIFY MESH=Sister SEQ=Shoot        TIME=0.10  FUNCTION=ShootRangedAmmo

#exec MESH NOTIFY MESH=Sister SEQ=Walk	       TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Sister SEQ=Walk	       TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Sister SEQ=Run	       TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Sister SEQ=Run	       TIME=0.87 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Sister SEQ=ReactP       TIME=0.01 FUNCTION=PlayAnimSound
#exec MESH NOTIFY MESH=Sister SEQ=ReactPLoop   TIME=0.01 FUNCTION=PlayAnimSound

//#exec MESH NOTIFY MESH=Sister SEQ=DeathB			TIME=0.70 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Sister SEQ=DeathL			TIME=0.38 FUNCTION=TransitionToCarcassNotification

#exec TEXTURE IMPORT NAME=JSisterGreen1 FILE=MODELS\SisterGreen1.PCX GROUP=Skins FLAGS=2 // Ajah1

#exec MESHMAP NEW   MESHMAP=Sister MESH=Sister
#exec MESHMAP SCALE MESHMAP=Sister X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Sister NUM=1 TEXTURE=JSisterGreen1
#exec MESHMAP SETTEXTURE MESHMAP=Sister NUM=2 TEXTURE=JSisterGreen1

#exec TEXTURE IMPORT FILE=Icons\Captains\H_SisterDisguise.PCX GROUP=UI MIPS=Off

defaultproperties
{
     DisguiseIcon=Texture'WOTPawns.UI.H_SisterDisguise'
     Mesh=LodMesh'WOTPawns.Sister'
     DrawScale=0.680000
     CollisionRadius=17.000000
     CollisionHeight=46.000000
     Mass=120.000000
}
