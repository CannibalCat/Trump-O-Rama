package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class RatingSplashState extends FlxState
{
	private var ratingScreen:FlxSprite;
	private var delayTimer:Float = 5;
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFFFFFFFF;
		FlxG.cameras.flash(0xFFFFFFFF, 1);
		ratingScreen = new FlxSprite(0, 0, "assets/images/RatingScreen.png");
		add(ratingScreen);
		
		super.create();
	}
	
	override public function update():Void
	{
		if (delayTimer > 0)
			delayTimer -= FlxG.elapsed;
			
		if (delayTimer <= 0)
			FlxG.cameras.fade(0xFF000000, 1, false, onFinalFade);
		
		super.update();
	}
	
	override public function destroy():Void
	{
		ratingScreen = null;
		super.destroy();
	}

	private function onFinalFade():Void
	{
		FlxG.switchState(new WarningState()); 
	}
}