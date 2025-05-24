//=============================================================================
// BaseHUD.uc
// $Author: Mfox $
// $Date: 1/09/00 4:04p $
// $Revision: 32 $
//=============================================================================
class BaseHUD expands MenuHUD;	  

#exec FONT    IMPORT FILE=Fonts\BaseHud\F_Charge.pcx			GROUP=UI
#exec FONT    IMPORT FILE=Fonts\BaseHud\F_Key.pcx				GROUP=UI
#exec FONT    IMPORT FILE=Fonts\BaseHud\F_KeySelected.pcx		GROUP=UI
#exec FONT    IMPORT FILE=Fonts\BaseHud\F_Charge_S.pcx			GROUP=UI
#exec FONT    IMPORT FILE=Fonts\BaseHud\F_Key_S.pcx				GROUP=UI
#exec FONT    IMPORT FILE=Fonts\BaseHud\F_KeySelected_S.pcx		GROUP=UI
#exec TEXTURE IMPORT FILE=Graphics\Warn.pcx						GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Graphics\I_Notch.pcx					GROUP=UI MIPS=Off Flags=2
#exec TEXTURE IMPORT FILE=Graphics\D_Notch.pcx					GROUP=UI MIPS=Off Flags=2

//#if 1 //NEW
//#exec AUDIO	IMPORT FILE=Sounds\Notification\HandNotify.wav	GROUP=Interface
#exec AUDIO		IMPORT FILE=Sounds\Notification\LeftNotify.wav	GROUP=Interface
#exec AUDIO		IMPORT FILE=Sounds\Notification\RightNotify.wav	GROUP=Interface
#exec TEXTURE	IMPORT FILE=Icons\Turtle.pcx					GROUP=UI		MIPS=Off Flags=2
#exec TEXTURE	IMPORT FILE=Icons\TurtleDead.pcx				GROUP=UI		MIPS=Off Flags=2
//#endif

const BaseSizeX 				= 640.0;
const BaseSizeY 				= 480.0;

const HandMessageOffsetY	  	= 96;

// syncronized with InterfaceLevel from uiConsole
const NormalInterface         	= 0;
const MinimizedInterface     	= 1;
const UltraMinimizedInterface 	= 2;

var bool bDrawIdentifyInfo;

//#if 1 //NEW
struct MessageData
{
	var() string Message;
	var() float LifeSpan;
};

struct GenericMessageData
{
	var() string Message;
	var() int X;
	var() int Y;
	var() bool bCenter;
	var() byte Intensity;
	var() Font F;
	var() float LifeSpan;
};

var int InterfaceLevel; // shadow variable from uiConsole (for improved performance)

var MessageData HandMessage;
var MessageData LeftMessages[10];
var MessageData RightMessages[10];
var MessageData CenterMessages[2];
var MessageData SubtitleMessage;
var GenericMessageData GenericMessages[16];

// In seconds.
var() float HandMessageDuration;
var() float LeftMessageDuration;
var() float RightMessageDuration;
var() float CenterMessageDuration;
var() float SubtitleMessageDuration;
var() float GenericMessageDuration;

// 0.0 to 1.0
var() float HandMessageFadePercent;
var() float LeftMessageFadePercent;
var() float RightMessageFadePercent;
var() float CenterMessageFadePercent;
var() float SubtitleMessageFadePercent;
var() float GenericMessageFadePercent;

// Text intensities.
var() byte HandMessageIntensity;
var() byte LeftMessageIntensity;
var() byte RightMessageIntensity;
var() byte CenterMessageIntensity;
var() byte SubtitleMessageIntensity;
var() byte GenericMessageIntensity;

// Audio notifications.
var() Sound HandMessageSound;
var() Sound CenterMessageSound;
var() Sound GenericMessageSound;

var() string LeftMessageName;
var() string RightMessageName;
var() Sound LeftMessageSound;
var() Sound RightMessageSound;

var float LastTimeSeconds;

var() config bool bTurtleEnabled;	// Display turtle if framerate drops below threshold.
var() float TurtleThresholdSP;		// Time bewteen two consecutive frames
var() float TurtleThresholdMP;		// after which performance is considered too slow.
var() float DeadTurtleThresholdSP;	// Unplayable.
var() float DeadTurtleThresholdMP;

var() float TurtleFadeTime;		// How long it takes the turtle to fade out.

// Icon flash support.
var float FlashTextureTime;
var float FlashTextureTimer;
var Texture FlashTexture;

var bool bHideHealth;
var bool bHideStatusIcons;
var bool bHideKeys;
var bool bHideMessages;


// Player ID support.
var float IdentifyFadeTime;
var string IdentifyTarget;
var() config bool  bPlayerIDEnabled;
var() config float PlayerIDTraceLen;
var() config float PlayerIDYOffsetRatio;
//#endif

//=============================================================================

var bool  bDrawHand;
var bool  AllowMinimizedInterface;
var bool  WarningEnabled;
var int   ScaledSizeX;
var int   ScaledSizeY;
var int   HandOffsetY;

const IconWidth 	= 64;
const IconHeight 	= 64;
const NotchWidth 	= 8;

var() float    TimeOut;
var float      TriggerTime;
var float      TriggerWarningTime;

replication
{
    // Functions the server replicates to the client player only
	reliable if( Role==ROLE_Authority && bNetOwner )
		SelectItem,
		UpdateTime;
}

//=============================================================================

function PreBeginPlay()
{
	Super.PreBeginPlay();

	PlayerIDTraceLen			= FClamp( PlayerIDTraceLen, 0.0, 65535.0 );	
	PlayerIDYOffsetRatio		= FClamp( PlayerIDYOffsetRatio, 0.0, 1.0 );
}

//=============================================================================
// functions called externally
//-----------------------------------------------------------------------------
simulated function SetWarning()
{
	TriggerWarningTime = Level.TimeSeconds;
}

