'use strict';

import Dropzone from 'dropzone'

export default function FileUpload() {

	console.log("-- FileUpload initialized")

  let $fileUploads = $('.FileUpload')

  $fileUploads.each(function(){

    let fileUpload = this

    Dropzone.autoDiscover = false
    let fileDropzone = new Dropzone(fileUpload, {
			url: $(fileUpload).data('url'),
			thumbnailWidth: 80,
		  thumbnailHeight: 80,
			createImageThumbnails: false,
			addRemoveLinks: false,
			uploadMultiple: true,
		  parallelUploads: 20,
			paramName: 'files',
			headers: {
				'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    	}
		})

		fileDropzone.on("success", function(file, responseText) {
			console.log(responseText)
		})

		// Add the dropzone class
    $(fileUpload).addClass('dropzone')

  })


}
