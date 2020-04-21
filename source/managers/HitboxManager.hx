package managers;

import flixel.FlxState;
import flixel.FlxObject;
import entities.FireArt;
import entities.Throwable;
import entities.Enemy;
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

class HitboxManager extends FlxBasic {
	public var playerGroup:PlayerGroup;
	public var treeGroup:TreeGroup;
	public var fireGroup:FlxTypedGroup<FireArt>;
	public var itemGroup:FlxGroup;
	public var playerHitboxes:FlxTypedGroup<HitboxSprite>;
	public var enemyHitboxes:FlxTypedGroup<HitboxSprite>;
	public var intraEnemyHitboxes:FlxTypedGroup<HitboxSprite>;
	public var enemyFlock:EnemyFlock;
	public var sortGroup:FlxSpriteGroup;

	var boundsGroup:FlxGroup;

	var game:FlxState;

	public function new(game:FlxState) {
		super();
		this.game = game;
		game.add(this);
		treeGroup = new TreeGroup();
		game.add(treeGroup.getTiles());

		sortGroup = new FlxSpriteGroup(0);
		game.add(sortGroup);

		playerHitboxes = new FlxTypedGroup<HitboxSprite>(0);
		enemyHitboxes = new FlxTypedGroup<HitboxSprite>(0);
		intraEnemyHitboxes = new FlxTypedGroup<HitboxSprite>(0);

		playerGroup = new PlayerGroup(this);
		fireGroup = new FlxTypedGroup<FireArt>(0);
		itemGroup = new FlxGroup(0);
		enemyFlock = new EnemyFlock(playerGroup.player);

		boundsGroup = new FlxGroup(0);
	}

	public function setPlayZone(minX:Float, minY:Float, maxX:Float, maxY:Float) {
		var width = maxX - minX;
		var height = maxY - minY;

		var leftBound = new FlxObject(minX - 10, minY - 10, 10, height + 20);
		leftBound.immovable = true;

		var topBound = new FlxObject(minX - 10, minY - 10, width + 20, 10);
		topBound.immovable = true;

		var rightBound = new FlxObject(maxX, minY - 10, 10, height + 20);
		rightBound.immovable = true;

		var bottomBound = new FlxObject(minX - 10, maxY, width + 20, 10);
		bottomBound.immovable = true;

		boundsGroup.add(leftBound);
		boundsGroup.add(topBound);
		boundsGroup.add(rightBound);
		boundsGroup.add(bottomBound);

		game.add(leftBound);
		game.add(topBound);
		game.add(rightBound);
		game.add(bottomBound);
	}

	public function getPlayer():Player {
		return playerGroup.player;
	}

	public function addPlayerHitbox(f:HitboxSprite) {
		playerHitboxes.add(f);
		sortGroup.add(f);
	}

	public function addEnemyHitbox(f:HitboxSprite) {
		enemyHitboxes.add(f);
		sortGroup.add(f);
	}

	public function addIntraEnemyHitbox(f:HitboxSprite) {
		intraEnemyHitboxes.add(f);
		sortGroup.add(f);
	}

	public function addUniversalHitbox(f:HitboxSprite) {
		enemyHitboxes.add(f);
		intraEnemyHitboxes.add(f);
		sortGroup.add(f);
	}

	public function addFire(f:FireArt) {
		fireGroup.add(f);
		sortGroup.add(f);
	}

	public function addTrees() {
		for (t in treeGroup.spawn()) {
			sortGroup.add(t.trunk);
			sortGroup.add(t.top);
		}
	}

	public function addItem(i:FlxSprite) {
		itemGroup.add(i);
		sortGroup.add(i);
	}

	public function addEnemy(e:Enemy) {
		enemyFlock.add(e);
		sortGroup.add(e);
	}

