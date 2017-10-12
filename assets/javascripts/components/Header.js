'use strict';

module.exports = Header;

import Headroom from "headroom.js"

let $header
let $hero

/**
 * Initializes the header
 * @returns {element} header element
 */
function Header() {

	console.log("-- Header initialized")

	$header = $('header.Header')
	$hero = $('.Hero')

  // headroom.js
  initHeadroom()

  // setStyleClass
  setStyleClass($header)

	//
	setStyleClassOnScroll()

  return $header

}

/**
 * Initializes headroom.js for the header
 * @param {string} header element
 * @returns {Object} headroom object
 */
function initHeadroom(header=$header[0]) {

  let headroom  = new Headroom(header, {
		offset: 0,
		classes: {
			initial: 	 "Header--visibility",
			pinned: 	 "Header--visibility-pinned",
			unpinned:  "Header--visibility-unpinned",
			top: 		   "Header--visibility-top",
			notTop: 	 "Header--visibility-not-top",
			bottom: 	 "Header--visibility-bottom",
			notBottom: "Header--visibility-not-bottom"
		}
	})

	headroom.init()

  return headroom

}

/**
 * Sets whether the header should have transparent class, depending if there's
 * a hero element
 * @param {string} header element
 * @returns {element} header
 */
function setStyleClass($header=$header, $hero=$('.Hero')) {

	if ($hero.length > 0) {

	  let heroHeight = $hero.height()

	  if ( $header.offset().top > heroHeight ) {
	    $header.removeClass('Header--transparent').addClass('Header--white')
	  } else {
	    $header.addClass('Header--transparent').removeClass('Header--white')
	  }

	} else {

		$header.removeClass('Header--transparent').addClass('Header--white')

	}

}

/**
 * Trigger setStyleClass when the user scrolls
 * @returns {element} header
 */
function setStyleClassOnScroll() {

  $(window).on('scroll', function(){
		setStyleClass($header)
	})

}
