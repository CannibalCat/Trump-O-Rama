package ;

import flixel.tweens.FlxTween;

class SpinnerEffect extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/Spinner.png", false, 84, 82, false);
		alpha = 0.1;
		scale.x = 0.25;
		scale.y = 0.25;
		angularVelocity = 1080;
		FlxTween.tween(scale, { x:4, y:4 }, 3, { type: FlxTween.ONESHOT } );
		FlxTween.tween(this, { alpha:0.8 }, 1.5, { type: FlxTween.ONESHOT, complete: fadeOut } );
	}
	
	private function fadeOut(tween:FlxTween):Void
	{
		FlxTween.tween(this, { alpha:0 }, 1, { type: FlxTween.ONESHOT, complete: onFadeOut } );
	}
	
	private function onFadeOut(tween:FlxTween):Void
	{
		kill();
	}
	
	override public function update():Void
	{
		color = ColorCycler.WilliamsUltraFlash;
		super.update();
	}
}