//=============================================================================
// EditorHUD.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 19 $
//=============================================================================
class EditorHUD expands MainHUD;

const TRACE_DISTANCE = 3200;	// 200 feet (sync. with WOTPlayer.uc)

var actor OldResource;			// Used for unhighlighting old traps
var actor TempResource;			// show player where the actor would fit
var class<actor> TempResourceClass;

//-----------------------------------------------------------------------------
function PreBeginPlay()
{
	assert( WOTPlayer(Owner) != None );
	Super.PreBeginPlay();
}

//-----------------------------------------------------------------------------
function Destroyed()
{
	DestroyTempResource();
	Super.Destroyed();
}

//-----------------------------------------------------------------------------
simulated function SelectItem()
{
	Super.SelectItem();

	if( OldResource != None )
	{
		WOTPlayer(Owner).ServerDeactivateResource( OldResource, false );
	}
	OldResource = None;
}

//-----------------------------------------------------------------------------
simulated function WOTInventory GetSelectedItem()
{
	local WOTPlayer Player;
	local HandInfo Info;
	local int i;

	Player = WOTPlayer(Owner);
/*
	assert( Player != None );
	assert( Player.CurrentHandSet != None );
	if( Player.CurrentHandSet.GetSelectedHand() == None )
	{
		log( Player );
		log( Player.CurrentHandSet );
		log( "Selected="$ Player.CurrentHandSet.Selected );
		for( i = 0; i < 10; i++ )
		{
			log( "  "$ Player.CurrentHandSet.Hands[i] );
		}
	}
	assert( Player.CurrentHandSet.GetSelectedHand() != None );
	if( Player.CurrentHandSet.GetSelectedHand().GetSelectedClassName() == '' )
	{
		log( Player );
		log( Player.CurrentHandSet );
		log( "Selected="$ Player.CurrentHandSet.Selected );
		for( i = 0; i < 10; i++ )
		{
			log( "  "$ Player.CurrentHandSet.Hands[i] );
		}
		Info = Player.CurrentHandSet.GetSelectedHand();
		log( Info );
		log( "Selected="$ Info.Selected );
		for( i = 0; i < 10; i++ )
		{
			log( "  "$ Info.ClassName[i] @ Info.bHaveThis[i] @ Info.Item[i] );
		}
	}
	assert( Player.CurrentHandSet.GetSelectedHand().GetSelectedClassName() != '' );
*/
	if( Player == None
		|| Player.CurrentHandSet == None
		|| Player.CurrentHandSet.GetSelectedHand() == None
		|| Player.CurrentHandSet.GetSelectedHand().GetSelectedClassName() == '' )
	{
		return None;
	}
	return WOTInventory( Player.CurrentHandSet.GetSelectedHand().GetSelectedItem() );
}

//-----------------------------------------------------------------------------
simulated function bool IsInvalidEditZone()
{
	return WOTZoneInfo(Owner.Region.Zone) == None || !WOTZoneInfo(Owner.Region.Zone).bAllowEditing;
}

//-----------------------------------------------------------------------------
simulated function actor CreateTempResource( class<actor> SpawnClass, vector StartLocation, vector StartNormal )
{
	local vector	Offset;
    local vector    Loc;
	local rotator	Rot;
	local actor		Resource;

	Loc = StartLocation;
	Rot = rotator( StartNormal );
	SpawnClass.static.AdjustSpawnLocation( Owner, Loc, Rot );
    Resource = Spawn( SpawnClass, Owner, , Loc, Rot );
	if( Resource != None ) 
	{
		Resource.bOnlyOwnerSee = true; // other players shouldn't see the item moving around
		Resource.BeginEditingResource( Pawn(Owner).PlayerReplicationInfo.Team );
	}

	return Resource;
}

//-----------------------------------------------------------------------------
simulated function DestroyTempResource()
{
	if( TempResource != None ) 
	{
	    TempResource.Destroy();
		TempResource = None;
	}
	if( TempResourceClass != None )
	{
		WOTPlayer(Owner).ServerEndSelect( TempResourceClass );
	}
	TempResourceClass = None;
}

//-----------------------------------------------------------------------------
simulated function HighlightResource( actor NewResource )
{
	local WOTPlayer Player;

	if( NewResource != OldResource )
	{
		Player = WOTPlayer(Owner);
		if( OldResource != None )
		{
			Player.ServerDeactivateResource( OldResource, false );
		}
		if( NewResource != None )
		{
			Player.ServerActivateResource( NewResource, false );
		}
		OldResource = NewResource;
	}
}

