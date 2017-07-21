$(document).ready(function(){
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

    $('#lesson_form_1').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            return false;
        }
    });


    // Dynamic
    $('fieldset').on("click", '.delete-standard', function(){
        index = $(this).data('order');
        console.log(index);
        if ($('.lesson--standard-wrapper').length > 1) {
            console.log('running');
            $('.lesson--standard-wrapper').get(index).remove();
            lst_index = $('.lesson--standard-wrapper').length;
            for( i=0; i < lst_index; i++){
                $elem = $('.lesson--standard-wrapper').eq(i);
                $elem.find("h4").text('Standard ' + (lst_index) );
                $elem.find(".delete-standard").attr("data-order",lst_index-1);
            }
        }
    });
    // Doesnt need to by dynamic
    $('.add-standard').click(function() {
        lst_index = $('.lesson--standard-wrapper').length;
        $elem = $('.lesson--standard-wrapper').last().clone(false,false);
        $elem.find(".textarea--short").val('');
        $elem.find("h4").text('Standard ' + (lst_index +1) );
        $elem.find(".delete-standard").attr("data-order",lst_index);
        $elem.insertAfter($('.lesson--standard-wrapper').last());
    });





});