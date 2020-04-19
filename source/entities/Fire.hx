package entities;

import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class Fire extends FlxGroup
{
    public var emitter:FlxEmitter;
    public var dead:Bool;
    public var duration:Float;
    public var MAX_DURATION:Float = 30;
    public var MIN_FREQUENCY:Float = 0.01;
    public var MAX_FREQUENCY:Float = 0.3;
    public var MAX_DRAG:Float = 125;
    public var DRAG_RATE:Float = 0.001;
    private var deathRate:Float;
    private var drag:Float = 0;

    public function new(x:Float, y:Float, duration:Float) {
        super();
        deathRate = (MIN_FREQUENCY - MAX_FREQUENCY) / MAX_DURATION;
        
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
    
        add(emitter);
        resize();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (dead) 
        {
            return;
        }
        duration -= elapsed;
        if (duration <= 0) {
            duration = 0;
            dead = true;
            emitter.frequency = 5000;   // this number goes big so we can essentially stop this emiter, 
                                        // but the existing particles won't just disappear
        }
        else {
            emitter.frequency = getFrequency();
        }

        if (drag < MAX_DRAG) {
            drag += DRAG_RATE * duration;
        }   
        emitter.drag.set(0, drag);
        Sys.print("\nduration: " + duration + ", drag: " + drag + " frequency: " + emitter.frequency);
    }
    
    private function getFrequency():Float
    {
        return deathRate * duration + MAX_FREQUENCY;
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
