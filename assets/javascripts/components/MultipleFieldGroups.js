'use strict';

module.exports = MutipleFieldGroups;

import {Sortable} from '@shopify/draggable';

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

    

    return false

  })

}