// Call this to make a little red light warning light appear to notify you 
// that something bad is happening with your code.  
// Pass in a valid object so we can perform a foreach search.  
// (Self will do in most cases.)
static function ClientWarn( Actor Helper )
{
	local BaseHUD IterHUD;

	foreach Helper.AllActors( class'BaseHUD', IterHUD )
	{
		IterHUD.WarningEnabled = true;	// NOTE[aleiby]: Why have a configurable variable if we're just going to override it anyway?
		IterHUD.SetWarning();
	}
}

//=============================================================================

simulated function SelectItem()
{
	bDrawHand  = true;
	TriggerTime = Level.TimeSeconds;
}

//=============================================================================

simulated function ChangeHud( int d )
{
}

//=============================================================================

simulated event PreRender( canvas C )
{
	local WOTPlayer Player;

	Super.PreRender( C );

	if( SizeX == 0 || SizeX >= BaseSizeX ) 
	{
		ScaledSizeX = SizeX;
	} 
	else 
	{
		ScaledSizeX = BaseSizeX;
	}

	if( SizeY == 0 || SizeY >= BaseSizeY ) 
	{
		ScaledSizeY = SizeY;
	} 
	else 
	{
		ScaledSizeY = BaseSizeY;
	}

	LegendCanvas(C).SetScale();

	InterfaceLevel = uiConsole( PlayerPawn(Owner).Player.Console ).InterfaceLevel;

	Player = WOTPlayer(Owner);
	if( Player != None && Player.CurrentHandSet != None )
	{
		Player.CurrentHandSet.Update();
	}
	
	HandOffsetY = ScaledSizeY - IconHeight;
}

//=============================================================================

simulated function DrawMinimizedHands( Canvas C )
{
    local int		i, j, k;
	local int		x, y;
	local int		SelectedIndex;
	local string	CountStr;
	local HandSet	CurrentHandSet;
    local HandInfo	Hand;
	local name ItemName;
	local Inventory Inv;
	local class<WOTInventory> InvClass;

	C.Style = ERenderStyle.STY_NORMAL;

	CurrentHandSet = WOTPlayer(Owner).CurrentHandSet;
	if( CurrentHandSet != None ) 
	{
		// draw the central active Angreal
		x = ( ScaledSizeX - IconWidth ) / 2;
		y = ScaledSizeY - IconHeight;

		Hand = CurrentHandSet.GetSelectedHand();
		if( Hand != None )
		{
			ItemName = Hand.GetSelectedClassName();
			Inv = Hand.GetSelectedItem();

			// hack to select forward if current item is empty
			if( ItemName == '' && !Hand.IsEmpty() )
			{
				SelectedIndex = Hand.Selected;
				Hand.SelectFirst();
				ItemName = Hand.GetSelectedClassName();
				Inv = WOTPlayer(Owner).FindInventoryName( ItemName );
				Hand.Selected = SelectedIndex;
			}					   

			if( ItemName != '' )
			{
				// draw item icon
				if( Inv != None )
				{
					Inv.DrawStatusIconAt( C, x + IconWidth * i, y );
				}
				else
				{
					InvClass = class<WOTInventory>( class'Util'.static.LoadClassFromName( ItemName ) );
					LegendCanvas( C ).DrawIconAt( InvClass.default.StatusIcon, x, y );
				}
				
				// draw item charge count
				if( AngrealInventory(Inv) != None ) 
				{
					if( AngrealInventory(Inv).ChargeCost == 0 ) 
					{
						CountStr = ":"; // The infinity is stored after the 9, where the : symbol lives.
					}
					else 
					{
						CountStr = string( AngrealInventory( Inv ).CurCharges );
					}
				} 
				else if( WOTInventory(Inv) != None )
				{
					CountStr = string( WOTInventory( Inv ).Count );
				}
				else
				{
					CountStr = "0";
				}

				LegendCanvas( C ).DrawScaledTextAt( x + IconWidth * i + 1, y + IconHeight / 2 - 12, int( ( CurrentHandSet.Selected + 1 ) % 10 ), font'F_KeySelected', false );

				// charges # should be centered under tile as value changes
				LegendCanvas( C ).DrawScaledTextAt( x + IconWidth / 2 + 2, y + 3 * IconHeight / 4 + 3, CountStr, font'F_Charge', false, false, true );
			}
		}

		if( InterfaceLevel == MinimizedInterface || bDrawHand ) 
		{
			y = ScaledSizeY - IconHeight / 2;

			// slide the item off the screen
			if( InterfaceLevel == UltraMinimizedInterface ) 
			{
				y += ( IconHeight / 2 ) * ( Level.TimeSeconds - TriggerTime ) / TimeOut;
			}

			// Now draw smaller hands
			for( i = 0; i < CurrentHandSet.GetArrayCount(); ++i )
			{
				if( i < CurrentHandSet.GetArrayCount() / 2 ) 
				{
					x = ( ScaledSizeX - IconWidth ) / 2 + ( i - CurrentHandSet.GetArrayCount() / 2 ) * IconWidth / 2;
				}
				else
				{
					x = ( ScaledSizeX + IconWidth ) / 2 + ( i - CurrentHandSet.GetArrayCount() / 2 ) * IconWidth / 2;
				}

				Hand = CurrentHandSet.GetHand( i );
				if( Hand != None && Hand.GetSelectedClassName() != '' ) 
				{
					Inv = Hand.GetSelectedItem();
					if( WOTInventory(Inv) != None )
					{
						LegendCanvas( C ).DrawIconAt( WOTInventory(Inv).StatusIconFrame, x, y, 0.5 );
					}
					else
					{
						InvClass = class<WOTInventory>( class'Util'.static.LoadClassFromName( Hand.GetSelectedClassName() ) );
						LegendCanvas( C ).DrawIconAt( InvClass.default.StatusIconFrame, x, y, 0.5 );
					}
				}
			}
		}
	}
}

