'use strict';

module.exports = Choices;

import ChoicesJs from 'choices.js'

/**
 * Initializes choices.js component(s)
 * @returns {element} element
 */
function Choices() {

	console.log("-- Choices initialized")

  $('.Input--choices').each(function(){

    let choices = new ChoicesJs(this, {
      removeItems: true,
      removeItemButton: true,
			placeholder: true,
			placeholderValue: "tag,"
    });

  })


}
