package cameras;

import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxObject;

using extensions.FlxObjectExt;

class PositionAverager extends FlxObject {

	var followees:Array<FlxObject> = [];
	var avg:FlxVector = FlxVector.get();
	var tmp:FlxPoint = FlxPoint.get();

	public function new() {
		super();
	}

	public function addObject(o:FlxObject) {
		followees.push(o);
	}

	override public function update(delta:Float) {
		avg.set(0, 0);
		for (f in followees) {
			f.getMidpoint(tmp);
			avg.addPoint(tmp);
		}
		avg.scale(1/followees.length);
		this.setMidpoint(avg.x, avg.y);
	}
}