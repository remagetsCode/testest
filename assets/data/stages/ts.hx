import hxvlc.flixel.FlxVideoSprite;
import reignited.DropShadow;
using StringTools;

var jumpscare:FlxSprite;
var stat:FlxSprite;
var simpleJump:FlxSprite;
var backJump:FlxSprite;
var noteStat:FlxSprite;
var pollo:FlxSprite;
var alvin:FlxSprite;
var vignette:FlxSprite;

var fuckingIntro:FlxVideoSprite;

var noteStatTmr:FlxTimer = new FlxTimer();
var statTmr:FlxTimer = new FlxTimer();

var miniEvents:Dynamic = Json.parse(Assets.getText(Paths.json('../songs/too-slow/miniEvents')));
var noteCam:HudCamera;
var extraCam:FlxCamera;

playCutscenes = true;
var canBump:Bool = true;
var shittingYourself:Bool = false;

var fireLight:CustomShader = new CustomShader('firelight');
var theTinyLittleMotherFuckerShaderHolyFuckManTsTuffFrFrMan:CustomShader = new CustomShader('chromaticAberration');
var rgbShader:Float = 0;
var dropShadowEffects:Array<DropShadow> = [];

FlxG.game.setFilters([]);
var heat1 = new CustomShader('heatwave1');
heat1.intensity = 0.0;
heat1.v_comp = 30.0;

function create() {
    introLength = 0.05;

    if (Options.quality != 0) canPause = false;

    FlxG.cameras.add(noteCam = new HudCamera(), false).bgColor = 0;
    FlxG.cameras.add(extraCam = new FlxCamera(), false).bgColor = 0;

	if (Options.downscroll){
		noteCam.downscroll = true;
		noteCam.y -= 581;
	}

    noteCam.height = 1300;
    
    for (e in ['jumpscare', 'softjump', 'statHit/hitStatic1', 'statHit/hitStatic2', 'staticnoise']) FlxG.sound.play(Paths.sound(e), 0);
}

function postCreate() {
    player.ghostTapping = true;

    if (Options.quality != 0){
       add(fuckingIntro = new FlxVideoSprite(-320, -180)).load(Paths.video('tooSlow'), [':no-audio']);
       fuckingIntro.scale.set(0.7, 0.7);
       fuckingIntro.camera = extraCam;
    }

    jumpscare = new FlxSprite();
    jumpscare.frames = Paths.getSparrowAtlas('stages/sonic/jumpscare');
    jumpscare.animation.addByPrefix('jumpscare', 'jumpscare', 24, false);
    jumpscare.animation.play('jumpscare');
    jumpscare.alpha = 0.001;
    jumpscare.screenCenter(0x01);
    add(jumpscare).camera = extraCam;

    noteStat = new FlxSprite();
    noteStat.frames = Paths.getSparrowAtlas('stages/sonic/special/hitStatic');
    noteStat.animation.addByPrefix('i', 'idle');
    noteStat.animation.play('i');
    add(noteStat).camera = extraCam;
    noteStat.alpha = 0;

    add(backJump = new FlxSprite().makeGraphic(1280*2, 720*2, 0xFF000000)).camera = extraCam;
	backJump.screenCenter();
    backJump.alpha = 0;

    simpleJump = new FlxSprite().loadGraphic(Paths.image('stages/sonic/special/jsShitMyself'));
    add(simpleJump).camera = extraCam;
    simpleJump.scale.set(0.9, 0.9);
    simpleJump.screenCenter();
    simpleJump.alpha = 0;

    stat = new FlxSprite(0, (Options.downscroll ? 2.5 : 0));
    stat.frames = Paths.getSparrowAtlas('stages/sonic/special/stat');
    stat.animation.addByPrefix('i', 'idle');
    stat.animation.play('i');
    add(stat).camera = extraCam;
    stat.alpha = 0;

	pollo = new FlxSprite(100, -280);
	pollo.frames = Paths.getSparrowAtlas('stages/sonic/fire/pollo');
	pollo.animation.addByPrefix('idle', 'idle', 20, false);
	pollo.animation.play('idle');
	insert(members.indexOf(dad)+1, pollo).camera = camGame;
	pollo.scale.set(0.7, 0.7);
	pollo.alpha = 0.001;

	alvin = new FlxSprite(-1100, 150);
	alvin.frames = Paths.getSparrowAtlas('stages/sonic/fire/alvin');
	alvin.animation.addByPrefix('idle', 'idle', 20, false);
	alvin.animation.play('idle');
	insert(members.indexOf(dad)-1, alvin).camera = camGame;
	alvin.scale.set(0.7, 0.7);
	alvin.alpha = 0.001;

    insert(0, vignette = new FlxSprite().loadGraphic(Paths.image("stages/sonic/orangeVign")));
    vignette.scale.set(0.75,0.75);
    vignette.updateHitbox();
    vignette.screenCenter();
    vignette.camera = extraCam;
    vignette.alpha = 0;

    for (i in 0...4) {
        cpu.members[i].camera = noteCam;
        player.members[i].camera = noteCam;
    }

    if (Options.quality != 0) for (uh in [camGame, camHUD, noteCam]) {
        uh.addShader(theTinyLittleMotherFuckerShaderHolyFuckManTsTuffFrFrMan);
        camGame.addShader(heat1);
    }
}

