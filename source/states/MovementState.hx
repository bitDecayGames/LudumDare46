package states;

import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import entities.Player;
import entities.TreeGroup;
import flixel.FlxG;
import flixel.FlxState;

class MovementState extends FlxState
{
	var player:Player;
	var playerGroup:FlxGroup;

	var treeGroup:TreeGroup;

	override public function create():Void
	{
		super.create();
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		playerGroup = new FlxGroup(1);
		add(playerGroup);

		player = new Player();
		playerGroup.add(player);

		treeGroup = new TreeGroup();
		add(treeGroup);
		treeGroup.spawn(2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(playerGroup, treeGroup);
	}

	private static function pixelPerfect(a: FlxSprite, b: FlxSprite): Bool {
		return FlxCollision.pixelPerfectCheck(a, b, 1);
	}
}
