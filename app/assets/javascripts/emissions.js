
$( document ).ready(function() {

  var tabStatus = { power: false }

  $('.datepicker').pickadate({
    today: false,
    clear: 'Clear date',
    formatSubmit: 'dd/mm/yyyy'
  })

  $('.form__power').change(function() {
    missingInputs(getPowerFormInputs())
  })

  $('.button__next--power').click(function(event){
    inputs = getPowerFormInputs()
    clearInputErrors(inputs)
    if (incorrectEndDate(inputs.start_date, inputs.end_date) &
        userEnergyToHigh(inputs.user_energy)) {
          $('.form__gas').removeClass("is-hidden")
          changeActiveTab('power', 'gas')
          tabStatus.power=true
          $('.button__submit').removeClass("is-hidden")
          $('.button__next--power').hide()
        }
  })

  $('form').submit(function(e) {
    console.log("BOO")
    var validData = false
    if (validData) {
      e.preventDefault();
    }
  })

  $('.tabs__power').click(function() {
    isActive = $('.tabs__power').attr('class').includes('is-active')
    if (tabStatus.power==true & !isActive) {
      changeActiveTab('gas', 'power')
    }
  })

})

// *** POWER FORM VALIDATION ***

function getPowerFormInputs() {
  return {
    start_date: $('#start_date').val(),
    end_date: $('#end_date').val(),
    user_energy: $('#user_energy').val(),
  }
}

function clearInputErrors(inputs) {
  $.each( inputs, function( key, value ) {
    $("#" + key).parent().next().empty()
    $("#" + key).removeClass("is-danger")
  })
}

function missingInputs(inputs) {
  var missing = 0
  $.each( inputs, function( key, value ) {
    if (value != "" ) { missing ++}
  })
  if (missing == 3) { $('.button__next--power').prop('disabled', false) }
}

function incorrectEndDate(startDate, endDate) {
  startDate = new Date(startDate)
  endDate = new Date(endDate)
  if (endDate.getTime() < startDate.getTime()) {
    appendErrMessage("Check your bill end date", '#end_date')
    appendErrMessage("Check your bill start date", '#start_date')
    return false
  }
  return true
}

function userEnergyToHigh(userEnergy) {
  if (userEnergy > 10000) {
    appendErrMessage("This seems a bit high, most households use about 250 - 750 kWh per month", '#user_energy')
    return false
  }
  return true
}

function appendErrMessage(errmessage, field_id) {
  $(field_id).addClass('is-danger')
  $(field_id).parent().next().append("<p>" + errmessage + "<p>")
}

// *** FORM TABS ***

function changeActiveTab(currentTab, nextTab) {
  $(".tabs__" + currentTab).removeClass("is-active")
  $(".tabs__" + nextTab).addClass("is-active")
  $(".form__" + currentTab).slideUp()
  $(".form__" + nextTab).slideDown()
}


