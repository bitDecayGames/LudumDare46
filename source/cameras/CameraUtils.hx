package cameras;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxCamera;

class CameraUtils {

    // getCenterPoint returns the world coordinate that the center of the given camera is located at
    public static function getCenterPoint(cam:FlxCamera, ?p:FlxPoint):FlxPoint {
        if (p == null) {
            p = FlxPoint.get();
        }
		p.set(cam.x, cam.y);
		// Adjust for where the camera is looking
		p.addPoint(cam.scroll);
        // Start as the proper 'center' of the camera's viewport relative to the screen
		p.add(cam.width / 2.0, cam.height / 2.0);
        return p;
    }

    // project will project a world point through a camera and produce a screen coordinate
    public static function project(worldPoint:FlxPoint, cam:FlxCamera, ?p:FlxPoint):FlxPoint {
        if (p == null) {
            p = FlxPoint.get();
        }
        p.set(worldPoint.x, worldPoint.y);

        var center = getCenterPoint(cam);
        p.subtractPoint(center);
        p.scale(cam.zoom);
        p.addPoint(center);
        p.subtractPoint(cam.scroll);
        
        center.put();
        return p;
    }

    // unproject will take a screen coordinate and return a world coordinate via the given camera
    public static function unproject(screenPoint:FlxPoint, cam:FlxCamera, ?p:FlxPoint):FlxPoint {
        if (p == null) {
            p = FlxPoint.get();
        }

        p.set(screenPoint.x + cam.scroll.x, screenPoint.y + cam.scroll.y);

        var center = getCenterPoint(cam);
        p.subtractPoint(center);
        p.scale(1.0/cam.zoom);
        p.addPoint(center);
        return p;
    }
}