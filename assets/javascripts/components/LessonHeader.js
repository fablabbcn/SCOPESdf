'use strict';

import Flickity from 'flickity-imagesloaded'

export default function LessonHeader() {

	console.log("-- LessonHeader initialized")

	let photosSelector = '.LessonHeader__photos'
	let $photos = $(photosSelector)

	if ($photos.length > 0) {

		let photoSelector = '.LessonHeader__photo'

		let $status = $('.LessonHeader__photos__status')
		let $current = $status.find('.current')
		let $total = $status.find('.total')

	  // Init flickity for all carousels
	  let flkty = new Flickity(photosSelector, {
	    cellAlign: 'left',
	    cellSelector: photoSelector,
	    contain: true,
	    pageDots: false,
	    prevNextButtons: false,
	    wrapAround: true,
			imagesLoaded: true,
	    percentPosition: false,
	  })

	  document.addEventListener("turbolinks:request-start", function() {
	    flkty.destroy()
	  })

		$total.html($(photoSelector).length)

		flkty.on( 'select', function() {
			$current.html(flkty.selectedIndex + 1)
		})

	  return flkty

	}

}
