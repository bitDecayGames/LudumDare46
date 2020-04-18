package entities;

import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

class Fire
{
    public var emitter:FlxEmitter;
    public var dead:Bool;
    public var duration:Float;
    public var MAX_DURATION:Float = 30;
    public var MIN_FREQUENCY:Float = 0.01;
    public var MAX_FREQUENCY:Float = 0.2;

    public function new(x, y, duration, fizzleCallback) {
        if (duration > MAX_DURATION) {
            duration = MAX_DURATION;
        }

        this.duration = duration;
        
        emitter = new FlxEmitter(x, y, 200);
		emitter.makeParticles(4, 6, FlxColor.ORANGE, 200);
		emitter.color.set(FlxColor.YELLOW, FlxColor.RED, FlxColor.BLACK);
		emitter.launchAngle.set(-80, -100);
		emitter.scale.set(0.5, 1, 2, 2.5);
		emitter.alpha.set(1,1,0,0);
        resize();
    }

    public function update(elapsed:Float):Void
    {
        if (dead) 
        {
            return;
        }
        duration -= elapsed;
        if (duration <= 0) {
            duration = 0;
            dead = true;
            emitter.kill();
        }
        else {
            var totalTimePassed:Float = MAX_DURATION - duration;
            //emitter.frequency = 0.01; //1.0 / duration;
            var slope:Float = (MIN_FREQUENCY - MAX_FREQUENCY) / MAX_DURATION;
            emitter.frequency = slope * duration + MAX_FREQUENCY;
            Sys.print("\nduration: " + duration + ", freq: " + emitter.frequency + ", slope: " + slope);

        }
        //resize();
    }
    
    public function start():Void
    {
        emitter.start(false, 0.01);        
    }

    function resize()
    {
        var size = 25;
        emitter.setSize(size, size);
        Sys.print(size + "\n");
    }
}


// super.create();
// emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 200);
// emitter.makeParticles(4, 6, FlxColor.ORANGE, 200);
// emitter.color.set(FlxColor.YELLOW, FlxColor.RED, FlxColor.BLACK);
// emitter.launchAngle.set(-80, -100);
// emitter.scale.set(0.5, 1, 2, 2.5);
// emitter.alpha.set(1,1,0,0);
// emitter.setSize(25, 25);
// add(emitter);
// emitter.start(false, 0.01);
