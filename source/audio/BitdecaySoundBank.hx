package audio;

import flixel.system.FlxSound;
import flixel.FlxG;

enum BitdecaySongs {
	ZombieFuel;
	ZombieFuelLowPass;
	TitleScreen;
}

enum BitdecaySounds {
	BulletTimeIn;
	BulletTimeOut;
	MachoManFail;
	MachoManGruntThrow;
	MachoManGrunt;
	MachoManThrowPunch;
	MenuSelect;
	RockGround;
	RockHit;
	TreeHit;
	WoodFall;
	ZombieCrush;
	ZombieGroan;
}

typedef SoundInfo = {
	var name:String;
	var instances:Int;
	var paths:Array<SoundPath>;
	var soundClip:BitdecaySound;
}

typedef SoundPath = {
	var path:String;
	var volume:Float;
}

typedef MusicInfo = {
	var name:String;
	var path:String;
	var volume:Float;
}

class BitdecaySoundBank {

	private var mute_music = false;

	public var flxSounds:Map<BitdecaySounds, SoundInfo> = [
		BitdecaySounds.BulletTimeIn => {name: Std.string(BitdecaySounds.BulletTimeIn), instances: 1, paths: [
			{ path: AssetPaths.BulletTimeIn__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.BulletTimeOut => {name: Std.string(BitdecaySounds.BulletTimeOut), instances: 1, paths: [
			{ path: AssetPaths.BulletTimeOut__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.MachoManFail => {name: Std.string(BitdecaySounds.MachoManFail), instances: 1, paths: [
			{ path: AssetPaths.macho_man_fail__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.MachoManGrunt => {name: Std.string(BitdecaySounds.MachoManGrunt), instances: 1, paths: [
			{ path: AssetPaths.macho_man_grunt1__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt2__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt3__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt4__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt5__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt6__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt7__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.MachoManGruntThrow => {name: Std.string(BitdecaySounds.MachoManGruntThrow), instances: 1, paths: [
			{ path: AssetPaths.macho_man_grunt_throw1__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt_throw2__ogg, volume: 1},
			{ path: AssetPaths.macho_man_grunt_throw3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.MachoManThrowPunch => {name: Std.string(BitdecaySounds.MachoManThrowPunch), instances: 1, paths: [
			{ path: AssetPaths.macho_man_throw_punch__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.MenuSelect => {name: Std.string(BitdecaySounds.MenuSelect), instances: 1, paths: [
			{ path: AssetPaths.menu_select__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.RockGround => {name: Std.string(BitdecaySounds.RockGround), instances: 1, paths: [
			{ path: AssetPaths.rock_ground1__ogg, volume: 1},
			{ path: AssetPaths.rock_ground2__ogg, volume: 1},
			{ path: AssetPaths.rock_ground3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.RockHit => {name: Std.string(BitdecaySounds.RockHit), instances: 1, paths: [
			{ path: AssetPaths.rock_hit__ogg, volume: 1},
			{ path: AssetPaths.rock_hit2__ogg, volume: 1},
			{ path: AssetPaths.rock_hit3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.TreeHit => {name: Std.string(BitdecaySounds.TreeHit), instances: 1, paths: [
			{ path: AssetPaths.tree_hit1__ogg, volume: 1},
			{ path: AssetPaths.tree_hit2__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.WoodFall => {name: Std.string(BitdecaySounds.WoodFall), instances: 1, paths: [
			{ path: AssetPaths.wood_fall1__ogg, volume: 1},
			{ path: AssetPaths.wood_fall2__ogg, volume: 1},
			{ path: AssetPaths.wood_fall3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.ZombieCrush => {name: Std.string(BitdecaySounds.ZombieCrush), instances: 1, paths: [
			{ path: AssetPaths.zombie_crush1__ogg, volume: 1},
			{ path: AssetPaths.zombie_crush2__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.ZombieGroan => {name: Std.string(BitdecaySounds.ZombieGroan), instances: 1, paths: [
			{ path: AssetPaths.zombie_groan1__ogg, volume: 1},
			{ path: AssetPaths.zombie_groan2__ogg, volume: 1},
			{ path: AssetPaths.zombie_groan3__ogg, volume: 1},
		], soundClip: null},
	];

	public var flxSongs:Map<BitdecaySongs, MusicInfo> = [ 
		BitdecaySongs.ZombieFuel => {name: Std.string(BitdecaySongs.ZombieFuel), path:AssetPaths.song2__ogg, volume: .5},
		BitdecaySongs.ZombieFuelLowPass => {name: Std.string(BitdecaySongs.ZombieFuelLowPass), path:AssetPaths.song2_lowpass__ogg, volume: .5},
		BitdecaySongs.TitleScreen => {name: Std.string(BitdecaySongs.TitleScreen), path:AssetPaths.song__ogg, volume: .5},
	];

	public var song:FlxSound;
	public var songLowPass:FlxSound;

	public var loopingSoundUniqueId:Int = 1;
	public var loopingSounds:Map<Int, BitdecaySound> = new Map();

	public var StopSongWhenVolumeIsZero:Bool = false;

	// private static var instance:BitdecaySoundBank;
	// public static function Instance():BitdecaySoundBank{
	// 	if (instance == null){
	// 		instance = new BitdecaySoundBank();
	// 	}
	// 	return instance;
	// }

	public function new () {
		trace('Instantiating sound engine');
		for(flxSound in flxSounds) {
			trace('loading data for ${flxSound.name}');
			flxSound.soundClip = new BitdecaySound(flxSound.name, flxSound.paths, flxSound.instances);
		}
	}

	public function PlaySound(soundName:BitdecaySounds) {
		trace('Trying to playce sound: ${soundName}');
		var soundInfo = flxSounds[soundName];
		if (soundInfo == null) {
			throw 'Tried to play sound effect ($soundName), but it was not found';
		}
		trace('Found sound ${soundInfo.name} loaded from ${soundInfo.paths} with sound clip ${soundInfo.soundClip}');
		soundInfo.soundClip.play();
	}

	public function PlaySoundLooped(soundName:BitdecaySounds):Int {
		var soundInfo = flxSounds[soundName];
		if (soundInfo == null) {
			throw 'Tried to load a looping sound effect ($soundName), but it was not found';
		}
		var soundId = loopingSoundUniqueId;
		loopingSounds[soundId] = new BitdecaySound(soundInfo.name, soundInfo.paths, 1);
		loopingSounds[soundId].play();

		loopingSoundUniqueId++;
		return soundId;
	}

	// This doesn't explicitly clean up the old sound. Does that happen for free?
	public function StopSoundLooped(loopedSoundId:Int) {
		var loopingSound = loopingSounds[loopedSoundId];
		if (loopingSound == null) {
			throw 'Tried to stop a looping sound effect (Id: $loopedSoundId), but it was not found';
		}
		loopingSound.stop();
		loopingSounds.remove(loopedSoundId);
	}

	public function PlaySong(songName:BitdecaySongs) {
		if (mute_music) {
			return;
		}

		if (song == null || !song.playing)
		{
			var musicInfo = flxSongs[songName]; 
			if (musicInfo == null) {
				throw 'Tried to get song ($songName), but it was not found';
			}

			song = FlxG.sound.load(musicInfo.path);
			song.looped = true;
			song.volume = musicInfo.volume;

			if (musicInfo.name == Std.string(BitdecaySongs.ZombieFuel)){
				trace('${Std.string(BitdecaySongs.ZombieFuel)} found. Playing low pass version in parallel at volume ${flxSongs[BitdecaySongs.ZombieFuelLowPass].volume}');
				songLowPass = FlxG.sound.load(flxSongs[BitdecaySongs.ZombieFuelLowPass].path);
				songLowPass.looped = true;
				songLowPass.volume = flxSongs[BitdecaySongs.ZombieFuelLowPass].volume;
				songLowPass.play();
			}

			trace('Playing ${musicInfo.name} at volume ${musicInfo.volume}');
			song.play();
		} else {
			trace('Song was already playing. Ignoring play request for ${songName}');
		}
	}

	public function StopSongWithFadeOut(fadeDuration:Int = 1) {
		StopSongWhenVolumeIsZero = true;
		song.fadeOut(fadeDuration);
	}

	public function IsSongPlaying():Bool {
		if (song == null){
			return false;
		}

		return song.playing;
	}

	public function TransitionToLowPassSong() {
		if (mute_music) {
			return;
		}

		if (song == null || songLowPass == null) {
			throw 'Tried to get fade to low pass song, but one of the songs wasn\'t loaded';
		}
		song.fadeOut(0.5);
		songLowPass.fadeIn(0.5);
	}

	public function TransitionToNormalSong() {
		if (mute_music) {
			return;
		}

		if (song == null || songLowPass == null) {
			throw 'Tried to get fade to low pass song, but one of the songs wasn\'t loaded';
		}
		song.fadeIn(0.5);
		songLowPass.fadeOut(0.5);
	}

	public function update() {
		for(loopingSound in loopingSounds) {
			if (!loopingSound.isPlaying()) {
				loopingSound.play();
			}
		}

		if (StopSongWhenVolumeIsZero) {
			if(song != null && song.volume == 0){
				song.stop();
				StopSongWhenVolumeIsZero = false;
			}
		}
	}
}
