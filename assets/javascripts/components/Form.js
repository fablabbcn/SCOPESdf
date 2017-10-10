'use strict';

module.exports = Form;

import Parsley from 'parsleyjs';

/**
 * Initializes forms
 * @returns {element} element
 */
function Form() {

	console.log("-- Form initialized")

	let options = {
		focus: 'first',
		errorClass: 'Input--error',
		successClass: 'Input--success',
		errorsWrapper: '<ul class="FormField__errors"></ul>',
	}

  $('.Form').parsley(options)

	// Prevent submission of form using return key
	$(document).on("keypress", "form", function(event) {
		return event.keyCode != 13;
	})

}