var heatVel:Float = 1;
var e:Float = 0;
function update(elapsed:Float) {
    heat1.iTime = e += elapsed*heatVel;
    noteCam.zoom = FlxMath.lerp(noteCam.zoom, 1, 0.05);

    theTinyLittleMotherFuckerShaderHolyFuckManTsTuffFrFrMan.redOff = [0, rgbShader];
    theTinyLittleMotherFuckerShaderHolyFuckManTsTuffFrFrMan.blueOff = [rgbShader, 0];
    theTinyLittleMotherFuckerShaderHolyFuckManTsTuffFrFrMan.greenOff = [-rgbShader, 0];
	
	extraCam.scroll.x = (shittingYourself ? FlxG.random.float(-20, 20) : 0);
	extraCam.scroll.y = (shittingYourself ? FlxG.random.float(-20, 20) : 0);    
}

function postUpdate(){
    var char = strumLines.members[(curCameraTarget != -1 ? (curCameraTarget != 2 ? curCameraTarget : 1) : 0)].characters[0];
    var animName = char.animation.curAnim.name;

    switch(animName){
        case 'singLEFT', 'singLEFT-alt': theFuckingMovement(-25, 0, 0.25);
        case 'singDOWN', 'singDOWN-alt': theFuckingMovement(0, 25, 0);
        case 'singUP', 'singUP-alt': theFuckingMovement(0, -25, 0);
        case 'singRIGHT', 'singRIGHT-alt': theFuckingMovement(25, 0, -0.25);
        default: theFuckingMovement(0, 0, 0);
    }

    if (fireLight != null) fireLight.iTime = Conductor.songPosition / 1000;

    if ((Conductor.curBeat > 156 && Conductor.curBeat < 411)) {
        window.title = freakyTitle('I am god');
    }

    if(Conductor.curBeat >= 252) {
        for(c in [bf, dad, gf]) {
            if(c.shader == null){
                c = new DropShadow(c, [208.3, 110.69, 61.88], c == dad ? 80 : 110, c == gf ? 40 : 25, 1, c == dad ? 0.05 : 0.1, 37, c==dad?0:10, c==dad?25:20, 5, 2, 1, false, false, false);
                dropShadowEffects.push(c);
            }
        }
        for(c in dropShadowEffects) {
            c?.distance = CoolUtil.fpsLerp(c?.distance, FlxG.random.int(10, 30), 0.1);
            c?.postUpdate(Conductor.songPosition / 1000);
        }
    }
}

