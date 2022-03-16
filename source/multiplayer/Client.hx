package multiplayer;

import multiplayer.Lobby;
import multiplayer.Lobby.LobbySelectorState;
import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.client.UDProteanClient;

using StringTools;

class Client {
    
	public var client:ProteanClient;
    
    public function new(ip:String, port:Int) {
		client = new ProteanClient(ip, port);

		#if target.threaded
		sys.thread.Thread.create(() -> {
			client.connect();

			trace("Connected to a Server with IP: " + ip + " Port: " + port);

			sendString('P2::nick::' + Player2.nick);

			try {
				while (true) {
					client.update();
				}
	
				client.disconnect();
			} catch (exc) {
				trace("Exception // Disconnected from server");
				trace(exc.details());
				FlxG.switchState(new LobbySelectorState());
			}
		});
		#end
    }

	public function sendString(s:String) {
        client.send(Bytes.ofString(s));
    }
}

class ProteanClient extends UDProteanClient {
	// Called after the constructor.
	override function initialize() {

    }

	override function onMessage(msg:Bytes) {
		var strMsg = msg.toString();

		trace("Client got a message: " + strMsg);

		if (strMsg.contains("::")) {
			var msgSplitted = strMsg.split("::");

			var splited1:Dynamic = CoolUtil.stringToOgType(msgSplitted[1]);
			var value = CoolUtil.stringToOgType(msgSplitted[2]);
			
			switch (msgSplitted[0]) {
				case "P1":
					Reflect.setField(Player1, msgSplitted[1], value);
				case "P2":
					Reflect.setField(Player2, msgSplitted[1], value);
				case "LKP":
					Lobby.player1.playAnim('sing$splited1', true);
				case "LKR":
					Lobby.player1.playAnim('idle', true);
				case "NP":
					PlayState.currentPlaystate.goodNoteHit(new Note( splited1, CoolUtil.stringToOgType(msgSplitted[2]) ), false);
				case "SNP":
					PlayState.currentPlaystate.strumPlayAnim(splited1, "bf", "pressed");
				case "SNR":
					PlayState.currentPlaystate.strumPlayAnim(splited1, "bf", "static");
				case "SONG":
					Lobby.curSong = splited1;
					Lobby.songsDropDown.selectLabel(Lobby.curSong);
				case "DIFF":
					Lobby.curDifficulty = splited1;
					switch (Lobby.curDifficulty) {
						case 0:
							Lobby.difficultyDropDown.selectedLabel = "Easy";
						case 1:
							Lobby.difficultyDropDown.selectedLabel = "Normal";
						case 2:
							Lobby.difficultyDropDown.selectedLabel = "Hard";
					}
			}
		}
    }

	// Called after the connection handshake.
	override function onConnect() { }

	override function onDisconnect() {
        trace("disconnected from server");
		CoolUtil.clearMPlayers();
        FlxG.switchState(new LobbySelectorState());
    }
}
