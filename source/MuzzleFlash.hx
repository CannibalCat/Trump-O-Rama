package ;

import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

class MuzzleFlash extends Entity
{
	private var parentReference:Entity;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/EnemyMuzzleFlash.png", true, 18, 10, false);
		animation.add("default", [0, 1, 2, 3], 32, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 

		parentReference = parentRef;
		
		setFlashPosition();
		facing = parentReference.facing;
		animation.play("default");	
		
		FlxSpriteUtil.fadeOut(this, 0.12);
	}

	override public function update():Void
    {
		setFlashPosition();
		
		if (animation.finished)
			this.kill();

		super.update();
	}
	
	private function setFlashPosition():Void
	{
		setPosition(parentReference.offset_x, parentReference.offset_y);
	}
}
