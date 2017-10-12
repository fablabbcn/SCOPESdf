'use strict';

module.exports = Carousel;

import Flickity from 'flickity'

/**
 * Initializes Carousel components
 * @param {string} selector as a string
 * @returns {Object} Flickity object
 */
function Carousel(selector='.Carousel__cells') {

	console.log("-- Carousel initialized")

	if ($(selector).length > 0) {

	  // Init flickity for all carousels
		let flkty = new Flickity( selector, {
			cellSelector: '.Carousel__cell',
			cellAlign: 'center',
			contain: true,
			groupCells: true
		})

		document.addEventListener("turbolinks:request-start", function() {
	    flkty.destroy()
	  })

		return flkty

	} else {

		return null

	}

}
