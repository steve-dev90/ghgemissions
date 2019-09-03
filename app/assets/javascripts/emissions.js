
$( document ).ready(function() {

  var tabStatus = { power: false }

  $('.button__submit').hide()
  $(".form__gas").hide()

  $('.datepicker').pickadate({
    today: false,
    clear: 'Clear date',
    formatSubmit: 'dd/mm/yyyy'
  })

  $('.button__next--power').click(function(event){
    inputs = getPowerFormInputs()
    clearInputErrors(inputs)
    if (missingInputs(inputs) &
        incorrectEndDate(inputs.start_date, inputs.end_date) &
        userEnergyToHigh(inputs.user_energy)) {
      changeActiveTab('power', 'gas')
      tabStatus.power=true
      $('.button__submit').show()
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
  var missing = true
  $.each( inputs, function( key, value ) {
    if (value == "" ) {
      if (key == "user_energy") {
        errmessage = "Enter your estimated power consumption in kWh"
      } else {
        errmessage = "Select the " + key.replace("_", " ") + " on your power bill"
      }
      appendErrMessage(errmessage, "#" + key)
      missing = false
    }
  })
  return missing
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

function changeActiveTab(currentTab, nextTab) {
  $(".tabs__" + currentTab).removeClass("is-active")
  $(".tabs__" + nextTab).addClass("is-active")
  $(".form__" + currentTab).slideUp()
  $(".form__" + nextTab).slideDown()
}

function appendErrMessage(errmessage, field_id) {
  $(field_id).addClass('is-danger')
  $(field_id).parent().next().append("<p>" + errmessage + "<p>")
}
