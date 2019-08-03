var expand_1 = 0;
var expand_2 = 0;
var cancel_1 = 0;
var cancel_2 = 0;
var wrap_count = 0;
var countdownEnds = false;
var nowCarousel = 1;
var leftCarousel = 1;
var rightCarousel = 2;
var hasinput = 0;
var sequential = -1;
var chosen_worker = ""
var chosen_name = ""
var chosen_target = ""
var start = ""
var end = ""

$(document).ready(function() {
	$('.carousel').carousel({
		interval: false
	})
	//send first message
	var url = window.location.href;
	if (url.indexOf("question") == -1) {
		send_data_and_request_next({first_time:true});
	}
});

function update(num, timer) {
	if (num == timer) {
		$('#chooser_button_1').html("Select");
		$('#chooser_button_2').html("Select");
		$('#chooser_button_1').removeAttr("disabled");
		$('#chooser_button_2').removeAttr("disabled");
		$('#chooser_button_1_up').removeAttr("disabled");
		$('#chooser_button_2_up').removeAttr("disabled");
		countdownEnds = true;
		check_active();
	}
	else {
		$('#chooser_button_1').html("Select (" + (timer - num) + ")");
		$('#chooser_button_2').html("Select (" + (timer - num) + ")");
	}
}

function set_timer(t){
  var timer = t;
	$('#chooser_button_1').attr("disabled", "Disabled");
	$('#chooser_button_2').attr("disabled", "Disabled");
	$('#chooser_button_1_up').attr("disabled", "Disabled");
	$('#chooser_button_2_up').attr("disabled", "Disabled");
	countdownEnds = false;
	for (var i = 0; i <= timer; i++) {
		window.setTimeout("update(" + i + "," + timer + ")", i * 1000);
	}
}

function send_data_and_request_next(choice_data) {
	$.ajax({url: "save", data: choice_data, type: "POST",
	error: function(result) {
		console.log('Error on ajax return')
	},
	success: function(next_data) {
		console.log('Sucessful Ajax return')
		console.log(next_data)
		check_active();
		var url = window.location.href;
		if (url.indexOf("evaluater_l") > -1) {
			sequential = 0;
		}
		else if (url.indexOf("evaluater_w") > -1) {
			sequential = 1;
		}
		else {
			sequential = -1;
		}
		if (next_data['sequential'] == 1 && sequential == 0){window.location = "evaluater_w.html"}
		if (next_data['sequential'] == 0 && sequential == 1){window.location = "evaluater_l.html"}
		else if (next_data['no_more_comparisons']){window.location = "iat.html"}
		else {
			data = next_data
			set_timer(data['timer']);
			hasinput = data['hasinput']
			sequential = data['sequential']
			setup_comparison_half(1, data['worker_1'], (data['worker_1_name'] + " " + data['worker_1_name_last']), data['hasphoto'], data['hasrating'])
			setup_comparison_half(2, data['worker_2'], (data['worker_2_name'] + " " + data['worker_2_name_last']), data['hasphoto'], data['hasrating'])
			setup_progress_bar(data['progress'])
			var worker_1_stars = data['worker_1']['stars']
			var worker_2_stars = data['worker_2']['stars']
			var type = data['type']
			console.log(worker_1_stars)
			// are we having ratings?
			if (data['hasrating'] == 1) {
					setup_stars_half(1, worker_1_stars)
					setup_stars_half(2, worker_2_stars)
			}
			else{
					clear_stars_half(1)
					clear_stars_half(2)
			}
			expand_1 = 0
			expand_2 = 0
			cancel_1 = 0
			cancel_2 = 0
			wrap_count = 0
		}
	}})
};

function cal_expand(id){
	if (id == 1) {
    expand_1 += 1;
	}
	if (id == 2) {
		expand_2 += 1;
	}
}

function cal_cancel(){
	if (chosen_worker.indexOf("1") > -1) {
		cancel_1 += 1;
	}
	else if (chosen_worker.indexOf("2") > -1) {
		cancel_2 += 1;
	}
}

