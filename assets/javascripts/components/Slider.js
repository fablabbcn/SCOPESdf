'use strict';

module.exports = Slider;

import noUiSlider from 'nouislider'
import wNumb from 'wnumb'
import { getOrdinal } from '../helpers'

/**
 * Initializes multislider component(s)
 * @returns {element} auth element
 */
function Slider() {

	console.log("-- Slider initialized")

  $('.Slider').each(function(){

    let slider = this
		let $slider = $(slider)
		let $control = $slider.find('.Slider__control')
		let $value = $slider.find('.Slider__value')
		let $input = $slider.find('input[type=hidden]')

		// Get ths config for this component
		let config = $control.data('config')

		// Create the slider
    noUiSlider.create($control[0], {
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
		
		// Set the initial value, as per the hidden element
		$control[0].noUiSlider.set($input.val())

		// On slide update, set the value of the nexted hidden input
    $control[0].noUiSlider.on('update', (values, handle) => {

			// if two values, output a range
			let value0, value1, valueString

			if (values.length == 2) {

				value0 = values[0]
				value1 = values[1]

				// Should this be ordinal?
				if (config.unit == 'ordinal'){
					value0 = getOrdinal(value0)
					value1 = getOrdinal(value1)
				} else if (config.unit) {
					value0 = `${value0}`
					value1 = `${value1} ${config.unit}`
				}

				valueString = `${value0} — ${value1}`


			} else {

				value0 = values[0]

				// Should this be ordinal?
				if (config.unit == 'ordinal'){
					value0 = getOrdinal(value0)
				} else if (config.unit) {
					value0 = `${value0} ${config.unit}`
				}

				valueString = `${value0}`

			}

			// Set the value of the hidden input
			$input.val(values)

			// Set the html in the value container
			$value.html(valueString)

    })

  })

}
