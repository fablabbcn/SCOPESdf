'use strict';

import Velocity from "velocity-animate"
import * as Config from "../config"

let $alert

export default function Alert() {

	console.log("-- Alert initialized")

	$alert = $('.Alert')

	$('.Alert__close').on('click', (ev) => {
		ev.preventDefault()
		close()
	})

	// Also close after a period of time
	setTimeout(close, 3000)

}

function close() {
	
	// -- fade out
	Velocity($alert, { opacity: 0, translateY: '-100%' }, { display: 'none', duration: Config.duration, easing: Config.easing })

}