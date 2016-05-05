package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

class Parachute extends Entity
{
	private var elapsedTime:Float = 0;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/Chute.png", true, 118, 70, false);
		animation.add("default", [0, 1, 2, 3, 4, 5], 10, false);
		animation.play("default");
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
	}
	
	private function onFadeOut(tween:FlxTween):Void
	{
		kill();
	}
	
	public override function update():Void
	{
		elapsedTime += FlxG.elapsed;
		velocity.y -= 4 *  (1 + elapsedTime);
		
		if (animation.finished)
			FlxTween.tween(this, { alpha:0 }, 0.5, { type: FlxTween.ONESHOT, complete: onFadeOut } );
		
		super.update();
	}
}