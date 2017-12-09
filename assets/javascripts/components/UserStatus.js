'use strict';

import Tippy from 'tippy.js'

export default function UserStatus() {

	console.log("-- UserStatus initialized")

  const $userStatus = $('.UserStatus')
	const $userStatusButtons = $('.UserStatusButtons')

  Tippy($userStatus[0], {
		animateFill: false,
		arrowSize: 'regular',
		html: $userStatusButtons[0],
		performance: true,
		theme: 'white',
		trigger: 'click',
		arrow: true,
		interactive: true,
	})

}
