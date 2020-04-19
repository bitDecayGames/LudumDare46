package managers;

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

class HitboxManager extends FlxBasic {
	public var playerGroup:PlayerGroup;
	public var treeGroup:TreeGroup;
	public var itemGroup:FlxGroup;
	public var playerHitboxes:FlxTypedGroup<HitboxSprite>;
	public var enemyHitboxes:FlxTypedGroup<HitboxSprite>;
	public var intraEnemyHitboxes:FlxTypedGroup<HitboxSprite>;
	public var enemyFlock:EnemyFlock;
	public var sortGroup:FlxSpriteGroup;

	public function new(game:GameScreen) {
		super();
		game.add(this);

		sortGroup = new FlxSpriteGroup(0);
		game.add(sortGroup);

		playerHitboxes = new FlxTypedGroup<HitboxSprite>(0);
		enemyHitboxes = new FlxTypedGroup<HitboxSprite>(0);
		intraEnemyHitboxes = new FlxTypedGroup<HitboxSprite>(0);

		playerGroup = new PlayerGroup(this);
		treeGroup = new TreeGroup();
		itemGroup = new FlxGroup(0);
		enemyFlock = new EnemyFlock(playerGroup.player);
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
		FlxG.collide(enemyFlock, treeGroup);
		FlxG.collide(itemGroup, treeGroup);

		// Environment interactions
		FlxG.collide(playerGroup, itemGroup);
		FlxG.overlap(playerHitboxes, itemGroup, playerHitItem);
		FlxG.overlap(playerHitboxes, treeGroup, hitTree);

		// Character interactions
		FlxG.overlap(playerHitboxes, enemyFlock, playerHitEnemy);
		FlxG.overlap(enemyHitboxes, playerGroup, enemyHitPlayer);
		FlxG.overlap(intraEnemyHitboxes, enemyFlock, enemyHitEnemy);
	}

	private function playerHitEnemy(playerHitbox:HitboxSprite, enemy:Enemy) {
		if (enemy.state == PICKUPABLE) {
			var player = cast(playerHitbox.source, Player);
			player.playerGroup.pickUp(enemy);
		} else {
			enemy.takeHit(playerHitbox.getMidpoint(), 30);
		}
	}

	private function enemyHitPlayer(enemy:HitboxSprite, player:Player) {
		player.getHit(player.getPosition().subtractPoint(enemy.source.getPosition()));
	}

	private function enemyHitEnemy(hitbox:HitboxSprite, enemy:Enemy) {
		if (hitbox.source == enemy) {
			// they can't hit themselves
			return;
		}
		FlxG.log.notice("Enemy wrecked themselves");
		enemy.takeHit(hitbox.getMidpoint(), 30);
		hitbox.kill();
	}

	private function hitTree(player:FlxSprite, tree:TreeTrunk) {
		if (tree.hasLog) {
			var interactVector:FlxVector = player.getMidpoint();
			interactVector.subtractPoint(tree.getMidpoint());
			SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.TreeHit);
			var newLog = tree.spawnLog(interactVector);
			itemGroup.add(newLog);
			sortGroup.add(newLog);
		}
	}

	private static function playerHitItem(playerHitbox:HitboxSprite, item:FlxSprite) {
		if (Std.is(item, Throwable)) {
			var throwable = cast(item, Throwable);
			if (throwable.state == PICKUPABLE) {
				var player = cast(playerHitbox.source, Player);
				player.playerGroup.pickUp(throwable);
			}
		}
	}
}