	public function addGeneral(f:FlxSprite) {
		sortGroup.add(f);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		sortGroup.sort(HitboxSorter.sort, FlxSort.ASCENDING);

		// Environment restrictions
		FlxG.collide(playerGroup, treeGroup);
		FlxG.collide(playerGroup, fireGroup);
		FlxG.collide(enemyFlock, treeGroup);
		FlxG.collide(itemGroup, treeGroup);

		// Keep things in bounds
		FlxG.collide(playerGroup, boundsGroup);
		FlxG.collide(itemGroup, boundsGroup);

		// Environment interactions
		FlxG.collide(playerGroup, itemGroup);
		FlxG.overlap(enemyFlock, fireGroup, enemyTouchFire);
		FlxG.overlap(enemyFlock, itemGroup, enemyTouchItem);
		FlxG.collide(itemGroup, fireGroup, itemTouchFire);
		FlxG.overlap(playerHitboxes, itemGroup, playerHitItem);
		FlxG.overlap(playerHitboxes, treeGroup, hitTree);

		// Character interactions
		FlxG.overlap(playerHitboxes, enemyFlock, playerHitEnemy);
		FlxG.overlap(enemyHitboxes, playerGroup, enemyHitPlayer);
		FlxG.overlap(intraEnemyHitboxes, enemyFlock, enemyHitEnemy);
		FlxG.overlap(enemyFlock, enemyFlock, enemiesTouched);
	}

	private function itemTouchFire(item:Throwable, fire:FireArt) {
		fire.consume(item);
	}

	private function enemyTouchFire(enemy:Enemy, fire:FireArt) {
		if (enemy.state == BEING_THROWN || enemy.state == PICKUPABLE) {
			fire.consume(enemy);
		} else {
			FlxObject.separate(enemy, fire);
		}
	}

	private function enemyTouchItem(enemy:Enemy, item:FlxSprite) {
		if (Std.is(item, Throwable)) {
			var throwable = cast(item, Throwable);
			enemy.checkThrowableHit(throwable);
		}
	}

	private function playerHitEnemy(playerHitbox:HitboxSprite, enemy:Enemy) {
		if (playerHitbox.hasHit(enemy)) {
			return;
		}
		playerHitbox.registerHit(enemy);
		if (enemy.state == PICKUPABLE) {
			var player = cast(playerHitbox.source, Player);
			player.playerGroup.pickUp(enemy);
		} else {
			enemy.takeHit(playerHitbox.getMidpoint(), 150);
		}
	}

	private function enemyHitPlayer(enemyHitbox:HitboxSprite, player:Player) {
		if (enemyHitbox.hasHit(player)) {
			return;
		}
		enemyHitbox.registerHit(player);
		player.getHit(player.getPosition().subtractPoint(enemyHitbox.source.getPosition()));

		if (enemyHitbox.name == "bullet") {
			// bullets only hit one thing
			enemyHitbox.kill();
		}
	}

	private function enemyHitEnemy(hitbox:HitboxSprite, enemy:Enemy) {
		if (hitbox.source == enemy) {
			// they can't hit themselves
			return;
		}
		if (hitbox.hasHit(enemy)) {
			return;
		}
		hitbox.registerHit(enemy);
		enemy.takeHit(hitbox.getMidpoint(), 150);
		hitbox.kill();
	}

	private function enemiesTouched(e1:Enemy, e2:Enemy) {
		e1.checkThrowableHit(e2);
		e2.checkThrowableHit(e1);
	}

	private function hitTree(hitbox:HitboxSprite, tree:TreeTrunk) {
		if (hitbox.hasHit(tree)) {
			return;
		}
		hitbox.registerHit(tree);

		if (tree.hasLog) {
			var interactVector:FlxVector = hitbox.source.getMidpoint();
			interactVector.subtractPoint(tree.getMidpoint());
			SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.TreeHit);
			FlxG.camera.shake(0.0005, .1);
			var newLog = tree.spawnLog(interactVector);
			itemGroup.add(newLog);
			sortGroup.add(newLog);
		}
	}

	private static function playerHitItem(playerHitbox:HitboxSprite, item:FlxSprite) {
		if (playerHitbox.hasHit(item)) {
			return;
		}
		playerHitbox.registerHit(item);

		if (Std.is(item, Throwable)) {
			var throwable = cast(item, Throwable);
			if (throwable.state == PICKUPABLE) {
				var player = cast(playerHitbox.source, Player);
				player.playerGroup.pickUp(throwable);
			}
		}
	}
}
