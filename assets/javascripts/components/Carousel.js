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

  // Init flickity for all carousels
	let flkty = new Flickity( selector, {
		cellSelector: '.Carousel__cell',
		cellAlign: 'left',
		contain: true,
		groupCells: true
	})

	return flkty

}
