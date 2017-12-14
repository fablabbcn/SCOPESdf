'use strict';

import Dropzone from 'dropzone'

Dropzone.autoDiscover = false

export default function FileUpload() {

	console.log("-- FileUpload initialized")

  let $fileUploads = $('.dropzone')

  $fileUploads.each(function(){

		let fileUpload = this
    
    let fileDropzone = new Dropzone(fileUpload, {
			url: $(fileUpload).data('url'),
			dictDefaultMessage: "Drag & drop files here - or click to browse<br />.jpg, .png, .pdf",
			thumbnailWidth: 80,
		  thumbnailHeight: 80,
			createImageThumbnails: true,
			addRemoveLinks: false,
			uploadMultiple: true,
		  parallelUploads: 20,
			paramName: 'files',
			headers: {
				'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
			},
		})

		fileDropzone.on("success", function(file, responseText) {

			console.log(file, file['name'], responseText)

			let deleteUrl = responseText['files'][0]['delete_url']

			let $upload = $(`<div class="FormUploads__file">
					<a href="${file['name']}" class="FormUploads__link">${file['name']}</a>
					<a href="${deleteUrl}" class="FormUploads__delete" data-method="delete">✕</a>
			</div>`)

			$('.FormUploads').append($upload)

		})

		fileDropzone.on("complete", function(file, responseText) {
			console.log(responseText)
		})

		fileDropzone.on("error", function(file, responseText) {
			console.log(responseText)
		})

		fileDropzone.on("uploadprogress", function(file, responseText) {
			console.log(responseText)
		})

  })


}
