import modchart.Manager;

public var modchart:Manager = new Manager();

function create() {
    add(modchart);

    modchart.addModifier('transform');
	modchart.addModifier('bounce');
	modchart.addModifier('confusion');
	modchart.addModifier('opponentswap');
	modchart.addModifier('drunk');
	modchart.addModifier('tipsy');
	modchart.addModifier('wiggle');
	modchart.addModifier('vibrate');
	modchart.addModifier('beat');
	modchart.addModifier('reverse');
}