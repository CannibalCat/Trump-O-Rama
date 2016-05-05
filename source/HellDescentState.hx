package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class HellDescentState extends FlxState
{
	private var trump:Entity;
	private var phraseTimer:FlxTimer;
	private var currentPhrase:Int = 1;
	private static var PHRASE_COUNT:Int = 8;
	private var cavernsBG:FlxBackdrop;
	private var cavernsFG:FlxBackdrop;
	
	override public function create():Void
	{
		cavernsBG = new FlxBackdrop("assets/images/CavernsBG.png", 0, 0.5, false, true); 
		cavernsBG.setPosition(0, 0);
		add(cavernsBG);
		
		cavernsFG = new FlxBackdrop("assets/images/CavernsFG.png", 0, 1, false, true);
		cavernsFG.setPosition(0, 0);
		add(cavernsFG);
		
		trump = new Entity((FlxG.width / 2) - 51, (FlxG.height / 2) - 68, (FlxG.height / 2) - 68);
		trump.loadGraphic("assets/images/NakedTrump.png", true, 102, 136, false);
		trump.animation.add("fall", [10, 11, 12, 13], 8, true);
		trump.setFacingFlip(FlxObject.LEFT, true, false); 
		trump.setFacingFlip(FlxObject.RIGHT, false, false); 
		trump.animation.play("fall");
		trump.angularVelocity = -180;
		trump.scrollFactor.set(0, 0);
		add(trump);
		
		FlxG.camera.bgColor = 0xFF000000;
		FlxG.cameras.fade(0xFF000000, 2, true);
		FlxG.sound.volume = 1;
		FlxG.sound.playMusic(Globals.PARADISE_BGM, 0.75, false); 
		
		phraseTimer = new FlxTimer(3, nextPhrase, PHRASE_COUNT);
	}
	
	private function nextPhrase(timer:FlxTimer):Void
	{
		switch currentPhrase
		{
			case 1:
				FlxG.sound.play("TrumpLoveMexicans");
				
			case 2:
				FlxG.sound.play("TrumpLoveCruz");
				
			case 3:
				FlxG.sound.play("TrumpLoveObama");
				
			case 4:
				FlxG.sound.play("TrumpLoveMuslims");
				
			case 5:
				FlxG.sound.play("TrumpLoveChina");
				
			case 6:
				FlxG.sound.play("TrumpChina");
				
			case 7:
				FlxG.sound.play("TrumpUghYaYe");
				
			case 8:
				fadeOut();
		}
		
		currentPhrase++;
	}
	
	private function fadeOut():Void
	{
		FlxTween.tween(FlxG.sound, { volume:0 }, 2);
		FlxG.cameras.fade(0xFF000000, 2, false, onFadeOutComplete);
	}
	
	private function onFadeOutComplete():Void
	{
		FlxG.switchState(new GameEndState());
	}
	
	override public function update():Void
	{
		FlxG.camera.scroll.add(0, 25);
		super.update();
	}
	
	override public function destroy():Void
	{
		FlxG.sound.music.stop();
		trump = null;
		cavernsBG = null;
		cavernsFG = null;
		if (phraseTimer != null)
			phraseTimer.destroy();

		super.destroy();
	}
}