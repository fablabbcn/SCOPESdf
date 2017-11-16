'use strict';

module.exports = MobileMenu;

function MobileMenu() {

	console.log("-- MobileMenu initialized")

    let $toggle = $('.ToggleMobileMenu')
    let $close = $('.MobileMenu__close')
    let $menu = $('.MobileMenu')

    const open = function(){
        $menu.addClass('MobileMenu--active')
        $('body').addClass('Body--no-scroll')
    }

    const close = function(){
        $menu.removeClass('MobileMenu--active')
        $('body').removeClass('Body--no-scroll')
    }

    $toggle.on('click', function(){
        open()
        return false
    })

    $close.on('click', function(){
        close()
        return false
    })

    $('.MobileMenu__navigation__link').on('click', function(){
        close()
    })

}
