import openfl.utils.Assets;
import flixel.text.FlxText.FlxTextBorderStyle;
using StringTools;

playCutscenes = true;

var tails:FlxSprite;
var jumpscare:FlxSprite;
var kadeText:FlxText;
var ratingShit:FlxText;

function create() {
    enableModchart = true;
    FlxG.sound.play(Paths.sound('jumpscare'), 0);
    FlxG.sound.play(Paths.sound('fakeJumpscare'), 0);

    // if (!FlxG.save.data.cached || FlxG.save.data.cached == null){
        // Assets.loadBitmapData(Paths.image('og/jumpscare'));
        // FlxG.save.data.cached = true;
    // }
}

function postCreate() {
    window.title = "Friday Night Funkin': Vs Sonic.exe";

    modchart.setPercent('tipsy', 0);
    modchart.setPercent('tipsyx', 0);

    tails = new FlxSprite(-190, 0);
    tails.frames = Paths.getFrames('og/tails');
    tails.animation.addByPrefix('idle', 'idle', 12);
    tails.animation.play('idle');
    tails.scale.set(1.5, 1.5);
    insert(members.indexOf(eggman)+1, tails);

    jumpscare = new FlxSprite(0, (Options.downscroll ? -750 : 0));
    jumpscare.frames = Paths.getFrames('og/jumpscare');
    jumpscare.animation.addByPrefix('jumpscare', 'jumpscare', 24, false);
    jumpscare.alpha = 0;
    jumpscare.screenCenter(FlxAxes.X);
    add(jumpscare);
    jumpscare.camera = camHUD;

    kadeText = new FlxText(20, (Options.downscroll ? 10 : FlxG.height-30), 600, 'too-slow - Hard | KE 1.5.4', 12).setFormat(null, 12, 0xFFFFFFFF, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    kadeText.camera = camHUD;
    add(kadeText);

    insert(20, ratingShit = new FlxText(400, healthBar.y + (Options.downscroll ? -60 : 50), 700, 'Score: 0 | Combo Breaks: 0 | Accuracy: 0%').setFormat(null, 14, 0xFFFFFFFF, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK)).camera = camHUD;

    scoreTxt.visible = missesTxt.visible = accuracyTxt.visible = false;
}

function postUpdate(elapsed:Float) {
    var char = strumLines.members[(curCameraTarget != -1 ? (curCameraTarget != 2 ? curCameraTarget : 1) : 0)].characters[0];
    var animName = char.animation.curAnim.name;

    switch(animName){
        case 'singLEFT', 'singLEFT-alt': theFuckingMovement(-30, 0);
        case 'singDOWN', 'singDOWN-alt': theFuckingMovement(0, 30);
        case 'singUP', 'singUP-alt': theFuckingMovement(0, -30);
        case 'singRIGHT', 'singRIGHT-alt': theFuckingMovement(30, 0);
        default: theFuckingMovement(0, 0);
    }

	ratingShit.text = 'Score: '+songScore+' | Combo Breaks: '+misses+' | Accuracy: '+ (FlxMath.roundDecimal(accuracy*100, 2) != -100 ? FlxMath.roundDecimal(accuracy*100, 2) : 0) +'%';
}

function beatHit(b:Int) {
    switch(b){
        case 190: defaultCamZoom = 1.15;
        case 197:
            defaultCamZoom = 1;
            modchart.setPercent('tipsy', 0.1);
        case 264:
            modchart.setPercent('tipsy', 0);
            modchart.setPercent('tipsyx', 0.1);
        case 294: modchart.setPercent('tipsyx', 0.3);
        case 488: FlxTween.num(0.3, 0, 2, {ease: FlxEase.sineInOut, onUpdate:(v:Float)->modchart.setPercent('tipsyx', v.value)});
    }
}

function stepHit(s:Int) {
    switch(s){
        case 1305: FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
        case 1432: FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
        case 1722:
            jumpscare.alpha = 1;
            jumpscare.animation.play('jumpscare');
            FlxG.sound.play(Paths.sound('jumpscare'), 0.8);
            FlxG.sound.play(Paths.sound('fakeJumpscare'), 0.8);
        case 1736:
            remove(jumpscare);
            jumpscare.destroy();
    }
}

function onPlayerHit(e) e.note.splash = "squirt";

function theFuckingMovement(x:Float, y:Float) camGame.targetOffset.set(x, y);