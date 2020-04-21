package managers;

import flixel.math.FlxMath;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.FlxG;
import entities.enemies.Dancer;
import flixel.math.FlxRandom;
import entities.Enemy;
import screens.GameScreen;
import flixel.FlxSprite;
import flixel.math.FlxVector;
import entities.EnemyFlock;
import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxGraphicAsset;

class DancePartyManager extends FlxBasic {
	var game:FlxState;
	private var totalUnits:Int = 200;
	private var innerRingRadius:Float = 50.0;

	private var spawnRingRadius:Float;
	private var timer = 0.0;
	private var flock:EnemyFlock;
	private var hitboxMgr:HitboxManager;
	private var rnd:FlxRandom;
	private var unitTypes:Array<FlxGraphicAsset>;
	private var center:FlxPoint;

	private var dancers:List<Dancer>;

	public function new(game:FlxState, hitboxMgr:HitboxManager, center:FlxPoint) {
		super();
		this.game = game;
		game.add(this);
		this.hitboxMgr = hitboxMgr;
		flock = hitboxMgr.enemyFlock;
		rnd = new FlxRandom();
		this.center = center;
		dancers = new List<Dancer>();

		unitTypes = [
			AssetPaths.Bear__png,
			AssetPaths.Zombie__png,
			AssetPaths.Skeleton__png,
			AssetPaths.Necromancer__png,
			AssetPaths.Devil__png,
			AssetPaths.Firefighter__png,
			AssetPaths.Cop__png,
			AssetPaths.Jackson__png,
		];

		hitboxMgr.getPlayer().kill();

		var u = new Dancer(hitboxMgr, AssetPaths.Player__png);
		u.x = center.x;
		u.y = center.y;
		hitboxMgr.addGeneral(u);
		for (i in 0...totalUnits) {
			spawnRandomUnit();
		}
	}

	private function spawnRandomUnit() {
		var u = new Dancer(hitboxMgr, randomUnitType());
		pickSafeLocation(u);
		hitboxMgr.addGeneral(u);
		dancers.add(u);
	}

	private function pickSafeLocation(u:FlxSprite) {
		var v:FlxPoint = new FlxPoint(0, 0);
		var goodPoint = true;
		for (i in 0...30) {
			v = pickRandomLocation();
			for (dancer in dancers) {
				if (FlxMath.distanceToPoint(dancer, v) < dancer.personalBubble) {
					goodPoint = false;
					break;
				}
			}
			if (goodPoint) {
				break;
			}
		}
		u.x = v.x;
		u.y = v.y;
	}

	private function pickRandomLocation():FlxPoint {
		var v = new FlxVector(rnd.float(-1.0, 1.0), rnd.float(-1.0, 1.0));
		var inner = new FlxVector(v.x, v.y);
		inner.normalize();
		inner.scale(innerRingRadius);
		v.x *= FlxG.width / 2.0 - innerRingRadius * 2;
		v.y *= FlxG.height / 2.0 - innerRingRadius * 2;
		return new FlxPoint(v.x + center.x + inner.x, v.y + center.y + inner.y);
	}

	private function randomUnitType():FlxGraphicAsset {
		var index = rnd.int(0, unitTypes.length - 1);
		var type = unitTypes[index];
		return type;
	}
}
