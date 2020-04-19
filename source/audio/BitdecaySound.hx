package audio;

import managers.HitboxManager;
import flixel.FlxSprite;
import audio.BitdecaySoundBank.SoundPath;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
#if !html5
import sys.FileSystem;
#end
import flixel.FlxG;

class BitdecaySound {

	private var debugSound:Bool = true;

	public var name:String;
	public var flxSounds:Array<FlxSound> = new Array();
	private var flxRandom:FlxRandom = new FlxRandom();
	private var lastPlayedIndex:Int = 100;

	public function new(soundName:String, soundPaths:Array<SoundPath>, MaxConcurrent:Int = 1) {

		name = soundName;

		for (soundPath in soundPaths) {
			#if !html5
			if (!FileSystem.exists(soundPath.path)) {
				throw 'Unable to find $soundPath sound file';
			}
			#end
			
			for (i in 0...MaxConcurrent) {
				var loadedSound:FlxSound = FlxG.sound.load(soundPath.path);
				loadedSound.volume = soundPath.volume;
				flxSounds.push(loadedSound);
			}
		}
	}

	// Due to a bug in FlxRandom's cpp transpiled code, I cannot shuffle the array directly. 
	//   An integer mapping array is used to work around this.
	public function play(?origin:FlxSprite, ?player:FlxSprite ) {
		var soundRange:Int = 200;
		var index = 0;
		var indexArray = new Array();
		for (i in 0...flxSounds.length) {
			indexArray.push(i);
		}
		flxRandom.shuffle(indexArray);
		indexArray.remove(lastPlayedIndex);
		for (index in indexArray) {
			if (!flxSounds[index].playing){

				if (origin != null && player != null){
					if (debugSound) {
						// trace('Setting location of ${name}[${index}] to ${origin.getPosition()} and is tracked by ${player}');
					}
					flxSounds[index].proximity(origin.getPosition().x, origin.getPosition().y, player, soundRange);
				} 

				if (debugSound) {
					trace('Playing ${name}[${index}] at volume ${flxSounds[index].volume}');
				}
				flxSounds[index].play();
				lastPlayedIndex = index;
				return;
			}
		}

		if (origin != null && player != null){
			if (debugSound) {
				// trace('Setting location of ${name}[${index}] to ${origin.getPosition()} and is tracked by ${player}');
			}
			flxSounds[index].proximity(origin.getPosition().x, origin.getPosition().y, player, soundRange);
		} 
		
		// If everything is currently playing, just reset the first one
		if (debugSound) {
			trace('All instances of the sound ${name} were playing. Restarting 0 at volume ${flxSounds[index].volume}');
		}
		flxSounds[0].play(true);
		lastPlayedIndex = index;
	}

	public function stop() {
		for (flxSound in flxSounds) {
			if (flxSound.playing){
				flxSound.stop();
			}
		}
	}

	public function isPlaying():Bool {
		for (flxSound in flxSounds) {
			if (flxSound.playing){
				return true;
			}
		}
		return false;
	}
}
