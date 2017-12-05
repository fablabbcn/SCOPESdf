'use strict';

import Parsley from 'parsleyjs';

export default function Form() {

	console.log("-- Form initialized")

	let options = {
		focus: 'first',
		errorClass: 'Input--error',
		successClass: 'Input--success',
		errorsWrapper: '<ul class="FormField__errors"></ul>',
	}

  $('.Form').parsley(options)

	// if we hit a save and create new button, we need to toggle the create hidden
	// field
	$('.FormField__action--create').on('click', function(){
		$('input[name="create"]').val(true)
		return false
	})

}
