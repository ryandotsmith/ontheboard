$(document).ready(function() {

    $("input#user_search").autocomplete("auto_complete_for_user_login");
	$('#navigation').corners();
	$('#user_bar').corners();
	$('#main').corners("10px");
	$('#left').corners("10px");

	$("#user_nav").lavaLamp({
        fx: "backout", 
        speed: 700,
		homeTop:-1,
		homeLeft:-1,
        click: function(event, menuItem) {
            return true;
        }
    });
	
	$('#edit_subject').accordion({
				header: "h3",
				animated: 'easeslide',
				autoHeight: false
	});


});
//end document