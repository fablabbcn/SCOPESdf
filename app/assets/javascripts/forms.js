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


    $('#lesson_form_1').on('keyup keypress', function (e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            // return false;
        }
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

});