'use strict';

import Dropzone from 'dropzone'
import Axios from 'axios'

Dropzone.autoDiscover = false

export default function FileUpload() {

	console.log("-- FileUpload initialized")

	// Configure axio to handle requests with csrf token
	let token = document.getElementsByName('csrf-token')[0].getAttribute('content')
	Axios.defaults.headers.common['X-CSRF-Token'] = token
  Axios.defaults.headers.common['Accept'] = 'application/json'

	// Handle delete buttons for existing files
	let initDeleteFile = function($deleteButton) {

		let url = $deleteButton.attr('href')

		$deleteButton.on('click', function(ev){
			ev.preventDefault()
			// Issue a request via ajax
			Axios.post(url)
			.then(function (response) {
				let status = response.data["deleted"]
				if (status) 
					$deleteButton.parent().remove()
				else
					alert("The file wasn't deleted.")
			})
			.catch(function (error) {
				console.log(error);
				console.log("Error");
			});
		})
	}

	// Loop through all existing files and init their delete buttons
	$('.FormUploads__delete').each(function(){
		initDeleteFile($(this))
	})

	// Initialize a dropdown for each file upload
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

		fileDropzone.on("success", (file, responseText) => {

			console.log(file, file['name'], responseText)

			let deleteUrl = responseText['files'][0]['delete_url']

			let $upload = $(`<div class="FormUploads__file">
					<a href="${file['name']}" class="FormUploads__link">${file['name']}</a>
					<a href="${deleteUrl}" class="FormUploads__delete" data-method="delete">✕</a>
			</div>`)

			let $deleteButton = $upload.find('.FormUploads__delete')
			initDeleteFile($deleteButton)

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
