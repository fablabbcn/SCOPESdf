'use strict';

module.exports = FileUpload;

import Dropzone from 'dropzone'

/**
 * Initializes choices.js component(s)
 * @returns {element} element
 */
function FileUpload() {

	console.log("-- FileUpload initialized")

  let $fileUploads = $('.FileUpload')

  $fileUploads.each(function(){

    let fileUpload = this

    Dropzone.autoDiscover = false
    let fileDropzone = new Dropzone(fileUpload, {
			url: $(fileUpload).data('url'),
			thumbnailWidth: 80,
		  thumbnailHeight: 80,
		  parallelUploads: 20,
		})

		// Add the dropzone class
    $(fileUpload).addClass('dropzone')

  })


}
