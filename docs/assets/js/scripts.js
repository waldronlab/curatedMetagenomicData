$( document ).ready(function() {

	// Responsive-Nav
	var nav = responsiveNav(".nav-collapse");

	// Round Reading Time
  $(".time").text(function (index, value) {
    return Math.round(parseFloat(value));
  });

	// CSS Hacks for Current Page
	var strURL = document.URL;
	gettingStarted = strURL.includes("getting-started");
	tutorials = strURL.includes("tutorials");
	publications = strURL.includes("publications");
	credits = strURL.includes("credits");
	is404 = $("h1.pageTitle").text().includes("404");

	if (is404) {
		$("#home > p").first().addClass("centered");
	} else if (gettingStarted) {
		$("[href='/curatedMetagenomicData/getting-started']").parent().addClass("current");
		$("#home").addClass("post");
		$("#home > p").first().addClass("intro");
	} else if (tutorials) {
		$("[href='/curatedMetagenomicData/tutorials']").parent().addClass("current");
	} else if (publications) {
		$("[href='/curatedMetagenomicData/publications']").parent().addClass("current");
		$("#home").addClass("post");
		$("#home > p").first().addClass("intro");
	} else if (credits) {
		$("#home").addClass("post");
		$("#home > p").first().addClass("intro");
	} else if (!is404) {
		$("[href='/curatedMetagenomicData/']").parent().addClass("current");
		$("#home").addClass("post");
		$("#home > p").first().addClass("centered");
		$("#home > h1").first().addClass("hide-me");
	}

	$($("#post > p.meta").next()).each(function() {
		$(this).addClass("intro");
		$("[href='/curatedMetagenomicData/tutorials']").parent().toggleClass("current");
	})

	// First Letter Style
	var currentText = $(".intro").first().text();
	$(".intro").html('<span class="dropcap">'+currentText.slice(0,1)+'</span>'+currentText.slice(1));

	// Intro Class w/o First Letter Style
	if (!is404) {
		$("#home > p.centered").next().addClass("intro");
	}

	// DropCap.js (should always come last)
	var dropcaps = document.querySelectorAll(".dropcap");
	window.Dropcap.layout(dropcaps, 2);

});
