package entities;

import flixel.tile.FlxTilemap;
import constants.GameConstants;
import flixel.group.FlxGroup;

class TreeGroup extends FlxTypedGroup<Tree> {
    static var TILE_SIZE = 32;

    var tilemap:FlxTilemap;

    public function new() {
        super(0);
        tilemap = new FlxTilemap();
    }

    public function getTiles():FlxTilemap {
        return tilemap;
    }

    public function spawn():Array<Tree> {
        var trees:Array<Tree> = [];

        var radius = 200;

        for (i in 1...5 + 1) {
            var tree = new Tree();
            var treeX = GameConstants.GAME_START_X + (radius * Math.cos(i * Math.PI / 2.5));
            var treeY = GameConstants.GAME_START_Y + (radius * Math.sin(i * Math.PI / 2.5));
            tree.setPosition(treeX, treeY);
            add(tree);
            trees.push(tree);
        }

        var tilemapCsv = "";
        var numHorizontalTiles = Std.int(GameConstants.GAME_WIDTH / TILE_SIZE);
        var numVerticalTiles = Std.int(GameConstants.GAME_WIDTH / TILE_SIZE);
        for (x in 0...numHorizontalTiles) {
            for (y in 0...numVerticalTiles) {
                var tileNum = 14;
                // var randVal = Std.int(Math.random() * 3);
                // if (randVal == 0) {
                //     tileNum = 3;
                // } else if (randVal == 1) {
                //     tileNum = 13;
                // } else if (randVal == 2) {
                //     tileNum = 14;
                // }

                tilemapCsv += Std.string(tileNum) + ",";
            }
            // Remove last trailing comma
            tilemapCsv = tilemapCsv.substring(0, tilemapCsv.length - 1);
            tilemapCsv += "\n";
        }

        // TODO Gen tilemap based on trees
        tilemap.loadMapFromCSV(tilemapCsv, AssetPaths.tiles__png, TILE_SIZE);

        return trees;
   }
}