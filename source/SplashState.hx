package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class SplashState extends FlxState
{
	private var kablooeyLogo:FlxSprite;
	private var CCLogo:FlxSprite;
	private var logoTimer:FlxTimer;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.scaleMode = new PixelPerfectScaleMode();
		FlxG.camera.bgColor = 0xFFFFFFFF;
		FlxG.cameras.fade(0xFFFFFFFF, 1, true, onKablooeyDisplay);
		FlxG.autoPause = false;
		
		kablooeyLogo = new FlxSprite(0, 0, "assets/images/KablooeyLogo.png");
		kablooeyLogo.setPosition(FlxG.width / 2 - kablooeyLogo.width / 2, FlxG.height / 2 - kablooeyLogo.height / 2);
		add(kablooeyLogo);
		
		CCLogo = new FlxSprite(0, 0, "assets/images/CCLogo.png");
		CCLogo.setPosition(FlxG.width / 2 - CCLogo.width / 2, FlxG.height / 2 - CCLogo.height / 2);
		CCLogo.visible = false;
		add(CCLogo);
		
		super.create();
	}
	
	private function onKablooeyDisplay():Void
	{
		logoTimer = new FlxTimer(1, kablooeyFadeOut, 1);
	}
	
	private function kablooeyFadeOut(timer:FlxTimer):Void
	{
		FlxG.cameras.fade(0xFFFFFFFF, 1, false, onKablooeyFade);	
	}
	
	private function onKablooeyFade():Void
	{
		kablooeyLogo.visible = false;
		CCLogo.visible = true;
		FlxG.cameras.fade(0xFFFFFFFF, 1, true, onCCDisplay, true);
	}
	
	private function onCCDisplay():Void
	{
		logoTimer = new FlxTimer(1, CCFadeOut, 1);
	}
	
	private function CCFadeOut(timer:FlxTimer):Void
	{
		FlxG.cameras.fade(0xFFFFFFFF, 1, false, onFinalFade);
	}
	
	override public function destroy():Void
	{
		kablooeyLogo = null;
		CCLogo = null;
		super.destroy();
	}

	private function onFinalFade():Void
	{
		FlxG.switchState(new RatingSplashState());
	}
}