//=============================================================================

simulated function DrawNormalHands( Canvas C )
{
    local int		i, j, k;
	local int		x, y;
	local int		SelectedIndex;
	local int		ItemCount;
    local HandSet	CurrentHandSet;
    local HandInfo	Hand;
	local name		ItemName;
	local Inventory Inv;
	local class<WOTInventory> InvClass;
	local Texture T;
	local string CountStr;
	local font HandNumFont;

	C.Style = ERenderStyle.STY_NORMAL;

	CurrentHandSet = WOTPlayer(Owner).CurrentHandSet;
	if( CurrentHandSet != None ) 
	{
		x = ( ScaledSizeX - CurrentHandSet.GetArrayCount() * IconWidth ) / 2;
		y = HandOffsetY;

		for( i = 0; i < CurrentHandSet.GetArrayCount(); ++i )
		{
			Hand = CurrentHandSet.GetHand( i );
			if( Hand != None )
			{
				ItemName = Hand.GetSelectedClassName();
				Inv = Hand.GetSelectedItem();

				// hack to select forward if current item is empty
				if( ItemName == '' && !Hand.IsEmpty() )
				{
					SelectedIndex = Hand.Selected;
					Hand.SelectFirst();
					ItemName = Hand.GetSelectedClassName();
					Inv = WOTPlayer(Owner).FindInventoryName( ItemName );
					Hand.Selected = SelectedIndex;
				}

				if( ItemName != '' )
				{
					// draw item icon
					if( Inv != None )
					{
						Inv.DrawStatusIconAt( C, x + IconWidth * i, y );
					}
					else
					{
						InvClass = class<WOTInventory>( class'Util'.static.LoadClassFromName( ItemName ) );
						LegendCanvas( C ).DrawIconAt( InvClass.default.StatusIcon, x + IconWidth * i, y );
					}

					// draw selected highlight and hand numbers
					if( Hand == CurrentHandSet.GetSelectedHand() && Hand.GetSelectedClassName() != '' )
					{
						C.Style = ERenderStyle.STY_Masked;
						LegendCanvas( C ).DrawIconAt( class'WOTInventory'.default.StatusIconSelected, x + IconWidth * i, y );
						C.Style = ERenderStyle.STY_Normal;

						HandNumFont = font'F_KeySelected';
					}
					else
					{
						HandNumFont = font'F_Key';
					}
					LegendCanvas( C ).DrawScaledTextAt( x + IconWidth * i + 1, y + IconHeight / 2 - 12, int( ( i + 1 ) % 10 ), HandNumFont, false, false );

					// draw item charge count
					if( AngrealInventory(Inv) != None )
					{
						if( AngrealInventory(Inv).ChargeCost == 0 ) 
						{
							CountStr = ":";
						}
						else 
						{
							CountStr = string( AngrealInventory( Inv ).CurCharges );
						}
					} 
					else if( WOTInventory(Inv) != None ) 
					{
						CountStr = string( WOTInventory( Inv ).Count );
					}
					else
					{
						CountStr = "0";
					}
					
					// charges # should be centered under tile as value changes
					LegendCanvas( C ).DrawScaledTextAt( x + IconWidth * i + IconWidth/2 + 2, y + 3 * IconHeight / 4 + 3, CountStr, font'F_Charge', false, false, true );

					// draw tick marks
					ItemCount = 0;
					SelectedIndex = 0;
					for( j = 0; j < Hand.GetArrayCount(); j++ ) 
					{
						if( Hand.GetClassName( j ) != '' ) 
						{
							if( j == Hand.Selected )
							{
								SelectedIndex = ItemCount;
							}
							ItemCount++;
						}
					}

					C.Style = ERenderStyle.STY_Masked;
					for( j = 0; j < ItemCount; j++ ) 
					{
						if( j == SelectedIndex )
						{
							T = Texture'I_Notch';
						}
						else
						{
							T = Texture'D_Notch';
						}
						LegendCanvas( C ).DrawIconAt( T, x + IconWidth * ( 2 * i + 1 ) / 2 + NotchWidth * ( 2 * j - ItemCount ) / 2, y );
					}
					C.Style = ERenderStyle.STY_Normal;
				}
			}
		}
	}
}

//=============================================================================

simulated function DrawCurrentHand( Canvas C )
{
	local int i;
	local int j;
	local int X;
	local int Y;
	local HandInfo Hand;
	local int ItemCount;
	local name ItemName;
	local Inventory Inv;
	local class<WOTInventory> ItemClass;
	local Texture FrameIcon;

	C.Style = ERenderStyle.STY_NORMAL;

	if( WOTPlayer( Owner ).CurrentHandSet != None ) 
	{
		Hand = WOTPlayer( Owner ).CurrentHandSet.GetSelectedHand();
		if( Hand != None ) 
		{
			ItemCount = Hand.GetItemCount();

			// compute the position of the first item based on the interface style and number of items
			if( InterfaceLevel != NormalInterface && AllowMinimizedInterface )
			{
				X = ScaledSizeX / 2 - ItemCount * IconWidth / 4;
				Y = ScaledSizeY - 3 * IconHeight / 2;
			}
			else
			{
				X = ( ScaledSizeX - WOTPlayer( Owner ).CurrentHandSet.GetArrayCount() * IconWidth ) / 2;
				X += ( 2 * WOTPlayer( Owner ).CurrentHandSet.Selected + 1 ) * IconWidth / 2;
				Y =  HandOffsetY - IconHeight / 2;

				if( X - ItemCount * IconWidth / 4 < 0 ) 
				{
					X = 0;
				}
				else if( X + ItemCount * IconWidth / 4 > ScaledSizeX  ) 
				{
					X = ScaledSizeX - ItemCount * IconWidth / 2;
				}
				else
				{
					X -= ItemCount * IconWidth / 4;
				}
			}

			// draw all items in the hand (scaled to 50% normal size)
			j = 0;
			for( i = 0; i < Hand.GetArrayCount(); i++ ) 
			{
				ItemName = Hand.GetClassName( i );
				if( ItemName != '' )
				{
					// draw the item
					Inv = Hand.GetItem( i );
					if( Inv != None )
					{
						FrameIcon = WOTInventory(Inv).StatusIconFrame;
					}
					else
					{
						ItemClass = class<WOTInventory>( class'Util'.static.LoadClassFromName( ItemName ) );
						FrameIcon = ItemClass.default.StatusIconFrame;
					}
					LegendCanvas( C ).DrawIconAt( FrameIcon, X + j * IconWidth / 2, Y, 0.5 );

					// draw the selection highlight
					if( i == Hand.Selected ) 
					{
						C.Style = ERenderStyle.STY_Masked;
						LegendCanvas( C ).DrawIconAt( class'WOTInventory'.default.StatusIconFrame, X + j * IconWidth / 2, Y, 0.5 );
						C.Style = ERenderStyle.STY_NORMAL;
					}

					j++;
				}
			}
		}
	}
}

