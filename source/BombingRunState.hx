package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;
import flixel.addons.display.FlxBackdrop;

class BombingRunState extends FlxState
{
	private var skipText:FlxText;
	private var chopper:Chopper;
	private var chopperFloor:FlxSprite;
	private var cloudLayer1:FlxBackdrop;
	private var cloudLayer2:FlxBackdrop;
	private var cloudLayer3:FlxBackdrop;
	private var daisyCutter:DaisyCutter;
	private var player:FlxSprite;
	private var explosion:FlxSprite;
	private var attackSiren:FlxSound;
	private var chopperBlades:FlxSound;
	private var pilotTimer:FlxTimer;
	private var playerTimer:FlxTimer;
	private var chopperTimer:FlxTimer;
	private var explosionTimer:FlxTimer;
	private var nextPilotPhrase:Int = 1;
	private var nextPlayerPhrase:Int = 1;
	private var phraseDelay:Float;
	private var bombDrop:Bool = false;
	
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
		if ((Globals.currentWave >= 1 && Globals.currentWave <= 4) ||
			(Globals.currentWave >= 13 && Globals.currentWave <= 16))
			FlxG.camera.bgColor = 0xFF0000FF; 
		else if ((Globals.currentWave >= 5 && Globals.currentWave <= 8) ||
				 (Globals.currentWave >= 17 && Globals.currentWave <= 20))
			FlxG.camera.bgColor = 0xFFD6189C;
		else if ((Globals.currentWave >= 9 && Globals.currentWave <= 12) ||
				 (Globals.currentWave >= 21 && Globals.currentWave <= 24))
			FlxG.camera.bgColor = 0xFFC0C0C0;

		FlxG.cameras.fade(0xFF000000, 1, true);
		
		cloudLayer1 = new FlxBackdrop("assets/images/CloudLayer1.png", 0.25, 0, true, false); 
		cloudLayer1.setPosition(0, 0);
		add(cloudLayer1);
		
		cloudLayer2 = new FlxBackdrop("assets/images/CloudLayer2.png", 0.5, 0, true, false);
		cloudLayer2.setPosition(0, 256);
		add(cloudLayer2);
		
		cloudLayer3 = new FlxBackdrop("assets/images/CloudLayer3.png", 1.0, 0, true, false); 
		cloudLayer3.setPosition(0, 512);
		add(cloudLayer3);
		
		chopperFloor = new FlxSprite();
		chopperFloor.loadGraphic("assets/images/ChopperFloor.png", false, 184, 22, false);
		chopperFloor.scrollFactor.set(0, 0);
		add(chopperFloor);
		
		daisyCutter = new DaisyCutter();
		daisyCutter.scrollFactor.set(0, 0);
		add(daisyCutter);
		
		chopper = new Chopper();
		chopper.setPosition((FlxG.width / 2) - (chopper.frameWidth / 2), 150);
		chopper.scrollFactor.set(0, 0);
		chopper.changeState(Entity.State.IDLE);
		add(chopper);

		chopperFloor.setPosition(chopper.x + 225, chopper.y + 171);
		daisyCutter.setPosition(chopper.x + 215, chopper.y + 80);
	
		player = new FlxSprite();
		player.loadGraphic("assets/images/Trump.png", true, 216, 144, false);
		player.animation.add("idle", [4], 1, true);
		player.animation.play("idle");
		player.setFacingFlip(FlxObject.LEFT, true, false); 
		player.facing = FlxObject.LEFT;
		player.setPosition(chopper.x + 255, chopper.y + 56);
		player.scrollFactor.set(0, 0);
		add(player);
		
		explosion = new FlxSprite();
		explosion.loadGraphic("assets/images/MegaBlast.png", false, 1024, 600, false);
		explosion.setPosition(0, FlxG.height);
		explosion.scrollFactor.set(0, 0);
		add(explosion);
		
		chopperTimer = new FlxTimer(1, adjustChopperPosition, 0);
		pilotTimer = new FlxTimer(1, pilotSpeak, 1);
		
