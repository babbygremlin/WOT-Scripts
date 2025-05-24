//=============================================================================
// MessageTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//
//=============================================================================
class MessageTrigger expands Trigger;

//=============================================================================
// Can be triggered either directly (e.g. by Pawn walking into/shooting trigger
// or through another trigger.

var() localized string Messages[16];	// list of messages -- localized strings in structs in 221 aren't exported properly
var() float FadeOutTime;				// fade out time used for all messages
var() bool bClearPrevious;				// when triggered, clears all previous messages before proceeding

var() struct MessageInfo
{
	var() float		MessageDelay;		// delay *before* displaying message i
	var() int 		MessageX;			// X coordinate of message on HUD
	var() int 		MessageY;			// Y coordinate of message on HUD
	var() bool 		bCenter;			// center text between X coordinate and right edge of screen
	var() byte 		Intensity;			// intensity for text (uses default for HUD if 0)
	var() Font		MessageFont;		// font to use for message i
}
MessageSettings[16];

var int i;

//=============================================================================

state() Waiting
{
	function DispatchTrigger( Actor Target, Actor Other, Pawn OtherInstigator )
	{
		Trigger( Other, Other.Instigator );
	}

	function Trigger( Actor Other, Pawn EventInstigator )
	{
		GotoState( 'Waiting', 'Output' );
	}

	function ShowMessageToPlayers( int MessageIndex )
	{
		local WOTPlayer WP;

		foreach AllActors( class 'WOTPlayer', WP )
		{
			if( MessageIndex != -1 )
			{
				WP.GenericMessage( Messages[MessageIndex], 
								   MessageSettings[MessageIndex].MessageX, 
								   MessageSettings[MessageIndex].MessageY, 
								   MessageSettings[MessageIndex].bCenter, 
								   MessageSettings[MessageIndex].Intensity, 
								   MessageSettings[MessageIndex].MessageFont, 
								   FadeOutTime );
			}
			else
			{
				WP.GenericMessage( "",
								   0,
								   0,
								   true,
								   0,
								   Font'WOT.F_WOTReg14',
								   0.01 );
			}
		}
	}

Output:
	Disable( 'Touch' );
	Disable( 'Trigger' );

	if( bClearPrevious )
	{
		for( i=0; i<ArrayCount(Messages); i++ )
		{
			ShowMessageToPlayers( -1 );
		}
	}

	for( i=0; i<ArrayCount(Messages) && Messages[i] != ""; i++ )
	{
		if( instr( Messages[i], "//" ) != 0 )
		{
			Sleep( MessageSettings[i].MessageDelay );

			ShowMessageToPlayers( i );
		}
	}

	Enable( 'Trigger' );
	Enable( 'Touch' );
}

defaultproperties
{
     FadeOutTime=10.000000
     MessageSettings(0)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(1)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(2)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(3)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(4)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(5)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(6)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(7)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(8)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(9)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(10)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(11)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(12)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(13)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(14)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     MessageSettings(15)=(bCenter=True,Intensity=255,MessageFont=Font'WOT.F_WOTReg14')
     InitialState=Waiting
}
