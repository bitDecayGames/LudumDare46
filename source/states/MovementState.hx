package states;

import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import entities.Player;
import entities.Tree;
import flixel.FlxG;
import flixel.FlxState;

class MovementState extends FlxState
{
	var player:Player;
	var playerGroup:FlxGroup;

	var treeGroup:FlxGroup;

	override public function create():Void
	{
		super.create();
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		playerGroup = new FlxGroup(1);
		add(playerGroup);

		player = new Player();
		playerGroup.add(player);

		treeGroup = new FlxGroup(100);
		add(treeGroup);

		var tree = new Tree();
		tree.x = player.x + 100;
		tree.y = player.y + 100;
		treeGroup.add(tree);
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
