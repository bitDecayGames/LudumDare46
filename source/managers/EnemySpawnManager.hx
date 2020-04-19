package managers;

import entities.enemies.HardworkingFirefighter;
import entities.enemies.ConfusedZombie;
import entities.enemies.RegularAssZombie;
import entities.enemies.CopWithSomthingToProve;
import entities.enemies.KingOfPop;
import flixel.math.FlxRandom;
import entities.Throwable;
import entities.Enemy;
import entities.Tree;
import screens.GameScreen;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import entities.TreeTrunk;
import entities.Player;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.util.FlxSort;
import sorting.HitboxSorter;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import entities.EnemyFlock;
import hitbox.HitboxSprite;
import flixel.group.FlxGroup;
import entities.TreeGroup;
import entities.PlayerGroup;
import flixel.FlxBasic;

class EnemySpawnManager extends FlxBasic {
	private var maxUnits:Int = 15;
	private var curUnits:Int = 0;

	private var timer = 0.0;
	private var spawnFrequency = 15.0;

	private var flock:EnemyFlock;
	private var hitboxMgr:HitboxManager;
	private var firepit:FlxSprite;

	private var rnd:FlxRandom;

	private var enemyTypes:Array<EnemyType>;

	public function new(game:GameScreen, hitboxMgr:HitboxManager, firepit:FlxSprite) {
		super();
		game.add(this);
		this.hitboxMgr = hitboxMgr;
		flock = hitboxMgr.enemyFlock;
		this.firepit = firepit;

		rnd = new FlxRandom();

		enemyTypes = [
			new EnemyType(Type.getClassName(RegularAssZombie), -1, 1, spawnRegularAssZombie),
			new EnemyType(Type.getClassName(ConfusedZombie), -1, 1, spawnConfusedZombie),
			new EnemyType(Type.getClassName(HardworkingFirefighter), 5, 1, spawnHardworkingFirefighter),
			new EnemyType(Type.getClassName(CopWithSomethingToProve), 3, 1, spawnCopWithSomethingToProve),
			new EnemyType(Type.getClassName(KingOfPop), 1, 3, spawnKingOfPop),
		];
	}

	public function spawnRegularAssZombie():Enemy {
		return new RegularAssZombie(hitboxMgr);
	}

	public function spawnConfusedZombie():Enemy {
		return new ConfusedZombie(hitboxMgr);
	}

	public function spawnHardworkingFirefighter():Enemy {
		return new HardworkingFirefighter(hitboxMgr, firepit);
	}

	public function spawnCopWithSomethingToProve():Enemy {
		return new CopWithSomethingToProve(hitboxMgr);
	}

	public function spawnKingOfPop():Enemy {
		return new KingOfPop(hitboxMgr);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		timer -= elapsed;
		if (timer < 0) {
			triggerSpawnEvent();
		}
	}

	private function triggerSpawnEvent() {
		calculateCurrentUnits();
		timer = spawnFrequency;
		maxUnits = Math.ceil(maxUnits * 1.1);
		var e:EnemyType;
		while (curUnits < maxUnits) {
			e = randomEnemyType();
			if (e.count < e.max || e.max < 0) {
				var enemy = e.spawn();
				hitboxMgr.addEnemy(enemy);
				e.count += 1;
				curUnits += e.cost;
			}
		}
	}

	private function calculateCurrentUnits():Void {
		for (et in enemyTypes) {
			et.count = 0;
		}
		flock.forEachAlive((enemy) -> {
			var clazz = Type.getClassName(Type.getClass(enemy));
			for (et in enemyTypes) {
				if (et.name == clazz) {
					et.count += 1;
					break;
				}
			}
		});
		curUnits = 0;
		for (et in enemyTypes) {
			curUnits += et.count * et.cost;
		}
	}

	private function pickRandomLocation(enemy:Enemy):Void {
		// TODO: MW pick a location near the edge of the map, or possibly off the map?
	}

	private function randomEnemyType():EnemyType {
		var index = rnd.int(0, enemyTypes.length - 1);
		return enemyTypes[index];
	}
}

class EnemyType {
	public var name:String;
	public var max:Int;
	public var cost:Int;
	public var count:Int;
	public var spawn:() -> Enemy;

	public function new(name:String, max:Int, cost:Int, spawn:() -> Enemy) {
		this.name = name;
		this.max = max;
		this.cost = cost;
		this.spawn = spawn;
		count = 0;
	}
}
