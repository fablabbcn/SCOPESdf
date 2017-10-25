'use strict';

module.exports = Slideshow;

import Flickity from 'flickity-as-nav-for'

function Slideshow() {

	console.log("-- Slideshow initialized")

  let slideshowSelector = '.Slideshow'
	let $slideshows = $(slideshowSelector)

	$slideshows.each(function(){

    let slideshow = this
    let mainSlideshow = $(this).find('.Slideshow__cells')[0]
    let navSlideshow = $(this).find('.Slideshow__nav__cells')[0]

	  // Init flickity for all carousels
	  let flkty = new Flickity(mainSlideshow, {
	    cellAlign: 'center',
	    cellSelector: '.Slideshow__cell',
	    contain: true,
	    pageDots: false,
	    prevNextButtons: false,
	    wrapAround: true,
			imagesLoaded: true,
	    percentPosition: true,
	  })

    // Init flickity for all carousels
	  let flktyNav = new Flickity(navSlideshow, {
	    cellAlign: 'center',
      asNavFor: mainSlideshow,
	    cellSelector: '.Slideshow__nav__cell',
	    contain: true,
	    pageDots: false,
	    prevNextButtons: true,
	    wrapAround: false,
	    percentPosition: true,
	  })

	  document.addEventListener("turbolinks:request-start", function() {
	    flkty.destroy()
	  })

	  return flkty

  })

}
