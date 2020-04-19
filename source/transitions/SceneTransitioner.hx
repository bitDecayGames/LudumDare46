package transitions;

import audio.BitdecaySound;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import audio.BitdecaySoundBank;

class SceneTransitioner {

    public var isTransitioning:Bool;
    public var destinationState:FlxUIState;
    public var bitdecaySoundBank:BitdecaySoundBank;

    public function new (theBitdecaySoundBank:BitdecaySoundBank) {
        bitdecaySoundBank = theBitdecaySoundBank;
    }

    public function TransitionWithMusicFade(state:FlxUIState) {
        destinationState = state;
        isTransitioning = true;
        bitdecaySoundBank.PlaySound(BitdecaySounds.MenuSelect);
        bitdecaySoundBank.StopSongWithFadeOut();
    }

    public function update() {
        if (isTransitioning) {
            if (!bitdecaySoundBank.IsSongPlaying()) {
                FlxG.switchState(destinationState);
            }
        }
    }
}