//=============================================================================

simulated function DrawAddedItems( Canvas C )
{
	local int i;
	local int X;
	local int Y;
	local HandSet CurrentHandSet;
	local HandInfo Hand;

	C.Style = ERenderStyle.STY_NORMAL;

	CurrentHandSet = WOTPlayer(Owner).CurrentHandSet;
	if( CurrentHandSet != None )
	{
		for( i = 0; i < CurrentHandSet.GetArrayCount(); i++ ) 
		{
			Hand = WOTPlayer( Owner ).CurrentHandSet.GetHand( i );
			if( Hand != None && Hand.ItemAdded != '' )
			{
				if( Level.TimeSeconds - Hand.ItemAddedTime > TimeOut || Level.TimeSeconds < Hand.ItemAddedTime )
				{
					Hand.ItemAdded = '';
				} 
				else
				{
					X = ( ScaledSizeX - CurrentHandSet.GetArrayCount() * IconWidth ) / 2;
					X += ( 4 * i + 1 ) * IconWidth / 4;
					Y = HandOffsetY - IconHeight / 2;

					Y += ( IconHeight / 2 ) * ( Level.TimeSeconds - Hand.ItemAddedTime ) / TimeOut;

					LegendCanvas( C ).DrawIconAt( class<WOTInventory>( class'Util'.static.LoadClassFromName( Hand.ItemAdded ) ).default.StatusIconFrame, X, Y, 0.5 );
				}
			}
		}
	}
}

//=============================================================================

simulated function DrawStatusIcons( Canvas C )
{
}

//=============================================================================

simulated function DrawKeys( Canvas C )
{
}

//=============================================================================

simulated function DrawHealth( Canvas C )
{
}

//=============================================================================

simulated function DrawWarning( Canvas C )
{
	if( Level.TimeSeconds - TriggerWarningTime < TimeOut )
	{
		LegendCanvas( C ).DrawIconAt( Texture'Warn', ( ScaledSizeX - 16 ) / 2 , 0 );
	}
}

//=============================================================================

simulated function UpdateTime()
{
	if( Level.TimeSeconds - TriggerTime > TimeOut )
	{
		bDrawHand = false;
	}
}

//=============================================================================

simulated function DrawHands( Canvas C )
{
	if( InterfaceLevel == NormalInterface || !AllowMinimizedInterface ) 
	{
		DrawNormalHands( C );
	}
	else
	{
		DrawMinimizedHands( C );
	}
}

//=============================================================================

simulated function DrawProgressMessage( Canvas C )
{
	local int i;
	local float YOffset, XL, YL;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.bCenter = true;

	C.SetFont( Font'WOT.F_WOTReg14' );
	C.StrLen( "TEST", XL, YL );
	YOffset = 0;
	for( i = 0; i < ArrayCount(class'PlayerPawn'.default.ProgressMessage); i++ )
	{
		C.SetPos( 0, 0.25 * C.ClipY + YOffset );
		C.DrawColor = PlayerPawn(Owner).ProgressColor[i];
		C.DrawText( PlayerPawn(Owner).ProgressMessage[i], false );
		YOffset += YL + 1;
	}

	C.bCenter = false;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
}

//=============================================================================

simulated function PostRender( Canvas C )
{
	local float DeltaTime;
	local WOTPlayer Player;

    Super.PostRender( C );

	Player = WOTPlayer(Owner);
	if( Player == None )
		return;

	if( !bHide && !Player.bShowMenu && Level.LevelAction == LEVACT_None || Level.LevelAction == LEVACT_Saving )
	{
		if( !bHideHealth )
		{
			DrawHealth( C );
		}

		if( !bHideStatusIcons )
		{
			DrawStatusIcons( C );
		}

		if( !bHideKeys )
		{
			DrawKeys( C );
		}

		// draw hands for main interface and inventory interface (through overridden functions)
		if( bDrawHand )
		{
			DrawCurrentHand( C );
		}
		else if( InterfaceLevel == NormalInterface )
		{
			DrawAddedItems( C );
		}
		DrawHands( C );

//#if 1 //NEW
		// Get DeltaTime.
		DeltaTime = Level.TimeSeconds - LastTimeSeconds;
		LastTimeSeconds = Level.TimeSeconds;

		if( Player.ProgressTimeOut > Level.TimeSeconds )
		{
			DrawProgressMessage( C );
		}

		if( !bHideMessages )
		{
			DrawMessages( C, DeltaTime );
		}

		if( bTurtleEnabled )
		{
			UpdateTurtle( DeltaTime );
		}
		
		// Player ID
		if( bPlayerIDEnabled && (Level.NetMode != NM_Standalone || Level.Game.IsA( 'giCombatBase' ) ) )
		{
			UpdatePlayerID( C, DeltaTime );
		}

		if( FlashTextureTimer > 0.0 )
		{
			DrawFlashTexture( C, DeltaTime );
		}
//#endif

		// draw debug warning
		if( WarningEnabled ) 
		{
			DrawWarning( C );
		}
	}
	UpdateTime();
}

