'use strict';

import Headroom from "headroom.js"

let $header
let $hero

export default function Header() {

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

function setStyleClassOnScroll() {

  $(window).on('scroll', function(){
		setStyleClass($header)
	})

}
