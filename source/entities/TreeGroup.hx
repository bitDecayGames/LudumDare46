package entities;

import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import tiled.TiledLevel;

class TreeGroup extends FlxTypedGroup<Tree> {
    var level:TiledLevel;

    public function new() {
        super(0);
        level = new TiledLevel(AssetPaths.map__tmx, this);
    }

    public function getTiles():FlxTilemap {
        return level.backgroundTiles;
    }

    public function spawn():Array<Tree> {
        var trees:Array<Tree> = [];

        for (t in this) {
            trees.push(t);
        }

        return trees;
   }
}