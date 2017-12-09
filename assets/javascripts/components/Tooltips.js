'use strict';

import Tippy from 'tippy.js'

export default function Tooltips() {

	console.log("-- Tooltips initialized")

  const $tooltips = $('.Tooltip')

  $tooltips.each(function(){

    Tippy(this, {
			position: 'bottom',
  		animateFill: false,
  		arrow: true,
  		arrowSize: 'regular',
  		performance: true,
  		theme: 'white',
  	})

  })



}
