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
		$("[href='/curatedMetagenomicData/tutorials']").parent().addClass("current");
	} else if (publications) {
		$("[href='/curatedMetagenomicData/publications']").parent().addClass("current");
	} else if (credits) {
		$("#home").addClass("post");
	} else {
		$("[href='/curatedMetagenomicData/']").parent().addClass("current");
		$("#home").addClass("post");
		$("#home > p").first().addClass("centered");
		$("#home > h1").first().addClass("hide-me");
	}

});
