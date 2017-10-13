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

}
