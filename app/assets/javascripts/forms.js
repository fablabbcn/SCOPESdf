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
      }
    } 
  });
});