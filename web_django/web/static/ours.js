function clickSubmit(e) {
	e.preventDefault()
	$('#confirm_button').prop('disabled', true)
	$('#confirm_button').addClass('disabled')
	var full_style = $('#face').attr('src');
	var img = full_style.match(/\w+\.jpg/)[0];
	console.log(img)

	localStorage.setItem("image", atob(img.split('.')[0]));
	localStorage.setItem("client_end", Date.now());
	var out_obj = {}
	out_obj.client_start = localStorage.getItem("client_start");
	out_obj.client_end = localStorage.getItem("client_end");
	out_obj.read_start = localStorage.getItem("read_start");
	out_obj.read_end = localStorage.getItem("read_end");
	out_obj.image = localStorage.getItem("image");
	out_obj.read_check = localStorage.getItem("read_check")
	how=$('#how').val().toLowerCase()
	out_obj.how = how
	var tmp = localStorage.getItem("rating")
	if(tmp.includes(",")) {
		out_obj.rating = localStorage.getItem("rating").split(",");
	} else {
		out_obj.rating = localStorage.getItem("rating");
	}
	encoded = btoa(JSON.stringify(out_obj))
	console.log(out_obj)
	$.ajax({url: "save", data: {data: encoded},
		error: function(result) {
			console.log(JSON.stringify(result))
			$('#confirm_button').prop('disabled', false)
			$('#confirm_button').removeClass('disabled')
		},
		success: function(result) {
			window.location = "confirm.html"
			console.log(out_obj)
		}})
}

function evalClickSubmit(e) {
	e.preventDefault()
	$('#evaluate_button').prop('disabled', true)
	$('#evaluate_button').addClass('disabled')
	authorname=$('#turk_check').val().toLowerCase()
	localStorage.setItem("read_end", Date.now())
	localStorage.setItem("read_check", authorname)
	window.location = "rate.html"
}


$(document).ready(function() {
	url = window.location.href;
	url = url.replace('http://innsbruck-umh.cs.umn.edu/reputation', '');
	/* make sure we're only storing time on the first page, not on the rating page */
	if(url === '/') {
		localStorage.setItem("client_start", Date.now())
	}
	if(url === '/evaluate.html') {
		localStorage.setItem("read_start", Date.now())
	}
	console.log(localStorage.getItem("client_start"))
})

if($('#eq1').length > 0) {
	localStorage.setItem("rating", [-1,-1,-1,-1])
	console.log(localStorage.getItem("rating"))

	verify_values = function() {
		if(localStorage.getItem("rating").indexOf(-1) === -1) {
			$("#confirm_div").removeClass("hiding");
			window.scrollTo(0,document.body.scrollHeight);
		}
	}

	$('#eq1').on('change', function () {
		var tmp = localStorage.getItem("rating").split(",")
		localStorage.removeItem("rating")
		tmp[0] = $(this).val();
		localStorage.setItem("rating", tmp)
		console.log(localStorage.getItem("rating"))
		verify_values();
	});

	$('#eq2').on('change', function () {
		var tmp = localStorage.getItem("rating").split(",")
		localStorage.removeItem("rating")
		tmp[1] = $(this).val();
		localStorage.setItem("rating", tmp)
		verify_values();
	});

	$('#eq3').on('change', function () {
		var tmp = localStorage.getItem("rating").split(",")
		localStorage.removeItem("rating")
		tmp[2] = $(this).val();
		localStorage.setItem("rating", tmp)
		verify_values();
	});
	$('#eq4').on('change', function () {
		var tmp = localStorage.getItem("rating").split(",")
		localStorage.removeItem("rating")
		tmp[3] = $(this).val();
		localStorage.setItem("rating", tmp)
		verify_values();
	});
} else {
	$('#cq').on('change', function () {
		$("#confirm_div").removeClass("hiding");
		localStorage.setItem("rating", $(this).val())
		// rating = $(this).val();
	});
}

$('#evaluate_button').on('click',evalClickSubmit)
$('#evaluate_form').on('submit',evalClickSubmit)

$('#confirm_button').on('click', clickSubmit);
$('#confirm_button').on('submit', clickSubmit);
