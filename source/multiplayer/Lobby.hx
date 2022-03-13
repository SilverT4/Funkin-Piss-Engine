package multiplayer;

import multiplayer.Server.Player1;
import multiplayer.Server.Player2;
import sys.net.Host;
import sys.net.UdpSocket;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.text.FlxTextField;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;

class Lobby extends MusicBeatState {

    public static var server:Server;
    public static var client:Client;
    public static var isHost:Bool;

    public static var player1:Character;
    public static var player2:Character;

    public static var player1DisplayName:FlxText;
	public static var player2DisplayName:FlxText;

    public static var ip:String;
    public static var port:Int;

    public function new(host:String, port:Int, isHost:Bool, nick:String) {
        CoolUtil.clearMPlayers();

        super();

        ip = host;
        Lobby.port = port;
        Lobby.isHost = isHost;

        if (isHost) {
            server = new Server(host, port);
            Player1.nick = nick;
        }
        else {
            client = new Client(host, port);
            Player2.nick = nick;
            client.sendString('P2::nick::$nick');
        }
    }

    override function create() {
        super.create();

        FlxG.sound.playMusic(Paths.music("giveALilBitBack", "shared"));
        Conductor.changeBPM(126);

        var ipInfo = new FlxText(10, 10, 0, 'IP: $ip', 16);
        add(ipInfo);

        var portInfo = new FlxText(10, ipInfo.y + ipInfo.height, 0, 'Port: $port', 16);
        add(portInfo);

        var nickInfo = new FlxText(10, portInfo.y + portInfo.height, 0, '', 16);
        if (isHost)
            nickInfo.text = 'Nick: ' + Player1.nick;
        else
            nickInfo.text = 'Nick: ' + Player2.nick;
        add(nickInfo);

        if (isHost) {
            var hostMode = new FlxText(10, nickInfo.y + nickInfo.height + 5, 0, 'HOST MODE', 16);
            hostMode.color = FlxColor.YELLOW;
            add(hostMode);
        }

        var PLAYERSPACE = 300;

        Paths.setCurrentLevel("week-1");
        Paths.setCurrentStage("stage");

        player1 = new Character(0, 0, "bf");
        player1.flipX = !player1.flipX;
        player1.screenCenter(XY);
        player1.x += PLAYERSPACE;
        add(player1);

        player2 = new Character(0, 0, "bf");
        player2.screenCenter(XY);
        player2.x -= PLAYERSPACE;
        if (isHost)
            player2.alpha = 0.4;
        add(player2);

        player1DisplayName = new FlxText(0, player1.y - 40, 0, Player1.nick, 24);
        player1DisplayName.x = (player1.x + (player1.width / 2)) - (player1DisplayName.width / 2);
        add(player1DisplayName);

        player2DisplayName = new FlxText(0, player2.y - 40, 0, Player2.nick, 24);
        player2DisplayName.x = (player2.x + (player2.width / 2)) - (player2DisplayName.width / 2);
        add(player2DisplayName);
    }

    override function update(elapsed) {
        super.update(elapsed);

        player1DisplayName.text = Player1.nick;
        player2DisplayName.text = Player2.nick;

        if (FlxG.keys.justPressed.ESCAPE) {
            if (isHost) {
                server.stop();
                CoolUtil.clearMPlayers();
                FlxG.switchState(new LobbySelectorState());
            }
            else {
                client.client.disconnect();
            }
        }
        
        Conductor.songPosition = FlxG.sound.music.time;
    }

	override public function beatHit() {
		super.beatHit();

        player1.playAnim('idle');
        if (player2.alpha == 1) {
            player2.playAnim('idle');
        }
    }

    override public function onFocusLost() {
        FlxG.autoPause = false;
    }
}

class LobbySelectorState extends FlxState {
    public function new() {
        super();

        FlxG.mouse.visible = true;

        var BUTTONSPACE = 50;

        var clientIP = new FlxUIInputText(0, 0, 100, "127.0.0.1", 10);
        clientIP.screenCenter(XY);
        clientIP.y += 50;
        clientIP.x += 20;
        add(clientIP);

        var clientIPInfo = new FlxText(clientIP.x - 40, clientIP.y, 0, "IP:");
        add(clientIPInfo);


        var clientPort = new FlxUIInputText(0, 0, 100, "9000", 10);
        clientPort.screenCenter(XY);
        clientPort.y = clientIP.y + 20;
        clientPort.x = clientIP.x;
        add(clientPort);

        var clientPortInfo = new FlxText(clientPort.x - 40, clientPort.y, 0, "Port:");
        add(clientPortInfo);

        var nick = "";
        if (Options.get("nick") != null) {
            nick = Options.get("nick");
        } else {
            nick = "Player" + new FlxRandom().int(1, 99);
        }

        var clientNick = new FlxUIInputText(0, 0, 100, nick, 10);
        clientNick.screenCenter(XY);
        clientNick.y = clientPort.y + 20;
        clientNick.x = clientPort.x;
        add(clientNick);

        var clientNickInfo = new FlxText(clientNick.x - 40, clientNick.y, 0, "Nick:");
        add(clientNickInfo);

        
        var text = new FlxText(0, 0, 0, "Multiplayer", 48);
        text.screenCenter(XY);
        text.y -= 150;
        add(text);

        var clientButton = new FlxButton(0, 0, "Connect", function onConnectPressed() {
            Options.setAndSave("nick", clientNick.text);
            FlxG.switchState(new Lobby(clientIP.text, Std.parseInt(clientPort.text), false, clientNick.text));
        });
        clientButton.screenCenter(XY);
        clientButton.x -= BUTTONSPACE;
        add(clientButton);

        var serverButton = new FlxButton(0, 0, "Host", function onHostPressed() {
            Options.setAndSave("nick", clientNick.text);
            FlxG.switchState(new Lobby(clientIP.text, Std.parseInt(clientPort.text), true, clientNick.text));
        });
        serverButton.screenCenter(XY);
        serverButton.x += BUTTONSPACE;
        add(serverButton);
    }

    override function update(elapsed) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            FlxG.switchState(new MainMenuState());
        }
    }
}