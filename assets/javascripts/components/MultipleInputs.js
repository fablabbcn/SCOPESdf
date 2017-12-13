"use strict";
import { register as RegisterAutocomplete } from "./StandardAutocomplete";
import { Sortable } from "@shopify/draggable";

export default function MultipleInputs() {
  console.log("-- MultipleInputs initialized");

  // for each textarea in the document, kick of various inits
  let $multipleInputs = $(".Input--multiple");

  $multipleInputs.each(function() {
    let input = this;

    // Append some instructions
    appendInstruction(input);

    // First handle existing data, provided via data-values
    initInitialValues(input);

    // Handle new inputs
    handleAddNewValue(input);

    // Init atocomplete if needs be
    RegisterAutocomplete(input);
  });
}

function handleAddNewValue(input) {
  $(input).on("keydown", function(ev) {

    // Don't do this for existing values
    if (!$(input).hasClass('Input--existing')) {

      // if the return key is pressed, create another input from the value entered
      if (event.which == 13 || event.keyCode == 13) {
        // don't submit the form
        ev.preventDefault(); 
        // fetch the value and create a new input
        let value = $(input).val();
        if (value) createNewInput(input, $(input).val());
      }

      // If we now have at least one multiple input we no longer need the required attr
      if ($(input).attr("required")) $(input).attr("required", false);

    }

  });
}

function appendInstruction(input) {
  // Set the instructions
  let $instructions = $(
    `<div class="FormField__instruction">Press  ↵ Return to add</div>`
  );

  // Append them to the container
  $(input)
    .parent()
    .append($instructions);
}

function initInitialValues(input) {
  if (!$(input).data("values")) return;

  // Fetch the initial values from the multiplevalues data attribute
  let initialData;

  try {
    initialData = $(input).data("values");
  } catch (e) {
    console.error("data-values needs to be a valid JSON string, {} if empty");
    return;
  }

  // Loop through initial values, creating another input for each
  for (var i = 0; i < initialData.length; i++) {
    let value = initialData[i];

    // Create a new input for this value
    createNewInput(input, value);

    // If we now have at least one multiple input we no longer need the required attr
    if ($(input).attr("required")) $(input).attr("required", false);
  }

  // Init a new sortable
  let sortable = new Sortable([$(input).parent()[0]], {
    draggable: ".FormField__multipleinput",
    handle: ".FormField__multipleinput__handle"
  });
}

function createNewInput(sourceInput, value) {
  // clone the input
  let clonedInput = $(sourceInput).clone(true).off();

  // Set the cloned input's value
  $(clonedInput).val(value);

  // Strip the input of its id, initial data, and placeholder, don't need them anymore
  $(clonedInput)
    .addClass('Input--existing')
    .removeAttr("id")
    .removeAttr("data-values")
    .removeAttr("placeholder");

  // Init atocomplete if needs be
  RegisterAutocomplete(clonedInput[0]);

  // Create a wrapper for the cloned input
  let $wrapper = $(`<div class="FormField__multipleinput">
		<button class="FormField__multipleinput__remove"><span>Remove</span></button>
		<button class="FormField__multipleinput__handle"><span>Sort</span></button>
	</div>`);

  // Wrap the element
  let $wrappedInput = $wrapper.append($(clonedInput));

  // Add it before the initial field, wrapped in a container
  $(sourceInput).before($wrappedInput);

  // Attached a click event to remove button
  $wrappedInput.on("keydown", function(ev) {
    if (event.which == 13 || event.keyCode == 13) ev.preventDefault()
  })
  $wrappedInput.find('.FormField__multipleinput__remove').on("click", function(ev) {
    ev.preventDefault()
    $wrappedInput.remove();
  })

  $(sourceInput).val(null)

}