//=============================================================================
//#if 1 //NEW
//------------------------------------------------------------------------------
// + Displays a message above the hands.
// + Only one message will be displayed at a time.  New messages will simply
//   overwrite the current one.
// + The message will be displayed for HandMessageDuration seconds, and fade out
//   over the last HandMessageFadePercent of its duration.
// + Plays HandMessageSound.
//------------------------------------------------------------------------------

simulated function AddHandMessage( string Message, optional float Duration )
{
	// Play sound.
	if( HandMessageSound != None && PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientPlaySound( HandMessageSound );
	}

	HandMessage.Message = Message;
	if( Duration > 0.0 )
	{
		HandMessage.LifeSpan = Duration;
	}
	else
	{
		HandMessage.LifeSpan = HandMessageDuration;
	}
}

//------------------------------------------------------------------------------
// Adds a message to the left side of the screen.
// Left justified.
// Below the health/key icons.
// Only stores up to 6 messages.
// Messages last for LeftMessageDuration seconds.
// Messages fade out over LeftMessageFadePercent of its duration.
// Plays LeftMessageSound.
//------------------------------------------------------------------------------
simulated function AddLeftMessage( string Message, optional float Duration )
{
	local int i;

	// Play sound.
	if( LeftMessageSound == None && LeftMessageName != "" )
	{
		LeftMessageSound = Sound( DynamicLoadObject( LeftMessageName, class'Sound' ) );
	}
	if( LeftMessageSound != None && PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientPlaySound( LeftMessageSound );
	}

	// Slide existing messages down...
	for( i = ArrayCount(LeftMessages) - 1; i > 0; i -= 1 )
	{
		LeftMessages[i].Message = LeftMessages[i-1].Message;
		LeftMessages[i].LifeSpan = LeftMessages[i-1].LifeSpan;
	}

	// Insert new message on top.
	LeftMessages[0].Message = Message;
	if( Duration > 0.0 )
	{
		LeftMessages[0].LifeSpan = Duration;
	}
	else
	{
		LeftMessages[0].LifeSpan = LeftMessageDuration;
	}

	PlayerPawn(Owner).Player.Console.Message( None, Message, 'Message' );
}

//------------------------------------------------------------------------------
// Adds a message to the right side of the screen.
// Right justified.
// Below the health/key icons.
// Only stores up to 6 messages.
// Messages last for RightMessageDuration seconds.
// Messages fade out over RightMessageFadePercent of its duration.
// Plays RightMessageSound.
//------------------------------------------------------------------------------
simulated function AddRightMessage( string Message, optional float Duration )
{
	local int i;

	// Play sound.
	if( RightMessageSound == None && RightMessageName != "" )
	{
		RightMessageSound = Sound( DynamicLoadObject( RightMessageName, class'Sound' ) );
	}
	if( RightMessageSound != None && PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientPlaySound( RightMessageSound );
	}

	// Slide existing messages down...
	for( i = ArrayCount(RightMessages) - 1; i > 0; i -= 1 )
	{
		RightMessages[i].Message = RightMessages[i-1].Message;
		RightMessages[i].LifeSpan = RightMessages[i-1].LifeSpan;
	}

	// Insert new message on top.
	RightMessages[0].Message = Message;
	if( Duration > 0.0 )
	{
		RightMessages[0].LifeSpan = Duration;
	}
	else
	{
		RightMessages[0].LifeSpan = RightMessageDuration;
	}

	PlayerPawn(Owner).Player.Console.Message( None, Message, 'Message' );
}

//------------------------------------------------------------------------------
// Adds a message to the Center side of the screen.
// Center justified.
// Below the health/key icons.
// Only stores up to 6 messages.
// Messages last for CenterMessageDuration seconds.
// Messages fade out over CenterMessageFadePercent of its duration.
// Plays CenterMessageSound.
//------------------------------------------------------------------------------
simulated function AddCenterMessage( string Message, optional float Duration, optional bool bEcho )
{
	local int i;

	// Play sound.
	if( CenterMessageSound != None && PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientPlaySound( CenterMessageSound );
	}

	// Slide existing messages down...
	for( i = ArrayCount(CenterMessages) - 1; i > 0; i -= 1 )
	{
		CenterMessages[i].Message = CenterMessages[i-1].Message;
		CenterMessages[i].LifeSpan = CenterMessages[i-1].LifeSpan;
	}

	// Insert new message on top.
	CenterMessages[0].Message = Message;
	if( Duration > 0.0 )
	{
		CenterMessages[0].LifeSpan = Duration;
	}
	else
	{
		CenterMessages[0].LifeSpan = CenterMessageDuration;
	}

	if( bEcho )
	{
		PlayerPawn(Owner).Player.Console.Message( None, Message, 'Message' );
	}
}

//------------------------------------------------------------------------------
// Adds a subtitle message to the Center of the screen.
// Center justified, near the top.
// Only stores up to 1 messages.
// Messages last for CenterMessageDuration seconds.
// Messages fade out over CenterMessageFadePercent of its duration.
//------------------------------------------------------------------------------
simulated function AddSubtitleMessage( string Message, optional float Duration, optional bool bEcho )
{
	// Insert new message on top.
	SubtitleMessage.Message = Message;
	if( Duration > 0.0 )
	{
		SubtitleMessage.LifeSpan = Duration;
	}
	else
	{
		SubtitleMessage.LifeSpan = CenterMessageDuration;
	}

	if( bEcho )
	{
		PlayerPawn(Owner).Player.Console.Message( None, Message, 'Message' );
	}
}

