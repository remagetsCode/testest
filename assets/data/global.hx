import funkin.editors.character.CharacterEditor;
import funkin.editors.charter.Charter;
import funkin.backend.system.framerate.Framerate;
import sys.FileSystem;

static var redirectStates:Map<FlxState, String> = [
    TitleState => 'title',
    MainMenuState => 'menu',
    FreeplayState => 'menu'
];

var chiyoPaths:Array<String>=CoolUtil.coolTextFile(Paths.txt('config/chiyoPaths'));
public var winSuffix:String = '';

// ye, ts js for uuuuuhhhhhhhhhh, the mod safety?????? ion fucking nou but ts cool asf
function new() {
    chiyoChecker();
    FlxG.save.bind('SonicAir', 'SonicAir');

    FlxG.save.data.tooSlow = false;
    if (FlxG.save.data.ogTitle == null) FlxG.save.data.ogTitle = false;
    if (FlxG.save.data.cached == null) FlxG.save.data.cached = false;
    if (FlxG.save.data.canAdvice == null) FlxG.save.data.canAdvice = true;
    if (FlxG.save.data.airMinimal == null) FlxG.save.data.airMinimal = false;

    var path = "mods";
    var maxTries = 3;

    if (FileSystem.exists(path)) {
        for (i in 0...maxTries) {
            try {
                trace('Intento '+(i+1)+': borrando carpeta '+path+'...');
                removingTheFuckingModFolder(path);
            } catch (e:Dynamic) {
                trace('Error en intento '+(i+1)+': '+e);
            }
        }
    } else trace('ts pmo');
}

function removingTheFuckingModFolder(path:String) {
    if (FileSystem.exists(path)) {
        if (FileSystem.isDirectory(path)) {
            for (file in FileSystem.readDirectory(path)) {
                removingTheFuckingModFolder(path + "/" + file);
            }
            FileSystem.deleteDirectory(path);
        } else {
            FileSystem.deleteFile(path);
        }
    }
}

function focusGained() {
    if (FileSystem.exists('mods')) removingTheFuckingModFolder('mods');
    chiyoChecker();
}
// ts pmo gng

//function update() if (!(FlxG.state is CharacterEditor) && !(FlxG.state is Charter)) if (window.title != "Vs Sonic.exe: AIR" && FlxG.save.data.ogTitle == false) window.title = "Vs Sonic.exe: AIR"; else if (window.title != "Friday Night Funkin': Vs Sonic.exe" && FlxG.save.data.ogTitle == true) window.title = "Friday Night Funkin': Vs Sonic.exe";

function preStateSwitch(){
    Framerate.codenameBuildField.text = '';
    for (i in redirectStates.keys())if (Std.isOfType(FlxG.game._requestedState, i))FlxG.game._requestedState = new ModState(redirectStates.get(i));
}

function chiyoChecker()
    for (chiyos in chiyoPaths)
        if (!FileSystem.exists('assets/images/'+chiyos+'.jpg')) FlxG.resetGame();