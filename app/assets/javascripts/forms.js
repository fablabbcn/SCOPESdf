window.Scopes = window.Scopes || {};

window.Scopes.lesson = {

  deleteFile: function(element) {
    var url = $(element).data('delete');

    if(url) {
      $.ajax({
        url:url,
        type:'DELETE',
        success: function(result){
          // @TODO come on. This is soo weak
          $(element).parent().remove();
        }
      });
    }
  }  
}

var fileUploadErrors = {
  maxFileSize: 'File is too big',
  minFileSize: 'File is too small',
  acceptFileTypes: 'Filetype not allowed',
  maxNumberOfFiles: 'Max number of files exceeded',
  uploadedBytes: 'Uploaded bytes exceed file size',
  emptyResult: 'Empty file upload result'
};



$(document).on('turbolinks:load', function() {
  $('#other-user-emails').click(function (e) {
      e.preventDefault();
      $('#new-user-modal').modal('show', {backdrop: 'static'});
  });


  $('fieldset').on("keypress", '[data-control="key"]', function (e) {
    if (e.charCode == 13) { // enter key
      e.preventDefault();
      for (i = 0; i < $('[data-control="key"]').length; i++) {
        if ($('[data-control="key"]').eq(i).val().length == 0) {
            return; // don't wanna clone empty elements
        }
      }
      $elem = $(this).clone(true, true);
      $elem.val('');
      $elem.appendTo($(this).parent());
      $elem.focus();
    }
  });
  $('fieldset').on('focusout', '[data-control="key"]', function (e) {
      if ($(this).val().length == 0 && $(this).siblings('[data-control="key"]').length > 1) {
          console.log('focus delete');

          //error gets created... race condition with keydown
          if ($(this).length > 0) {
              $(this).remove();
          }
      }
  });

  $('fieldset').on("keydown", '[data-control="key"]', function (e) {
      var key = e.keyCode || e.charCode;
      // console.log($(this).data());
      if (key == 8 || key == 46) { // delete made
          if( ($(this).val().length > 0)  || $(this).siblings('[data-control="key"]').length == 0 ){
              return; //do nothing
          }
          console.log('key delete');
          $(this).prev().focus();
          //error gets created... race condition with keydown
          if ($(this).length > 0) {
              $(this).remove();
          }
      }
  });

  $('#other-user-emails').click(function(e){
    e.preventDefault();
      $('#new-user-modal').modal('show',{backdrop:'static'});
  });

  $('[data-control="key"]').wrap('<div class="clone-container"></div>');

  $('[data-control="key"]').keypress(function(e){
    if(e.charCode == 13){ // enter key
      e.preventDefault();
      if($(this).val()){ // don't wanna clone empty elements
        $elem = $(this).clone(true,true);
        $elem.val('');
        $elem.appendTo($(this).parent());
        $elem.focus();
      }
    }
  });


  /* Character counter in every textarea but short ones */

  var textareaLimit = 800;
  $('.lesson--steps textarea:not(".textarea--short")').parent().append('<div class="textarea--counter"><em>0</em>/<span></span></div>');

  $('.textarea--counter span').text(textareaLimit);

  $('.lesson--steps textarea').on('keyup', function(e) {
      var characters = $(this).val().length;
      var lessText = "";
      if (characters >= textareaLimit) {
          e.preventDefault();
          lessText = $(this).val();
          $(this).val(lessText.substring(0,800));
      }
      $(this).parent().find('.textarea--counter em').text($(this).val().length);
  });


  // Dynamic
  $('fieldset').on("click", '.delete-standard', function () {
      index = $(this).data('order');
      console.log(index);
      if ($('.lesson--standard-wrapper').length > 1) {
          console.log('running');
          $('.lesson--standard-wrapper').get(index).remove();
          lst_index = $('.lesson--standard-wrapper').length;
          for (i = 0; i < lst_index; i++) {
              $elem = $('.lesson--standard-wrapper').eq(i);
              $elem.find("h4").text('Standard ' + (lst_index));
              $elem.find(".delete-standard").attr("data-order", lst_index - 1);
          }
      }
  });

  // Doesnt need to by dynamic
  $('fieldset').on("click", '.add-standard', function () {
      lst_index = $('.lesson--standard-wrapper').length;
      $elem = $('.lesson--standard-wrapper').last().clone(false, false);
      $elem.find(".textarea--short").val('');
      $elem.find("h4").text('Standard ' + (lst_index + 1));
      for (i = 0; i < $elem.find('[data-control="key"]').length; i++) { //only copy one element
          if (i > 0) {
              console.log('removing');
              console.log($elem.find('[data-control="key"]').eq(i));
              $elem.find('[data-control="key"]').eq(i).remove();
          }
      }
      $elem.find(".delete-standard").attr("data-order", lst_index);
      $elem.insertAfter($('.lesson--standard-wrapper').last());
  });

  var setCoverImage = function(){ // WARNING! This is repeated in step5. Should DRY this by attaching stuff in the window object.
    $('span.label--cover-image').remove();
    $('.lesson--steps .field--image-gallery figure:first-child').prepend('<span class="label label--dark label--cover-image">Cover image</span>');
  }

  setCoverImage();


    /** Upload images **/


    $('#fileupload').fileupload({
        autoUpload:true,
        dropZone: $('.dropzone'),
    });

    // Specific for lesson 1

    $('#lesson_form_1').fileupload({
        autoUpload:true,
        dropZone: $('.dropzone'),
        url:$('#lesson_form_1 .image-uploader-wrapper').data('endpoint')
    });


    $.getJSON($('#lesson_form_1 .image-uploader-wrapper').data('endpoint'), function (files) {

      $.each(files, function(index,key){
          $.each(key, function(index,file){
            $('#lesson_form_1 .image-uploader-wrapper').parent().find('.files').append('<span class="button button--file"><a href="'+file.url+'">'+file.name+'</a><a href="#" data-delete="'+file.delete_url+'"><i class="icon-close"></i></a></span>');
          });
        });
    });

    $(".dropzone").on("click",function(){
      $(this).parent().parent().find("input[type='file']").trigger('click');
    });

    $(document).on("click",'a[data-delete]',function(e){
      e.preventDefault();
      var self = $(this);
      window.Scopes.lesson.deleteFile(self);
    });


    $(document).bind('dragover', function (e) {
        var dropZones = $('.dropzone'),
            timeout = window.dropZoneTimeout;
        if (timeout) {
            clearTimeout(timeout);
        } else {
            dropZones.addClass('in');
        }
        var hoveredDropZone = $(e.target).closest(dropZones);
        dropZones.not(hoveredDropZone).removeClass('hover');
        hoveredDropZone.addClass('hover');
        window.dropZoneTimeout = setTimeout(function () {
            window.dropZoneTimeout = null;
            dropZones.removeClass('in hover');
        }, 100);
    });

    $(document).bind('drop dragover', function (e) {
      e.preventDefault();
    });

    /* Sort images */

    $('.field--image-gallery').sortable({
      revert: false,
      containment: "parent",
      tolerance: "pointer",
      update: function(event,ui){
        setCoverImage();
        //@TODO here the endpoint for the ajax call with the order
        // loop through figures
      }
    }).disableSelection();

});