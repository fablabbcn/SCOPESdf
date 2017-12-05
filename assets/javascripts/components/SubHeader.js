'use strict';

export default function SubHeader() {

	console.log("-- SubHeader initialized")

	$('.SubHeader__tool--draft').on('click', (ev) => {

		ev.preventDefault()
		
		$('.Form').submit()

	})

}
