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

    public function TransitionWithGlobalFlxMusicFade(state:FlxState) {
        destinationState = state;
        isTransitioning = true;
        SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MenuSelect);
        SoundBankAccessor.GetBitdecaySoundBank().StopSongWithFadeOut();
    }

    public function update() {
        if (isTransitioning) {
            if (!SoundBankAccessor.GetBitdecaySoundBank().IsSongPlaying()) {
                FlxG.switchState(destinationState);
            }
        }
    }
}