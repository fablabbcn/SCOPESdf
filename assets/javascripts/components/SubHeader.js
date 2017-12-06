'use strict';

export default function SubHeader() {

	console.log("-- SubHeader initialized")

	// submit the page's form when click the save a draft button
	$('.SubHeader__tool--draft').on('click', (ev) => {

		ev.preventDefault()
		
		$('.Form').submit()

	})

}
