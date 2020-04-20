package managers;

import flixel.FlxG;
import entities.enemies.HardworkingFirefighter;
import entities.enemies.ConfusedZombie;
import entities.enemies.RegularAssZombie;
import entities.enemies.CopWithSomthingToProve;
import entities.enemies.KingOfPop;
import entities.enemies.SmokeyTheBear;
import entities.enemies.ShinyDemon;
import entities.enemies.NecroDancer;
import flixel.math.FlxRandom;
import entities.Enemy;
import screens.GameScreen;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import entities.EnemyFlock;
import flixel.FlxBasic;

class EnemySpawnManager extends FlxBasic {
	var game:GameScreen;
	private var maxUnits:Int = 15;
	private var curUnits:Int = 0;
	private var spawnFrequency:Float = 3.0;
	private var spawnRingRadius:Float = 600.0;

	private var timer = 0.0;
	private var flock:EnemyFlock;
	private var hitboxMgr:HitboxManager;
	private var firepit:FlxSprite;
	private var rnd:FlxRandom;
	private var enemyTypes:Array<EnemyType>;
	private var shouldSpawnEnemies:Bool = false;

	public function new(game:GameScreen, hitboxMgr:HitboxManager, firepit:FlxSprite) {
		super();
		this.game = game;
		game.add(this);
		this.hitboxMgr = hitboxMgr;
		flock = hitboxMgr.enemyFlock;
		this.firepit = firepit;

		rnd = new FlxRandom();

		enemyTypes = [
			new EnemyType(Type.getClassName(RegularAssZombie), 0.0, 2, 1, spawnRegularAssZombie),
			new EnemyType(Type.getClassName(ConfusedZombie), 0.1, 2, 1, spawnConfusedZombie),
			new EnemyType(Type.getClassName(HardworkingFirefighter), 0.2, 2, 1, spawnHardworkingFirefighter),
			new EnemyType(Type.getClassName(CopWithSomethingToProve), 0.2, 2, 1, spawnCopWithSomethingToProve),
			new EnemyType(Type.getClassName(KingOfPop), 0.8, 1, 3, spawnKingOfPop),
			new EnemyType(Type.getClassName(SmokeyTheBear), 0.5, 1, 2, spawnSmokeyTheBear),
			new EnemyType(Type.getClassName(ShinyDemon), 0.5, 1, 4, spawnShinyDemon),
			new EnemyType(Type.getClassName(NecroDancer), 0.75, 1, 4, spawnNecroDancer),
		];
	}

	public function startSpawningEnemies() {
		shouldSpawnEnemies = true;
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

	public function spawnSmokeyTheBear():Enemy {
		return new SmokeyTheBear(hitboxMgr);
	}

	public function spawnShinyDemon():Enemy {
		return new ShinyDemon(hitboxMgr);
	}

	public function spawnNecroDancer():Enemy {
		return new NecroDancer(hitboxMgr, firepit);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (shouldSpawnEnemies) {
			timer -= elapsed;
			if (timer < 0) {
				triggerSpawnEvent();
			}
		}
	}

	private function triggerSpawnEvent() {
		calculateCurrentUnits();
		timer = spawnFrequency;
		maxUnits = Math.ceil(maxUnits * 1.1);
		var e:EnemyType;
		e = randomEnemyType();
		if (e.count < e.max || e.max < 0) {
			var enemy = e.spawn();
			pickRandomLocation(enemy);
			hitboxMgr.addEnemy(enemy);
			e.count += 1;
			curUnits += e.cost;
		} else {
			FlxG.log.notice("Can't spawn: " + e.name);
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
		if (enemy.name == "devil") {
			enemy.x = firepit.x;
			enemy.y = firepit.y - 20;
		} else {
			var v = new FlxVector(rnd.float(-1.0, 1.0), rnd.float(-1.0, 1.0));
			v.normalize();
			v.scale(spawnRingRadius);
			enemy.x = v.x + firepit.x;
			enemy.y = v.y + firepit.y;
		}
	}

	private function randomEnemyType():EnemyType {
		var validTypes:Array<EnemyType> = [];
		for (et in enemyTypes) {
			if (game.victoryMgr.currentProgress() >= et.spawnThreshold) {
				validTypes.push(et);
			}
		}
		var index = rnd.int(0, validTypes.length - 1);
		var type = validTypes[index];
		return type;
	}
}

class EnemyType {
	public var name:String;
	// threshold of precentage of game left when this enemy spawns 0
	// 1 == never spawn
	// 0.5 == spawn halfway through the game
	// 0 == spawn immediately
	public var spawnThreshold:Float;
	public var max:Int;
	public var cost:Int;
	public var count:Int;
	public var spawn:() -> Enemy;

	public function new(name:String, spawnThreshold:Float, max:Int, cost:Int, spawn:() -> Enemy) {
		this.name = name;
		this.spawnThreshold = spawnThreshold;
		this.max = max;
		this.cost = cost;
		this.spawn = spawn;
		count = 0;
	}
}
