var countdownEnds = false;
var hasinput = 0;
var chosen_worker = ""
var chosen_name = ""
var chosen_target = ""
var hasClicked = false

$(document).ready(function() {
	// $('.carousel').carousel({
	// 	interval: false
	// })
	//send first message
	var url = window.location.href;
	if (url.indexOf("question") == -1) {
		send_data_and_request_next({first_time:true});
	}

	// function disablePrev() { window.history.back() }
  // window.onload = disablePrev();
  // window.onpageshow = function(evt) { if (evt.persisted) disableBack() }

	console.log("We get into the ready function");
    if (person_number == 2) {
				console.log("person_number == 2");
        // $('#person-1').addClass("profile-2");
        // $('#person-2').addClass("profile-2");
        // $('#person-3').css("visibility", "hidden");
        // $('#person-4').css("visibility", "hidden");
				// $('#person-5').css("visibility", "hidden");
				// $('#person-6').css("visibility", "hidden");
				// $('#person-7').css("visibility", "hidden");
				// $('#person-8').css("visibility", "hidden");
				$('#person-3').remove()
				$('#person-4').remove()
				$('#person-5').remove()
				$('#person-6').remove()
				$('#person-7').remove()
				$('#person-8').remove()
    }
    else if (person_number == 4) {
				console.log("person_number == 4");
        // $('#person-1').addClass("profile-4");
        // $('#person-2').addClass("profile-4");
        // $('#person-3').addClass("profile-4");
        // $('#person-4').addClass("profile-4");
				$('#person-5').remove()
				$('#person-6').remove()
				$('#person-7').remove()
				$('#person-8').remove()
    }
    // else {
		// 		$('#person-1').addClass("profile-8")
		// 		$('#person-2').addClass("profile-8");
		// 		$('#person-3').addClass("profile-8");
		// 		$('#person-4').addClass("profile-8");
		// 		$('#person-5').addClass("profile-8");
		// 		$('#person-6').addClass("profile-8");
		// 		$('#person-7').addClass("profile-8");
		// 		$('#person-8').addClass("profile-8");
    // }

		//set up all the warning info as hidden
		for(var i=1; i<=person_number; i++)
		{
				$('#warning'+i).css("visibility", "hidden");
		}

		//set the col class for each candidate based on the person_number
		if(person_number == 8)
		{
			for(var i=1; i<=person_number; i++)
			{
				$('#person-'+i).addClass("col-sm-3");
			}
		}
		else {
			for(var i=1; i<=person_number; i++)
			{
				$('#person-'+i).addClass("col-sm-6");
			}
		}

		if(display_condition != '2')
		{
			console.log("Don't show distribution.")
			$('#dist_img').remove();
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
	// $('#chooser_button_1_up').attr("disabled", "Disabled");
	// $('#chooser_button_2_up').attr("disabled", "Disabled");
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
		var url = window.location.href;
		if (next_data['no_more_comparisons']){window.location = "iat_2.html"}
		else {
			data = next_data
			//set_timer(data['timer']);
			for(var i=1; i<=person_number; i++)
			{
				setup_person(i, data['worker_'+i])
			}

      $('#chooser_button_9').attr("cid", 9)
      $('#chooser_button_9_up').attr("cid", 9)
			setup_progress_bar(data['progress'])
			for(var i=0; i<person_number; i++)
			{
				setup_icon(i, data['icon_'+i])
			}
			var type = data['type']
			// if(data['show_distribution'] == 0)
			// {
			// 	$('#distribution').addClass('hidden')
			// }
			// else
			// {
			// 	$('#distribution').removeClass('hidden')
			// }
		}
	}})
};

function setup_icon(id, icon_data){
	$('#icon-'+(id+1)).attr("src", icon_data)
}

function setup_person(id, worker_data) {
	//$(`#comparison-half-${half_id} h2`).text(name)
  //$(`#chooser_button_${half_id}`).attr("Target", worker_data['Target'])
	$(`#chooser_button_${id}`).attr("cid", id)
	// $(`#chooser_button_${id}_up`).attr("cid", id)

  var prof_html = worker_data['text'].replace(/\\n/g,"<br/>")
	var prof_node = $('<p> </p>').html(prof_html)

	$(`#person-text-${id} p`).html(prof_node)
	//make_collapsing_about_me(half_id, 'collapse')
};