//-----------------------------------------------------------------------------
simulated function SyncTempResourceWithCursor()
{
	local WOTPlayer Player;
	local WOTInventory Item;
	local bool bNoResource;
    local Actor HitActor;
    local vector HitLocation;
    local vector HitNormal;

	// hide and unhide the object as the player moves through the level
	if( IsInvalidEditZone() )
	{
		if( TempResourceClass != None )
		{
			DestroyTempResource();
		}
		goto Finish;
	}

	Player = WOTPlayer( Owner );

	// determine current selection, and delete old the TempResource if necessary
	Item = GetSelectedItem();
	bNoResource = ( Item == None || ( Item.Count < 1 && Item.SpawnTempResource ) );
	if( TempResourceClass != None )
	{
		if( bNoResource || Item.ResourceClass != TempResourceClass )
		{
			DestroyTempResource();
		}
	}
	if( bNoResource ) 
	{
		goto Finish;
	}

	// create the TempResource
	if( TempResource == None )
	{
		TempResourceClass = Item.ResourceClass;
		assert( TempResourceClass != None );
		if( Item.SpawnTempResource )
		{
			TempResource = CreateTempResource( TempResourceClass, GetCursorStart(), GetCursorDirection() );
		}
		else
		{
			Player.ServerBeginSelect( TempResourceClass );
		}
	}

	if( !Item.SpawnTempResource )
	{
		HitActor = Player.EditorTrace( GetCursorDirection(), HitLocation, HitNormal, GetCursorStart(), true, TRACE_DISTANCE );
		HighlightResource( HitActor );
	}
	else if( TempResource != None )
	{
		TempResource.Hide();
		HitActor = Player.EditorTrace( GetCursorDirection(), HitLocation, HitNormal, GetCursorStart(), true, TRACE_DISTANCE );
		TempResource.Show();

	    if( HitActor != None && TempResource.SameLogicalActor( HitActor ) )
		{
		    goto Finish;
		}

		if( HitActor != Level ) 
		{
			TempResource.RemoveResource();
		}
		else if( !TempResource.DeployResource( HitLocation, HitNormal ) )
		{
			TempResource.RemoveResource();
		}
	}

Finish:
	return;
}

//-----------------------------------------------------------------------------
simulated function LeftMouseDown()
{
	local actor			HitActor;
	local vector		HitLocation;
	local vector		HitNormal;
	local WOTPlayer		Player;
	local WOTInventory	Item;

	if( IsInvalidEditZone() )
	{
		return;
	}

	Player = WOTPlayer(Owner);
//Player.ClientMessage( "LeftMouseDown" );

	// remove any active window before editing
	if( uiHUD(Player.myHUD).IsWindowActive() )
	{
		uiHUD(Player.myHUD).RemoveWindows();
		return;
	}

	Item = GetSelectedItem();

	if( TempResource != None )
	{
		TempResource.Hide();
	}
	HitActor = Player.EditorTrace( GetCursorDirection(), HitLocation, HitNormal, GetCursorStart(), true, TRACE_DISTANCE );

	if( HitActor == Level )
	{
		if( Item.Count > 0 && Item.SpawnTempResource ) 
		{
			Player.ServerCreateResource( Item.ResourceClass, HitLocation.X, HitLocation.Y, HitLocation.Z, HitNormal.X, HitNormal.Y, HitNormal.Z );
		}
	}
	else if( HitActor != None )
	{
		if( !HitActor.IsA( 'Portcullis' ) && !HitActor.IsA( 'Staircase' ) )
		{
//			Player.ClientMessage( "Remove "$ HitActor );
			Player.ServerRemoveResource( HitActor );
		}
		else if( HitActor.Class == Item.ResourceClass && Item.Count > 0 )
		{
//			Player.ClientMessage( "Toggle "$ HitActor );
			Player.ServerToggleResource( HitActor );
		}
		else
		{
//			assert( HitActor != None ); // ServerDeactivateResource() assert() was failing... assert() that it's a replication problem!
//			Player.ClientMessage( "Deactivate "$ HitActor );
			Player.ServerDeactivateResource( HitActor, true );
		}
	}
}

//-----------------------------------------------------------------------------
simulated function vector GetCursorStart()
{
    local vector	StartPosition;
	local WOTPlayer	Player;

	Player = WOTPlayer(Owner);
    
	return Player.Location + vect(0,0,1) * Player.EyeHeight;
}

//-----------------------------------------------------------------------------
simulated function int CalcAngle( float X, float Y )
{
    // returns the angle described by X, Y (not implemented for negative X values
    if( X == 0 )
        return 0;
    if( X < 0 )
        return -atan( Y / -X ) * 32768 / PI;
    else if( X > 0 )
        return atan( Y / X ) * 32768 / PI;
}

//-----------------------------------------------------------------------------
simulated function vector GetCursorDirection()
{
    local vector XV, YV, ZV;
	GetAxes( WOTPlayer(Owner).ViewRotation, XV, YV, ZV );
	return XV;
}

//=============================================================================
simulated function PreRender( Canvas C )
{
	Super.PreRender( C );

	SyncTempResourceWithCursor();
}

simulated function DrawCursor( Canvas C )
{
	// mouse movement inhibited by CitadelEditorMouse MoveX/MoveY overrides
	Mouse.Draw( C );
}

simulated function DrawHealth( Canvas C )
{
	// override health drawing in base class
}

// end of EditorHUD.uc

defaultproperties
{
     MouseClass=Class'WOT.CitadelEditorMouse'
     CursorClass=Class'WOT.CitadelEditorCursor'
}
