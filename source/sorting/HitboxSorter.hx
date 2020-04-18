package sorting;

import flixel.FlxSprite;
import flixel.util.FlxSort;

class HitboxSorter {
	public static inline function sort(order:Int, s1:FlxSprite, s2:flixel.FlxSprite):Int {
		return FlxSort.byValues(order, s1.getPosition().y + s1.height / 2, s1.getPosition().y + s2.height / 2);
	}
}