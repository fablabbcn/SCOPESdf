'use strict';

module.exports = Slider;

import noUiSlider from 'nouislider'
import wNumb from 'wnumb'

/**
 * Initializes multislider component(s)
 * @returns {element} auth element
 */
function Slider() {

	console.log("-- Slider initialized")

  $('.Input--slider').each(function(){

    let slider = this

		// Get ths config for this component
		let config = $(this).data('config')

		// Create the slider
    noUiSlider.create(slider, {
      start: config.start,
      connect: config.connect,
      step: config.step,
      format: {
	      to: ( value ) => {
					return parseInt(value)
	      },
	      from: ( value ) => {
	        return parseInt(value)
	      }
	    },
      range: config.range
    })

		// On slide update, set the value of the nexted hidden input
    slider.noUiSlider.on('update', function(values, handle){
      console.log(values)
			$(slider).find('input[type=hidden]').val(values)
    })

  })

}
