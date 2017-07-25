$(document).on('turbolinks:load', function() {
    $('#other-user-emails').click(function (e) {
        e.preventDefault();
        $('#new-user-modal').modal('show', {backdrop: 'static'});
    });

    // $('[data-control="key"]').wrap('<div class="clone-container"></div>');


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


    /* Character counter in every textarea */

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

    /** Upload images **/


  $('#form').fileupload({
    dataType: 'script',
    autoUpload: true,
    add(e, data) {
      const types = /(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i;
      const file = data.files[0];
      if (types.test(file.type) || types.test(file.name)) {
        data.context = $(tmpl("template-upload", file));
        $('#form').append(data.context);
        return data.submit();
      } else {
        return alert(`${file.name} is not a gif, jpg or png image file`);
      }
    },
    progress(e, data) {
      if (data.context) {
        const progress = parseInt((data.loaded / data.total) * 100, 10);
        return data.context.find('.bar').css('width', progress + '%');
      }
    }
  });


    $(document).bind('drop dragover', function (e) {
        e.preventDefault();
    });

});