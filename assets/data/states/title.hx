import flixel.math.FlxMath;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;
import hxvlc.flixel.FlxVideoSprite;

var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/titlescreen/logo'));
var enter:FlxSprite = new FlxSprite();
var back:FlxSprite = new FlxSprite(-5, -8);
var black:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);

var pressed:Bool = false;
var started:Bool = false;
var logoShit:Float = 0;

var uh:CustomShader = new CustomShader('vhsPause');
var fuzz = new CustomShader('fuzzShader');
var shadCam:FlxCamera = new FlxCamera();
var topCam:FlxCamera = new FlxCamera();

function create() {
	if (FlxG.save.data.canAdvice){
		window.alert('This mod is extremely demanding in\nterms of performance; if you have a low-end\nPC, we suggest you to disable shaders and set\nthe graphics quality to low\n\nEste mod es extremadamente demandante\nen temas graficos, si tienes una PC muy mala,\nte recomendamos deshabilitar los shaders y\nponer los graficos en bajos\n\nEnjoy! || Disfruta pe chamo', 'Read this before playing || Lee esto antes de jugar');
		FlxG.save.data.canAdvice = false;
	}
	window.title = "Vs Sonic.exe: AIR";

    add(intro = new FlxVideoSprite(-320, -180)).load(Paths.video('gameIntro'), [':no-audio']);
	intro.scale.set(0.67, 0.67);
	intro.updateHitbox();
	intro.play();
	intro.alpha = 0.001;

	if (Options.gameplayShaders) FlxG.cameras.add(shadCam).bgColor = 0x0;
	FlxG.cameras.add(topCam).bgColor = 0x0;
	if (Options.gameplayShaders) cameras = [shadCam];

	back.frames = Paths.getFrames('menus/titlescreen/fundillo');
	back.animation.addByPrefix('idle', 'idle');
	back.animation.play('idle');
	add(back);

	add(logo).scale.set(0.5, 0.5);
	logo.screenCenter(FlxAxes.X);

	enter.frames = Paths.getFrames('menus/titlescreen/enter');
	enter.animation.addByPrefix('pressed', 'pressed', 24, false);
	enter.animation.addByPrefix('idle', 'idle');
	enter.animation.play('idle');
	add(enter);

	add(black).camera = topCam;
}

function postCreate() {
	FlxG.sound.play(Paths.sound('title/laugh'));
	new FlxTimer().start(1.5, () -> {
		topCam.flash(0xFFFF0000, 1.5);
		black.alpha = 0;
		FlxG.sound.play(Paths.sound('title/show'));
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		started = true;
	});
	
	if (Options.gameplayShaders) {
		fuzz.pixel = [0.01, 0.01];
		fuzz.stronk = 0.01;
		shadCam.addShader(fuzz);
		shadCam.addShader(uh);
	}
}

function update(elapsed:Float) {
	logoShit += elapsed;
	logo.y = -250 + Math.sin(logoShit * 2) * 15;

	if (Options.gameplayShaders) {
		fuzz.iTime = logoShit / 1000;
		uh.iTime = logoShit;
	}

	if (controls.ACCEPT && !pressed && started){
		pressed = true;

		FlxG.sound.play(Paths.sound('title/enter'));
		FlxG.sound.play(Paths.sound('title/enterConfirm'));
		enter.animation.play('pressed', true);
		FlxTween.tween(enter, {alpha: 0}, 1, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.num(FlxG.sound.music.volume, 0, 2, {startDelay: 1, onUpdate: (twn) -> FlxG.sound.music.volume = twn});
		FlxTween.tween(black, {alpha: 1}, 2, {ease: FlxEase.quartInOut, startDelay: 1, onComplete: () -> FlxG.switchState(new ModState('videoShit'))});
	}
}