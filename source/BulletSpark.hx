package ;

import flixel.FlxObject;

class BulletSpark extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/BulletSpark.png", true, 22, 18, false);
		animation.add("default", [0, 1, 0], 12, false);
		animation.play("default");
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		facing = Direction;
	}
	
	override public function update():Void
	{
		if (animation.finished)
			kill();
			
		super.update();
	}
}