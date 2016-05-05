package ;

import flixel.FlxG;
import flixel.FlxObject;

enum ArrowType
{
	RESCUE;
	CAPTURE;
	ASSIST;
}

class ArrowHighlight extends Entity
{
	private var parentReference:Entity;
	private var parentClassName:String;
	private var y_offset:Float;
	private var x_offset:Float;
	private var duration:Float;
	private var elapsedTime:Float = 0;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, type:ArrowType, duration:Float=-1, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		this.duration = duration;
		
		parentClassName = Type.getClassName(Type.getClass(parentReference));
		
		if (type == ArrowType.RESCUE)
			loadGraphic("assets/images/RescueArrow.png", true, 56, 86, false);
		else if (type == ArrowType.CAPTURE)
			loadGraphic("assets/images/CaptureArrow.png", true, 56, 86, false);
		else if (type == ArrowType.ASSIST)
			loadGraphic("assets/images/AssistArrow.png", true, 56, 86, false);
			
		animation.add("default", [0, 1, 2, 3, 2, 1], 12, true);
		
		switch parentClassName
		{
			case "Laborer":
				this.y_offset = 86;
				
			case "Bimbo":
				this.y_offset = 88;
				
			case "Banker":
				this.y_offset = 60;
				
			case "Palin":
				this.y_offset = 88;
		}
		
		animation.play("default", true);	
	}
	
	override public function update():Void
	{
		if (duration != -1)
		{
			elapsedTime += FlxG.elapsed;
			if (elapsedTime > duration || !parentReference.alive || 
				parentReference.currentState == Entity.State.COLLECTED || 
				parentReference.currentState == Entity.State.DYING)
				kill();
		}
			
		if (parentClassName == "Banker")
		{
			if (parentReference.facing == FlxObject.LEFT)
				this.x_offset = -2;
			else
				this.x_offset = 4;
		}
		else if (parentClassName == "Bimbo")
		{
			if (parentReference.facing == FlxObject.LEFT)
				this.x_offset = -2;
			else
				this.x_offset = 4;
		}
		else if (parentClassName == "Laborer")
		{
			if (parentReference.facing == FlxObject.LEFT)
				this.x_offset = -2;
			else
				this.x_offset = 4;
		}
		else if (parentClassName == "Palin")
		{
			if (parentReference.facing == FlxObject.LEFT)
				this.x_offset = -2;
			else
				this.x_offset = 4;
		}
		
		x = ((parentReference.x + (parentReference.frameWidth / 2)) - (frameWidth / 2)) + x_offset;
		y = parentReference.y - y_offset;
		
		super.update();
	}
}