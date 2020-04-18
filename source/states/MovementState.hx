package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;

class MovementState extends FlxState
{
	var player:Player;

	override public function create():Void
	{
		super.create();
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		player = new Player();
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
