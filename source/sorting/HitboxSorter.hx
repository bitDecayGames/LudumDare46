package sorting;

import flixel.FlxSprite;
import flixel.util.FlxSort;

class HitboxSorter {
	// sort will sort things based on the CENTER-Y of their hitboxes
	public static inline function sort(order:Int, s1:FlxSprite, s2:flixel.FlxSprite):Int {
		return FlxSort.byValues(order, s1.y + s1.height / 2, s2.y + s2.height / 2);
	}
}