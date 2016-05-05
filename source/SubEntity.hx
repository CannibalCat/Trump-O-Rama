package ;

class SubEntity extends Entity
{
	private var parentReference:Entity;
	private var depth:Float;
	private var anchor_X:Float;
	private var anchor_Y:Float;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity, offset_X:Float=0, offset_Y:Float=0) 
	{
		depth = Z - Y;
		anchor_X = offset_X;
		anchor_Y = offset_Y;
		super(X, Y, Z);
		parentReference = parentRef;
	}
	
	override public function update():Void
	{
		setPosition(parentReference.x + anchor_X, parentReference.y + anchor_Y);
		z = y + depth;
		super.update();
	}
}