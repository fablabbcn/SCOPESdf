'use strict';

module.exports = Slider;

import noUiSlider from 'nouislider'

/**
 * Initializes multislider component(s)
 * @returns {element} auth element
 */
function Slider() {

	console.log("-- Slider initialized", $('.Input--slider'))

  $('.Input--slider').each(function(){

    let slider = this

    noUiSlider.create(slider, {
      start: [8, 10],
      connect: true,
      step: 1,
      tooltips: true,
      format: {
      to: function ( value ) {
        return value
      },
      from: function ( value ) {
        return value
      }
    },
      range: {
        min: 7,
        max: 18
      }
    })

    slider.noUiSlider.on('update', function(values, handle){
      console.log(values)
    });


  })


}
