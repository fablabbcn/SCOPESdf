'use strict';

module.exports = MutipleFieldGroups;

import {Sortable} from '@shopify/draggable';
import MultipleInputs from './MultipleInputs'

/**
 * Initializes multiple field groups
 * @returns {element} element
 */
function MutipleFieldGroups() {

	console.log("-- MutipleFieldGroups initialized")

  let $formFieldGroups = $('.FormFieldGroups--multiple')

  $formFieldGroups.each(function(){

    let formFieldGroup = this

    // Initialise this group
    initFormFieldGroup(formFieldGroup)

  })

}

function initFormFieldGroup(formFieldGroup) {

  let $addGroup = $(formFieldGroup).find('.FormFieldGroups__add')

  // When add button is clicked, add a new group
  $addGroup.on('click', function(){

		let $clonedFieldGroup = $(formFieldGroup).find('.FormFieldGroup').first().clone()

		$(this).before($clonedFieldGroup)

    return false

  })

}