function setup_progress_bar(progress){
	$(".progress-bar").attr("aria-valuenow", progress)
	$(".progress-bar").attr("style", `width: ${progress}%; min-width: 2em`)
	$(".progress-bar").text(`${progress}%`)
};

function send_click(chosen_id){
	choice_data = {
					 chosen_id:chosen_id,
				   sequence_pos:data['sequence_pos'],
				 };
	//send the icon name

	for(var i=1; i<=person_number; i++)
	{
		choice_data['belief_worker'+i] = $("#dropdown-"+i).val()
	}

	for(var i=1; i<=person_number; i++)
	{
		choice_data["icon_"+i] = $("#icon-"+i).attr("src");
	}
	console.log(`I'm about to send ${choice_data['chosen_id']} ${choice_data['sequence_pos']} ${choice_data['belief_worker1']} ${choice_data['belief_worker2']}`)
	//send these data to server
	send_data_and_request_next(choice_data);
	//reset all the dropdowns
	for(var i=1; i<=person_number; i++)
	{
		choice_data['belief_worker'+i] = $("#dropdown-"+i).val()
	}
	//make all potential warning info invisible
	for(var i = 1; i <= person_number; i++)
	{
				$('#warning'+i).css("visibility", "hidden");
	}
};

function all_drop_selected(){
	var all_selected = 1;
	for(var i = 1; i <= person_number; i++)
	{
			if($('#dropdown-'+i).val() == 'default')
			{
				$('#warning'+i).css("visibility", "visible");
				all_selected = 0;
			}
			else {
				$('#warning'+i).css("visibility", "hidden");
			}
	}
	return all_selected;
};

$('#question-button').on('click', function(e) {
	e.preventDefault();
	q1 = $('#q1').val();
	q2 = $('#q2').val();
	q3 = $('#q3').val();
	q4 = $('#q4').val();
	q5 = $('#q5').val();
	q6 = $('#q6').val();
	q7 = $('#q7').val();
	q9 = $('#q9').val();
	q10 = $('#q10').val();
	q11 = $('#q11').val();
	q12 = $('#q12').val();
	q13 = $('#q13').val();
	// q12 = $('#q12').val();
	// q13 = $('#q13').val();
	// q14 = $('#q14').val();
	// q15 = $('#q15').val();
    flag = 0;
    q8 = '';
    //process q8
    for (var i = 1; i <= 7; i++) {
        check = 0;
        for (var j = 1; j <= 5; j++) {
            if ($(`#q8q${i}a${j}`)[0].checked)
                check = j;
        }
        if (check == 0)
            flag = 1;
        else
            q8 = q8 + String(check);
    }
    for (var i = 8; i <= 9; i++) {
        check = -1;
        for (var j = 0; j <= 10; j++) {
            if ($(`#q8q${i}a${j}`)[0].checked)
                check = j;
        }
        if (check == -1)
            flag = 1;
        else if (check == 10)
            q8 = q8 + "X";
        else
            q8 = q8 + String(check);
    }
    q9 = $('#q9').val();
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
	if(q9 == "default")
		flag = 1;
	if (flag == 1) {
		$('#warning').css("visibility", "visible");
	}
	else {
		// data = {q1:q1, q2:q2, q3:q3, q4:q4, q5:q5, q6:q6, q7:q7, q8:q8, q9:q9, q10:q10, q11:q11, q12:q12, q13:q13, q14:q14, q15:q15};
		data = {q1:q11, q2:q1, q3:q2, q4:q3, q5:q4, q6:q5, q7:q6, q8:q7, q9:q9, q10:q12, q11:q13, q12:q8, q13:q10};
		$.ajax({url: "saveq", data: data, type: "POST",
		error: function(result) {
			console.log('Error on ajax return -- post')
			window.location = "bonus.html";
		},
		success: function(next_data) {
			console.log('Sucessful Ajax return -- post')
			console.log(next_data)
			window.location = "bonus.html";
		}})
	}
});


$('.button').on('click', function(e) {
	e.preventDefault();
	chosen_id = $(e.target).attr('worker');
	if(all_drop_selected() && hasClicked == false)
	{
  	send_click(chosen_id);
		if(sequence_pos == 12)
		e.preventDefault();
		window.location = "pre_trials.html";
		hasClicked = true;
	}
});
