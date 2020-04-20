package audio;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;

enum BitdecaySongs {
	ZombieFuel;
	ZombieFuelLowPass;
	TitleScreen;
}

enum BitdecaySounds {
	BulletTimeIn;
	BulletTimeOut;
	Campfire;
	CampfireIgntite;
	FiremanWater;
	HumanBurn;
	HumanKnockout;
	LogHit;
	LogLand;
	MachoManDamage;
	MachoManFail;
	MachoManGruntThrow;
	MachoManGrunt;
	MachoManThrowPunch;
	MachoManOhYeah;
	MenuNavigate;
	MenuSelect;
	RockGround;
	RockHit;
	TreeHit;
	WoodFall;
	ZombieAttack;
	ZombieCrush;
	ZombieGroan;
	ZombieHit;
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
		BitdecaySounds.Campfire => {name: Std.string(BitdecaySounds.Campfire), instances: 1, paths: [
			{ path: AssetPaths.campfire__ogg, volume: 0.5}
		], soundClip: null},
		BitdecaySounds.CampfireIgntite => {name: Std.string(BitdecaySounds.CampfireIgntite), instances: 1, paths: [
			{ path: AssetPaths.campfire_ignite1__ogg, volume: .55},
			{ path: AssetPaths.campfire_ignite2__ogg, volume: .55},
		], soundClip: null},
		BitdecaySounds.FiremanWater => {name: Std.string(BitdecaySounds.FiremanWater), instances: 1, paths: [
			{ path: AssetPaths.fireman_water__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.HumanBurn => {name: Std.string(BitdecaySounds.HumanBurn), instances: 1, paths: [
			{ path: AssetPaths.human_burn__ogg, volume: .3},
		], soundClip: null},
		BitdecaySounds.HumanKnockout => {name: Std.string(BitdecaySounds.HumanKnockout), instances: 1, paths: [
			{ path: AssetPaths.human_knockout1__ogg, volume: .6},
			{ path: AssetPaths.human_knockout2__ogg, volume: .6},
		], soundClip: null},
		BitdecaySounds.LogHit => {name: Std.string(BitdecaySounds.LogHit), instances: 1, paths: [
			{ path: AssetPaths.log_hit1__ogg, volume: 1},
			{ path: AssetPaths.log_hit2__ogg, volume: 1},
			{ path: AssetPaths.log_hit3__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.LogLand => {name: Std.string(BitdecaySounds.LogLand), instances: 1, paths: [
			{ path: AssetPaths.log_land1__ogg, volume: .2},
			{ path: AssetPaths.log_land2__ogg, volume: .2},
			{ path: AssetPaths.log_land3__ogg, volume: .2},
		], soundClip: null},
		BitdecaySounds.MachoManDamage => {name: Std.string(BitdecaySounds.MachoManDamage), instances: 1, paths: [
			{ path: AssetPaths.macho_man_damage2__ogg, volume: 1},
			{ path: AssetPaths.macho_man_damage3__ogg, volume: 1},
			{ path: AssetPaths.macho_man_damage4__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.MachoManFail => {name: Std.string(BitdecaySounds.MachoManFail), instances: 1, paths: [
			{ path: AssetPaths.macho_man_fail__ogg, volume: 1}
		], soundClip: null},
		BitdecaySounds.MachoManGrunt => {name: Std.string(BitdecaySounds.MachoManGrunt), instances: 1, paths: [
			{ path: AssetPaths.macho_man_grunt2__ogg, volume: .7},
			{ path: AssetPaths.macho_man_grunt3__ogg, volume: .8},
			{ path: AssetPaths.macho_man_grunt4__ogg, volume: .8},
			{ path: AssetPaths.macho_man_grunt5__ogg, volume: .8},
			{ path: AssetPaths.macho_man_grunt7__ogg, volume: .8},
		], soundClip: null},
		BitdecaySounds.MachoManGruntThrow => {name: Std.string(BitdecaySounds.MachoManGruntThrow), instances: 1, paths: [
			{ path: AssetPaths.macho_man_grunt_throw1__ogg, volume: .4},
			{ path: AssetPaths.macho_man_grunt_throw2__ogg, volume: .6},
			{ path: AssetPaths.macho_man_grunt_throw3__ogg, volume: .6},
		], soundClip: null},
		BitdecaySounds.MachoManThrowPunch => {name: Std.string(BitdecaySounds.MachoManThrowPunch), instances: 5, paths: [
			{ path: AssetPaths.macho_man_throw_punch__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.MachoManOhYeah => {name: Std.string(BitdecaySounds.MachoManOhYeah), instances: 1, paths: [
			{ path: AssetPaths.macho_man_oh_yeah__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.MenuNavigate => {name: Std.string(BitdecaySounds.MenuNavigate), instances: 1, paths: [
			{ path: AssetPaths.menu_navigate__ogg, volume: .2},
		], soundClip: null},
		BitdecaySounds.MenuSelect => {name: Std.string(BitdecaySounds.MenuSelect), instances: 1, paths: [
			{ path: AssetPaths.menu_select__ogg, volume: .2},
		], soundClip: null},
		BitdecaySounds.RockGround => {name: Std.string(BitdecaySounds.RockGround), instances: 1, paths: [
			{ path: AssetPaths.rock_ground1__ogg, volume: 1},
			{ path: AssetPaths.rock_ground2__ogg, volume: 1},
			{ path: AssetPaths.rock_ground3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.RockHit => {name: Std.string(BitdecaySounds.RockHit), instances: 10, paths: [
			{ path: AssetPaths.rock_hit__ogg, volume: 0.6},
			{ path: AssetPaths.rock_hit2__ogg, volume: 0.6},
			{ path: AssetPaths.rock_hit3__ogg, volume: 0.6},
		], soundClip: null},
		BitdecaySounds.TreeHit => {name: Std.string(BitdecaySounds.TreeHit), instances: 1, paths: [
			{ path: AssetPaths.tree_hit1__ogg, volume: 0.15},
			{ path: AssetPaths.tree_hit2__ogg, volume: 0.15},
		], soundClip: null},
		BitdecaySounds.WoodFall => {name: Std.string(BitdecaySounds.WoodFall), instances: 1, paths: [
			{ path: AssetPaths.wood_fall1__ogg, volume: 1},
			{ path: AssetPaths.wood_fall2__ogg, volume: 1},
			{ path: AssetPaths.wood_fall3__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.ZombieAttack => {name: Std.string(BitdecaySounds.ZombieAttack), instances: 1, paths: [
			{ path: AssetPaths.zombie_attack1__ogg, volume: .35},
			{ path: AssetPaths.zombie_attack2__ogg, volume: .35},
			{ path: AssetPaths.zombie_attack3__ogg, volume: .35},
		], soundClip: null},
		BitdecaySounds.ZombieCrush => {name: Std.string(BitdecaySounds.ZombieCrush), instances: 1, paths: [
			{ path: AssetPaths.zombie_crush1__ogg, volume: 1},
			{ path: AssetPaths.zombie_crush2__ogg, volume: 1},
		], soundClip: null},
		BitdecaySounds.ZombieGroan => {name: Std.string(BitdecaySounds.ZombieGroan), instances: 10, paths: [
			{ path: AssetPaths.zombie_groan_loud1__ogg, volume: .4},
			{ path: AssetPaths.zombie_groan_loud3__ogg, volume: .4},
			{ path: AssetPaths.zombie_groan_loud4__ogg, volume: .4},
			{ path: AssetPaths.zombie_groan_loud5__ogg, volume: .4},
		], soundClip: null},
		BitdecaySounds.ZombieHit => {name: Std.string(BitdecaySounds.ZombieHit), instances: 1, paths: [
			{ path: AssetPaths.zombie_hit1__ogg, volume: .10},
			{ path: AssetPaths.zombie_hit2__ogg, volume: .10},
			{ path: AssetPaths.zombie_hit3__ogg, volume: .10},
		], soundClip: null},
	];

	public var flxSongs:Map<BitdecaySongs, MusicInfo> = [ 
		BitdecaySongs.ZombieFuel => {name: Std.string(BitdecaySongs.ZombieFuel), path:AssetPaths.song2__ogg, volume: .1},
		BitdecaySongs.ZombieFuelLowPass => {name: Std.string(BitdecaySongs.ZombieFuelLowPass), path:AssetPaths.song2_lowpass__ogg, volume: .1},
		BitdecaySongs.TitleScreen => {name: Std.string(BitdecaySongs.TitleScreen), path:AssetPaths.song__ogg, volume: .1},
	];

	public var song:FlxSound;
	public var preFadeVolume:Float;
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
		// trace('Instantiating sound engine');
		for(flxSound in flxSounds) {
			// trace('loading data for ${flxSound.name}');
			flxSound.soundClip = new BitdecaySound(flxSound.name, flxSound.paths, flxSound.instances);
		}
	}

	public function PlaySound(soundName:BitdecaySounds) {
		var soundInfo = flxSounds[soundName];
		if (soundInfo == null) {
			throw 'Tried to play sound effect ($soundName), but it was not found';
		}
		soundInfo.soundClip.play();
	}

	public function PlaySoundAtLocation(soundName:BitdecaySounds, origin:FlxSprite, player:FlxSprite) {
		var soundInfo = flxSounds[soundName];
		if (soundInfo == null) {
			throw 'Tried to play sound effect ($soundName), but it was not found';
		}
		soundInfo.soundClip.play(origin, player);
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
			song.group = FlxG.sound.defaultMusicGroup;

			// if (musicInfo.name == Std.string(BitdecaySongs.ZombieFuel)){
			// 	trace('${Std.string(BitdecaySongs.ZombieFuel)} found. Playing low pass version in parallel at volume ${flxSongs[BitdecaySongs.ZombieFuelLowPass].volume}');
			// 	songLowPass = FlxG.sound.load(flxSongs[BitdecaySongs.ZombieFuelLowPass].path);
			// 	songLowPass.looped = true;
			// 	songLowPass.volume = flxSongs[BitdecaySongs.ZombieFuelLowPass].volume;
			// 	songLowPass.group = FlxG.sound.defaultMusicGroup;
			// 	songLowPass.play();
			// }
			if (musicInfo.name == Std.string(BitdecaySongs.TitleScreen)) {
				// If it is the title screen, let it persist through menus until we manually fade it out
				song.persist = true;
			}

			trace('Playing ${musicInfo.name} at volume ${musicInfo.volume}');
			song.play();
		} else {
			trace('Song was already playing. Ignoring play request for ${songName}');
		}
	}
	
	public function TrackSong(existingSong:FlxSound){
		song = existingSong;
	}

	public function StopSongWithFadeOut(fadeDuration:Int = 1) {
		if (song == null){
			return;
		}

		StopSongWhenVolumeIsZero = true;
		song.fadeOut(fadeDuration);
		if(songLowPass != null){
			songLowPass.fadeOut(fadeDuration);
		}
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
		preFadeVolume = song.volume;
		song.fadeOut(0.5);
		songLowPass.fadeIn(0.5, 0, preFadeVolume);
	}

	public function TransitionToNormalSong() {
		if (mute_music) {
			return;
		}

		if (song == null || songLowPass == null) {
			throw 'Tried to get fade to low pass song, but one of the songs wasn\'t loaded';
		}
		songLowPass.fadeOut(0.5);
		song.fadeIn(0.5, 0, preFadeVolume);
	}

	public function update() {

		for(loopingSound in loopingSounds) {
			if (!loopingSound.isPlaying()) {
				loopingSound.play();
			}
		}

		if (StopSongWhenVolumeIsZero) {
			if(song != null && song.volume == 0){
				if (songLowPass != null) {
					if (songLowPass.volume == 0) {
						song.stop();
						songLowPass.stop();
						song.group = null;
					} 
					else {
						return;
					}
				}
				song.stop();
				song.group = null;
			}
		}
	}
}
