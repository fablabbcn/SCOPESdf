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
		focus: 'none',
		errorClass: 'Input--error',
		successClass: 'Input--success',
	}

  $('.Form').parsley(options)

}
