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
		let config = JSON.parse($(this).data('config'))

		console.log(config.start)

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

    slider.noUiSlider.on('update', function(values, handle){
      console.log(values)
    })

  })

}