//------------------------------------------------------------------------------
// Adds a generic message to the screen.
// Center justified.
// At the specified location.
// Only stores up to 16 messages.
// Messages last for GenericMessageDuration seconds.
// Messages fade out over GenericMessageFadePercent of its duration.
// Plays GenericMessageSound.
//------------------------------------------------------------------------------
simulated function AddGenericMessage( string Message, int X, int Y, bool bCenter, byte Intensity, Font F, optional float Duration )
{
	local int i;

	// Play sound.
	if( GenericMessageSound != None && PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ClientPlaySound( GenericMessageSound );
	}

	// Slide existing messages down...
	for( i = ArrayCount(GenericMessages) - 1; i > 0; i -= 1 )
	{
		GenericMessages[i].Message = GenericMessages[i-1].Message;
		GenericMessages[i].X = GenericMessages[i-1].X;
		GenericMessages[i].Y = GenericMessages[i-1].Y;
		GenericMessages[i].bCenter = GenericMessages[i-1].bCenter;
		GenericMessages[i].Intensity = GenericMessages[i-1].Intensity;
		GenericMessages[i].F = GenericMessages[i-1].F;
		GenericMessages[i].LifeSpan = GenericMessages[i-1].LifeSpan;
	}

	// Insert new message on top.
	GenericMessages[0].Message = Message;
	GenericMessages[0].X = X;
	GenericMessages[0].Y = Y;
	GenericMessages[0].bCenter = bCenter;
	GenericMessages[0].Intensity = Intensity;
	
	if( F != None )
	{
		GenericMessages[0].F = F;
	}
	else
	{
		GenericMessages[0].F = Font'WOT.F_WOTReg14';
	}
		
	if( Duration > 0.0 )
	{
		GenericMessages[0].LifeSpan = Duration;
	}
	else
	{
		GenericMessages[0].LifeSpan = GenericMessageDuration;
	}

	PlayerPawn(Owner).Player.Console.Message( None, Message, 'Message' );
}

//=============================================================================

