var width = 0;
var width_rate = 0;
var working = new Array(3);
var pos = new Array(3);
var speed = 0.2;
var interval = 15;
var interval_create = 1000;
var prob = 0.15;
var time = 6000;
var time_var = 2000;
var chars = ['A','B','C','D','E','F'];

$(document).ready(function() {
	flying_controller();
	document.onkeydown = keyListener;
	for (var i = 0; i < 3; i++) {
		working[i] = false;
		pos[i] = -50;
	}
});

function randomInt(Min, Max){
	return (Min + Math.floor(Math.random() * (Max - Min)));
}

function randomFloat(Min, Max){
	return (Min + Math.random() * (Max - Min));
}

function initialize(){
	width = document.body.clientWidth;
	width_rate = width / 2400;
	console.log("initialization complete!");
	for (var i = 0; i < 3; i++) {
		$(`#flying-text-${i+1}`).html(' ');
	}
}
/*

function update(){
	for (var i = 0; i < 3; i++) {
		if (working[i]) {
			pos[i] += speed * interval;
		}
		if (pos[i] > width + 50) {
			pos[i] = -50;
			working[i] = false;
		}
		$(`#flying-line-${i+1}`).css("left", pos[i]+"px")
	}
}

*/

function clear(i) {
	$(`#flying-line-${i+1}`).css("animation", "");
	$(`#flying-text-${i+1}`).css("animation", "");
	working[i] = false;
}

function parse(c) {
  for (var i = 0; i < 3; i++) {
		if (working[i]) {
			//console.log(c);
			//console.log($(`#flying-text-${i+1}`).html());
			if ((c == $(`#flying-text-${i+1}`).html()) || (c == "5" && $(`#flying-text-${i+1}`).html() == "F")) {
				//console.log("Same!");
				$(`#flying-text-${i+1}`).css("animation", "fadeout 1s linear");
				setTimeout("clear("+i+")", 1000);
			}
		}
	}
}

function keyListener(event){
	//console.log("listen!");
	//console.log(event.keyCode);
	if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 65 && event.keyCode <= 90)) {
		parse(String.fromCharCode(event.keyCode));
	}
}

function create(){
	var time_t;
	width = document.body.clientWidth;
	width_rate = width / 2400;
	for (var i = 0; i < 3; i++) {
		if (!working[i]) {
			if (Math.random() < prob) {
				working[i] = true;
				$(`#flying-text-${i+1}`).html(chars[randomInt(0, chars.length)])
				time_t = randomInt(time - time_var, time + time_var);
				$(`#flying-line-${i+1}`).css("animation", "flying "+(time_t/1000/width_rate)+"s linear");
				setTimeout("clear("+i+")", time_t)
			}
		}
	}
}

function flying_controller(){
  initialize();
	// setInterval(update, interval);
	setInterval(create, interval_create);
}
