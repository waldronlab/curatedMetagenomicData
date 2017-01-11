// A $( document ).ready() block.
$( document ).ready(function() {

	// DropCap.js
	var dropcaps = document.querySelectorAll(".dropcap");
	window.Dropcap.layout(dropcaps, 2);

	// Responsive-Nav
	var nav = responsiveNav(".nav-collapse");

	// Round Reading Time
    $(".time").text(function (index, value) {
      return Math.round(parseFloat(value));
    });

	// Set current link
	var strURL = document.URL;
	tutorials = strURL.includes("tutorials");
	publications = strURL.includes("publications");
	credits = strURL.includes("credits");

	if (tutorials) {
		$("[href='/tutorials']:parent").addClass("current");
	} else if (publications) {
		$().addClass();
	} else if (credits) {
		NULL
	} else {
		$().addClass();
	}

});