function make_collapsing_about_me(half_id, expand_collapse){
	var origin_text = data[`worker_${half_id}`]['Profile Text']
	var prof_text;
	var link_text;
	var link_fun;

	cal_expand(half_id)
	if (expand_collapse == 'collapse'){
		prof_text = origin_text.slice(0,200) + '...'
		link_text = 'show more';
		link_fun = function(){make_collapsing_about_me(half_id, 'expand')}

	}else if (expand_collapse == 'expand'){
		prof_text = origin_text;
		link_text = 'show less';
		var link_fun = function(){make_collapsing_about_me(half_id, 'collapse')}
	}

	if (origin_text.length < 200) {
		var prof_html = origin_text.replace(/\\n/g,"<br/>")
		var prof_node = $('<p> </p>').html(prof_html)
		prof_node = prof_node.append($('<br/>'))
	}
	else {
		var prof_html = prof_text.replace(/\\n/g,"<br/>")
		var prof_node = $('<p> </p>').html(prof_html)
		var link_node = $('<a> </a>').attr('class',`expand_collapse-${half_id}`).attr('id',`expand-${half_id}`).text(` ${link_text}`).click(link_fun)
		link_node = link_node.append($('<br/>'))
		$(link_node).appendTo(prof_node)
		// $(`#expand_collapse-${half_id}`).click(function(){link_fun})
	}
	$(`#comparison-text-${half_id} p`).html(prof_node)
}

function setup_comparison_half(half_id, worker_data, name, hasphoto, hasrating) {
	if (hasphoto == 1) {
		$(`#comparison-img-${half_id} div`).css("background-image", `url(${worker_data['img_url']})`)
	}
	else {
		$(`#comparison-img-${half_id} div`).css("background-image", 'url("/static/default.png")')
	}
	$(`#comparison-half-${half_id} h2`).text(name)
  //$(`#chooser_button_${half_id}`).attr("Target", worker_data['Target'])
	$(`#chooser_button_${half_id}`).attr("target", worker_data['Target'])
	$(`#chooser_button_${half_id}`).attr("worker", half_id)
	$(`#chooser_button_${half_id}`).attr("name", name)
	$(`#chooser_button_${half_id}_up`).attr("target", worker_data['Target'])
	$(`#chooser_button_${half_id}_up`).attr("worker", half_id)
	$(`#chooser_button_${half_id}_up`).attr("name", name)
	// var prof_text = worker_data['Profile Text'].replace(/\\n/g,"<br/>");
	// $(`#comparison-text-${half_id} p`).html(prof_text)
	make_collapsing_about_me(half_id, 'collapse')
};

function setup_progress_bar(progress){
	$(".progress-bar").attr("aria-valuenow", progress)
	$(".progress-bar").attr("style", `width: ${progress}%; min-width: 2em`)
	$(".progress-bar").text(`${progress}%`)
};

function clear_stars_half(half_id) {
	var viz_content = $(`<div> </div>`)
		.attr('id', `comparison-viz-${half_id}`)
	var text_node = $("<p id='norating'>New to our platform</p>")
	var img_node = $('<img src="static/starparts/10.png" alt="Rating unavailable" id="nostars">')
	// img_node.appendTo(viz_content)
	text_node.appendTo(viz_content)
	$(`#comparison-viz-${half_id}`).replaceWith(viz_content)
}

function setup_stars_half(half_id, rating) {
	var star_text_node = $(`<p>${rating} stars</p>`)
	if (rating == 3.5) {
		star_text_node = $("<p>okay</p>")
	}
	if (rating == 4) {
		star_text_node = $("<p>good</p>")
	}
	if (rating == 4.5) {
		star_text_node = $("<p>great</p>")
	}
	if (rating == 5) {
		star_text_node = $("<p>excellent</p>")
	}
	//Dynamically generate
	var viz_content = $(`<div> </div>`)
		.attr('id', `comparison-viz-${half_id}`)
	for (var i in [0,1,2,3,4]) {
		rating = parseFloat(rating.toFixed(1))
		if (rating > 1){ var rating_to_add = '1.0'}
		else{
			rating_to_add = rating.toFixed(1)}
			//put the right fractional rating.
		var star_name = String(rating_to_add).replace('.','')
		var star_file_name = `static/starparts/${star_name}.png`
		var img_node = $('<img id="star">').attr('src', star_file_name).attr('width', '35px');
		img_node.appendTo(viz_content)
		rating = rating - rating_to_add
		}
	// var br_node = $('<br/>')
	// br_node.appendTo(viz_content);
	// star_text_node.appendTo(viz_content);
	$(`#comparison-viz-${half_id}`).replaceWith(viz_content)
}

