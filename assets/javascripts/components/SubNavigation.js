'use strict';

import Tippy from 'tippy.js'

export default function SubNavigation() {

	console.log("-- SubNavigation initialized")

	// Show a tooltip when click on the lesson progress track

	const $track = $('.SubNavigation__track')
	const $trackContent = $('.SubNavigation__trackContent')

	Tippy($track[0], {
		animateFill: false,
		arrowSize: 'regular',
		html: $trackContent[0],
		performance: true,
		theme: 'white',
		trigger: 'click',
		arrow: true,
		interactive: true,
		placement: 'bottom',
	})

}
