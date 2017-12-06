'use strict';

let $auth
let $footer
let $header

export default function Auth() {

	console.log("-- Auth initialized")

	$auth = $('.Auth')
	$header = $('.Header')
  $footer = $('.Footer')

  setHeight()

  $(window).on('resize', setHeight)

  return $header

}

function setHeight() {


  $auth.css({
    minHeight: (window.innerHeight - $footer.height() - $header.height()) + 'px'
  })

  return $auth

}