var modulo:Int = 2;
function beatHit(b:Int) {
    if (b % modulo == 0 && canBump) noteCam.zoom = 1.02;

    switch (b) {
        case 1: for(n in holds) n.camera = noteCam;
        case 33: 
            canBump = true;
            player.ghostTapping = false;
            if(fuckingIntro != null)rmv(fuckingIntro);

        case 115: allHud(0, 4);

        case 120: window.title = "Vs Sonic.exe";
        case 121: window.title = "Vs Sonic";
        case 122: window.title = "Vs So";
        case 123: window.title = "";
 
        case 124:
            wave("x");
            allHud(1, 0.5);

        case 157: modulo = 1;

        case 252:
            FlxTween.tween(vignette, {alpha: 0.4}, 10);
            allHud(0, 3.5);
            for (uh in [knux, eggman, tail, tailsHead]) rmv(uh);
            for (uh in [backFire, frontFire]) {
                FlxTween.tween(uh, {y: uh.y - 500}, 5, {ease: FlxEase.quadInOut});
                uh.alpha = 1;
            }

            if (Options.quality != 0) for (e in [tailsHeadFire, knuxFire, eggmanFire, tailFire]) e.alpha = 1;
            if (Options.quality != 0) for (e in [camHUD, camGame, noteCam]) e.addShader(fireLight);
            player.ghostTapping = true;


		case 256:
			pollo.alpha = 1;
			pollo.animation.play('idle');
			new FlxTimer().start(3, ()->rmv(pollo));

		case 260:
			alvin.alpha = 1;
			alvin.animation.play('idle');
			new FlxTimer().start(3.5, ()->rmv(alvin));

        case 282: 
            allHud(1, 1);
            player.ghostTapping = false;
        case 412:
            window.title = "I'm gonna getcha";
            allHud(0, 1.5);
        case 425: window.title = "I am god";
        case 434: window.title = "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA";
        case 445: window.title = "yOu ArE tOO sLoW";

        case 444: 
            FlxTween.tween(vignette, {alpha: 0.8}, 3, {type:4});
            allHud(1, 3);
        case 416:
            wave("x", false);
            wave("y");
        case 449:
            FlxTween.num(1, 2.5, 2, {onUpdate: (v)->shaderVel = v.value});
            FlxTween.tween(heat1, {intensity: 0.015}, 2);
        case 516: modulo = 2;
        case 580: 
            FlxTween.num(2.5, 5, 1, {onUpdate: (v)->shaderVel = v.value});
            FlxTween.num(0, 0.005, 20, {onUpdate: (twn) -> rgbShader = twn.value});
            noteCam.shake(0.0025, 39);
            modulo = 1;
            for(strum in cpuStrums) strum.scrollSpeed = 5;
        case 612: 
            FlxTween.num(5, 7, 1, {onUpdate: (v)->shaderVel = v.value});
            for(strum in cpuStrums) strum.scrollSpeed = 7;
        case 676: for(strum in cpuStrums) strum.scrollSpeed = 10;

		case 706: for (e in [camGame, camHUD, noteCam]) e.shake(0.005, 5);
        case 708: 
            FlxTween.cancelTweensOf(vignette);
            FlxTween.tween(vignette, {alpha: 0}, 2);
            FlxTween.num(0.005, 0, 5, {onUpdate: (twn) -> rgbShader = twn.value});
		case 722: 
            heat1.intensity = 0;
            for (cams in [camGame, camHUD, noteCam]) cams.visible = false;
    }
}

function stepHit(s:Int) {
    for (e in miniEvents.simpleJumpscare)
        if (s == e)
            simpleJumpscare();

    for (e in miniEvents.stat){
        if (s == e){
            stat.alpha = 0.5;
            FlxG.sound.play(Paths.sound('staticnoise'), 0.8);
            statTmr.start(0.2, () -> stat.alpha = 0);
        }
    }

    if (s == miniEvents.jumpscare) {
        jumpscare.alpha = 1;
        jumpscare.animation.play('jumpscare');
        FlxG.sound.play(Paths.sound('jumpscare'), 1.1);
        new FlxTimer().start(3, () -> rmv(jumpscare));

        for (e in [camGame, camHUD, noteCam, extraCam]) e.shake(0.005, 1);
    }
}

