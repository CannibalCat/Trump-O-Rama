package ;

import flixel.util.FlxSpriteUtil;

class ExplosionFlash extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/ExplosionFlash.png", true, 302, 220, false);
		animation.add("flash", [0, 1, 2, 3], 16, false);		
		animation.play("flash");
		FlxSpriteUtil.fadeOut(this, 0.33);
	}
	
	override public function update():Void
	{
		if (animation.finished)
			kill();
			
		super.update();
	}
}