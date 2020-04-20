package sorting;

import flixel.FlxSprite;
import flixel.util.FlxSort;
import entities.WaterSplash;

class HitboxSorter {
	// sort will sort things based on the CENTER-Y of their hitboxes
	public static inline function sort(order:Int, s1:FlxSprite, s2:FlxSprite):Int {
		// HACKS figure out another way to do this
		var largeValue = 999999;
		var s1Z = Type.getClass(s1) == WaterSplash ? largeValue : 0;
		var s2Z = Type.getClass(s2) == WaterSplash ? largeValue : 0;

		return FlxSort.byValues(order, s1.y + (s1.height / 2) + s1Z, s2.y + (s2.height / 2) + s2Z);
	}

	public static inline function sortNested(order:Int, s1:FlxSprite, s2:FlxSprite):Int {
		return FlxSort.byValues(order, s1.y + s1.height / 2, s2.y + s2.height / 2);
	}
}