
(function() {
  $( document ).ready(function() {

    var tabStatus = { power: false }

    $('.datepicker').pickadate({
      today: false,
      clear: 'Clear date',
      formatSubmit: 'dd/mm/yyyy'
    })

    // *** NEXT BUTTON ***
    // Check for missing inputs and if none enanle next button
    $('.form__power, .form__gas').change(function() {
      if ($(this).hasClass('form__power')) {
        missingInputs(getPowerGasFormInputs('power'),'power')
      } else {
        missingInputs(getPowerGasFormInputs('gas'), 'gas')
      }
    })

    // Useful article on passing arguments in jquery
    // https://stackoverflow.com/questions/979337/how-can-i-pass-arguments-to-event-handlers-in-jquery
    $('.button__next--power').click(function() { nextButtonActions('power','gas') })
    $('.button__next--gas').click(function() { nextButtonActions('gas','car') })

    function nextButtonActions(currentTab, nextTab) {
      if (checkFormInputs(currentTab)) {
        $('.form__' + nextTab).removeClass("is-hidden")
        changeActiveTab(currentTab, nextTab)
        tabStatus.power=true
        if (nextTab == "car") {
          $('.button__submit').removeClass("is-hidden")
        }
        $('.button__next--' + currentTab).hide()
        addTickToFormStatusIcon('.form-status__power--icon')
        $(window).scrollTop(0);
      }
    }

    $('form').submit(function(e) {
      // Don't submit unless form inputs are OK
      if (!checkPowerFormInputs()) {
        e.preventDefault();
      }
    })

    // Power tab listener
    $('.tabs__power').click(function() {
      isActive = $('.tabs__power').attr('class').includes('is-active')
      if (tabStatus.power==true & !isActive) {
        changeActiveTab('gas', 'power')
      }
    })
  })

  // *** FORM STATUS ***
  function addTickToFormStatusIcon(icon) {
    $(icon).addClass('fa-check-circle')
    $(icon).removeClass('fa-circle')
  }

  // *** POWER FORM VALIDATION ***
  // Dealing with missing inputs
  function missingInputs(inputs, tab) {
    var missing = 0
    $.each( inputs, function( key, value ) {
      if (value != "" ) { missing ++}
    })
    console.log(missing, inputs)
    if (missing == 3) { $('.button__next--' + tab).prop('disabled', false) }
  }

  // Dealing with input errors
  function checkFormInputs(tab) {
    switch (tab) {
      // Gas and power share the same code
      case 'gas':
      case 'power':
        inputs = getPowerGasFormInputs(tab)
        clearInputErrors(inputs, tab)
        return testPowerGasInputs(
          inputs.start_date, inputs.end_date,
          inputs.user_energy, tab)
    }
  }

  function testPowerGasInputs(startDate, endDate, userEnergy, tab) {
    console.log(userEnergy)
    if (incorrectEndDate(startDate, endDate, tab) & userEnergyToHigh(userEnergy, tab)) {
      return true
    } else {
      return false
    }
  }

  function getPowerGasFormInputs(tab) {
    start_css_id = '#' + tab + '_'
    return {
      start_date: $(start_css_id + 'start_date').val(),
      end_date: $(start_css_id + 'end_date').val(),
      user_energy: $(start_css_id + 'user_energy').val(),
    }
  }

  function clearInputErrors(inputs, tab) {
    start_css_id = '#' + tab + '_'
    $.each( inputs, function( key, value ) {
      $(start_css_id + key).parent().next().empty()
      $(start_css_id  + key).removeClass("is-danger")
    })
  }

  function incorrectEndDate(inputStartDate, inputEndDate, tab) {
    startDate = new Date(inputStartDate)
    endDate = new Date(inputEndDate)
    start_css_id = '#' + tab + '_'
    if (endDate.getTime() < startDate.getTime()) {
      appendErrMessage("Check your bill end date", start_css_id + 'end_date')
      appendErrMessage("Check your bill start date", start_css_id + 'start_date')
      return false
    }
    return true
  }

  function userEnergyToHigh(userEnergy, tab) {
    // MBIE gas 134 per week
    start_css_id = '#' + tab + '_'
    if (userEnergy > 10000) {
      if (tab == 'power') {
        appendErrMessage("This seems a bit high, most households use about 250 - 750 kWh per month", start_css_id + 'user_energy')
      } else {
        appendErrMessage("This seems a bit high, most households use about 200 - 600 kWh per month", start_css_id + 'user_energy')
      }
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

})()
