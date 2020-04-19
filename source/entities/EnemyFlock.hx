package entities;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

// This needs to be a sprite group to work with render sort ordering
class EnemyFlock extends FlxSpriteGroup {
	var player:Player;

	// MW is this going to create memory leaks?
	public var enemies:List<Enemy>;

	public function new(player:Player) {
		super();
		this.player = player;
		enemies = new List<Enemy>();
	}

	public override function add(obj:FlxSprite):FlxSprite {
		super.add(obj);

		var enemy = cast(obj, Enemy);
		enemies.add(enemy);
		enemy.flock = this;

		return obj;
	}

	public override function remove(obj:FlxSprite, splice:Bool = false):FlxSprite {
		super.remove(obj, splice);

		var enemy = cast(obj, Enemy);
		enemies.remove(enemy);
		enemy.flock = null;

		return obj;
	}
}
