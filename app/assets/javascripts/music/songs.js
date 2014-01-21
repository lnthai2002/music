//generate audio section using download link 
$(document).ready(function() {
	var audioSection = $('section#audio');
	$('a.html5-audio').click(function() {

		var audio = $('<audio>', {
			controls : 'controls'
		});

		var url = $(this).attr('href');
		$('<source>').attr('src', url).appendTo(audio);
		audioSection.html(audio);
		return false;
	});
}); 
