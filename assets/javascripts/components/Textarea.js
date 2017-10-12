'use strict';

module.exports = Textarea;

import Autosize from 'autosize'

/**
 * Initializes textareas
 * @returns {element} element
 */
function Textarea() {

	console.log("-- Textarea initialized")

  // for each textarea in the document, kick of various inits
  let $textareas = $('.Input--textarea')

  $textareas.each(function() {

    let textarea = this

    // init autosize
    if ($(textarea).hasClass('Input--autosize'))
      initAutosize(textarea)

    // init character count
    if ($(textarea).hasClass('Input--character-count'))
      initCharacterCount(textarea)

  })

}

export function initAutosize(textarea) {
  Autosize(textarea)
}

function characterCount(textarea) {
  return $(textarea).val() ? $(textarea).val().length : 0
}

export function initCharacterCount(textarea) {

  // Set some initial counts
  let currentCount = characterCount(textarea)
  let maxCount = parseInt($(textarea).attr('maxlength'))

  // Append a character count element to the parent
  let $formField = $(textarea).parent('.FormField__input')
  let currentClass = 'FormField__characters__current'
  let maxClass = 'FormField__characters__max'
  let $status = $(`<div class="FormField__characters">
      <span class="${currentClass}">${currentCount}</span><span class="${maxClass}">/${maxCount}</span>
    </div>`)
  $formField.append($status)

  // On keyup, update the character count
  $(textarea).on('keyup', function(){ // using keyup event to capture backspace and other non-printable chars

    // Update the current count
    currentCount = characterCount(textarea)

    // Update the appended FormField__characters__current
    $formField.find(`.${currentClass}`).html(currentCount)

  })

}
