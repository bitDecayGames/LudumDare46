package analytics;

import haxe.Http;

class Analytics {
    static var SERVER_URL = "https://gm4832bitdecaygames-149ce.firebaseio.com/event.json?auth=dnWdIrcc7Sd6Fi5OpG7oRKvKaF2MGahrWVZHk3nZ";

    public static var GAME_LOADED = "game_loaded";
    public static var GAME_STARTED = "game_started";
    public static var GAME_WIN = "game_win";
    public static var GAME_LOSE = "game_lose";
    public static var CREDITS = "game_lose";

    static var game_guid = "not_set";

    public static function createGameGUID() {
        try {
            game_guid = '${Math.random()}';
            #if debug
            trace("game_guid");
            trace(game_guid);
            #end
        } catch (err: Any) {
            game_guid = "not_set_err";
        }
    }

    public static function send(name: String) {
        try {
            var body = "{";
            body += '"game_guid": "${game_guid}",';
            body += '"name": "${name}",';
            body += '"timestamp": "${Date.now().toString()}",';
            body += "}";

            var http = new Http(SERVER_URL);
            http.setPostData(body);
            #if debug
            http.onData = function(data:String) {
                trace('onData');
                trace(data);
            };
            http.onError = function(err:String) {
                trace('onError');
                trace(err);
            };
            http.onStatus = function(status:Int) {
                trace('onStatus');
                trace(status);
            };
            trace('Sending analytic for ${name}');
            #end
            http.request(true);
        } catch (err: Any) {
            // no-op
        }
    }
}