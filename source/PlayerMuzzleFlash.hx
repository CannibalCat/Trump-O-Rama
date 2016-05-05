package ;

import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

class PlayerMuzzleFlash extends Entity
{
	private var parentReference:Entity;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		
		loadGraphic("assets/images/PlayerMuzzleFlash.png", true, 22, 14, false);
		animation.add("default", [0, 1, 2, 3], 32, false);
		animation.play("default");	
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		facing = parentReference.facing;
		
		FlxSpriteUtil.fadeOut(this, 0.12);
	}

	override public function update():Void
    {
		setPosition(parentReference.offset_x, parentReference.offset_y);
		
		if (animation.finished)
			this.kill();
			
		super.update();
	}
}
