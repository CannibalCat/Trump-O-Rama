package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.system.FlxSound;

class Niqabi extends Entity
{
	public var landingLine:Float;
	
	private static var WALK_SPEED:Float = 72;
	private static var RUN_SPEED:Float = 175;
	private static var blastRange:Int = 100;	
	private static var trackingRange:Int = 300;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var fuseCounter:Float = 0;
	private var warCry:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Niqabi.png", true, 72, 122, false);
		animation.add("idle", [5], 1, true);
		animation.add("jumping", [4], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("exploding", [20, 21], 15, true);
		
		warCry = FlxG.sound.load("assets/sounds/NiqabiWarCry.wav", 1);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		target = null;
		facing = Direction;
		scoreValue = 150;
		health = 3;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EXPLODING)
			FlxG.sound.play("EvilLaugh");
		else if (newState == Entity.State.JUMPING)
		{
			FlxG.sound.play("Jump" + FlxRandom.intRanged(1, 2)); 
			animation.play("jumping");
			velocity.y = -200;
			velocity.x = 150;
			acceleration.y = 400;
		}
		else if (newState == Entity.State.CHASING)
		{
			warCry.play();
			animation.play("attack", true, -1);
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (facing == FlxObject.RIGHT)
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;		
				
			animation.play("walk", true, -1);
		}
		else if (newState == Entity.State.IDLE)
			animation.play("idle");
	
		super.changeState(newState);
	}
	
    override public function update():Void
	{
		z = y + frameHeight;
		
		if (target != null && target.alive && target.currentState == Entity.State.IN_CHOPPER)
			changeState(Entity.State.WANDERING);
		
		if (currentState == Entity.State.WANDERING)
		{
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				if (FlxRandom.chanceRoll(50))
					velocity.x = WALK_SPEED;
				else
					velocity.x = -WALK_SPEED;
				
				if (FlxRandom.chanceRoll(75))
					velocity.y = 0;
				else if (FlxRandom.chanceRoll(50))
					velocity.y = WALK_SPEED;	
				else
					velocity.y = -WALK_SPEED;
			}
			
			if (target != null && target.alive && target.currentState != Entity.State.IN_CHOPPER)
			{
				if (FlxRandom.chanceRoll(5) && FlxMath.distanceBetween(this, target) < trackingRange)
					changeState(Entity.State.CHASING);
			}
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
		}
		else if (currentState == Entity.State.CHASING)
		{
			if (target != null && target.alive)
			{
				if (x < target.x)
					velocity.x = RUN_SPEED;
				else if (x > target.x + (target.frameWidth / 2))
					velocity.x = -RUN_SPEED;	
				else
					velocity.x = 0;
					
				if (z < target.z)
					velocity.y = RUN_SPEED;
				else if (z > target.z)
					velocity.y = -RUN_SPEED;
				else 
					velocity.y = 0;
					
				if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
				
				if (FlxMath.distanceBetween(this, target) < blastRange) 
					changeState(Entity.State.EXPLODING);
			}
			else 
				changeState(Entity.State.WANDERING);
		}
		else if (currentState == Entity.State.EXPLODING)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			fuseCounter += FlxG.elapsed;
			if (fuseCounter > 1)
			{
				explode(true);
				FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
				FlxG.sound.play("FemaleDie");
				kill();
			}
			
			animation.play("exploding");
		}
		else if (currentState == Entity.State.JUMPING)
		{
			if (z >= landingLine)
			{
				velocity.y = 0;
				velocity.x = 0;
				changeState(Entity.State.CHASING);
			}
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			if (target != null)
			{
				if (x < target.x)
					facing = FlxObject.RIGHT;
				else if (x > target.x)
					facing = FlxObject.LEFT;
			}
		}
		
		if (z <= Globals.horizonLimit) 
		{
			if (currentState == Entity.State.CHASING)
				velocity.y = RUN_SPEED;
			else
				velocity.y = WALK_SPEED;
		}
		else if (z >= FlxG.camera.bounds.height)
		{
			if (currentState == Entity.State.CHASING)
				velocity.y = -RUN_SPEED;
			else
				velocity.y = -WALK_SPEED;			
		}
			
		if (x + frameWidth < 0 || x > FlxG.camera.bounds.width || 
			x < FlxG.camera.scroll.x - FlxG.width || x > FlxG.camera.scroll.x + (FlxG.width * 2))
		{
			Globals.globalGameState.waveData.currentNiqabis--;
			super.kill();
		}
		
		super.update();
	}
	
	private function explode(withShrapnel:Bool=false):Void
	{
		var center:FlxPoint = getGraphicMidpoint();
		Globals.globalGameState.displayList.add(new ExplosionFlash(center.x - 151, z - 220, z - 1));
		Globals.globalGameState.displayList.add(new Explosion(center.x - 64, center.y - 64, z + 1, Explosion.ExplosionType.FIRE));
		Globals.globalGameState.blowChunks(this, false);
		FlxG.camera.flash(0xFFFFFFFF, 0.1);
		FlxG.camera.shake(0.01, 0.5);
		
		FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
		
		if (withShrapnel)
		{
			var fullCircle:Float = 2 * Math.PI;
			var interval:Float = fullCircle / 8; 
			var length:Int = 350; 
			var angle:Float = 0;
			
			while (angle < fullCircle)
			{
				var shrapnel = Globals.globalGameState.shrapnel.recycle();
				shrapnel.x = center.x;
				shrapnel.y = center.y;
				shrapnel.z = z + 1;
				shrapnel.velocity = new FlxPoint(length * Math.cos(angle), length * Math.sin(angle));
				Globals.globalGameState.displayList.add(shrapnel);
				angle += interval;
			}
		}
	}
	
	override public function kill():Void
	{
		if (warCry.playing)
			warCry.stop();
		FlxG.sound.play("FemaleDie");
		Globals.globalGameState.updateScore(scoreValue);
		if (Globals.currentWave != 25)
			Globals.globalGameState.updateApprovalRating(1);
		Globals.killsCount++;
		Globals.globalGameState.waveData.currentNiqabis--;
		super.kill();
	}
	
	override public function hurt(damage:Float):Void
	{
		super.hurt(damage);
		FlxG.sound.play("FleshHit");
	}
}