package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.effects.particles.FlxEmitterExt;

class TitleState extends FlxState
{
	private var shineTimer:FlxTimer;
	private var delayTimer:FlxTimer;
	private var codeTimer:FlxTimer;
	private var textTimer:FlxTimer;
	private var background:FlxSprite;
	private var titleLogo:FlxSprite;
	private var trump:FlxSprite;
	private var startText:FlxText;
	private var presentsText:FlxText;
	private var tagLineText1:FlxTypeText;
	private var tagLineText2:FlxTypeText;
	private var typingSound:FlxSound;
	private var whiteStarExplosion:FlxEmitterExt;
	private var blueStarExplosion:FlxEmitterExt;
	private var redStarExplosion:FlxEmitterExt;
	private var attractTimer:Float = 10;
	private var messageNum:Int = 1;
	private var tagLineComplete:Bool = false;
	private var exitDialogActive:Bool = false;
	private var showStartText:Bool = true;
	
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
		FlxG.camera.bgColor = 0x00000000;
		
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
		
		typingSound = new FlxSound();
		typingSound.loadStream("assets/sounds/Type.wav", false, false);
		add(typingSound);
		
		background = new FlxSprite(0, 0, "assets/images/Flag.png");
		background.visible = false;
		add(background); 
		
		whiteStarExplosion = new FlxEmitterExt(FlxG.width / 2, 400, 25);
		whiteStarExplosion.setRotation(-360, 360);
		whiteStarExplosion.setMotion(0, 200, 1, 360, 200, 0.5);
		whiteStarExplosion.makeParticles("assets/images/WhiteStar.png", 25, 16, false, 0);
		add(whiteStarExplosion);
		
		redStarExplosion = new FlxEmitterExt(FlxG.width / 2, 400, 25);
		redStarExplosion.setRotation(-360, 360);
		redStarExplosion.setMotion(0, 200, 1, 360, 200, 0.5);
		redStarExplosion.makeParticles("assets/images/RedStar.png", 25, 16, false, 0);
		add(redStarExplosion);
		
		blueStarExplosion = new FlxEmitterExt(FlxG.width / 2, 400, 25);
		blueStarExplosion.setRotation(-360, 360);
		blueStarExplosion.setMotion(0, 200, 1, 360, 200, 0.5);
		blueStarExplosion.makeParticles("assets/images/BlueStar.png", 25, 16, false, 0);
		add(blueStarExplosion);
		
		trump = new FlxSprite(0, 0, "assets/images/TrumpTitle.png");
		trump.setPosition(280, 180);
		trump.visible = false;
		add(trump); 

