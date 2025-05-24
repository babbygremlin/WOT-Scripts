//=============================================================================
// MessageBoxTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
//=============================================================================
class MessageBoxTrigger expands Trigger;

//=============================================================================
// If triggered and there is a WOTTextWindowInfo in the level whose Tag matches
// the MessageBoxTrigger's Event, calls ShowMessageBox on all players in the
// level (usually only the one in singleplayer but could be used in multiplayer
// to show message to all players). Players have to use F1 (ShowHelp) to close 
// the MessageBox. Can also be triggered by another trigger.
//=============================================================================

function DispatchTrigger( Actor Target, Actor Other, Pawn OtherInstigator )
{
	local WOTPlayer WP;

	if( Target.IsA( 'WOTTextWindowInfo' ) )
	{
		foreach AllActors( class 'WOTPlayer', WP )
		{
			WP.ShowMessageBox( WOTTextWindowInfo( Target ) );
		}
	}
}

//=============================================================================

function Trigger( Actor Other, Pawn EventInstigator )
{
	local WOTTextWindowInfo TextWindowInfo;

	if( Event != '' )
	{
		foreach AllActors( class'WOTTextWindowInfo', TextWindowInfo, Event )
		{
			DispatchTrigger( TextWindowInfo, Other, Other.Instigator );
		}
	}
}

defaultproperties
{
}
