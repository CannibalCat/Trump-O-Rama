package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.text.FlxTypeText;

class WantedListState extends FlxState
{
	private var textTimer:FlxTimer;
	private var background:FlxSprite;
	private var titleLogo:FlxSprite;
	private var wantedFrame:FlxSprite;
	private var wantedBackdrop:FlxBackdrop;
	private var typedText:FlxTypeText;
	private var wantedNameText:FlxTypeText;
	private var typingSound:FlxSound;
	private var startText:FlxText;
	private var copyrightText:FlxText;
	private var descriptionComplete:Bool = false;
	private var exitDialogActive:Bool = false;
	private var showStartText:Bool = true;
	private var attractTimer:Float = 10;
	private var messageNum:Int = 1;
	private var wantedCharacter:FlxSprite;
	
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);

		return gamepad;
	}
	
	override public function create():Void
	{
		typingSound = new FlxSound();
		typingSound.loadStream("assets/sounds/Type.wav", false, false);
		add(typingSound);
		
		wantedBackdrop = new FlxBackdrop("assets/images/WantedBackdrop.png", 1, 0, true, false);
		wantedBackdrop.setPosition(61, 205);
		wantedBackdrop.velocity.set(-85, 0);
		add(wantedBackdrop);
		
		background = new FlxSprite(0, 0, "assets/images/FBI.png");
		add(background); 

		titleLogo = new FlxSprite(0, 0, "assets/images/MostWantedLogo.png");
		titleLogo.setPosition(FlxG.width / 2 - titleLogo.width / 2, 60);
		add(titleLogo); 
		
		wantedNameText = new FlxTypeText(360, 201, FlxG.width - 30, getNextWantedName(), 48, false);
		wantedNameText.font = Globals.TEXT_FONT;
		wantedNameText.showCursor = false;
		wantedNameText.autoErase = false;
		wantedNameText.color = 0xFFFFFF;
		wantedNameText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		add(wantedNameText);
		
		typedText = new FlxTypeText(360, 253, FlxG.width - 30, getNextWantedDescription(), 48, false);
		typedText.font = Globals.TEXT_FONT;
		typedText.showCursor = false;
		typedText.autoErase = false;
		typedText.color = 0xFFFFFF;
		typedText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		add(typedText);
		
		switch Globals.nextWantedProfile
		{
			case 1:
				{
					wantedCharacter = new FlxSprite(150, 360); 
					wantedCharacter.loadGraphic("assets/images/Niqabi.png", true, 72, 122, true);
					wantedCharacter.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					wantedCharacter.animation.play("walk");
					wantedCharacter.scale.set(2, 2);
					add(wantedCharacter);	
				}
				
			case 2:
				{
					wantedCharacter = new FlxSprite(80, 338); 
					wantedCharacter.loadGraphic("assets/images/Panther.png", true, 152, 144, true);
					wantedCharacter.animation.add("walk", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 10, true);
					wantedCharacter.animation.play("walk");
					wantedCharacter.scale.set(2, 2);
					add(wantedCharacter);	
				}
				
			case 3:
				{
					wantedCharacter = new FlxSprite(150, 324); 
					wantedCharacter.loadGraphic("assets/images/Cleric.png", true, 72, 158, true);
					wantedCharacter.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					wantedCharacter.animation.play("walk");
					wantedCharacter.scale.set(2, 2);
					add(wantedCharacter);	
				}
				
			case 4:
				{
					wantedCharacter = new FlxSprite(150, 376); 
					wantedCharacter.loadGraphic("assets/images/Laborer.png", true, 64, 106, true);
					wantedCharacter.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					wantedCharacter.animation.play("walk");
					wantedCharacter.scale.set(2, 2);
					add(wantedCharacter);	
				}
				
			case 5:
				{
					wantedCharacter = new FlxSprite(125, 316); 
					wantedCharacter.loadGraphic("assets/images/Bandito.png", true, 136, 162, true);
					wantedCharacter.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
					wantedCharacter.animation.play("walk");
					wantedCharacter.scale.set(2, 2);
					add(wantedCharacter);
				}
		}
		
		wantedNameText.start(0.05, false, false, typingSound, null, onNameComplete);
		
		startText = new FlxText(0, 630, FlxG.width, "PRESS ENTER TO PLAY");
		startText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFF, "center");
		startText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		startText.antialiasing = false;
		add(startText);
		
		copyrightText = new FlxText(0, 700, FlxG.width, "(C) 2016 cannibal cat software and kablooey!");
		copyrightText.setFormat(Globals.TEXT_FONT, 36, 0xFFFFFF, "center");
		copyrightText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		copyrightText.antialiasing = false;
		add(copyrightText);
		
		textTimer = new FlxTimer(1.5, onTextFlash, 0);
		
		super.create();
	}
	
	private function onCloseDialog():Void
	{
		exitDialogActive = false;
	}
	
	private function onNameComplete():Void
	{
		typedText.start(0.05, false, false, typingSound, null, onDescriptionComplete);
	}
	
	private function onDescriptionComplete():Void
	{
		descriptionComplete = true;
	}
	
	private function getNextWantedDescription():String
	{
		var wantedDescription:String = "";
		
		switch Globals.nextWantedProfile 
		{
			case 1:
				{
					wantedDescription = "HEIGHT: 5'2\"\nWEIGHT: 105 TO 115 POUNDS\nBUILD: THIN\nOCCUPATION: UNKNOWN\nHAIR: UNKNOWN\nEYES: THAT'S ALL WE CAN SEE\nCAUTION: DANGEROUS, MIGHT\nHAVE A BOMB UNDER THERE.";
				}
				
			case 2:
				{
					wantedDescription = "HEIGHT: 6'1\"\nWEIGHT: 130 TO 150 POUNDS\nBUILD: ATHLETIC\nOCCUPATION: ACTIVIST\nHAIR: BLACK\nEYES: BROWN\nCAUTION: UNPREDICTABLE,\nARMED AND DANGEROUS.";
				}

			case 3:
				{
					wantedDescription = "HEIGHT: 5'8\"\nWEIGHT: 140 TO 175 POUNDS\nBUILD: MEDIUM\nOCCUPATION: IMAM\nHAIR: BLACK\nEYES: BROWN\nCAUTION: HISTORY OF LYING\nAND BRAINWASHING.";
				}
				
			case 4:
				{
					wantedDescription = "HEIGHT: 4'8\"\nWEIGHT: 100 TO 110 POUNDS\nBUILD: SMALL\nOCCUPATION: VARIOUS\nHAIR: BLACK\nEYES: BROWN\nCAPTURE ALIVE SO THEY CAN\nHELP BUILD THE WALL.";
				}
				
			case 5:
				{
					wantedDescription = "HEIGHT: 5'2\"\nWEIGHT: 125 TO 150 POUNDS\nBUILD: MEDIUM\nOCCUPATION: REVOLUTIONARY\nHAIR: BLACK\nEYES: BROWN\nCAUTION: TRAVELS IN PACKS,\nEXTREMELY DANGEROUS.";
				}
		}		
		
		return wantedDescription;
	}
	
	private function getNextWantedName():String
	{
		var wantedName:String = "";
		
		switch Globals.nextWantedProfile 
		{
			case 1:
				{
					wantedName = "NIQABI";
				}
				
			case 2:
				{
					wantedName = "BLACK PANTHER";
				}

			case 3:
				{
					wantedName = "CLERIC";
				}
				
			case 4:
				{
					wantedName = "DAY LABORER";
				}
				
			case 5:
				{
					wantedName = "BANDITO";
				}
		}		
		
		return wantedName;
	}
	
	private function onTextFlash(timer:FlxTimer):Void
	{
		showStartText = !showStartText;
		
		if (showStartText)
		{
			messageNum++;
			if (messageNum > 2)
				messageNum = 1;
		}
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		startText.color = ColorCycler.WilliamsFlash8;
		wantedNameText.color = ColorCycler.RedPulse;
		
		if (exitDialogActive)
			return;		
			
		if (messageNum == 1)
			startText.text = "PRESS ENTER TO PLAY";
		else
			startText.text = "PRESS SPACE FOR \"HOW TO PLAY\"";		
			
		if (showStartText)
			startText.visible = true;
		else
			startText.visible = false;	
		
		if (descriptionComplete)
			attractTimer -= FlxG.elapsed;
		
		if (attractTimer <= 0)
		{
			Globals.nextWantedProfile += 1;
			if (Globals.nextWantedProfile > Globals.maxWantedProfiles)
				Globals.nextWantedProfile = 1;
				
			if (Globals.nextWantedProfile % 2 != 0)
				FlxG.switchState(new InstructionsState());
			else
				FlxG.switchState(new WarningState()); 
		}
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			persistentUpdate = true;
			exitDialogActive = true;
			var exitDialog = new GameExitState();
			exitDialog.closeCallback = onCloseDialog;
			openSubState(exitDialog);
		}
		
		if (FlxG.keys.justPressed.SPACE)
			FlxG.switchState(new InstructionsState());
		
		if (FlxG.keys.pressed.ENTER || gamepad.justPressed(7) || 
			gamepad.justPressed(LogitechButtonID.TEN))
		{
			Globals.resetGameGlobals(); 
            FlxG.switchState(new NewsFlashState());
		}
			
		super.update();
	}
	
	override public function destroy():Void
	{
		background = null;
		titleLogo = null;
		wantedBackdrop = null;
		copyrightText = null;
		startText = null;
		typedText = null;
		typingSound = null;
		wantedCharacter = null;
		if (textTimer != null)
			textTimer.destroy();
		
		super.destroy();
	}
}