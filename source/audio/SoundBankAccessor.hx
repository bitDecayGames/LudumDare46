package audio;

import flixel.FlxG;
import audio.BitdecaySoundBank;
import screens.GameScreen;
import screens.MainMenuScreen;

class SoundBankAccessor {
    public static function GetBitdecaySoundBank():BitdecaySoundBank {
        try {
            var state:GameScreen = cast(FlxG.state, GameScreen);
            return state.bitdecaySoundBank;
        } catch( msg : String ) {}
        try {
            var state:MainMenuScreen = cast(FlxG.state, MainMenuScreen);
            return state.bitdecaySoundBank;
        } catch( msg : String ) {}

        throw 'No BitdecaySoundBank found on state';
        return null;
    }
}