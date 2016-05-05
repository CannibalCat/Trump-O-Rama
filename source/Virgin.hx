package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class Virgin extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private var transformTimer:Float = 0;
	private var parentState:ParadiseState;
	private var reflection:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT, parentState:ParadiseState) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Virgin.png", true, 86, 150, false);
		animation.add("idle", [2], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("transform", [5, 10], 18, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE; 
		this.parentState = parentState;
		
		reflection = new FlxSprite();
		reflection.loadGraphic("assets/images/VirginReflection.png", true, 86, 150, false);
		reflection.animation.add("idle", [2], 1, true);
		reflection.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		reflection.animation.add("transform", [5, 10], 18, true);
		reflection.setFacingFlip(FlxObject.LEFT, true, false); 
		reflection.setFacingFlip(FlxObject.RIGHT, false, false); 
		reflection.alpha = 0.3;
		reflection.scrollFactor.set(0, 0);
		reflection.animation.play("idle");
		
		target = null;
		facing = Direction;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.TRANSFORMING)
		{
			animation.play("transform");
			reflection.animation.play("transform");
		}
	
		super.changeState(newState);
	}
	
	override public function draw():Void
	{
		reflection.draw();
		super.draw();
	}
	
    override public function update():Void
	{
		reflection.x = x;
		reflection.y = z;
		reflection.facing = facing;
		reflection.update();
		
		if (target != null && !target.alive)
			target = null;
			
		if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			animation.play("idle");
			reflection.animation.play("idle");
		}
		else if (currentState == Entity.State.TRANSFORMING)
		{
			velocity.x = 0;
			velocity.y = 0;		
				
			transformTimer += FlxG.elapsed;
			if (transformTimer > 2.5)
			{
				var convert:NiqabiDemon = new NiqabiDemon(x, z - 146, z, facing, parentState);
				convert.changeState(Entity.State.CHASING);
				convert.scrollFactor.set(0, 0);
				parentState.displayList.add(convert);
				kill();
			}
		}
		
		z = y + frameHeight;
	
		super.update();
	}
}