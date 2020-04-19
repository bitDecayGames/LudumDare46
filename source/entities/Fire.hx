package entities;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import entities.FireArt;


class Fire extends FlxGroup
{
    public var emitter:FlxEmitter;
    public var fireArt:FireArt;
    public var dead:Bool;
    public var duration:Float;
    public var MAX_DURATION:Float = 30;
    public var MIN_FREQUENCY:Float = 0.01;
    public var MAX_FREQUENCY:Float = 0.3;
    public var MAX_DRAG:Float = 125;
    public var DRAG_RATE:Float = 0.001;
    public var onFizzle:Void->Void;
    private var deathRate:Float;
    private var drag:Float = 0;

    public function new(x:Float, y:Float, duration:Float) {
        super();
        deathRate = (MIN_FREQUENCY - MAX_FREQUENCY) / MAX_DURATION;
        
        if (duration > MAX_DURATION) {
            duration = MAX_DURATION;
        }

        this.duration = duration;
        fireArt = new FireArt(x, y);
        add(fireArt);
        
        emitter = new FlxEmitter(x + fireArt.width / 2 - 13, y + fireArt.height / 2 - 23, 200);
		emitter.makeParticles(4, 6, FlxColor.ORANGE, 200);
		emitter.color.set(FlxColor.YELLOW, FlxColor.RED, FlxColor.BLACK);
        emitter.launchAngle.set(-80, -100);
        emitter.scale.set(0.25, 0.5, 1, 1.25);
        emitter.alpha.set(0.5, 0.5, 0, 0);
        resize();

        add(emitter);
    
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (dead) 
        {
            trace("about to fizzle");
            if (onFizzle != null) {
                trace("call fizzle");
                onFizzle();
            }
            return;
        }
        duration -= elapsed;
        if (duration <= 0) {
            duration = 0;
            dead = true;
            emitter.frequency = 5000;   // this number goes big so we can essentially stop this emiter, 
                                        // but the existing particles won't just disappear
            fireArt.kill();
        }
        else {
            emitter.frequency = getFrequency();
        }

        if (drag < MAX_DRAG) {
            drag += DRAG_RATE * duration;
        }   
        emitter.drag.set(0, drag);


        if (FlxG.keys.justPressed.H)
        {            
            addTime(5);
            trace("add duration: " + duration);
        }
        
        if (FlxG.keys.justPressed.L)
        {
            addTime(-5);
            trace("less duration: " + duration);

        }
    
        updateAnimation(duration);
    }
    

    private function updateAnimation(duration):Void
    {
        var newAnimation:String;
        if (duration > 2 / 3 * MAX_DURATION) {
            newAnimation = "raging";
        } else if (duration > 1 / 3 * MAX_DURATION) {
            newAnimation = "regular";
        } else {
            newAnimation = "tiny";
        }
        if (newAnimation != fireArt.currentAnimation) {
            trace("duration for animation change: " + duration);
        }
        fireArt.switchAnimation(newAnimation);
    }

    private function getFrequency():Float
    {
        return deathRate * duration + MAX_FREQUENCY;
    }

    public function start():Void
    {
        emitter.start(false, 0.01);        
    }

    public function addTime(seconds:Float) {
        var newDuration = duration + seconds;
        if (newDuration >= 0 && duration <= MAX_DURATION) {
            duration = newDuration;
        }
    }

    function resize()
    {
        var size = 25;
        emitter.setSize(size, size);
    }
}