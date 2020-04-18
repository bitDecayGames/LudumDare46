package entities;

import flixel.group.FlxGroup.FlxTypedGroup;

class EnemyFlock extends FlxTypedGroup<Enemy> {
	var player:Player;

	public var enemies:List<Enemy>;

	public function new(player:Player) {
		super();
		this.player = player;
		enemies = new List<Enemy>();
	}

	public override function add(obj:Enemy):Enemy {
		super.add(obj);
		enemies.add(obj);
		obj.flock = this;
		return obj;
	}

	public override function remove(obj:Enemy, splice:Bool = false):Enemy {
		super.remove(obj, splice);
		enemies.remove(obj);
		obj.flock = null;
		return obj;
	}
}