simulated function DrawMessages( Canvas C, float DeltaTime )
{
	local int i, j;
	local float TextX, TextY;
	local float Text1X, Text1Y;
	local int X, Y;
	local float FadeTime;
	local float Scale;
	local float OldOrgX, OldClipX;

	// Update message lifespans.
	if( HandMessage.LifeSpan > 0.0 )
	{
		HandMessage.LifeSpan = FMax( HandMessage.LifeSpan - DeltaTime, 0.0 );
	}
	for( i = 0; i < ArrayCount(LeftMessages); i++ )
	{
		if( LeftMessages[i].LifeSpan > 0.0 )
		{
			LeftMessages[i].LifeSpan = FMax( LeftMessages[i].LifeSpan - DeltaTime, 0.0 );
		}
	}
	for( i = 0; i < ArrayCount(RightMessages); i++ )
	{
		if( RightMessages[i].LifeSpan > 0.0 )
		{
			RightMessages[i].LifeSpan = FMax( RightMessages[i].LifeSpan - DeltaTime, 0.0 );
		}
	}
	for( i = 0; i < ArrayCount(CenterMessages); i++ )
	{
		if( CenterMessages[i].LifeSpan > 0.0 )
		{
			CenterMessages[i].LifeSpan = FMax( CenterMessages[i].LifeSpan - DeltaTime, 0.0 );
		}
	}
	if( SubtitleMessage.LifeSpan > 0.0 )
	{
		SubtitleMessage.LifeSpan = FMax( SubtitleMessage.LifeSpan - DeltaTime, 0.0 );
	}
	for( i = 0; i < ArrayCount(GenericMessages); i++ )
	{
		if( GenericMessages[i].LifeSpan > 0.0 )
		{
			GenericMessages[i].LifeSpan = FMax( GenericMessages[i].LifeSpan - DeltaTime, 0.0 );
		}
	}

	C.Style = ERenderStyle.STY_Translucent;
	C.SetFont( Font'WOT.F_WOTReg14' );
	
	// Draw HandMessage
	if( HandMessage.LifeSpan > 0.0 && HandMessageIntensity > 0 )
	{
		C.DrawColor.R = HandMessageIntensity;
		C.DrawColor.G = HandMessageIntensity;
		C.DrawColor.B = HandMessageIntensity;
		FadeTime = HandMessageDuration * HandMessageFadePercent;
		if( HandMessage.LifeSpan < FadeTime )
		{
			Scale = HandMessage.LifeSpan / FadeTime;
			C.DrawColor.R = C.DrawColor.R * Scale;
			C.DrawColor.G = C.DrawColor.G * Scale;
			C.DrawColor.B = C.DrawColor.B * Scale;
		}
		C.TextSize( HandMessage.Message, TextX, TextY );
		LegendCanvas(C).DrawTextAt( (C.SizeX - TextX) / 2, C.SizeY - (LegendCanvas(C).ScaleValY(HandMessageOffsetY) + TextY), HandMessage.Message );
	}

	// Draw LeftMessages
	if( LeftMessageIntensity > 0 )
	{
		X = 0;
		Y = LegendCanvas(C).ScaleValY(80);
		FadeTime = LeftMessageDuration * LeftMessageFadePercent;
		for( i = 0; i < ArrayCount(LeftMessages); i++ )
		{
			if( LeftMessages[i].LifeSpan > 0.0 )
			{
				C.DrawColor.R = LeftMessageIntensity;
				C.DrawColor.G = LeftMessageIntensity;
				C.DrawColor.B = LeftMessageIntensity;
				if( LeftMessages[i].LifeSpan < FadeTime )
				{
					Scale = LeftMessages[i].LifeSpan / FadeTime;
					C.DrawColor.R = C.DrawColor.R * Scale;
    				C.DrawColor.G = C.DrawColor.G * Scale;
					C.DrawColor.B = C.DrawColor.B * Scale;
				}
				C.TextSize( LeftMessages[i].Message, TextX, TextY );
				LegendCanvas(C).DrawTextAt( X, Y, LeftMessages[i].Message );
				Y += TextY;
			}
		}
	}

	// Draw RightMessages
	if( RightMessageIntensity > 0 )
	{
		Y = LegendCanvas(C).ScaleValY(80);
		FadeTime = RightMessageDuration * RightMessageFadePercent;
		for( i = 0; i < ArrayCount(RightMessages); i++ )
		{
			if( RightMessages[i].LifeSpan > 0.0 )
			{
				C.DrawColor.R = RightMessageIntensity;
				C.DrawColor.G = RightMessageIntensity;
				C.DrawColor.B = RightMessageIntensity;
				if( RightMessages[i].LifeSpan < FadeTime )
				{
					Scale = RightMessages[i].LifeSpan / FadeTime;
					C.DrawColor.R = C.DrawColor.R * Scale;
					C.DrawColor.G = C.DrawColor.G * Scale;
					C.DrawColor.B = C.DrawColor.B * Scale;
				}
				C.TextSize( RightMessages[i].Message, TextX, TextY );
				X = C.SizeX - TextX - 1;
				LegendCanvas(C).DrawTextAt( X, Y, RightMessages[i].Message );
				Y += TextY;
			}
		}
	}

	// Draw CenterMessages
	if( CenterMessageIntensity > 0 )
	{
		C.TextSize( " ", TextX, TextY );
		Y = TextY;
		FadeTime = CenterMessageDuration * CenterMessageFadePercent;
		for( i = 0; i < ArrayCount(CenterMessages); i++ )
		{
			if( CenterMessages[i].LifeSpan > 0.0 )
			{
				C.DrawColor.R = CenterMessageIntensity;
				C.DrawColor.G = CenterMessageIntensity;
				C.DrawColor.B = CenterMessageIntensity;
				if( CenterMessages[i].LifeSpan < FadeTime )
				{
					Scale = CenterMessages[i].LifeSpan / FadeTime;
					C.DrawColor.R = C.DrawColor.R * Scale;
					C.DrawColor.G = C.DrawColor.G * Scale;
					C.DrawColor.B = C.DrawColor.B * Scale;
				}
				C.TextSize( CenterMessages[i].Message, TextX, TextY );
				// draw centered text
				LegendCanvas(C).DrawTextAt( (C.SizeX - TextX) / 2, Y, CenterMessages[i].Message );
				Y += TextY;
			}
		}
	}

	// Draw SubtitleMessage
	if( SubtitleMessageIntensity > 0 )
	{
		Y = LegendCanvas(C).ScaleValY(24);
		FadeTime = SubtitleMessageDuration * SubtitleMessageFadePercent;
   		if( SubtitleMessage.LifeSpan > 0.0 )
   		{
   			C.DrawColor.R = SubtitleMessageIntensity;
   			C.DrawColor.G = SubtitleMessageIntensity;
   			C.DrawColor.B = SubtitleMessageIntensity;
   			if( SubtitleMessage.LifeSpan < FadeTime )
   			{
   				Scale = SubtitleMessage.LifeSpan / FadeTime;
   				C.DrawColor.R = C.DrawColor.R * Scale;
   				C.DrawColor.G = C.DrawColor.G * Scale;
   				C.DrawColor.B = C.DrawColor.B * Scale;
   			}

   			OldOrgX	= C.OrgX;
   			OldClipX = C.ClipX;

			// show in center 8/10ths of top of screen?
   			C.OrgX = C.SizeX/10;
   			C.ClipX	= 8*C.SizeX/10;

   			C.SetPos( 0, 0 );
			C.StrLen( SubtitleMessage.Message, TextX, TextY );
			C.StrLen( "X", Text1X, Text1Y );

			// center if only 1 line
			C.bCenter = ( TextY <= Text1Y );

   			C.DrawText( SubtitleMessage.Message, false );

   			C.OrgX = OldOrgX;
   			C.ClipX	= OldClipX;
			C.bCenter = false;
		}
	}

	// Draw GenericMessages
	if( GenericMessageIntensity > 0 )
	{
		FadeTime = GenericMessageDuration * GenericMessageFadePercent;
		for( i = 0; i < ArrayCount(GenericMessages); i++ )
		{
			C.bCenter = GenericMessages[i].bCenter;
			
			if( GenericMessages[i].LifeSpan > 0.0 )
			{
				if( GenericMessages[i].Intensity > 0 )
				{
					C.DrawColor.R = GenericMessages[i].Intensity;
					C.DrawColor.G = GenericMessages[i].Intensity;
					C.DrawColor.B = GenericMessages[i].Intensity;
				}
				else	
				{
					C.DrawColor.R = GenericMessageIntensity;
					C.DrawColor.G = GenericMessageIntensity;
					C.DrawColor.B = GenericMessageIntensity;
				}
				
				if( GenericMessages[i].LifeSpan < FadeTime )
				{
					Scale = GenericMessages[i].LifeSpan / FadeTime;
					C.DrawColor.R = C.DrawColor.R * Scale;
					C.DrawColor.G = C.DrawColor.G * Scale;
					C.DrawColor.B = C.DrawColor.B * Scale;
				}
				
				C.SetPos( LegendCanvas(C).ScaleValX(GenericMessages[i].X), LegendCanvas(C).ScaleValY(GenericMessages[i].Y) );
				C.SetFont( GenericMessages[i].F );
				C.DrawText( GenericMessages[i].Message );
			}
		}
		C.bCenter = false;
	}

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	C.SetPos( 0, 0 );			
	C.SetFont( Font'WOT.F_WOTReg14' );
	C.Style = ERenderStyle.STY_Normal;
}

