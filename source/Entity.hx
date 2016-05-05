package ;

import flixel.FlxSprite;

enum State
{
	IDLE;
	WANDERING;
	CHASING;
	PURSUING;
	EVADING;
	RUNNING_AWAY;
	IN_CHOPPER;
	COLLECTED;
	DESCENDING;
	LANDED;
	DISCARDED;
	EXPLODING;
	JUMPING;
	DYING;
	SHOOTING;
	HUNTING;
	FOLLOWING;
	IDLE_SHOOTING;
	ATTACKING;
	TRANSFORMING;
	TAKING_OFF;
	HOVERING;
	ACCELERATING;
	DRIVING;
	BRAKING;
	UNLOADING;
	RUN_OVER;
}

class Entity extends FlxSprite
{
	public var z:Float;
	public var currentState:State;
	public var previousState:State;
	public var target:Entity;
	public var scoreValue:Int = 0;
	public var offset_x:Float;
	public var offset_y:Float;

	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		z = Z;
		currentState = IDLE;
		previousState = IDLE;
		offset_x = 0;
		offset_y = 0;
		super(X, Y);
	}
	
	public function changeState(newState:Entity.State):Void
	{
		previousState = currentState;
		currentState = newState;
	}
}