function onSongEnd() if (FlxG.save.data.tooSlow != true) FlxG.save.data.tooSlow = true;

function onSongStart() {
    noteCam.flash(0xFF000000, 5);
    if (Options.quality != 0) fuckingIntro.play();

    if (Options.quality != 0){
        new FlxTimer().start(21.5, () -> {
            canPause = true;
            FlxTween.tween(fuckingIntro, {alpha: 0}, 0.5, {ease: FlxEase.quartInOut, onComplete: () -> {
                if(fuckingIntro != null) rmv(fuckingIntro);
            }});
        });
    }
}

function onPlayerMiss(e) {
    if (e.noteType == 'Static' || e.noteType == 'StaticAlt') {
        noteStat.alpha = 1;
        noteStat.animation.play('i', true);
        health -= 0.2;
        songScore -= 500;

        FlxG.sound.play(Paths.sound('statHit/hitStatic' + FlxG.random.int(1, 2)), 0.6);

        noteStatTmr.start(0.5, () -> noteStat.alpha = 0);
    }
}

function onPlayerHit(e) if (e.noteType == 'Static' || e.noteType == 'StaticAlt') songScore += 500;

function destroy() FlxG.game.setFilters([]);

function allHud(a:Float, t:Float) for (uh in [healthBar, healthBarBG, iconP1, iconP2, accuracyTxt, missesTxt, scoreTxt, noteCam]) FlxTween.tween(uh, {alpha: a}, t, {ease: FlxEase.quartInOut});

function wave(dir:String, ?enable:Bool) {
    if(dir == null) return;
    enable ??= true;

    if(!enable) {
        for (i in 0...4) {
            FlxTween.cancelTweensOf(cpu.members[i]);
            FlxTween.cancelTweensOf(player.members[i]);
        }
        return;
    }
    
    if(dir == "x")
        for (i in 0...4) {
            FlxTween.tween(cpu.members[i], {x: cpu.members[i].x-15}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 0.25 * i});
            FlxTween.tween(player.members[i], {x: player.members[i].x-15}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 1.5 + (0.25 * i)});
        }

    else if(dir == "y") {
        for (i in 0...4) {
            cpu.members[i].y = 40;
            player.members[i].y = 40;
        }

        for (i in 0...4) {
            FlxTween.tween(cpu.members[i], {y: 60}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 0.25 * i});
            FlxTween.tween(player.members[i], {y: 60}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 1.5 + (0.25 * i)});
        }
    }
}

function theFuckingMovement(x:Float, y:Float, angle:Float) {
	camGame.targetOffset.set(x, y);
	camGame.angle = CoolUtil.fpsLerp(camGame.angle, angle, camGame.followLerp * 25 / 15);
}

function simpleJumpscare() {
	simpleJump.alpha = 1;
    backJump.alpha = 1;
    FlxG.sound.play(Paths.sound("softjump"), 0.6);
    shittingYourself = true;

    new FlxTimer().start(0.2, () -> {simpleJump.alpha = 0; backJump.alpha = 0; shittingYourself = false;});
}

function freakyTitle(base:String):String {
    var chars:Array<String> = base.split('');

    for (i in 0...chars.length){
        if (FlxG.random.bool(15)){
            var j:Int = FlxG.random.int(0, chars.length - 1);
            var tmp:String = chars[i];
            chars[i] = chars[j];
            chars[j] = tmp;
        }
    }

    for (i in 0...chars.length){
        var c:String = chars[i];

        if (c == ' ') continue;

        if (FlxG.random.bool(5)) {
            chars[i] = ' ';
            continue;
        }

        if (FlxG.random.bool(35)) chars[i] = c.toUpperCase();
        else chars[i] = c.toLowerCase();
    }

    return chars.join('');
}

function rmv(spr:FlxSprite) {
    remove(spr);
    spr.destroy();
}