'use strict';

module.exports = Header;

import Headroom from "headroom.js"

let $header

/**
 * Initializes the header
 * @returns {element} header element
 */
function Header() {

	console.log("-- Header initialized")

	$header = $('header.Header')

  // headroom.js
  initHeadroom()

  // setStyleClass
  setStyleClass($header)

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
 * Sets whether the header should have transparent class
 * @param {string} header element
 * @returns {element} header
 */
function setStyleClass($header=$header, $hero=$('.Hero')) {

  console.log($header, $hero)

  let heroHeight = $hero.height()

  $(window).on('scroll', function() {

    if ( $header.offset().top > heroHeight ) {
      $header.removeClass('Header--transparent').addClass('Header--white')
    } else {
      $header.addClass('Header--transparent').removeClass('Header--white')
    }

  })

}
