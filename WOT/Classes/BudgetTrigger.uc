//=============================================================================
// BudgetTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//
//=============================================================================
class BudgetTrigger expands Trigger;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	log( Self$" in state "$ GetStateName() );
}

state() GivePlayerBudget
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local WOTPlayer Player;
		local BudgetInfo B;

		Player = WOTPlayer(EventInstigator);
		if( Player != None )
		{
			Player.Budget = None;
			foreach AllActors( class'BudgetInfo', B, Event )
			{
				assert( Player.Budget == None );
				Player.Budget = B;
			}
		}
		else
		{
			warn( "( "$ Other $", "$ EventInstigator $" ) unable to locate player" );
		}
	}
}

state() RemovePlayerBudget
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local WOTPlayer Player;

		Player = WOTPlayer(EventInstigator);
		if( Player != None )
		{
			Player.Budget = None;
		}
		else
		{
			warn( "( "$ Other $", "$ EventInstigator $" ) unable to locate player" );
		}
	}
}

state() EnableEditExit
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local WOTPlayer P, Player;

		Player = WOTPlayer(EventInstigator);
		if( Player == None )
		{
log( Self$" Searching:" );
			foreach AllActors( class'WOTPlayer', P )
			{
log( "  Found "$ P );
				Player = P;
			}
		}
		if( Player != None )
		{
			Player.bProhibitEditorExit = false;
		}
		else
		{
			warn( "( "$ Other $", "$ EventInstigator $" ) unable to locate player" );
		}
	}
}

state() DisableEditExit
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local WOTPlayer Player;

		Player = WOTPlayer(EventInstigator);
		if( Player != None )
		{
			Player.bProhibitEditorExit = true;
		}
		else
		{
			warn( "( "$ Other $", "$ EventInstigator $" ) unable to locate player" );
		}
	}
}

// end of BudgetTrigger.uc

defaultproperties
{
     InitialState=GivePlayerBudget
}