function send_click(chosen_worker, rationale){
	choice_data = {chosen_worker:chosen_worker,
				   sequence_pos:data['sequence_pos'],
				   expand_1:expand_1,
				   expand_2:expand_2,
					 cancel_1:cancel_1,
					 cancel_2:cancel_2,
					 wrap_count:wrap_count,
				   rationale:rationale};
	console.log(`I'm about to send ${choice_data['chosen_worker']} ${choice_data['sequence_pos']}`)
	send_data_and_request_next(choice_data);
};

function check_active(){
	if (nowCarousel == leftCarousel) {
		$('.left.carousel-control').attr("style", "visibility: hidden");
		$('.right.carousel-control').removeAttr("style");
	}
	else if (nowCarousel == rightCarousel) {
		$('.left.carousel-control').removeAttr("style");
		$('.right.carousel-control').attr("style", "visibility: hidden");
	}
	else {
		$('.left.carousel-control').removeAttr("style");
		$('.right.carousel-control').removeAttr("style");
	}
	for (var i = 1; i <= 2; i++) {
		if (nowCarousel == i && countdownEnds) {
			$(`#chooser_button_${i}`).removeAttr("disabled");
			$(`#chooser_button_${i}_up`).removeAttr("disabled");
		}
		else if (sequential == 1) {
			$(`#chooser_button_${i}`).attr("disabled", "Disabled");
			$(`#chooser_button_${i}_up`).attr("disabled", "Disabled");
		}
	}
}

function isStatic() {
	static = true;
	for (var i = 1; i <= 2; i++) {
		if ($(`.carousel-${i}`).hasClass("prev") || $(`.carousel-${i}`).hasClass("next"))
		  static = false;
	}
	return static;
}

$('#question-button').on('click', function(e) {
	e.preventDefault();
	q1 = $('#q1').val();
	q2 = $('#q2').val();
	q3 = $('#q3').val();
	q4 = $('#q4').val();
	q5 = "";
	for (var i = 1; i <= 6; i++) {
		if ($(`#q5a${i}`)[0].checked) 
			q5 = q5 + "1"
		else
			q5 = q5 + "0"
	}
	q6 = $('#q6').val();
	q7 = $('#q7').val();
	q8 = $('#q8').val();
	q9 = $('#q9').val();
	q10 = $('#q10').val();
	q11 = $('#q11').val();
	flag = 0;
	if (q1 == "default")
		flag = 1;
	if (q2 == "default")
		flag = 1;
	if (q3 == "default")
		flag = 1;
	if (q4 == "default")
		flag = 1;
	if (q6 == "default")
		flag = 1;
	if (q7 == "default")
		flag = 1;
	if (q8 == "default")
		flag = 1;
	if (q9 == "default")
		flag = 1;
	if (q10 == "default")
		flag = 1;
	if (flag == 1) {
		$('#warning').css("visibility", "visible");
	}
	else {
		data = {q1:q1, q2:q2, q3:q3, q4:q4, q5:q5, q6:q6, q7:q7, q8:q8, q9:q9, q10:q10, q11:q11};
		$.ajax({url: "saveq", data: data, type: "POST",
		error: function(result) {
			console.log('Error on ajax return -- post')
			window.location = "confirm.html";
		},
		success: function(next_data) {
			console.log('Sucessful Ajax return -- post')
			console.log(next_data)
			window.location = "confirm.html";
		}})
	}
});


$('.button').on('click', function(e) {
	e.preventDefault();
	chosen_worker = $(e.target).attr('worker')
	chosen_name = $(e.target).attr('name')
	chosen_target = $(e.target).attr('target')
	if (hasinput == 1) {
		$('#myModal').modal('show');
		$('#worker-name-dialog').html(chosen_name);
	}
	else {
		send_click(chosen_target, "");
	}
});

$('#dialog-confirm').on('click', function(e) {
  var rationale = $('#rationale').val();
	send_click(chosen_target, rationale);
	$('#rationale').val("");
	$('#myModal').modal('hide');
});

$('#dialog-cancel').on('click', function(e) {
	cal_cancel();
	$('#myModal').modal('hide');
});

$('#dialog-close').on('click', function(e) {
	cal_cancel();
});

$('.carousel-control.left').on('click', function(e) {
	if (isStatic()) {
		nowCarousel -= 1;
		wrap_count += 1;
		check_active();
  }
});

$('.carousel-control.right').on('click', function(e) {
	if (isStatic()) {
		nowCarousel += 1;
		wrap_count += 1;
		check_active();
	}
});
