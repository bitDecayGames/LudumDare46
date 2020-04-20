package tiled;

import haxe.io.Path;
import flixel.tile.FlxTilemap;
import entities.Tree;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;

// Originally from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
// Modified for this game.
/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/Tiles/";

    public var backgroundTiles:FlxTilemap;

	public function new(tiledLevel:FlxTiledMapAsset, treeGroup: FlxTypedGroup<Tree>)
	{
        super(tiledLevel);

        // TODO Jake C-T this might be good to add in
		// FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

		loadObjects(treeGroup);

		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE)
				continue;
			var tileLayer:TiledTileLayer = cast layer;

			var tileSheetName:String = tileLayer.properties.get("tileset");

			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}

			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

			var imagePath = new Path(tileSet.imageSource);
			var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

			if (layer.name == "Background") {
                backgroundTiles = tilemap;
            }
        }
        
        if (backgroundTiles == null) {
            throw "Is there a Background tile layer on this map?";
        }
	}

	public function loadObjects(treeGroup: FlxTypedGroup<Tree>)
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			// objects layer
			if (layer.name == "objects")
			{
				for (o in objectLayer.objects)
				{
					loadObject(o, objectLayer, treeGroup);
				}
			}
		}
	}

	function loadObject(o:TiledObject, g:TiledObjectLayer, treeGroup: FlxTypedGroup<Tree>)
	{
        var x:Int = o.x;
		var y:Int = o.y;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

		switch (o.type.toLowerCase())
		{
			case "tree":
                var tileset = g.map.getGidOwner(o.gid);
                var tree = new Tree();
                tree.setPosition(x, y);
                treeGroup.add(tree);
		}
	}

}