import LazySizes from "lazysizes"

export const check = function() {
  console.log("--- Checking images")
  LazySizes.loader.checkElems()
}

export default function() {

  console.log("-- Images initialized")

  window.lazySizesConfig = window.lazySizesConfig || {}

  // use .Image--lazy instead of .lazyload
  window.lazySizesConfig.lazyClass = 'Image--lazy'
  window.lazySizesConfig.loadingClass = 'Image--lazyloading'
  window.lazySizesConfig.loadedClass = 'Image--lazyloaded'
  window.lazySizesConfig.autosizesClass = 'Image--lazyautosizes'

  document.addEventListener("turbolinks:before-cache", function() {

    let $images = $('.Image')

    $images.removeClass('Image--lazyautosizes')
    $images.removeClass('Image--lazyloading')
    $images.removeClass('Image--lazyloaded')
    $images.addClass('Image--lazy')

  })

}