		skipText = new FlxText(225, 630, 0, "PRESS ENTER TO SKIP");
		skipText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFFFF);
		skipText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 4);
		skipText.antialiasing = false;
		skipText.scrollFactor.set(0, 0);
		add(skipText);
		
		attackSiren = FlxG.sound.load("assets/sounds/AttackSiren.wav", 1, true, true);
		chopperBlades = FlxG.sound.load("assets/sounds/Chopper.wav", 1, true, true); 
		chopperBlades.play();
		
		super.create();
	}
	
	private function adjustChopperPosition(timer:FlxTimer):Void
	{
		FlxTween.tween(chopper, { x:(FlxG.width / 2) - (chopper.frameWidth / 2), y:150 }, .5, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn } );
	}
	
	private function pilotSpeak(timer:FlxTimer):Void
	{
		switch nextPilotPhrase
		{
			case 1:
				FlxG.sound.play("PilotOrdersSir");
				phraseDelay = 1.5;
				
			case 2:
				FlxG.sound.play("PilotIdentifyTarget");
				phraseDelay = 1.5;
				
			case 3:
				FlxRandom.chanceRoll() ? (FlxG.sound.play("PilotYesSir")) : (FlxG.sound.play("PilotDelightedToSir"));
				skipText.visible = false;
		}
		
		if (nextPilotPhrase <= 3)
		{
			playerTimer = new FlxTimer(phraseDelay, playerSpeak, 1);
			nextPilotPhrase++;
		}
	}
	
	private function playerSpeak(timer:FlxTimer):Void
	{
		switch nextPlayerPhrase
		{
			case 1:
				FlxG.sound.play("TrumpBlast");
				phraseDelay = 2;
				
			case 2:
				FlxG.sound.play("TrumpSuffer");
				phraseDelay = 2;
		}
		
		if (nextPlayerPhrase <= 2)
		{
			pilotTimer = new FlxTimer(phraseDelay, pilotSpeak, 1);
			nextPlayerPhrase++;
			if (nextPlayerPhrase == 3)
				pilotTimer = new FlxTimer(3.5, dropBomb, 1);
		}
	}
	
	private function dropBomb(timer:FlxTimer):Void
	{
		attackSiren.volume = 0.25;
		attackSiren.play();
		bombDrop = true;
		FlxTween.tween(daisyCutter, { y:FlxG.height + 100 }, 2, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn, complete: impactDelay } );
		FlxTween.angle(daisyCutter, 0, -45, 3);
	}
	
	private function impactDelay(tween:FlxTween):Void
	{
		explosionTimer = new FlxTimer(2, showExplosion, 1);
	}
	
	private function showExplosion(timer:FlxTimer):Void 
	{
		attackSiren.fadeOut(1, 0);
		FlxG.sound.play("MegaExplosion");
		FlxTween.tween(explosion, { y:500 }, 3, { type: FlxTween.ONESHOT, ease: FlxEase.quadOut, complete: explosionRecede } );
	}
	
	private function explosionRecede(tween:FlxTween):Void 
	{
		FlxTween.tween(explosion, { y:FlxG.height }, 3, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn, complete: fadeOut } );
	}
	
	private function fadeOut(tween:FlxTween):Void 
	{
		FlxG.cameras.fade(0xFF000000, 2, false, onFadeOutComplete);
		chopperBlades.fadeOut(2, 0);
	}
	
	private function onFadeOutComplete():Void
	{
		FlxG.switchState(new TallyState());
	}
	
	override public function update():Void
	{
		FlxG.camera.scroll.add(-5, 0);
		
		ColorCycler.Update();
		skipText.color = ColorCycler.WilliamsFlash8;
		explosion.color = ColorCycler.ExplosionFlash;
		
		chopper.setPosition(chopper.x + FlxRandom.intRanged(-3, 3), chopper.y + FlxRandom.intRanged(-3, 3));
		chopperFloor.setPosition(chopper.x + 225, chopper.y + 171);
		if (!bombDrop)
			daisyCutter.setPosition(chopper.x + 215, chopper.y + 80);
		player.setPosition(chopper.x + 255, chopper.y + 56);
		
		if (FlxG.keys.justPressed.ENTER || gamepad.justPressed(7) || gamepad.justPressed(LogitechButtonID.TEN))
		{
			FlxG.cameras.fade(0xFF000000, 2, false, onFadeOutComplete);
			chopperBlades.fadeOut(2, 0);
		}
		
		super.update();
	}
	
	override public function destroy():Void
	{
		skipText = null;
		chopper = null;
		cloudLayer1 = null;
		cloudLayer2 = null;
		cloudLayer3 = null;
		chopperFloor = null;
		daisyCutter = null;
		player = null;
		explosion = null;
		attackSiren = null;
		chopperBlades = null;
		if (pilotTimer != null)
			pilotTimer.destroy();
		if (pilotTimer != null)
			playerTimer.destroy();
		if (chopperTimer != null)	
			chopperTimer.destroy();
		if (explosionTimer != null)
			explosionTimer.destroy();
		
		super.destroy();
	}
}