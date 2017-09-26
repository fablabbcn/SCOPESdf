export default function() {

	console.log("-- External links initialized")

	// Open up external links in new tab
	$('a').not('[href*="mailto:"]').each(function () {
		var isInternalLink = new RegExp('/' + window.location.host + '/')
		if ( ! isInternalLink.test(this.href) ) {
			$(this).attr('target', '_blank')
		}
	})

}
