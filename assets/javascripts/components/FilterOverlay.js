'use strict';

module.exports = FilterOverlay;

import Velocity from "velocity-animate"
import * as Config from "../config"

let $close
let $filterOverlay

export let state = {
  isOpen: false
}

function FilterOverlay() {

	console.log("-- FilterOverlay initialized", Config)

  $filterOverlay = $('.FilterOverlay')

  $close = $('.FilterOverlay__close')

  $('.Filter__filters').on('click', function(ev){
    ev.preventDefault()
    toggle()
  })

  $(document).on('keyup', function(e) {
     if (e.keyCode == 27) { // escape key maps to keycode `27`
        close()
    }
  })

}

function toggle() {
  state.isOpen ? close() : open()
}

function open() {
  // -- fade in
  Velocity($filterOverlay, { opacity: 1 }, { display: 'flex', duration: Config.duration, easing: Config.easing })
  state.isOpen = true

  // -- close overlay menu on click filter toggle
  $close.one('click', function(ev){
    ev.preventDefault()
    close()
  })

}

function close() {
  // -- fade out
  Velocity($filterOverlay, { opacity: 0 }, { display: 'none', duration: Config.duration, easing: Config.easing })
  state.isOpen = false
}
