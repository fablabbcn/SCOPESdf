'use strict';

module.exports = MultipleInputs;

import {Sortable} from '@shopify/draggable';

/**
 * Initializes multiple inputs
 * @returns {element} element
 */
function MultipleInputs() {

	console.log("-- MultipleInputs initialized")

  // for each textarea in the document, kick of various inits
  let $multipleInputs = $('.Input--multiple')

  $multipleInputs.each(function() {

    let input = this

    // Append some instructions
    appendInstruction(input)

    // First handle existing data, provided via data-multiplevalues
    initInitialValues(input)

    // Handle new inputs
    handleAddNewValue(input)

  })

}

function handleAddNewValue(input) {

  $(input).on('keydown', function(ev){

    // if the return key is pressed, create another input from the value entered
    if (event.which == 13 || event.keyCode == 13) {
      createNewInput(input, $(input).val())
      $(input).val(null)
    }

  })

}

function appendInstruction(input) {

  // Set the instructions
  let $instructions = $(`<div class="FormField__instruction">Press  ↵ Return to add</div>`)

  // Append them to the container
  $(input).parent().append($instructions)

}

function initInitialValues(input) {

  if (!$(input).data('multiplevalues')) {
    console.error('Multiple value inputs need data-multiplevalues attributes, formatted as JSON string')
    return
  }

  // Fetch the initial values from the multiplevalues data attribute
  let initialData

  try {
    initialData = JSON.parse($(input).data('multiplevalues'))
  } catch (e) {
    console.error('data-multiplevalues needs to be a valid JSON string, {} if empty')
    return
  }

  // Loop through initial values, creating another input for each
  for (var i = 0; i < initialData.length; i++) {

    let value = initialData[i]

    // Create a new input for this value
    createNewInput(input, value)

  }

  // Init a new sortable
  let sortable = new Sortable([$(input).parent()[0]], {
    draggable: '.FormField__multipleinput',
    handle: '.FormField__multipleinput__handle'
  })

}

function createNewInput(sourceInput, value) {

  // clone the input
  let clonedInput = $(sourceInput).clone()

  // Set the cloned input's value
  $(clonedInput).val(value)

  // Strip the input of its id and initial data, don't need them anymore
  $(clonedInput).attr('id', false).attr('data-multiplevalues', false)

  // Create a wrapper for the cloned input
  let $wrapper = $('<div class="FormField__multipleinput"><button class="FormField__multipleinput__handle"><span>Sort</span></button></div>')

  let $wrappedInput = $wrapper.append($(clonedInput))

  // Add it before the initial field, wrapped in a container
  $(sourceInput).before($wrappedInput)

}