		startText = new FlxText(0, 630, FlxG.width, "PRESS ENTER TO PLAY");
		startText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF, "center");
		startText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		startText.antialiasing = false;
		startText.visible = false;
		add(startText);

		presentsText = new FlxText(100, 18, 0, "cannibal cat software and kablooey! present...");
		presentsText.setFormat(Globals.TEXT_FONT, 36, ColorCycler.RedPulse);
		presentsText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		presentsText.antialiasing = false;
		presentsText.visible = false;
		add(presentsText);
		
		tagLineText1 = new FlxTypeText(135, 700, 0, "NO ONE HAD THE GUTS...", 48, false);
		tagLineText1.font = Globals.TEXT_FONT;
		tagLineText1.showCursor = false;
		tagLineText1.autoErase = false;
		tagLineText1.color = 0xFFFFFF;
		tagLineText1.antialiasing = false;
		tagLineText1.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		add(tagLineText1);
		
		tagLineText2 = new FlxTypeText(650, 700, 0, "UNTIL NOW!", 48, false);
		tagLineText2.font = Globals.TEXT_FONT;
		tagLineText2.showCursor = false;
		tagLineText2.autoErase = false;
		tagLineText2.color = 0xFFFFFF;
		tagLineText1.antialiasing = false;
		tagLineText2.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		add(tagLineText2);
		
		titleLogo = new FlxSprite();
		titleLogo.loadGraphic("assets/images/TitleLogo.png", true, 983, 96, false);
		titleLogo.animation.add("shine", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0], 24, false);
		titleLogo.setPosition(FlxG.width / 2 - titleLogo.width / 2, 78);
		titleLogo.visible = false;
		add(titleLogo); 
		
		tagLineText1.start(0.05, false, false, typingSound, null, onTagLine1Complete);
		
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
	
	private function shineLogo(timer:FlxTimer):Void
	{
		titleLogo.animation.play("shine");
	}
	
	private function onTagLine1Complete():Void
	{
		delayTimer = new FlxTimer(0.5, startTagLine2, 1);
	}
	
	private function startTagLine2(timer:FlxTimer):Void
	{
		tagLineText2.start(0.05, false, false, typingSound, null, onTagLineComplete);
	}
	
	private function onTagLineComplete():Void
	{
		FlxG.sound.play("ShowTitleScreen");
		whiteStarExplosion.start(false, 0, 0.2);
		redStarExplosion.start(false, 0, 0.2);
		blueStarExplosion.start(false, 0, 0.2);
		background.visible = true;
		presentsText.visible = true;
		trump.visible = true;
		startText.visible = true;
		tagLineComplete = true;
		titleLogo.visible = true;
		titleLogo.animation.play("shine");
		shineTimer = new FlxTimer(3, shineLogo, 0);
		textTimer = new FlxTimer(1.5, onTextFlash, 0);		
		FlxG.sound.playMusic(Globals.ATTRACT_BGM, 0.5, true);
		FlxG.camera.shake(0.01, 0.5, trumpVoice);
	}
	
	private function trumpVoice():Void
	{
		var soundSelection = FlxRandom.intRanged(1, 5, [Globals.lastSoundSelection]);
		Globals.lastSoundSelection = soundSelection;
		
		switch soundSelection
		{
			case 1:
				FlxG.sound.play("TrumpShoot");
				
			case 2:
				FlxG.sound.play("BuildWall");
				
			case 3:
				FlxG.sound.play("Grapefruits");
				
			case 4:
				FlxG.sound.play("AmericanDream");
				
			case 5:
				FlxG.sound.play("Politicians");
		}		
	}

	override public function destroy():Void
	{
		trump = null;
		titleLogo = null;
		presentsText = null;
		startText = null;
		background = null;
		redStarExplosion = null;
		whiteStarExplosion = null;
		blueStarExplosion = null;
		Globals.enteredCode = "";
		if (shineTimer != null)
			shineTimer.destroy();
		if (delayTimer != null)
			delayTimer.destroy();
		if (textTimer != null)
			textTimer.destroy();
	
		super.destroy();
	}
	
	private function onCloseDialog():Void
	{
		exitDialogActive = false;
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		if (tagLineComplete)
		{
			if (messageNum == 1)
				startText.text = "PRESS ENTER TO PLAY";
			else
				startText.text = "PRESS SPACE FOR \"HOW TO PLAY\"";
			
			if (showStartText)
				startText.visible = true;
			else
				startText.visible = false;
			
			startText.color = ColorCycler.WilliamsFlash8;
			presentsText.color = ColorCycler.RedPulse;
			tagLineText1.color = ColorCycler.WilliamsUltraFlash;
			tagLineText2.color = ColorCycler.WilliamsUltraFlash;
			
			if (exitDialogActive)
				return;
		
			attractTimer -= FlxG.elapsed;
			
			if (attractTimer <= 0)
				FlxG.switchState(new HighScoresState());
				
			if (FlxG.keys.justPressed.ENTER || 
				gamepad.justPressed(7) || 
				gamepad.justPressed(LogitechButtonID.TEN))
			{
				Globals.resetGameGlobals(); 
				FlxG.switchState(new NewsFlashState());
			}
				
			if (FlxG.keys.justPressed.SPACE)
				FlxG.switchState(new InstructionsState());
				
			if (FlxG.keys.justPressed.ESCAPE)
			{
				persistentUpdate = true;
				exitDialogActive = true;
				var exitDialog = new GameExitState();
				exitDialog.closeCallback = onCloseDialog;
				openSubState(exitDialog);
			}
			
			if (Globals.enteredCode.length < 7)
			{
				if (FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.NUMPADONE)
					Globals.enteredCode += "1";
				if (FlxG.keys.justPressed.TWO || FlxG.keys.justPressed.NUMPADTWO)
					Globals.enteredCode += "2";
				if (FlxG.keys.justPressed.THREE || FlxG.keys.justPressed.NUMPADTHREE)
					Globals.enteredCode += "3";
				if (FlxG.keys.justPressed.FOUR || FlxG.keys.justPressed.NUMPADFOUR)
					Globals.enteredCode += "4";
				if (FlxG.keys.justPressed.FIVE || FlxG.keys.justPressed.NUMPADFIVE)
					Globals.enteredCode += "5";
				if (FlxG.keys.justPressed.SIX || FlxG.keys.justPressed.NUMPADSIX)
					Globals.enteredCode += "6";
				if (FlxG.keys.justPressed.SEVEN || FlxG.keys.justPressed.NUMPADSEVEN)
					Globals.enteredCode += "7";
				if (FlxG.keys.justPressed.EIGHT || FlxG.keys.justPressed.NUMPADEIGHT)
					Globals.enteredCode += "8";
				if (FlxG.keys.justPressed.NINE || FlxG.keys.justPressed.NUMPADNINE)
					Globals.enteredCode += "9";
				if (FlxG.keys.justPressed.W)
					Globals.enteredCode += "W";
				if (FlxG.keys.justPressed.A)
					Globals.enteredCode += "A";
				if (FlxG.keys.justPressed.N)
					Globals.enteredCode += "N";
				if (FlxG.keys.justPressed.T)
					Globals.enteredCode += "T";
				if (FlxG.keys.justPressed.O)
					Globals.enteredCode += "O";
				if (FlxG.keys.justPressed.C)
					Globals.enteredCode += "C";
			}
				
			if (Globals.enteredCode == Globals.debugModeCode) 
			{
				Globals.enteredCode = "";
				FlxG.switchState(new DebugState());
			}
			else if (Globals.enteredCode == Globals.easterEggCode) 
			{
				Globals.enteredCode = "";
				FlxG.switchState(new HiddenState());
			}
		}
		
		super.update();
	}
}