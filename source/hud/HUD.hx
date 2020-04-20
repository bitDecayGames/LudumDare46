package hud;

import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup.FlxTypedGroup;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;

 using flixel.util.FlxSpriteUtil;

 class HUD extends FlxTypedGroup<FlxSprite>
 {
     var dayNight:FlxSprite;

     public function new()
     {
         super();
         dayNight = new FlxSprite()
            .loadGraphic(AssetPaths.sky_clipart_day_and_night__png);
         add(dayNight);
         forEach(function(sprite) { sprite.scrollFactor.set(0, 0); });
     }
 }