//=============================================================================

simulated function SetFlashTexture( Texture T, optional float Duration )
{
	if( Duration > 0.0 )
		FlashTextureTime = Duration;
	else
		FlashTextureTime = 1.0;

	FlashTexture = T;
	FlashTextureTimer = FlashTextureTime;
}

//=============================================================================

simulated function DrawFlashTexture( Canvas C, float DeltaTime )
{
	local byte Intensity;
	
	if( FlashTexture != None )
	{
		C.Style = ERenderStyle.STY_Translucent;
		Intensity = 255 * FMin( (FlashTextureTimer / FlashTextureTime), 1.0 );
		C.DrawColor.R = Intensity;
		C.DrawColor.G = Intensity;
		C.DrawColor.B = Intensity;

		LegendCanvas( C ).DrawIconAt( FlashTexture, ScaledSizeX - 64, 64 );

		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.Style = ERenderStyle.STY_Normal;
	}

	FlashTextureTimer -= DeltaTime;
}

//=============================================================================

simulated function UpdateTurtle( float DeltaTime )
{
	local float TurtleThreshold;
	local float DeadTurtleThreshold;

	// Get thresholds.
	if( Level.Netmode == NM_Standalone )
	{
		TurtleThreshold = TurtleThresholdSP;
		DeadTurtleThreshold = DeadTurtleThresholdSP;
	}
	else
	{
		TurtleThreshold = TurtleThresholdMP;
		DeadTurtleThreshold = DeadTurtleThresholdMP;
	}

	// Check frame difference.
	if( DeltaTime > DeadTurtleThreshold )
	{
		SetFlashTexture( Texture'WOT.UI.TurtleDead', TurtleFadeTime );
	}
	else if( DeltaTime > TurtleThreshold )
	{
		SetFlashTexture( Texture'WOT.UI.Turtle', TurtleFadeTime );
	}
}

//=============================================================================

exec function GetRidOfTurtle()
{
	bTurtleEnabled = False;
}

//=============================================================================

exec function BringBackTurtle()
{
	bTurtleEnabled = True;
}

//=============================================================================

exec function SetTurtleFadeTime( float Time )
{
	TurtleFadeTime = Time;
}
//#endif


// Player ID functions
simulated function UpdatePlayerID( canvas Canvas, float DeltaTime )
{
	IdentifyFadeTime = FMax(0.0, IdentifyFadeTime - DeltaTime * 85);

	if ( TraceIdentify( Canvas ) )
	{
		Canvas.SetFont( Font'WOT.F_WOTReg14' );
		Canvas.SetPos( 0.0, Canvas.SizeY*PlayerIDYOffsetRatio );
		Canvas.Style = 3;
		Canvas.DrawColor.R = 1 * (IdentifyFadeTime * 0.5 );
		Canvas.DrawColor.G = 1 * (IdentifyFadeTime * 0.5 );
		Canvas.DrawColor.B = 1 * (IdentifyFadeTime * 0.5 );

		Canvas.bCenter = true;
		Canvas.DrawText( IdentifyTarget, false );
		Canvas.bCenter = false;
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		Canvas.Style = 1;
	}
}



simulated function bool TraceIdentify(canvas Canvas)
{
	local actor Other;
	local vector HitLocation, HitNormal, StartTrace;
	local Pawn PawnOwner;
	local Pawn HitPawn;

	PawnOwner = Pawn( Owner );

	StartTrace    = PawnOwner.Location;
	StartTrace.Z += PawnOwner.BaseEyeHeight;

	Other = class'Util'.static.TraceRecursive( Owner, HitLocation, HitNormal, StartTrace, true,, Vector(PawnOwner.ViewRotation), PlayerIDTraceLen );

	if( Other.IsA( 'AngrealIllusionProjectile' ) )
	{
		HitPawn = Pawn( AngrealIllusionProjectile(Other).ReplicatedOwner );
	}
	else
	{
		HitPawn = Pawn( Other );
	}

	if ( HitPawn != None && HitPawn.bIsPlayer && !HitPawn.bHidden )
	{
		if( HitPawn.PlayerReplicationInfo.DisguiseName != "" )
		{
			IdentifyTarget = HitPawn.PlayerReplicationInfo.DisguiseName;
		}
		else
		{
			IdentifyTarget = HitPawn.PlayerReplicationInfo.PlayerName;
		}

		IdentifyFadeTime = 350.0;
	}

	return ( (IdentifyFadeTime != 0.0) && (IdentifyTarget != "") );
}

defaultproperties
{
     HandMessageDuration=1.500000
     LeftMessageDuration=10.000000
     RightMessageDuration=10.000000
     CenterMessageDuration=5.000000
     SubtitleMessageDuration=5.000000
     GenericMessageDuration=5.000000
     HandMessageFadePercent=0.500000
     LeftMessageFadePercent=0.200000
     RightMessageFadePercent=0.200000
     CenterMessageFadePercent=0.250000
     SubtitleMessageFadePercent=0.250000
     GenericMessageFadePercent=0.250000
     HandMessageIntensity=255
     LeftMessageIntensity=255
     RightMessageIntensity=255
     CenterMessageIntensity=255
     SubtitleMessageIntensity=255
     GenericMessageIntensity=255
     LeftMessageName="WOT.Interface.LeftNotify"
     RightMessageName="WOT.Interface.RightNotify"
     TurtleThresholdSP=0.050000
     TurtleThresholdMP=0.050000
     DeadTurtleThresholdSP=0.083333
     DeadTurtleThresholdMP=0.066666
     TurtleFadeTime=1.000000
     bPlayerIDEnabled=True
     PlayerIDTraceLen=32767.000000
     PlayerIDYOffsetRatio=0.667000
     ScaledSizeX=640
     ScaledSizeY=480
     TimeOut=1.500000
}
