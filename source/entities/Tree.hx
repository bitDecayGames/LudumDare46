package entities;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class Tree extends FlxGroup {

	public var trunk:TreeTrunk;
	public var top:TreeTop;

	public function new() {
		super();
		
		trunk = new TreeTrunk(this);
		top = new TreeTop();
		add(trunk);
		add(top);
	}

	public function setPosition(x:Float, y:Float) {
		trunk.setMidpoint(x, y);
		top.setMidpoint(x, y);
	}
}