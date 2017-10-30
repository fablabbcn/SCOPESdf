'use strict';

import Tooltip from 'tooltip.js'

module.exports = UserStatus;

function UserStatus() {

	console.log("-- UserStatus initialized")

  const referenceElement = $('.UserStatus')[0]

  const instance = new Tooltip(referenceElement, {
    title: "Hey there",
    trigger: "click",
  });
  instance.show()

}
