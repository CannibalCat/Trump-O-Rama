package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;

class NakedTrump extends Entity
{
	private static var WALK_SPEED:Float = 125;
	private var reflection:FlxSprite;

	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);

		loadGraphic("assets/images/NakedTrump.png", true, 102, 136, false);
		animation.add("idle", [1], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, true);
		animation.add("fall", [10, 11, 12, 13], 12, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		animation.play("idle");
		
		reflection = new FlxSprite();
		reflection.loadGraphic("assets/images/NakedTrumpReflection.png", true, 102, 136, false);
		reflection.animation.add("idle", [1], 1, true);
		reflection.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, true);
		reflection.setFacingFlip(FlxObject.LEFT, true, false); 
		reflection.setFacingFlip(FlxObject.RIGHT, false, false); 
		reflection.alpha = 0.3;
		reflection.scrollFactor.set(0, 0);
		reflection.setPosition(x, z);
		reflection.facing = facing;
		reflection.animation.play("idle");
		
		target = null;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.FOLLOWING)
		{
			animation.play("walk");
			reflection.animation.play("walk");
		}
		else if (newState == Entity.State.IDLE)
		{
			animation.play("idle");
			reflection.animation.play("idle");		
		}
	
		super.changeState(newState);
	}
	
	override public function draw():Void
	{
		if (animation.curAnim.name != "fall")
			reflection.draw();
			
		super.draw();
	}
    override public function update():Void
	{
		if (animation.curAnim.name != "fall")
		{
			reflection.x = x;
			reflection.y = z;
			reflection.facing = facing;
			reflection.update();
		}
		
		if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;	
		
		z = y + frameHeight;
	
		super.update();
	}
}