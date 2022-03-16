package multiplayer;

import multiplayer.Lobby;
import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.server.UDProteanClientBehavior;
import udprotean.server.UDProteanServer;

using StringTools;

class Server extends UDProteanServer {

	public function new(host:String, port:Int) {
		super(host, port, ServerBehavior);

		#if target.threaded
		sys.thread.Thread.create(() -> {
			start();

			trace("Started Server with IP: " + host + " Port: " + port);

			onClientConnected(client -> {
				trace("Some Client Connected");

				Lobby.player2.alpha = 1;
				sendStringToCurClient("P1::nick::" + Player1.nick);
				sendStringToCurClient("P1::ready::" + Player1.ready);
				sendStringToCurClient("SONG::" + Lobby.curSong);
				sendStringToCurClient("DIFF::" + Lobby.curDifficulty);
			});
			onClientDisconnected(client -> {
				trace("Some Client Disconnected");

				Lobby.player2.alpha = 0.4;
				Player2.clear();

				if (Lobby.inGame) {
					FlxG.switchState(new LobbySelectorState());
				}
			});

			try {
				while (true) {
					update();
				}
	
				stop();
			} catch (exc) {
				trace("Exception // Stopped the server");
				trace(exc.details());
				FlxG.switchState(new LobbySelectorState());
			}
		});
		#end
	}

	public function sendStringToCurClient(s:String) {
		for (client in peers)
			client.send(Bytes.ofString(s));
    }

	public function hasClients() {
		if (peers.length > 0)
			return true;
		return false;
    }
}

class ServerBehavior extends UDProteanClientBehavior {
	// Called after the constructor.
	override function initialize() { }

	override function onMessage(msg:Bytes) {
		var strMsg = msg.toString();
		trace("Server got a message: " + strMsg);

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
					Lobby.player2.playAnim('sing$splited1', true);
				case "LKR":
					Lobby.player2.playAnim('idle', true);
				case "NP":
					try {
						PlayState.currentPlaystate.goodNoteHit(new Note( splited1, CoolUtil.stringToOgType(msgSplitted[2]) ), true);
					} catch (exc) {
						trace(exc.details());
					}
				case "SNP":
					PlayState.currentPlaystate.strumPlayAnim(splited1, "dad", "pressed");
				case "SNR":
					PlayState.currentPlaystate.strumPlayAnim(splited1, "dad", "static");
			}
		}
	}

	// Called after the connection handshake.
	override function onConnect() { }

	override function onDisconnect() { }
}

