(function() {
  $( document ).ready(function() {

    var tabStatus = { chart: true }

    $('.tabs__item').click(function() {
      isActive = $(this).attr('class').includes('is-active')
      if (!isActive) {
        $(this).siblings().first().removeClass("is-active")
        $(this).addClass("is-active")
        $(this).parent().parent().parent().find(".chart__body").fadeToggle(100)
        $(this).parent().parent().parent().find(".info__body").fadeToggle()
      }
    })
  })

})()
