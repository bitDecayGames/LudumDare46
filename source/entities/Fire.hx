package entities;

import faxe.FaxeSoundHelper;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import shaders.NightShader;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import entities.FireArt;
import entities.Throwable;

class Fire extends FlxGroup
{
    public var emitter:FlxEmitter;
    public var fireArt:FireArt;
    public var dead:Bool;
    public var duration:Float;
    public var alwaysBurns:Bool = false;
    public var MAX_DURATION:Float = 30;
    public var MIN_FREQUENCY:Float = 0.01;
    public var MAX_FREQUENCY:Float = 0.3;
    public var MAX_DRAG:Float = 125;
    public var DRAG_RATE:Float = 0.001;
    public var onFizzle:Void->Void;
    private var deathRate:Float;
    private var drag:Float = 0;
    private var isTimerGoing:Bool = false;

    private var burnRate:Float = 0.8;

    private var hasPlayedFizzle:Bool = false;

    private var MAX_RADIUS = 1.2;
    // Higher the number the more extreme the decay will taper off initially
    // and the closer it gets to zero
    private var DECAY_BASE = 200;

    public var shader:NightShader;

    public function new(shader:NightShader, x:Float, y:Float, duration:Float) {
        super();
        this.shader = shader;

        deathRate = (MIN_FREQUENCY - MAX_FREQUENCY) / MAX_DURATION;
        
        if (duration > MAX_DURATION) {
            duration = MAX_DURATION;
        }

        this.duration = duration;
        fireArt = new FireArt(x, y, this);
        trace("made new fireart");
        emitter = new FlxEmitter(x + fireArt.width / 2 - 13, y + fireArt.height / 2 - 23, 200);
		emitter.makeParticles(4, 6, FlxColor.ORANGE, 200);
		emitter.color.set(FlxColor.YELLOW, FlxColor.RED, FlxColor.BLACK);
        emitter.launchAngle.set(-80, -100);
        emitter.scale.set(0.25, 0.5, 1, 1.25);
        emitter.alpha.set(0.5, 0.5, 0, 0);
        resize();

        add(emitter);
    }

    public function setOnConsume(func:Throwable->Void) {
        this.fireArt.onConsume = func;
    }

    public function startFireTimer() {
        isTimerGoing = true;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (dead) 
        {
            if (onFizzle != null) {
                onFizzle();
            }
            return;
        }

        if (shader != null) { 
            shader.fireRadius.value = [calculateRadius()];
        }

        if (isTimerGoing){
            duration -= elapsed * burnRate;
        }
        
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
        }
        
        if (FlxG.keys.justPressed.L)
        {
            addTime(-5);
        }
    
        updateAnimation(duration);
    }
    
    function calculateRadius():Float {
        // value between 0 and 1 representing the strength of the fire
        var normalized = 1-Math.min(MAX_DURATION, duration) / MAX_DURATION;
        var radius = MAX_RADIUS;

        radius = 1 - normalized;

        // if (normalized < 0.6) {
        //     // linear decay for strong fire
        //     radius = 1 - 1.5*normalized;
        // } else {
        //     // exponential for the fading tail
        //     radius = Math.pow(50, -normalized);
        // }

        // exponential decay
        // var normalized = 1 - Math.min(MAX_DURATION, duration) / MAX_DURATION;
        // var radius = Math.pow(DECAY_BASE, -normalized);

        return radius;
    }

    private function updateAnimation(duration):Void
    {
        var newAnimation:String;
        if (duration > 0.6 * MAX_DURATION) {
            newAnimation = "raging";
        } else if (duration > 0.3 * MAX_DURATION) {
            newAnimation = "regular";
        } else if (duration > 0.1 * MAX_DURATION || alwaysBurns)  {
            newAnimation = "tiny";
        } else {
            trace("hiding a fire");
            if (!hasPlayedFizzle){
                // SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.CampfirePutout);
			    FaxeSoundHelper.GetInstance().PlaySound("CampfireFizzle");
                hasPlayedFizzle = true;
            }
            newAnimation = "none";
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