$(document).ready(function() {

    $("input#user_search").autocomplete("auto_complete_for_user_login");
	$('#user_bar').corners();
	$('#center').corners("10px");
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
	
});
//end document