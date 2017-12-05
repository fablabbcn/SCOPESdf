'use strict';

import ChoicesJs from 'choices.js'

export default function Choices() {

	console.log("-- Choices initialized")

  $('.Input--choices').each(function(){

    let choices = new ChoicesJs(this, {
      removeItems: true,
      removeItemButton: true,
			placeholder: true,
			placeholderValue: "Enter a tag..."
    });

  })


}
