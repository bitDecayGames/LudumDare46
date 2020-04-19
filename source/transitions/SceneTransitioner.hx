package transitions;

import audio.SoundBankAccessor;
import flixel.FlxState;
import audio.BitdecaySound;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import audio.BitdecaySoundBank;

class SceneTransitioner {

    public var isTransitioning:Bool;
    public var destinationState:FlxState;

    public function new () {}

    public function TransitionWithMusicFade(state:FlxState, fadeDuration:Int = 1) {
        destinationState = state;
        isTransitioning = true;
        SoundBankAccessor.GetBitdecaySoundBank().StopSongWithFadeOut(fadeDuration);
    }

    public function update() {
        if (isTransitioning) {
            if (!SoundBankAccessor.GetBitdecaySoundBank().IsSongPlaying()) {
                FlxG.switchState(destinationState);
            }
        }
    }
}