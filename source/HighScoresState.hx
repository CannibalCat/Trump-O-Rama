package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;
import flixel.input.gamepad.XboxButtonID;
import flixel.text.FlxText;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxBitmapFont;

using StringTools;

class HighScoresState extends FlxState
{
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);

		return gamepad;
	}	
	
	private var textTimer:FlxTimer;
	private var initialTimer:FlxTimer;
	private var background:FlxSprite;
	private var titleLogo1:FlxSprite;
	private var titleLogo2:FlxSprite;
	private var initialsLine1:FlxBitmapFont;
	private var initialsLine1Shadow:FlxBitmapFont;
	private var initialsLine2:FlxBitmapFont;
	private var initialsLine2Shadow:FlxBitmapFont;
	private var initialsLine3:FlxBitmapFont;
	private var initialsLine3Shadow:FlxBitmapFont;
	private var initialsLine4:FlxBitmapFont;
	private var initialsLine4Shadow:FlxBitmapFont;
	private var initialsLine5:FlxBitmapFont;
	private var initialsLine5Shadow:FlxBitmapFont;
	private var initialsLine6:FlxBitmapFont;
	private var initialsLine6Shadow:FlxBitmapFont;
	private var scoreLine1:FlxBitmapFont;
	private var scoreLine1Shadow:FlxBitmapFont;
	private var scoreLine2:FlxBitmapFont;
	private var scoreLine2Shadow:FlxBitmapFont;
	private var scoreLine3:FlxBitmapFont;
	private var scoreLine3Shadow:FlxBitmapFont;
	private var scoreLine4:FlxBitmapFont;
	private var scoreLine4Shadow:FlxBitmapFont;
	private var scoreLine5:FlxBitmapFont;
	private var scoreLine5Shadow:FlxBitmapFont;
	private var scoreLine6:FlxBitmapFont;
	private var scoreLine6Shadow:FlxBitmapFont;
	private var startText:FlxText;
	private var copyrightText:FlxText;
	private var instructionLine1:FlxText;
	private var instructionLine2:FlxText;
	private var instructionLine3:FlxText;
	private var upHighlight:FlxText;
	private var downHighlight:FlxText;
	private var leftHighlight:FlxText;
	private var rightHighlight:FlxText;
	private var enterHighlight:FlxText;
	private var scoresSave:FlxSave;
	private var attractTimer:Float = 10;
	private var messageNum:Int = 1;
	private var playerInitial1:FlxBitmapFont;
	private var playerInitial1Shadow:FlxBitmapFont;
	private var playerInitial2:FlxBitmapFont;
	private var playerInitial2Shadow:FlxBitmapFont;
	private var playerInitial3:FlxBitmapFont;
	private var playerInitial3Shadow:FlxBitmapFont;
	private var playerInitialsIndex:Array<Int> = [ 0, 0, 0 ];
	private var validInitials:Array<String> = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", 
												"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ];
	private var currentSelectInitial:Int = 0;
	private var scoreIndex:Int;
	private var initialsYPos:Float;
	private var playerNameEntryMode:Bool = false;
	private var exitDialogActive:Bool = false;
	private var showStartText:Bool = true;
	private var currentInitialVisible:Bool = true;

	override public function create():Void
	{
		Globals.highScores = new Array<HighScoreData>();
		
		background = new FlxSprite(0, 0, "assets/images/DarkFlag.png");
		add(background); 
		
		scoresSave = new FlxSave();
		scoresSave.bind("highscores");
		
		if (!loadHighScores())
			initializeHighScores();
			
		if (Globals.validatePlayerScore)
		{
			scoreIndex = checkPlayerRanking();
			if (scoreIndex > -1)
				playerNameEntryMode = true;
				
			Globals.validatePlayerScore = false;
		}
		
		if (playerNameEntryMode)
		{
			FlxG.sound.playMusic(Globals.HIGHSCORE_BGM, 0.5, true); 
			FlxG.sound.play("SpecialGuy");
		}
		else
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Globals.ATTRACT_BGM, 0.5, true); 
		}
		
		titleLogo1 = new FlxSprite(0, 0, "assets/images/TruePatriotsLogo.png");
		titleLogo1.setPosition(FlxG.width / 2 - titleLogo1.width / 2, 30);
		titleLogo1.visible = false;
		add(titleLogo1); 
		
		titleLogo2 = new FlxSprite(0, 0, "assets/images/EnterInitialsLogo.png");
		titleLogo2.setPosition(FlxG.width / 2 - titleLogo2.width / 2, 30);
		titleLogo2.visible = false;
		add(titleLogo2); 
		
		initialsLine1Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine1Shadow.setText("1." + Globals.highScores[0].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine1Shadow.setPosition(70 + 4, 165 + 4);
		add(initialsLine1Shadow);
		
		initialsLine1 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine1.setText("1." + Globals.highScores[0].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine1.setPosition(70, 165);
		add(initialsLine1);
		
		scoreLine1Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine1Shadow.setText(Std.string(Globals.highScores[0].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine1Shadow.setPosition(432 + 4, 165 + 4);
		add(scoreLine1Shadow);
		
		scoreLine1 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine1.setText(Std.string(Globals.highScores[0].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine1.setPosition(432, 165);
		add(scoreLine1);
		
		initialsLine2Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine2Shadow.setText("2." + Globals.highScores[1].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine2Shadow.setPosition(70 + 4, 240 + 4);
		add(initialsLine2Shadow);
		
		initialsLine2 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine2.setText("2." + Globals.highScores[1].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine2.setPosition(70, 240);
		add(initialsLine2);
		
		scoreLine2Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine2Shadow.setText(Std.string(Globals.highScores[1].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine2Shadow.setPosition(432 + 4, 240 + 4);
		add(scoreLine2Shadow);
		
		scoreLine2 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine2.setText(Std.string(Globals.highScores[1].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine2.setPosition(432, 240);
		add(scoreLine2);
		
		initialsLine3Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine3Shadow.setText("3." + Globals.highScores[2].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine3Shadow.setPosition(70 + 4, 315 + 4);
		add(initialsLine3Shadow);
		
		initialsLine3 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine3.setText("3." + Globals.highScores[2].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine3.setPosition(70, 315);
		add(initialsLine3);
		
		scoreLine3Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine3Shadow.setText(Std.string(Globals.highScores[2].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine3Shadow.setPosition(432 + 4, 315 + 4);
		add(scoreLine3Shadow);
		
		scoreLine3 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine3.setText(Std.string(Globals.highScores[2].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine3.setPosition(432, 315);
		add(scoreLine3);
		
		initialsLine4Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine4Shadow.setText("4." + Globals.highScores[3].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine4Shadow.setPosition(70 + 4, 390 + 4);
		add(initialsLine4Shadow);
		
		initialsLine4 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine4.setText("4." + Globals.highScores[3].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine4.setPosition(70, 390);
		add(initialsLine4);
		
		scoreLine4Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine4Shadow.setText(Std.string(Globals.highScores[3].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine4Shadow.setPosition(432 + 4, 390 + 4);
		add(scoreLine4Shadow);
		
		scoreLine4 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine4.setText(Std.string(Globals.highScores[3].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine4.setPosition(432, 390);
		add(scoreLine4);
		
		initialsLine5Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png",62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine5Shadow.setText("5." + Globals.highScores[4].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine5Shadow.setPosition(70 + 4, 465 + 4);
		add(initialsLine5Shadow);
		
		initialsLine5 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine5.setText("5." + Globals.highScores[4].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine5.setPosition(70, 465);
		add(initialsLine5);
		
		scoreLine5Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine5Shadow.setText(Std.string(Globals.highScores[4].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine5Shadow.setPosition(432 + 4, 465 + 4);
		add(scoreLine5Shadow);	
		
		scoreLine5 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine5.setText(Std.string(Globals.highScores[4].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine5.setPosition(432, 465);
		add(scoreLine5);
		
		initialsLine6Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine6Shadow.setText("6." + Globals.highScores[5].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine6Shadow.setPosition(70 + 4, 540 + 4);
		add(initialsLine6Shadow);
		
		initialsLine6 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		initialsLine6.setText("6." + Globals.highScores[5].PlayerInitials, false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		initialsLine6.setPosition(70, 540);
		add(initialsLine6);
		
		scoreLine6Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine6Shadow.setText(Std.string(Globals.highScores[5].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine6Shadow.setPosition(432 + 4, 540 + 4);
		add(scoreLine6Shadow);

		scoreLine6 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		scoreLine6.setText(Std.string(Globals.highScores[5].PlayerScore).lpad("0", 8), false, 4, 2, FlxBitmapFont.ALIGN_RIGHT, false);
		scoreLine6.setPosition(432, 540);
		add(scoreLine6);
		
		startText = new FlxText(0, 630, FlxG.width, "PRESS ENTER TO PLAY");
		startText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFF, "center");
		startText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		startText.antialiasing = false;
		startText.visible = false;
		add(startText);
		
		copyrightText = new FlxText(0, 700, FlxG.width, "(C) 2016 cannibal cat software and kablooey!");
		copyrightText.setFormat(Globals.TEXT_FONT, 36, 0xFFFFFF, "center");
		copyrightText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		copyrightText.antialiasing = false;
		copyrightText.visible = false;
		add(copyrightText);
		
		instructionLine1 = new FlxText(0, 625, FlxG.width, "[UP]/[DOWN] TO CHANGE LETTER");
		instructionLine1.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF, "center");
		instructionLine1.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		instructionLine1.antialiasing = false;
		instructionLine1.visible = false;
		add(instructionLine1);
		
		upHighlight = new FlxText(191, 625, 0, "[UP]");
		upHighlight.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF);
		upHighlight.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		upHighlight.antialiasing = false;
		upHighlight.visible = false;
		add(upHighlight);
		
		downHighlight = new FlxText(298, 625, 0, "[DOWN]");
		downHighlight.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF);
		downHighlight.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		downHighlight.antialiasing = false;
		downHighlight.visible = false;
		add(downHighlight);
		
		instructionLine2 = new FlxText(0, 665, FlxG.width, "[LEFT]/[RIGHT] TO SELECT LETTER");
		instructionLine2.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF, "center");
		instructionLine2.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		instructionLine2.antialiasing = false;
		instructionLine2.visible = false;
		add(instructionLine2);
		
		leftHighlight = new FlxText(156, 665, 0, "[LEFT]");
		leftHighlight.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF);
		leftHighlight.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		leftHighlight.antialiasing = false;
		leftHighlight.visible = false;
		add(leftHighlight);
		
		rightHighlight = new FlxText(311, 665, 0, "[RIGHT]");
		rightHighlight.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF);
		rightHighlight.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		rightHighlight.antialiasing = false;
		rightHighlight.visible = false;
		add(rightHighlight);
		
		instructionLine3 = new FlxText(0, 705, FlxG.width, "[ENTER] TO SAVE WHEN DONE");
		instructionLine3.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF, "center");
		instructionLine3.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		instructionLine3.antialiasing = false;
		instructionLine3.visible = false;
		add(instructionLine3);
		
		enterHighlight = new FlxText(220, 705, 0, "[ENTER]");
		enterHighlight.setFormat(Globals.TEXT_FONT, 48, 0xFFFFFF);
		enterHighlight.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		enterHighlight.antialiasing = false;
		enterHighlight.visible = false;
		add(enterHighlight);
		
		playerInitial1Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial1Shadow.setText(Globals.playerInitials[0], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial1Shadow.visible = false;
		add(playerInitial1Shadow);
		
		playerInitial1 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial1.setText(Globals.playerInitials[0], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial1.visible = false;
		add(playerInitial1);
		
		playerInitial2Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial2Shadow.setText(Globals.playerInitials[1], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial2Shadow.visible = false;
		add(playerInitial2Shadow);
		
		playerInitial2 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial2.setText(Globals.playerInitials[1], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial2.visible = false;
		add(playerInitial2);
		
		playerInitial3Shadow = new FlxBitmapFont("assets/fonts/BlockFontShadow.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial3Shadow.setText(Globals.playerInitials[2], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial3Shadow.visible = false;
		add(playerInitial3Shadow);
		
		playerInitial3 = new FlxBitmapFont("assets/fonts/BlockFont.png", 62, 64, Globals.textSet, 10, 2, 2, 0, 0);
		playerInitial3.setText(Globals.playerInitials[2], false, 4, 2, FlxBitmapFont.ALIGN_LEFT, false);
		playerInitial3.visible = false;
		add(playerInitial3);
		
		textTimer = new FlxTimer(1.5, onTextFlash, 0);
		initialTimer = new FlxTimer(0.15, onInitialFlash, 0);
		
		super.create();
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
	
	private function onInitialFlash(timer:FlxTimer):Void
	{
		currentInitialVisible = !currentInitialVisible;
	}
	
	private function onCloseDialog():Void
	{
		exitDialogActive = false;
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		if (playerNameEntryMode)
		{
			if (Globals.analogStickDelay > 0)
			{
				Globals.analogStickDelay -= FlxG.elapsed;
				if (Globals.analogStickDelay < 0)
					Globals.analogStickDelay = 0;
			}
			
			titleLogo1.visible = false;
			titleLogo2.visible = true;
			startText.visible = false;
			copyrightText.visible = false;
			instructionLine1.visible = true;
			instructionLine2.visible = true;
			instructionLine3.visible = true;
			upHighlight.visible = true;
			downHighlight.visible = true;
			leftHighlight.visible = true;
			rightHighlight.visible = true;
			enterHighlight.visible = true;
			
			switch scoreIndex
			{
				case 0:
					initialsYPos = 165;
					
				case 1:
					initialsYPos = 240;
					
				case 2:
					initialsYPos = 315;
					
				case 3:
					initialsYPos = 390;
					
				case 4:
					initialsYPos = 465;
					
				case 5:
					initialsYPos = 540;
			}
			
			playerInitial1.setPosition(202, initialsYPos);
			playerInitial1Shadow.setPosition(202 + 4, initialsYPos + 4);
			playerInitial2.setPosition(268, initialsYPos);
			playerInitial2Shadow.setPosition(268 + 4, initialsYPos + 4);
			playerInitial3.setPosition(334, initialsYPos);
			playerInitial3Shadow.setPosition(334 + 4, initialsYPos + 4);

			playerInitial1.visible = true;
			playerInitial1Shadow.visible = true;
			playerInitial2.visible = true;
			playerInitial2Shadow.visible = true;
			playerInitial3.visible = true;
			playerInitial3Shadow.visible = true;
			playerInitial1.text = Globals.playerInitials[0];
			playerInitial1Shadow.text = Globals.playerInitials[0];
			playerInitial2.text = Globals.playerInitials[1];
			playerInitial2Shadow.text = Globals.playerInitials[1];
			playerInitial3.text = Globals.playerInitials[2];
			playerInitial3Shadow.text = Globals.playerInitials[2];
			
			if (currentSelectInitial == 0)
			{
				playerInitial1.visible = currentInitialVisible;
				playerInitial1Shadow.visible = currentInitialVisible;
				playerInitial1.color = ColorCycler.RGB;
			}
			else
				playerInitial1.color = ColorCycler.WilliamsUltraFlash;
				
			if (currentSelectInitial == 1)
			{
				playerInitial2.visible = currentInitialVisible;
				playerInitial2Shadow.visible = currentInitialVisible;
				playerInitial2.color = ColorCycler.RGB;
			}
			else
				playerInitial2.color = ColorCycler.WilliamsUltraFlash;
				
			if (currentSelectInitial == 2)
			{
				playerInitial3.visible = currentInitialVisible;
				playerInitial3Shadow.visible = currentInitialVisible;
				playerInitial3.color = ColorCycler.RGB;
			}
			else
				playerInitial3.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			if (messageNum == 1)
				startText.text = "PRESS ENTER TO PLAY";
			else
				startText.text = "PRESS SPACE FOR \"HOW TO PLAY\"";			

			if (showStartText)
				startText.visible = true;
			else
				startText.visible = false;			
			
			titleLogo1.visible = true;
			titleLogo2.visible = false;
			copyrightText.visible = true;
			instructionLine1.visible = false;
			instructionLine2.visible = false;
			instructionLine3.visible = false;
			upHighlight.visible = false;
			downHighlight.visible = false;
			leftHighlight.visible = false;
			rightHighlight.visible = false;
			enterHighlight.visible = false;	
			playerInitial1.visible = false;
			playerInitial1Shadow.visible = false;
			playerInitial2.visible = false;
			playerInitial2Shadow.visible = false;
			playerInitial3.visible = false;
			playerInitial3Shadow.visible = false;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 1)
		{
			initialsLine1.color = ColorCycler.WilliamsUltraFlash;
			scoreLine1.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine1.color = ColorCycler.RWB1;
			scoreLine1.color = ColorCycler.RWB6;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 2)
		{
			initialsLine2.color = ColorCycler.WilliamsUltraFlash;
			scoreLine2.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine2.color = ColorCycler.RWB2;
			scoreLine2.color = ColorCycler.RWB5;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 3)
		{
			initialsLine3.color = ColorCycler.WilliamsUltraFlash;
			scoreLine3.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine3.color = ColorCycler.RWB3;
			scoreLine3.color = ColorCycler.RWB4;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 4)
		{
			initialsLine4.color = ColorCycler.WilliamsUltraFlash;
			scoreLine4.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine4.color = ColorCycler.RWB4;
			scoreLine4.color = ColorCycler.RWB3;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 5)
		{
			initialsLine5.color = ColorCycler.WilliamsUltraFlash;
			scoreLine5.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine5.color = ColorCycler.RWB5;
			scoreLine5.color = ColorCycler.RWB2;
		}
		
		if (Globals.playerScore != 0 && Globals.lastHighScoreEntryNumber != 0 && Globals.lastHighScoreEntryNumber == 6)
		{
			initialsLine6.color = ColorCycler.WilliamsUltraFlash;
			scoreLine6.color = ColorCycler.WilliamsUltraFlash;
		}
		else
		{
			initialsLine6.color = ColorCycler.RWB6;
			scoreLine6.color = ColorCycler.RWB1;
		}
				
		if (!playerNameEntryMode)
			startText.color = ColorCycler.WilliamsFlash8;
		else
		{
			instructionLine1.color = ColorCycler.WilliamsFlash8;
			instructionLine2.color = ColorCycler.WilliamsFlash8;
			instructionLine3.color = ColorCycler.WilliamsFlash8;
			upHighlight.color = ColorCycler.WilliamsUltraFlash;
			downHighlight.color = ColorCycler.WilliamsUltraFlash;
			leftHighlight.color = ColorCycler.WilliamsUltraFlash;
			rightHighlight.color = ColorCycler.WilliamsUltraFlash;
			enterHighlight.color = ColorCycler.WilliamsUltraFlash;
		}
		
		if (!playerNameEntryMode)
		{
			if (exitDialogActive)
				return;
				
			attractTimer -= FlxG.elapsed;
			
			if (attractTimer <= 0)
			{
				FlxG.sound.music.volume = 0.50;
				FlxG.switchState(new WantedListState());
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
				
			if (FlxG.keys.justPressed.ENTER || 
				gamepad.justPressed(7) || 
				gamepad.justPressed(LogitechButtonID.TEN))
			{
				Globals.resetGameGlobals(); 
				FlxG.switchState(new NewsFlashState());
			}
		}
		else
		{
			if (FlxG.keys.justPressed.ENTER || 
				gamepad.justPressed(7) || 
				gamepad.justPressed(LogitechButtonID.TEN))
			{
				Globals.highScores[scoreIndex].PlayerInitials = Globals.playerInitials[0] + Globals.playerInitials[1] + Globals.playerInitials[2];
				switch scoreIndex
				{
					case 0:
						initialsLine1.text = "1." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine1Shadow.text = "1." + Globals.highScores[scoreIndex].PlayerInitials;
					
					case 1:
						initialsLine2.text = "2." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine2Shadow.text = "2." + Globals.highScores[scoreIndex].PlayerInitials;
						
					case 2:
						initialsLine3.text = "3." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine3Shadow.text = "3." + Globals.highScores[scoreIndex].PlayerInitials;
						
					case 3:
						initialsLine4.text = "4." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine4Shadow.text = "4." + Globals.highScores[scoreIndex].PlayerInitials;
						
					case 4:
						initialsLine5.text = "5." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine5Shadow.text = "5." + Globals.highScores[scoreIndex].PlayerInitials;
						
					case 5:
						initialsLine6.text = "6." + Globals.highScores[scoreIndex].PlayerInitials;
						initialsLine6Shadow.text = "6." + Globals.highScores[scoreIndex].PlayerInitials;
				}
				
				scoresSave.flush();
				playerNameEntryMode = false;
				FlxG.keys.reset();
			}
			
			if (FlxG.keys.justPressed.LEFT || 
			   (gamepad.dpadLeft && Globals.analogStickDelay == 0) ||
			   (gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_X) < -Globals.analogMovementThreshold && Globals.analogStickDelay == 0))
			{
				Globals.analogStickDelay = 0.25;
				FlxG.sound.play("Click");
				currentSelectInitial--;
				if (currentSelectInitial < 0)
					currentSelectInitial = 2;
			}
			
			if (FlxG.keys.justPressed.RIGHT || 
			   (gamepad.dpadRight && Globals.analogStickDelay == 0) ||
			   (gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_X) > Globals.analogMovementThreshold && Globals.analogStickDelay == 0))
			{
				Globals.analogStickDelay = 0.25;
				FlxG.sound.play("Click");
				currentSelectInitial++;
				if (currentSelectInitial > 2)
					currentSelectInitial = 0;
			}

			if (FlxG.keys.justPressed.UP || 
			   (gamepad.dpadUp && Globals.analogStickDelay == 0) ||
			   (gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_Y) < -Globals.analogMovementThreshold && Globals.analogStickDelay == 0))
			{
				Globals.analogStickDelay = 0.25;
				FlxG.sound.play("Thud");
				playerInitialsIndex[currentSelectInitial]--;
				if (playerInitialsIndex[currentSelectInitial] < 0)
					playerInitialsIndex[currentSelectInitial] = 25;
				Globals.playerInitials[currentSelectInitial] = validInitials[playerInitialsIndex[currentSelectInitial]];				
			}
			
			if (FlxG.keys.justPressed.DOWN || 
			   (gamepad.dpadDown && Globals.analogStickDelay == 0) ||
			   (gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_Y) > Globals.analogMovementThreshold && Globals.analogStickDelay == 0))
			{
				Globals.analogStickDelay = 0.25;
				FlxG.sound.play("Thud");
				playerInitialsIndex[currentSelectInitial]++;
				if (playerInitialsIndex[currentSelectInitial] > 25)
					playerInitialsIndex[currentSelectInitial] = 0;
				Globals.playerInitials[currentSelectInitial] = validInitials[playerInitialsIndex[currentSelectInitial]];				
			}
		}
			
		super.update();
	}
	
	override public function destroy():Void
	{
		background = null;
		titleLogo1 = null;
		titleLogo2 = null;
		initialsLine1 = null;
		initialsLine1Shadow = null;
		initialsLine2 = null;
		initialsLine2Shadow = null;
		initialsLine3 = null;
		initialsLine3Shadow = null;
		initialsLine4 = null;
		initialsLine4Shadow = null;
		initialsLine5 = null;
		initialsLine5Shadow = null;
		initialsLine6 = null;
		initialsLine6Shadow = null;
		scoreLine1 = null;
		scoreLine1Shadow = null;
		scoreLine2 = null;
		scoreLine2Shadow = null;
		scoreLine3 = null;
		scoreLine3Shadow = null;
		scoreLine4 = null;
		scoreLine4Shadow = null;
		scoreLine5 = null;
		scoreLine5Shadow = null;
		scoreLine6 = null;
		scoreLine6Shadow = null;
		startText = null;
		copyrightText = null;
		playerInitial1 = null;
		playerInitial1Shadow = null;
		playerInitial2 = null;
		playerInitial2Shadow = null;
		playerInitial3 = null;
		playerInitial3Shadow = null;
		instructionLine1 = null;
		instructionLine2 = null;
		instructionLine3 = null;
		upHighlight = null;
		downHighlight = null;
		leftHighlight = null;
		rightHighlight = null;
		enterHighlight = null;
		scoresSave.destroy();
		if (textTimer != null)
			textTimer.destroy();
		if (initialTimer != null)
			initialTimer.destroy();
		
		super.destroy();
	}
	
	private function loadHighScores():Bool
	{
		var loadedOK:Bool = true;
		
		if (scoresSave.data.scoreData == null)
			loadedOK = false;
		else
		{
			for (i in 0...6)
				Globals.highScores[i] = scoresSave.data.scoreData[i];
		}
		
		return loadedOK;
	}
	
	private function checkPlayerRanking():Int
	{
		var ranking:Int = -1;
		
		for (i in 0...6)
		{
			if (Globals.playerScore > Globals.highScores[i].PlayerScore)
			{
				ranking = i;
				var newScore = new HighScoreData();
				newScore.PlayerScore = Globals.playerScore;
				newScore.PlayerInitials = "";
				Globals.lastHighScoreEntryNumber = ranking + 1;
				Globals.highScores.insert(ranking, newScore);
				scoresSave.data.scoreData.insert(ranking, newScore);
				break;
			}
		}
		
		return ranking;
	}
		
	private function initializeHighScores():Void
	{
		if (scoresSave.data.scoreData == null)
			scoresSave.data.scoreData = new Array<HighScoreData>();
			
		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "RCW";
		highScoreData.PlayerScore = 325000;
		Globals.highScores[0] = highScoreData;
		
		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "ZAW";
		highScoreData.PlayerScore = 280105;
		Globals.highScores[1] = highScoreData;

		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "JIM";
		highScoreData.PlayerScore = 195450;
		Globals.highScores[2] = highScoreData;
		
		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "DRJ";
		highScoreData.PlayerScore = 115750;
		Globals.highScores[3] = highScoreData;
		
		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "MUJ";
		highScoreData.PlayerScore = 64200;
		Globals.highScores[4] = highScoreData;
		
		var highScoreData:HighScoreData = new HighScoreData();
		highScoreData.PlayerInitials = "DJT";
		highScoreData.PlayerScore = 12500;
		Globals.highScores[5] = highScoreData;
		
		for (i in 0...6)
			scoresSave.data.scoreData.push(Globals.highScores[i]);
		
		scoresSave.flush();
	}
}