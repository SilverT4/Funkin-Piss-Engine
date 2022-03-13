package multiplayer;

import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.server.UDProteanClientBehavior;
import udprotean.server.UDProteanServer;

using StringTools;

class Player1 {
	public static var nick = "(unknown)";

	public static function clear() {
		nick = "(unknown)";
	}
}

class Player2 {
	public static var nick = "(unknown)";

	public static function clear() {
		nick = "(unknown)";
	}
}

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
				client.send(Bytes.ofString("P1::nick::" + Player1.nick));
			});
			onClientDisconnected(client -> {
				trace("Some Client Disconnected");

				Lobby.player2.alpha = 0.4;
				Player2.nick = "(unknown)";
			});

			while (true) {
				update();
			}

			stop();
		});
		#end
	}
}

class ServerBehavior extends UDProteanClientBehavior {
	// Called after the constructor.
	override function initialize() { }

	override function onMessage(msg:Bytes) {
		send(msg);

		var strMsg = msg.toString();
		trace("Server got a message: " + strMsg);

		if (strMsg.contains("::")) {
			var msgSplitted = strMsg.split("::");
			
			switch (msgSplitted[0]) {
				case "P1":
					Reflect.setField(Player1, msgSplitted[1], msgSplitted[2]);
				case "P2":
					Reflect.setField(Player2, msgSplitted[1], msgSplitted[2]);
			}
		}
		switch (strMsg) {
			/*
			case "PW":
				ServerState.upA.animation.play("upConfirm");
			case "RW":
				ServerState.upA.animation.play("greenScroll");
			
			case "PA":
				ServerState.leftA.animation.play("leftConfirm");
			case "RA":
				ServerState.leftA.animation.play("purpleScroll");

			case "PS":
				ServerState.downA.animation.play("downConfirm");
			case "RS":
				ServerState.downA.animation.play("blueScroll");
				
			case "PD":
				ServerState.rightA.animation.play("rightConfirm");
			case "RD":
				ServerState.rightA.animation.play("redScroll");
			*/
		}
	}

	// Called after the connection handshake.
	override function onConnect() { }

	override function onDisconnect() { }
}

