var colors:Array = ["Purple", "Blue", "Green", "Red"];
var generated:Bool = false;
public var holds:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();


if (curSong != 'og'){
function postCreate(){
	window.title = "Vs Sonic.exe: AIR";

	for(i => color in colors){
		s = new FlxSprite(i*100, 0);
		s.frames = Paths.getFrames('game/splashes/holds/holdCover'+color);
		s.animation.addByPrefix('start', 'holdCoverStart'+color, 20, false);
		s.animation.addByPrefix('hold', 'holdCover'+color, 20, true);
		s.animation.addByPrefix('end', 'holdCoverEnd'+color, 22, false);
		s.cameras = [camHUD];
		s.visible = false;
		s.animation.onFinish.add(function(e){
			switch(e){
				case "start": holds.members[i].animation.play('hold');
				case "end": holds.members[i].visible = false;
			}
		});
		holds.add(s);
	}
	add(holds);
	generated = true;
}

var healthBarValue:Float;
public var smoothness:Float = 0.1;
function update() healthBar.percent = healthBarValue = CoolUtil.fpsLerp(healthBarValue, health*50, smoothness);

function postUpdate() {
	// This simulates how vslice plays the press animation when theres no note being hit
	for(i in 0...4){
		if(Conductor.songPosition - player.members[i].lastHit > 210 && player.members[i].getAnim() == "confirm"){
			player.members[i].playAnim('pressed', true);
		}
	}
}

function stepHit(){
	var swap = 0;//modchart.getPercent('opponentSwap', 1);
	var mode = downscroll ? 87 : -5;

	for(i in 0...4){
		var milk = holds.members[i];
		if(player.members[i].animation.name == "static" && generated){
			if(milk.animation.name == "hold") milk.visible = false;
		}

		if(generated) milk.setPosition(
			(player.members[i].x-player.members[i].width), 
			(player.members[i].y-player.members[i].height)-mode
		);
	}
		
	
}

function onPlayerHit(event){
	if(event.direction > 3) return;
	if(event.note.noteType == "Static" || event.note.noteType == "StaticAlt") {
		var d = event.direction;
		var milk = holds.members[event.direction];

	
		if(event.note.isSustainNote){ 
			milk.visible = true;


			if(milk.animation.name != "hold") {
				milk.frames = Paths.getFrames('game/splashes/holds/holdCoverStatic');
				milk.animation.addByPrefix('start', 'holdCoverStartRed', 20, false);
				milk.animation.addByPrefix('hold', 'holdCoverRed', 20, true);
				milk.animation.addByPrefix('end', 'holdCoverEndRed', 22, false);
				milk.animation.play('start');
			}
		}

		if(event.note.nextSustain == null && milk.visible && event.note.isSustainNote) milk.animation.play('end');
		return;
	}

	var d = event.direction;
	var milk = holds.members[event.direction];
	var color = colors[d];
	
	if(event.note.isSustainNote){ 
		milk.visible = true;

		if(milk.animation.name != "hold") {
			
			milk.frames = Paths.getFrames('game/splashes/holds/holdCover'+color);
			milk.animation.addByPrefix('start', 'holdCoverStart'+color, 20, false);
			milk.animation.addByPrefix('hold', 'holdCover'+color, 20, true);
			milk.animation.addByPrefix('end', 'holdCoverEnd'+color, 22, false);
			milk.animation.play('start');
		}
	}

	if(event.note.nextSustain == null && milk.visible && event.note.isSustainNote) milk.animation.play('end');
	//if(event.note.nextNote.nextSustain != null) event.showSplash = false;	
}
}